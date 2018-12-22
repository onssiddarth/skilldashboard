﻿-- =============================================
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