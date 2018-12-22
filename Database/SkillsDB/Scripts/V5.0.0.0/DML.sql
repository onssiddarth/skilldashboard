PRINT '========================================='
PRINT '================V4.0.0.0================='
PRINT '================DML.sql=================='
PRINT '========================================='

PRINT 'CREATE PROCEDURE [dbo].[usp_getEmployeeRequests]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getEmployeeRequests]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getEmployeeRequests]
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getEmployeeRequests]
    @LoggedInUserID int,
    @Type VARCHAR(50) = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

    IF UPPER(@Type) = 'INIT'
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
				uir.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status], 
				uir.Comments
		FROM tbl_UserInitialSkillRequest uir INNER JOIN tbl_Status s
		ON uir.StatusID  = s.StatusID
		WHERE uir.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
		SELECT 'Demonstration' AS [Request type], 
				ud.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				ud.Comments
		FROM tbl_UserDemo ud INNER JOIN tbl_Status s
		ON ud.StatusID  = s.StatusID
		WHERE ud.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
		SELECT 'Certification' AS [Request type], 
				uc.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				uc.Comments
		FROM tbl_UserCertificate uc INNER JOIN tbl_Status s
		ON uc.StatusID  = s.StatusID
		WHERE uc.UserID = @LoggedInUserID;
	END
	ELSE
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
				uir.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				uir.Comments
		FROM tbl_UserInitialSkillRequest uir INNER JOIN tbl_Status s
		ON uir.StatusID  = s.StatusID
		WHERE uir.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Demonstration' AS [Request type],  
				ud.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				ud.Comments
		FROM tbl_UserDemo ud INNER JOIN tbl_Status s
		ON ud.StatusID  = s.StatusID
		WHERE ud.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Certification' AS [Request type],  
				uc.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				uc.Comments
		FROM tbl_UserCertificate uc INNER JOIN tbl_Status s
		ON uc.StatusID  = s.StatusID
		WHERE uc.UserID = @LoggedInUserID;
	END
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
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_getEmployeeRequests',@Params;
	END
			
END CATCH
END	

GO




GO


PRINT '========================================='
PRINT 'INSERT INTO [dbo].[Tbl_VersionMaster]...'
GO
INSERT INTO [dbo].[Tbl_VersionMaster]
           ([Major]
           ,[Minor]
           ,[Customization]
           ,[Patch])
     VALUES
           (5
           ,0
           ,0
           ,0)
PRINT 'Version 5.0.0.0 executed'
GO
