PRINT '========================================='
PRINT '================V10.0.0.0================='
PRINT '================DML.sql=================='
PRINT '========================================='

PRINT 'CREATE PROCEDURE [dbo].[usp_getPendingSkillExpertApprovals]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getPendingSkillExpertApprovals]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getPendingSkillExpertApprovals]
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getPendingSkillExpertApprovals]
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
			@StatusID_ManagerApproved INT,
			@StatusID_DemoScheduled INT,
			@StatusID_ManagerPending INT;
	
	SET @StatusID_ManagerApproved = [dbo].[fn_GetStatusIDFromCode]('MGR_APR');
	SET @StatusID_DemoScheduled = [dbo].[fn_GetStatusIDFromCode]('DEMO_SCH');
	SET @StatusID_ManagerPending = [dbo].[fn_GetStatusIDFromCode]('MGR_PND');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UISKH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'INIT' AS [RequestCode]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
	INNER JOIN tbl_UserInitialSkillRequestHistory UISKH
		ON UISKH.UISRID = UIR.UISRID
		AND UISKH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved;
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	SELECT 'Demonstration' AS [Request type], 
			UD.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			Manager.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UD.UDID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			UD.Room,
			UD.DateAndTime AS [DemoSchedule],
			UDH.Comments AS [UserComments],
			SkillExpert.Comments AS [SkillExpertComments],
			'DEMO' AS [RequestCode]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
	INNER JOIN tbl_UserDemoHistory UDH
		ON UDH.UDID = UD.UDID
		AND UDH.StatusID = @StatusID_ManagerPending
	INNER JOIN tbl_UserDemoHistory Manager
		ON Manager.UDID = UD.UDID
		AND Manager.StatusID = @StatusID_ManagerApproved
	LEFT JOIN tbl_UserDemoHistory SkillExpert
		ON SkillExpert.UDID = UD.UDID
		AND SkillExpert.StatusID = @StatusID_DemoScheduled
	WHERE ST.StatusID IN (@StatusID_ManagerApproved,@StatusID_DemoScheduled);
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UCH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'CERT' AS [RequestCode]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
	INNER JOIN tbl_UserCertificateHistory UCH
		ON UCH.UCID = UC.UCID
		AND UCH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved;
	
	END
	ELSE
	BEGIN
	
	SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UISKH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'INIT' AS [RequestCode]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
	INNER JOIN tbl_UserInitialSkillRequestHistory UISKH
		ON UISKH.UISRID = UIR.UISRID
		AND UISKH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved
	
	UNION ALL
	
	SELECT 'Demonstration' AS [Request type], 
			UD.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			Manager.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UD.UDID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			UD.Room,
			UD.DateAndTime AS [DemoSchedule],
			UDH.Comments AS [UserComments],
			SkillExpert.Comments AS [SkillExpertComments],
			'DEMO' AS [RequestCode]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
	INNER JOIN tbl_UserDemoHistory UDH
		ON UDH.UDID = UD.UDID
		AND UDH.StatusID = @StatusID_ManagerPending
	INNER JOIN tbl_UserDemoHistory Manager
		ON Manager.UDID = UD.UDID
		AND Manager.StatusID = @StatusID_ManagerApproved
	LEFT JOIN tbl_UserDemoHistory SkillExpert
		ON SkillExpert.UDID = UD.UDID
		AND SkillExpert.StatusID = @StatusID_DemoScheduled
	WHERE ST.StatusID IN (@StatusID_ManagerApproved,@StatusID_DemoScheduled)
	
	UNION ALL
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UCH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'CERT' AS [RequestCode]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
	INNER JOIN tbl_UserCertificateHistory UCH
		ON UCH.UCID = UC.UCID
		AND UCH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved;
	
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
		EXEC usp_sav_ErrorLog @StackTrace,'usp_getPendingSkillExpertApprovals',@Params;
	END
			
END CATCH
END	

GO

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
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'INIT' AS [RequestCode]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
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
			UD.UDID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'DEMO' AS [RequestCode]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
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
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'CERT' AS [RequestCode]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
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
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'INIT' AS [RequestCode]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
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
				UD.UDID AS [UniqueID],
				AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			    'DEMO' AS [RequestCode]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
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
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'CERT' AS [RequestCode]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
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

PRINT '========================================='
PRINT 'INSERT INTO [dbo].[Tbl_VersionMaster]...'
GO
INSERT INTO [dbo].[Tbl_VersionMaster]
           ([Major]
           ,[Minor]
           ,[Customization]
           ,[Patch])
     VALUES
           (10
           ,0
           ,0
           ,0)
PRINT 'Version 10.0.0.0 executed'
GO





