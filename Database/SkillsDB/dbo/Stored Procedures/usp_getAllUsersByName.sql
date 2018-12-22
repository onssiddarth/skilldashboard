CREATE PROCEDURE [dbo].[usp_getAllUsersByName] 
    @LoggedInUserID int,
    @NamePrefix VARCHAR(50) 
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT FirstName + ISNULL(' '+LastName,'')AS [UserName],
			   Id AS [UserID]
		FROM AspNetUsers
		WHERE Id <> @LoggedInUserID
		AND FirstName LIKE @NamePrefix+'%';

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
						'NamePrefix='+CONVERT(NVARCHAR(MAX),@NamePrefix);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllUsersByName',@Params;
		END
	END CATCH
END

