-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savApproveBadge]
    @LoggedInUserID INT,
    @Comments VARCHAR(MAX),
    @UserBadgeID INT,
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
	
	-- Update the status as manager approved
	UPDATE tbl_UserBadge
	SET [StatusID] = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		[ModifiedBy] = @LoggedInUserID,
		[ModifiedDate] = GETDATE(),
		[Comments] = @Comments
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
						' | @UserBadgeID ='+CONVERT(NVARCHAR(MAX),@UserBadgeID)+
						' | @Status ='+CONVERT(NVARCHAR(MAX),@Status);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savApproveBadge',@Params;
	END
			
END CATCH
END	

