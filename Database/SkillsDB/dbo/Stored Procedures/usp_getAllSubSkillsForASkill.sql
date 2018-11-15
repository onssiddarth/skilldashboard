CREATE PROCEDURE [dbo].[usp_getAllSubSkillsForASkill] 
    @LoggedInUserID int,
	@SkillID int
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT SkillID, 
				SubskillID, 
				SubskillName 
		FROM tbl_SubskillMaster
		WHERE SkillID=@SkillID 
				AND IsActive=1;

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
						' | SkillID ='+CONVERT(NVARCHAR,@SkillID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllSubSkillsForASkill',@Params;
		END
	END CATCH
END