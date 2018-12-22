PRINT '========================================='
PRINT '================V9.0.0.0================='
PRINT '==============Static.sql================='
PRINT '========================================='



IF EXISTS(SELECT 1 FROM Tbl_Status WHERE StatusCode = 'SE_REJ')
BEGIN
	UPDATE Tbl_Status
	SET StatusDescription = 'SkillExpert Rejected'
	WHERE StatusCode = 'SE_REJ';
	
	PRINT 'Description updated for skill expert rejected status...'
END
ELSE
BEGIN
	PRINT 'Status Code SE_REJ does not exist...'
END

IF NOT EXISTS(SELECT 1 FROM Tbl_Status WHERE StatusCode = 'DEMO_SCH')
BEGIN
	INSERT INTO Tbl_Status
			   (
				StatusCode,
				StatusDescription
			    )
	VALUES
				(
				'DEMO_SCH',
				'Demo scheduled by skill expert'
				)
	PRINT 'DEMO_SCH status inserted...'
END
ELSE
BEGIN
	PRINT 'DEMO_SCH status already exists...'
END