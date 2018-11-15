-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_testAddUser 
	@Name VARCHAR(MAX),
	@Age INT,
	@Address VARCHAR(MAX),
	@LoggedInUser VARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    INSERT INTO [dbo].[Tbl_testUsers]
           ([Name]
           ,[Age]
           ,[Address]
           ,[AddedBy]
           ,[AddedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           (@Name
           ,@Age
           ,@Address
           ,@LoggedInUser
           ,GETDATE()
           ,NULL
           ,NULL)
           
END