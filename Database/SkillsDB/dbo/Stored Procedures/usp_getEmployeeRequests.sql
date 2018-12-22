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

