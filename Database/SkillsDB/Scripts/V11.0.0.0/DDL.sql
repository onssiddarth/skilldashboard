PRINT '========================================='
PRINT '================V11.0.0.0================'
PRINT '================DDL.sql=================='
PRINT '========================================='

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'Comments'
          AND Object_ID = Object_ID(N'dbo.Tbl_UserBadge'))
BEGIN
	ALTER TABLE Tbl_UserBadge
	ADD Comments VARCHAR(250)
	
	PRINT 'Comments column added to table Tbl_UserBadge...'
END
ELSE
BEGIN
	PRINT 'Comments column already exists in table Tbl_UserBadge...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'Comments'
          AND Object_ID = Object_ID(N'dbo.Tbl_UserBadgeHistory'))
BEGIN
	ALTER TABLE Tbl_UserBadgeHistory
	ADD Comments VARCHAR(250)
	
	PRINT 'Comments column added to table Tbl_UserBadgeHistory...'
END
ELSE
BEGIN
	PRINT 'Comments column already exists in table Tbl_UserBadgeHistory...'
END

PRINT 'Changing datatype for BadgeName Column in Tbl_BadgeMaster...'
GO
ALTER TABLE [dbo].[tbl_BadgeMaster]
ALTER COLUMN [BadgeName] VARCHAR(50)
GO

PRINT 'Changing datatype for BadgeImageURL Column in Tbl_BadgeMaster...'
GO
ALTER TABLE [dbo].[tbl_BadgeMaster]
ALTER COLUMN [BadgeImageURL] VARCHAR(50)
GO