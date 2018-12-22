PRINT '========================================='
PRINT '================V6.0.0.0================='
PRINT '================DML.sql=================='
PRINT '========================================='

PRINT 'CREATE PROCEDURE [dbo].[usp_getPendingManagerApprovals]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getPendingManagerApprovals]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getPendingManagerApprovals]
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getPendingManagerApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50) = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_PendingWithManager INT;
	
	SET @StatusID_PendingWithManager = [dbo].[fn_GetStatusIDFromCode]('MGR_PND');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	WHERE ST.StatusID = @StatusID_PendingWithManager;
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	SELECT 'Demonstration' AS [Request type], 
			UD.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			UD.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UD.UDID AS [UniqueID]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	END
	ELSE
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	UNION ALL
	
	SELECT 'Demonstration' AS [Request type], 
				UD.CreatedDate AS [Request date], 
				ST.StatusDescription AS [Status] , 
				UD.Comments,
				SM.SkillName,
				SSM.SubskillName,
				SSM.SkillPoints,
				NULL AS [FileGUID],
				NULL AS [FileName],
				UD.UDID AS [UniqueID]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	UNION ALL
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	WHERE ST.StatusID = @StatusID_PendingWithManager
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
		EXEC usp_sav_ErrorLog @StackTrace,'usp_getPendingManagerApprovals',@Params;
	END
			
END CATCH
END	

GO


PRINT 'CREATE PROCEDURE [dbo].[usp_savManagerApprovals]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_savManagerApprovals]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_savManagerApprovals]
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savManagerApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50),
    @UniqueID INT,
    @Comments VARCHAR(MAX),
    @Status VARCHAR(50) -- APPROVED/REJECTED
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_ManagerApproved INT,
			@StatusID_ManagerRejected INT;
	
	SET @StatusID_ManagerApproved = [dbo].[fn_GetStatusIDFromCode]('MGR_APR');
	SET @StatusID_ManagerRejected = [dbo].[fn_GetStatusIDFromCode]('MGR_REJ');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	UPDATE tbl_UserInitialSkillRequest
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UISRID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserInitialSkillRequestHistory]
           ([UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
      SELECT [UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
      FROM [dbo].[tbl_UserInitialSkillRequest]
      WHERE UISRID = @UniqueID;
	
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	UPDATE tbl_UserDemo
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UDID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserDemoHistory]
           ([UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy])
     SELECT [UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,ISNULL(ModifiedDate,CreatedDate)
           ,ISNULL(ModifiedBy,CreatedBy)
      FROM tbl_UserDemo
      WHERE UDID = @UniqueID;
     
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	UPDATE tbl_UserCertificate
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UCID = @UniqueID;
	
	INSERT INTO [dbo].[tbl_UserCertificateHistory]
           ([UCID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID]
           ,[FileUploadID])
     SELECT [UCID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID]
           ,[FileUploadID]
     FROM [dbo].[tbl_UserCertificate]
     WHERE UCID = @UniqueID;
	
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
						' | @UniqueID ='+CONVERT(NVARCHAR(MAX),@UniqueID)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+
						' | @Status ='+CONVERT(NVARCHAR(MAX),@Status);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savManagerApprovals',@Params;
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
           (6
           ,0
           ,0
           ,0)
PRINT 'Version 6.0.0.0 executed'
GO
