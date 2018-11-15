
-- =============================================
-- Author:		Siddarth Nair
-- Create date: 1-April-2018
-- Description:	This stored procedure is used to save information about error logs
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_ErrorLog] 
	@StackTrace VARCHAR(MAX),
	@StoredProcName VARCHAR(100),
	@Parameters VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO [dbo].[Tbl_ErrorLogs]
           ([StoredProcName]
           ,[Parameters]
           ,[StackTrace]
           ,[DateCreated])
     VALUES
           (@StoredProcName
           ,@Parameters
           ,@StackTrace
           ,GETDATE());
    
END