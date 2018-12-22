PRINT '========================================='
PRINT '================V6.0.0.0================='
PRINT '================DDL.sql=================='
PRINT '========================================='



IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='PK__tbl_User__F2C6C8D829221CFB')
BEGIN
	ALTER TABLE tbl_UserInitialSkillRequestHistory
	DROP CONSTRAINT  PK__tbl_User__F2C6C8D829221CFB;
	
	PRINT 'Constraint removed...'
END
ELSE
BEGIN
	PRINT 'Constraint does not exist...'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='PK__UserIntialHistory')
BEGIN
	ALTER TABLE tbl_UserInitialSkillRequestHistory
	ADD CONSTRAINT  PK__UserIntialHistoty PRIMARY KEY (UISRHistoryID);
	
	PRINT 'Constraint PK__UserIntialHistory created...'
END
ELSE
BEGIN
	PRINT 'Constraint already exists...'
END
	









