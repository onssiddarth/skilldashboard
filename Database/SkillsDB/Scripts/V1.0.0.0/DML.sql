PRINT '========================================='
PRINT '================V1.0.0.0================='
PRINT '================DML.sql=================='
PRINT '========================================='

PRINT 'Creating stored procedures...'
GO

PRINT 'CREATE PROCEDURE [dbo].[usp_sav_ErrorLog]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_sav_ErrorLog]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_sav_ErrorLog]
GO
GO
-- =============================================
-- Author:		Siddarth Nair
-- Create date: 1-April-2018
-- Description:	This stored procedure is used to save information about error logs
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_ErrorLog] 
	@StackTrace VARCHAR(MAX),
	@StoredProcName VARCHAR(100),
	@Parameters VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO [dbo].[Tbl_ErrorLogs]
           ([StoredProcName]
           ,[Parameters]
           ,[StackTrace]
           ,[DateCreated])
     VALUES
           (@StoredProcName
           ,@Parameters
           ,@StackTrace
           ,GETDATE());
    
END
GO


PRINT 'CREATE PROCEDURE [dbo].[usp_getAllSkillsAvailable]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getAllSkillsAvailable]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getAllSkillsAvailable]
GO
CREATE PROCEDURE [dbo].[usp_getAllSkillsAvailable] 
    @LoggedInUserID int
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT sm.SkillID, sm.SkillName from tbl_SkillMaster sm WHERE sm.IsActive=1;

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllSkillsAvailable',@Params;
		END
	END CATCH
END

GO

PRINT 'CREATE PROCEDURE [dbo].[usp_getAllSubSkillsForASkill]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getAllSubSkillsForASkill]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getAllSubSkillsForASkill]
GO
GO
CREATE PROCEDURE [dbo].[usp_getAllSubSkillsForASkill] 
    @LoggedInUserID int,
	@SkillID int
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT SkillID, 
				SubskillID, 
				SubskillName 
		FROM tbl_SubskillMaster
		WHERE SkillID=@SkillID 
				AND IsActive=1;

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | SkillID ='+CONVERT(NVARCHAR,@SkillID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllSubSkillsForASkill',@Params;
		END
	END CATCH
END
GO

PRINT 'CREATE PROCEDURE usp_getTestUsers...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getTestUsers]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getTestUsers]
GO
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_getTestUsers
	@LoggedInUser VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ID,
		   Name,
		   Age,
		   Address,
		   AddedBy,
		   AddedDate,
		   ModifiedBy,
		   ModifiedDate
    FROM [dbo].[Tbl_testUsers]
END

GO

PRINT 'CREATE PROCEDURE usp_testAddUser...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_testAddUser]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
DROP PROCEDURE [dbo].[usp_testAddUser]
GO
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_testAddUser 
	@Name VARCHAR(MAX),
	@Age INT,
	@Address VARCHAR(MAX),
	@LoggedInUser VARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    INSERT INTO [dbo].[Tbl_testUsers]
           ([Name]
           ,[Age]
           ,[Address]
           ,[AddedBy]
           ,[AddedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           (@Name
           ,@Age
           ,@Address
           ,@LoggedInUser
           ,GETDATE()
           ,NULL
           ,NULL)
           
END
GO

PRINT 'CREATE PROCEDURE usp_testModifyUser...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_testModifyUser]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
DROP PROCEDURE [dbo].[usp_testModifyUser]
GO
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_testModifyUser
	@Name VARCHAR(MAX),
	@Age INT,
	@Address VARCHAR(MAX),
	@LoggedInUser VARCHAR(MAX),
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE [dbo].[Tbl_testUsers]
    SET Name = @Name,
		Age = @Age,
		Address = @Address,
		ModifiedBy = @LoggedInUser,
		ModifiedDate = GETDATE()
	WHERE ID = @UserID;
		
END

GO

GO
PRINT 'Stored Procedures Created...'

PRINT '========================================='
PRINT 'INSERT INTO [dbo].[Tbl_VersionMaster]...'
GO
INSERT INTO [dbo].[Tbl_VersionMaster]
           ([Major]
           ,[Minor]
           ,[Customization]
           ,[Patch])
     VALUES
           (1
           ,0
           ,0
           ,0)
PRINT 'Version 1.0.0.0 executed'
GO