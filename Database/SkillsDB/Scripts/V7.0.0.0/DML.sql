PRINT '========================================='
PRINT '================V7.0.0.0================='
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
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uir.Comments
		FROM tbl_UserInitialSkillRequest uir INNER JOIN tbl_Status s
		ON uir.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
		ON sm.SkillID = uir.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
		ON ssm.SubskillID = uir.RequestedSubskillID
		WHERE uir.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
		SELECT 'Demonstration' AS [Request type], 
				ud.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				ud.Comments
		FROM tbl_UserDemo ud INNER JOIN tbl_Status s
		ON ud.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
		ON sm.SkillID = ud.AcquiredSkillID
		INNER JOIN tbl_SubskillMaster ssm
		ON ssm.SubskillID = ud.AcquiredSubskillID
		WHERE ud.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
		SELECT 'Certification' AS [Request type], 
				uc.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uc.Comments
		FROM tbl_UserCertificate uc INNER JOIN tbl_Status s
		ON uc.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
		ON sm.SkillID = uc.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
		ON ssm.SubskillID = uc.RequestedSubskillID
		WHERE uc.UserID = @LoggedInUserID;
	END
	ELSE
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
				uir.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status], 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uir.Comments
		FROM tbl_UserInitialSkillRequest uir INNER JOIN tbl_Status s
		ON uir.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
		ON sm.SkillID = uir.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
		ON ssm.SubskillID = uir.RequestedSubskillID
		WHERE uir.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Demonstration' AS [Request type], 
				ud.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				ud.Comments
		FROM tbl_UserDemo ud INNER JOIN tbl_Status s
		ON ud.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
		ON sm.SkillID = ud.AcquiredSkillID
		INNER JOIN tbl_SubskillMaster ssm
		ON ssm.SubskillID = ud.AcquiredSubskillID
		WHERE ud.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Certification' AS [Request type], 
				uc.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uc.Comments
		FROM tbl_UserCertificate uc INNER JOIN tbl_Status s
		ON uc.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
		ON sm.SkillID = uc.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
		ON ssm.SubskillID = uc.RequestedSubskillID
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
PRINT 'CREATE PROCEDURE [dbo].[usp_getEmployeesForASkillSubskill]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getEmployeesForASkillSubskill]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getEmployeesForASkillSubskill]
GO
CREATE PROCEDURE [dbo].[usp_getEmployeesForASkillSubskill] 
	@LoggedInUserID int, 
	@SkillID int,
	@SubskillID int
AS
	BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

	 select acq.UserID, acq.AcquiredSkillID, 
			 emp.FirstName + ' ' + emp.LastName as [Employee Name],
			 emp.Email,
			 emp.Phonenumber as [Contact Number],
			 SUM(ssm.SkillPoints) as [Skill Points]
	 from AspNetUsers emp 	 
	 inner join tbl_UserAcquiredSkillSubskill acq
	 on acq.UserID=emp.Id
	 inner join tbl_subskillmaster ssm
	 on acq.AcquiredSubskillID=ssm.SubskillID	 
	 WHERE acq.AcquiredSkillID = @SkillID
	 AND acq.AcquiredSubskillID = @SubskillID	 
	 group by acq.UserID, acq.AcquiredSkillID, emp.FirstName, emp.Email, emp.LastName, emp.PhoneNumber;

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
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)
						+' | SkillID ='+CONVERT(NVARCHAR(MAX),@SkillID)
						+' | SubskillID ='+CONVERT(NVARCHAR(MAX),@SubskillID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getEmployeesForASkillSubskill',@Params;
		END
	END CATCH
END

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
           (7
           ,0
           ,0
           ,0)
PRINT 'Version 7.0.0.0 executed'
GO
