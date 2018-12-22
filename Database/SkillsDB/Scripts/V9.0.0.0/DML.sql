PRINT '========================================='
PRINT '================V9.0.0.0================='
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
			NULL AS [SkillExpertComments]
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
			SkillExpert.Comments AS [SkillExpertComments]
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
			NULL AS [SkillExpertComments]
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
			NULL AS [SkillExpertComments]
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
			SkillExpert.Comments AS [SkillExpertComments]
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
			NULL AS [SkillExpertComments]
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

PRINT 'CREATE PROCEDURE [dbo].[usp_savSkillExpertApprovals]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_savSkillExpertApprovals]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].usp_savSkillExpertApprovals
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savSkillExpertApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50),--INIT/DEMO/CERT
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
			@StatusID_SkillExpertApproved INT,
			@StatusID_SkillExpertRejected INT,
			@RequestedSkillID INT,
			@RequestedSubSkillID INT,
			@RequestorID INT;
	
	SET @StatusID_SkillExpertApproved = [dbo].[fn_GetStatusIDFromCode]('SE_APR');
	SET @StatusID_SkillExpertRejected = [dbo].[fn_GetStatusIDFromCode]('SE_REJ');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	UPDATE tbl_UserInitialSkillRequest
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_SkillExpertApproved
					  ELSE @StatusID_SkillExpertRejected
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
      
      -- If status is approved make an entry in table tbl_UserAcquiredSkillSubskill
      IF UPPER(@Status) = 'APPROVED'
      BEGIN
			-- Get the requested skill and subskill ID
		  SELECT @RequestedSkillID = RequestedSkillID, 
				 @RequestedSubSkillID = RequestedSubskillID,
				 @RequestorID = UserID
		  FROM tbl_UserInitialSkillRequest
		  WHERE UISRID = @UniqueID;
		  
		  -- Make entry in table tbl_UserAcquiredSkillSubskill
		  INSERT INTO [dbo].[tbl_UserAcquiredSkillSubskill]
			   ([UserID]
			   ,[AcquiredSubskillID]
			   ,[AcquiredSkillID]
			   ,[Type]
			   ,[IsActive]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[ModifiedDate]
			   ,[ModifiedBy])
			VALUES
				(
				@RequestorID,
				@RequestedSubSkillID,
				@RequestedSkillID,
				@Type,
				1,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
				)
      END 
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	UPDATE tbl_UserDemo
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_SkillExpertApproved
					  ELSE @StatusID_SkillExpertRejected
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
     
      -- If status is approved make an entry in table tbl_UserAcquiredSkillSubskill
      IF UPPER(@Status) = 'APPROVED'
      BEGIN
			-- Get the requested skill and subskill ID
		  SELECT @RequestedSkillID = AcquiredSkillID, 
				 @RequestedSubSkillID = AcquiredSubskillID,
				 @RequestorID = UserID
		  FROM tbl_UserDemo
		  WHERE UDID = @UniqueID;
		  
		  -- Make entry in table tbl_UserAcquiredSkillSubskill
		  INSERT INTO [dbo].[tbl_UserAcquiredSkillSubskill]
			   ([UserID]
			   ,[AcquiredSubskillID]
			   ,[AcquiredSkillID]
			   ,[Type]
			   ,[IsActive]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[ModifiedDate]
			   ,[ModifiedBy])
			VALUES
				(
				@RequestorID,
				@RequestedSubSkillID,
				@RequestedSkillID,
				@Type,
				1,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
				)
      END
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	UPDATE tbl_UserCertificate
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_SkillExpertApproved
					  ELSE @StatusID_SkillExpertRejected
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
     
     -- If status is approved make an entry in table tbl_UserAcquiredSkillSubskill
      IF UPPER(@Status) = 'APPROVED'
      BEGIN
			-- Get the requested skill and subskill ID
		  SELECT @RequestedSkillID = RequestedSkillID, 
				 @RequestedSubSkillID = RequestedSubskillID,
				 @RequestorID = UserID
		  FROM tbl_UserCertificate
		  WHERE UCID = @UniqueID;
		  
		  -- Make entry in table tbl_UserAcquiredSkillSubskill
		  INSERT INTO [dbo].[tbl_UserAcquiredSkillSubskill]
			   ([UserID]
			   ,[AcquiredSubskillID]
			   ,[AcquiredSkillID]
			   ,[Type]
			   ,[IsActive]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[ModifiedDate]
			   ,[ModifiedBy])
			VALUES
				(
				@RequestorID,
				@RequestedSubSkillID,
				@RequestedSkillID,
				@Type,
				1,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
				)
      END
	
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
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savSkillExpertApprovals',@Params;
	END
			
END CATCH
END	

GO

PRINT 'CREATE PROCEDURE [dbo].[usp_sav_DemoScheduleBySkillExpert]...'
GO

IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_sav_DemoScheduleBySkillExpert]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].usp_sav_DemoScheduleBySkillExpert
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_DemoScheduleBySkillExpert] 
	-- Add the parameters for the stored procedure here
	@LoggedInUserID INT, -- Logged In User
	@DemoSchedule DATETIME,
	@Comments VARCHAR(MAX),
	@UniqueID INT,
	@Room VARCHAR(25)
AS
BEGIN
	
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_DemoScheduled INT;
			
	SET @StatusID_DemoScheduled = [dbo].[fn_GetStatusIDFromCode]('DEMO_SCH');
			
	UPDATE Tbl_UserDemo
	SET StatusID = @StatusID_DemoScheduled,
		Comments = @Comments,
		Room = @Room,
		DateAndTime = @DemoSchedule,
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
			
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	IF XACT_STATE() <> 0  
			ROLLBACK TRAN 
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @DemoSchedule ='+CONVERT(NVARCHAR(MAX),@DemoSchedule)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @UniqueID ='+CONVERT(NVARCHAR(MAX),@UniqueID)+
						' | @Room ='+CONVERT(NVARCHAR(MAX),@Room);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_sav_DemoScheduleBySkillExpert',@Params;
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
           (9
           ,0
           ,0
           ,0)
PRINT 'Version 9.0.0.0 executed'
GO
