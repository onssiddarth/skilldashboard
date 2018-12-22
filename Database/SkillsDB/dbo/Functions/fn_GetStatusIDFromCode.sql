-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION fn_GetStatusIDFromCode 
(
	@StatusCode VARCHAR(10)
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @StatusID INT;
	
	SELECT @StatusID = StatusID
	FROM tbl_Status
	WHERE StatusCode = @StatusCode;
	
	RETURN @StatusID;

END