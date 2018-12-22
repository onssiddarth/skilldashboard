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


