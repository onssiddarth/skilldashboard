PRINT '========================================='
PRINT '================V11.0.0.0================'
PRINT '================DML.sql=================='
PRINT '========================================='

PRINT 'CREATE PROCEDURE [dbo].[usp_getAllBadges]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getAllBadges]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getAllBadges]
GO

CREATE PROCEDURE [dbo].[usp_getAllBadges] 
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

		SELECT BadgeID,
			   BadgeName,
			   BadgeImageURL
		FROM tbl_BadgeMaster
		WHERE IsActive=1
		AND BadgeName = ISNULL(@Type,BadgeName);

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
						'Type='+CONVERT(NVARCHAR(MAX),@Type);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllBadges',@Params;
		END
	END CATCH
END
GO

PRINT 'CREATE PROCEDURE [dbo].[usp_savBadge]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_savBadge]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_savBadge]
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savBadge]
    @LoggedInUserID INT,
    @Type VARCHAR(50), --EXPERT/USER
    @Comments VARCHAR(MAX),
    @BadgeGivenTo INT,
    @BadgeID INT
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_PendingWithManager INT,
			@StatusID_SkillExpertApproved INT,
			@BadgeInsertedValue INT;
	
	SET @StatusID_PendingWithManager = [dbo].[fn_GetStatusIDFromCode]('MGR_PND');
	SET @StatusID_SkillExpertApproved = [dbo].[fn_GetStatusIDFromCode]('SE_APR');

    IF UPPER(@Type) = 'EXPERT'
    BEGIN
		-- If expert gives a badge user directly gets it
		INSERT INTO [dbo].[tbl_UserBadge]
           ([UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		VALUES
           (@BadgeGivenTo
           ,@StatusID_SkillExpertApproved
           ,@BadgeID
           ,@LoggedInUserID
           ,1
           ,GETDATE()
           ,@LoggedInUserID
           ,NULL
           ,NULL
           ,@Comments)
           
         SET @BadgeInsertedValue = @@IDENTITY;
         
         INSERT INTO [dbo].[tbl_UserBadgeHistory]
           ([UserBadgeID]
           ,[UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		SELECT UserBadgeID,
			UserID,
			StatusID,
			BadgeID, 
			BadgeGivenBy,
			IsActive, 
			CreatedDate, 
			CreatedBy, 
			ModifiedDate, 
			ModifiedBy, 
			Comments
		FROM tbl_UserBadge
		WHERE UserBadgeID = @BadgeInsertedValue;
			 
    END
    ELSE IF UPPER(@Type) = 'USER'
    BEGIN
		-- If user gives a badge it goes to manager for approval
		INSERT INTO [dbo].[tbl_UserBadge]
           ([UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		VALUES
           (@BadgeGivenTo
           ,@StatusID_PendingWithManager
           ,@BadgeID
           ,@LoggedInUserID
           ,1
           ,GETDATE()
           ,@LoggedInUserID
           ,NULL
           ,NULL
           ,@Comments)
           
         SET @BadgeInsertedValue = @@IDENTITY;
         
         INSERT INTO [dbo].[tbl_UserBadgeHistory]
           ([UserBadgeID]
           ,[UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		SELECT UserBadgeID,
			UserID,
			StatusID,
			BadgeID, 
			BadgeGivenBy,
			IsActive, 
			CreatedDate, 
			CreatedBy, 
			ModifiedDate, 
			ModifiedBy, 
			Comments
		FROM tbl_UserBadge
		WHERE UserBadgeID = @BadgeInsertedValue;
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
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+ 
						' | @BadgeGivenTo ='+CONVERT(NVARCHAR(MAX),@BadgeGivenTo)+ 
						' | @BadgeID ='+CONVERT(NVARCHAR(MAX),@BadgeID);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savBadge',@Params;
	END
			
END CATCH
END	

GO

PRINT 'CREATE PROCEDURE [dbo].[usp_savApproveBadge]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_savApproveBadge]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_savApproveBadge]
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savApproveBadge]
    @LoggedInUserID INT,
    @Comments VARCHAR(MAX),
    @UserBadgeID INT
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_ManagerApproved INT;
	
	SET @StatusID_ManagerApproved = [dbo].[fn_GetStatusIDFromCode]('MGR_APR');
	
	-- Update the status as manager approved
	UPDATE tbl_UserBadge
	SET [StatusID] = @StatusID_ManagerApproved,
		[ModifiedBy] = @LoggedInUserID,
		[ModifiedDate] = GETDATE()
	WHERE UserBadgeID = @UserBadgeID;
   
	-- Create an entry in history table         
	INSERT INTO [dbo].[tbl_UserBadgeHistory]
				(
				 [UserBadgeID]
				,[UserID]
				,[StatusID]
				,[BadgeID]
				,[BadgeGivenBy]
				,[IsActive]
				,[CreatedDate]
				,[CreatedBy]
				,[ModifiedDate]
				,[ModifiedBy]
				,[Comments]
				)
		SELECT UserBadgeID,
				UserID,
				StatusID,
				BadgeID, 
				BadgeGivenBy,
				IsActive, 
				CreatedDate, 
				CreatedBy, 
				ModifiedDate, 
				ModifiedBy, 
				Comments
		FROM tbl_UserBadge
		WHERE UserBadgeID = @UserBadgeID;
	
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
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @UserBadgeID ='+CONVERT(NVARCHAR(MAX),@UserBadgeID);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savApproveBadge',@Params;
	END
			
END CATCH
END	

GO

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
				uir.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL
		FROM tbl_UserInitialSkillRequest uir 
		INNER JOIN tbl_Status s
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
				ud.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserDemo ud 
		INNER JOIN tbl_Status s
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
				uc.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserCertificate uc 
		INNER JOIN tbl_Status s
			ON uc.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = uc.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = uc.RequestedSubskillID
		WHERE uc.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'BADGE'
	BEGIN
		SELECT 'Badge' AS [Request type], 
				UB.CreatedDate AS [Request date], 
				ST.StatusDescription AS [Status] , 
				NULL AS [Skill],
				NULL AS [Sub-skill],
				UB.Comments,
				BM.BadgeID,
				BM.BadgeName,
				BM.BadgeImageURL,
				GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor]
		FROM tbl_UserBadge UB
		INNER JOIN AspNetUsers GivenFor
			ON GivenFor.Id = UB.UserID
		INNER JOIN tbl_BadgeMaster BM
			ON BM.BadgeID = UB.BadgeID
		INNER JOIN tbl_Status ST
			ON ST.StatusID = UB.StatusID
		WHERE BadgeGivenBy = @LoggedInUserID
	END
	ELSE
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
				uir.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status], 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uir.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserInitialSkillRequest uir 
		INNER JOIN tbl_Status s
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
				ud.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserDemo ud 
		INNER JOIN tbl_Status s
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
				uc.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserCertificate uc 
		INNER JOIN tbl_Status s
			ON uc.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = uc.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = uc.RequestedSubskillID
		WHERE uc.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Badge' AS [Request type], 
				UB.CreatedDate AS [Request date], 
				ST.StatusDescription AS [Status] , 
				NULL AS [Skill],
				NULL AS [Sub-skill],
				UB.Comments,
				BM.BadgeID,
				BM.BadgeName,
				BM.BadgeImageURL,
				GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor]
		FROM tbl_UserBadge UB
		INNER JOIN AspNetUsers GivenFor
			ON GivenFor.Id = UB.UserID
		INNER JOIN tbl_BadgeMaster BM
			ON BM.BadgeID = UB.BadgeID
		INNER JOIN tbl_Status ST
			ON ST.StatusID = UB.StatusID
		WHERE BadgeGivenBy = @LoggedInUserID;
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
			'INIT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
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
			'DEMO' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
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
			'CERT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
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
	ELSE IF UPPER(@Type) = 'BADGE'
	BEGIN
	
	SELECT 'Badge' AS [Request type], 
			UB.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			UB.Comments,
			NULL AS SkillName,
			NULL AS SubskillName,
			NULL AS SkillPoints,
			NULL AS FileGUID,
			NULL AS [FileName],
			UB.UserBadgeID AS [UniqueID],
			GivenBy.FirstName + ISNULL(' '+GivenBy.LastName,'') AS [UserName],
			'BADGE' AS [RequestCode],
			GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor],
			BM.BadgeID,
			BM.BadgeName,
			BM.BadgeImageURL
	FROM tbl_UserBadge UB
	INNER JOIN AspNetUsers GivenFor
		ON GivenFor.Id = UB.UserID
	INNER JOIN AspNetUsers GivenBy
		ON GivenBy.Id = UB.BadgeGivenBy
	INNER JOIN tbl_BadgeMaster BM
		ON BM.BadgeID = UB.BadgeID
	INNER JOIN tbl_Status ST
		ON ST.StatusID = UB.StatusID
	WHERE UB.StatusID = @StatusID_PendingWithManager
	
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
			'INIT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
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
			    'DEMO' AS [RequestCode],
			    NULL AS [BadgeGivenFor],
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL
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
			'CERT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
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
	
	UNION ALL
	
	SELECT 'Badge' AS [Request type], 
			UB.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			UB.Comments,
			NULL AS SkillName,
			NULL AS SubskillName,
			NULL AS SkillPoints,
			NULL AS FileGUID,
			NULL AS [FileName],
			UB.UserBadgeID AS [UniqueID],
			GivenBy.FirstName + ISNULL(' '+GivenBy.LastName,'') AS [UserName],
			'BADGE' AS [RequestCode],
			GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor],
			BM.BadgeID,
			BM.BadgeName,
			BM.BadgeImageURL
	FROM tbl_UserBadge UB
	INNER JOIN AspNetUsers GivenFor
		ON GivenFor.Id = UB.UserID
	INNER JOIN AspNetUsers GivenBy
		ON GivenBy.Id = UB.BadgeGivenBy
	INNER JOIN tbl_BadgeMaster BM
		ON BM.BadgeID = UB.BadgeID
	INNER JOIN tbl_Status ST
		ON ST.StatusID = UB.StatusID
	WHERE UB.StatusID = @StatusID_PendingWithManager
	
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

PRINT 'CREATE PROCEDURE [dbo].[usp_getAllUsersByName]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_getAllUsersByName]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_getAllUsersByName]
GO

CREATE PROCEDURE [dbo].[usp_getAllUsersByName] 
    @LoggedInUserID int,
    @NamePrefix VARCHAR(50) 
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT FirstName + ISNULL(' '+LastName,'')AS [UserName],
			   Id AS [UserID]
		FROM AspNetUsers
		WHERE Id <> @LoggedInUserID
		AND FirstName LIKE @NamePrefix+'%';

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
						'NamePrefix='+CONVERT(NVARCHAR(MAX),@NamePrefix);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllUsersByName',@Params;
		END
	END CATCH
END

GO
INSERT INTO [dbo].[Tbl_VersionMaster]
           ([Major]
           ,[Minor]
           ,[Customization]
           ,[Patch])
     VALUES
           (11
           ,0
           ,0
           ,0)
PRINT 'Version 11.0.0.0 executed'
GO


