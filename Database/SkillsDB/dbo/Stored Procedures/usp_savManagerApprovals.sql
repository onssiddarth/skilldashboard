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

