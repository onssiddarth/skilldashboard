-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_getTestUsers
	@LoggedInUser VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ID,
		   Name,
		   Age,
		   Address,
		   AddedBy,
		   AddedDate,
		   ModifiedBy,
		   ModifiedDate
    FROM [dbo].[Tbl_testUsers]
END