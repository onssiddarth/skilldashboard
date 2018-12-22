PRINT '========================================='
PRINT '================V3.0.0.0================='
PRINT '================DML.sql=================='
PRINT '========================================='

PRINT 'CREATE PROCEDURE [dbo].[usp_sav_ImproveSkills]...'
GO
IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[usp_sav_ImproveSkills]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

DROP PROCEDURE [dbo].[usp_sav_ImproveSkills]
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_ImproveSkills] 
	-- Add the parameters for the stored procedure here
	@LoggedInUserID INT, -- Logged In User
	@SkillSetXML XML,
	@Comments VARCHAR(MAX),
	@Type VARCHAR(50), -- DEMO/CERTIFICATE
	@FileUploadPath VARCHAR(MAX) = NULL
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
	
	IF @Type = 'DEMO'
	BEGIN
		INSERT INTO [dbo].[tbl_UserDemo]
           ([UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
        OUTPUT INSERTED.UDID INTO @SkillIDInserted
		SELECT @LoggedInUserID,
				SubSkillID,
				SkillID,
				[dbo].[fn_GetStatusIDFromCode]('MGR_PND'),
				@Comments,
				NULL,
				NULL,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
     FROM @TempEmployeeSkill;
     
     -- Create History
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
     SELECT UDID
           ,UserID
           ,AcquiredSubskillID
           ,AcquiredSkillID
           ,StatusID
           ,Comments
           ,Room
           ,DateAndTime
           ,CreatedDate
           ,CreatedBy
     FROM [dbo].[tbl_UserDemo] 
     WHERE [UDID] IN (SELECT REQUESTID FROM @SkillIDInserted);
     
	END
	ELSE IF @Type = 'CERTIFICATE' 
	BEGIN
		
		INSERT INTO [dbo].[tbl_UserCertificate]
           ([ImagePath]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID])
       OUTPUT INSERTED.UCID INTO @SkillIDInserted
       SELECT @FileUploadPath,
			  [dbo].[fn_GetStatusIDFromCode]('MGR_PND'),
			  @Comments,
			  GETDATE(),
			  @LoggedInUserID,
			  NULL,
			  NULL,
			  SubSkillID,
			  SkillID,
			  @LoggedInUserID		
     FROM @TempEmployeeSkill;
     
     -- Create History
     INSERT INTO [dbo].[tbl_UserCertificateHistory]
           ([UCID]
           ,[ImagePath]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID])
     SELECT UCID
           ,ImagePath
           ,StatusID
           ,Comments
           ,CreatedDate
           ,CreatedBy
           ,ModifiedDate
           ,ModifiedBy
           ,RequestedSubskillID
           ,RequestedSkillID
           ,UserID
     FROM [dbo].[tbl_UserCertificate]
     WHERE UCID IN (SELECT REQUESTID FROM @SkillIDInserted);
	END
			
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
						' | @SkillSetXML ='+CONVERT(NVARCHAR(MAX),@SkillSetXML)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @FileUploadPath ='+CONVERT(NVARCHAR(MAX),@FileUploadPath);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_sav_ImproveSkills',@Params;
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
           (3
           ,0
           ,0
           ,0)
PRINT 'Version 3.0.0.0 executed'
GO
