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