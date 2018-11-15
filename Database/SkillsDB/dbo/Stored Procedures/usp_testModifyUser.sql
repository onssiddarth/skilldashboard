-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_testModifyUser
	@Name VARCHAR(MAX),
	@Age INT,
	@Address VARCHAR(MAX),
	@LoggedInUser VARCHAR(MAX),
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE [dbo].[Tbl_testUsers]
    SET Name = @Name,
		Age = @Age,
		Address = @Address,
		ModifiedBy = @LoggedInUser,
		ModifiedDate = GETDATE()
	WHERE ID = @UserID;
		
END