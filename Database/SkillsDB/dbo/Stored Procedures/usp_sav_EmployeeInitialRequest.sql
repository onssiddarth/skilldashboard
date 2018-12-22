-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_EmployeeInitialRequest] 
	-- Add the parameters for the stored procedure here
	@LoggedInUserID INT, -- Logged In User
	@SkillSetXML XML,
	@Comments VARCHAR(MAX)
AS
BEGIN
	
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);
			
	
	DECLARE @TempEmployeeSkill AS TABLE(SkillID INT, SubSkillID INT);
	DECLARE @SkillIDInserted AS TABLE(REQUESTID INT)
	
	-- Move XML data to Temp Table
	INSERT INTO @TempEmployeeSkill(
			SkillID,
			SubSkillID
	)
	SELECT  x.SkillDataTable.value('SkillID[1]','INT') AS SkillID,
			 x.SkillDataTable.value('SubskillID[1]','INT') AS SubskillID			 
		FROM @SkillSetXML.nodes('SkillSet/Skill')
		AS x(SkillDataTable);
	
		
	--Insert data into request table	
	INSERT INTO [dbo].[tbl_UserInitialSkillRequest]
           ([UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     OUTPUT INSERTED.UISRID INTO @SkillIDInserted
     SELECT @LoggedInUserID,
			SubSkillID,
			SkillID,
			[dbo].[fn_GetStatusIDFromCode]('MGR_PND'),
			@Comments,
			GETDATE(),
			@LoggedInUserID,
			NULL,
			NULL
     FROM @TempEmployeeSkill;
     
     -- Create history of the record inserted
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
      SELECT UISRID 
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
      FROM tbl_UserInitialSkillRequest
      WHERE UISRID IN (SELECT REQUESTID FROM @SkillIDInserted); 
			
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
						' | @SkillSetXML ='+CONVERT(NVARCHAR(MAX),@SkillSetXML);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_sav_EmployeeInitialRequest',@Params;
	END
			
	

END CATCH
END

