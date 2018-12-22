PRINT '========================================='
PRINT '================V3.0.0.0================='
PRINT '================DDL.sql=================='
PRINT '========================================='

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RequestedSubskillID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificate'))
BEGIN
	ALTER TABLE tbl_UserCertificate
	ADD RequestedSubskillID INT
	
	PRINT 'RequestedSubskillID added to tbl_UserCertificate...'
END
ELSE
BEGIN
	PRINT 'RequestedSubskillID already present in tbl_UserCertificate...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RequestedSkillID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificate'))
BEGIN
	ALTER TABLE tbl_UserCertificate
	ADD RequestedSkillID INT
	
	PRINT 'RequestedSkillID added to tbl_UserCertificate...'
END
BEGIN
	PRINT 'RequestedSkillID already present in tbl_UserCertificate...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RequestedSubskillID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificateHistory'))
BEGIN
	ALTER TABLE tbl_UserCertificateHistory
	ADD RequestedSubskillID INT
	
	PRINT 'RequestedSubskillID added to tbl_UserCertificateHistory...'
END
ELSE
BEGIN
	PRINT 'RequestedSubskillID already present in tbl_UserCertificateHistory...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RequestedSkillID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificateHistory'))
BEGIN
	ALTER TABLE tbl_UserCertificateHistory
	ADD RequestedSkillID INT
	
	PRINT 'RequestedSkillID added to tbl_UserCertificateHistory...'
END
ELSE
BEGIN
	PRINT 'RequestedSkillID already present in tbl_UserCertificateHistory...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'UserID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificateHistory'))
BEGIN
	ALTER TABLE tbl_UserCertificateHistory
	ADD UserID INT
	
	PRINT 'UserID added to tbl_UserCertificateHistory...'
END
ELSE
BEGIN
	PRINT 'UserID already present in tbl_UserCertificateHistory...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'UserID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificate'))
BEGIN
	ALTER TABLE tbl_UserCertificate
	ADD UserID INT
	
	PRINT 'UserID added to tbl_UserCertificate...'
END
ELSE
BEGIN
	PRINT 'UserID already present in tbl_UserCertificate...'
END
