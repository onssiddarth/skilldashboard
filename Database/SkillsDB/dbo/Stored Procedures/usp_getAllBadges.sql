CREATE PROCEDURE [dbo].[usp_getAllBadges] 
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

		SELECT BadgeID,
			   BadgeName,
			   BadgeImageURL
		FROM tbl_BadgeMaster
		WHERE IsActive=1
		AND BadgeName = ISNULL(@Type,BadgeName);

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
						'Type='+CONVERT(NVARCHAR(MAX),@Type);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllBadges',@Params;
		END
	END CATCH
END