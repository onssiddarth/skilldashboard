CREATE PROCEDURE [dbo].[usp_getAllSkillsAvailable] 
    @LoggedInUserID int
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT sm.SkillID, sm.SkillName from tbl_SkillMaster sm WHERE sm.IsActive=1;

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
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllSkillsAvailable',@Params;
		END
	END CATCH
END