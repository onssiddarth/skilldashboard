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

