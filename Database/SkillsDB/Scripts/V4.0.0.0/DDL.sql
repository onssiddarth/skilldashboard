PRINT '========================================='
PRINT '================V4.0.0.0================='
PRINT '================DDL.sql=================='
PRINT '========================================='

PRINT 'CREATE TABLE [dbo].[Tbl_FileUploads]...'
GO
IF (NOT EXISTS (SELECT 1 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Tbl_FileUploads'))
BEGIN
	CREATE TABLE [dbo].[Tbl_FileUploads](
		[FileUploadID] [int] IDENTITY(1,1) NOT NULL,
		[FileGUID] [varchar](max) NOT NULL,
		[FileName] [varchar](max) NOT NULL,
		[DateCreated] [datetime] NOT NULL,
		[CreatedBy] [int] NOT NULL,
	 CONSTRAINT [PK_Tbl_FileUploads] PRIMARY KEY CLUSTERED 
	(
		[FileUploadID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	PRINT '[dbo].[Tbl_FileUploads] table created...'
END
ELSE
BEGIN
	PRINT '[dbo].[Tbl_FileUploads] table already exists...'
END

GO

IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'ImagePath'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificate'))
BEGIN
	ALTER TABLE tbl_UserCertificate
	DROP COLUMN ImagePath
	
	PRINT 'ImagePath column removed successfully from tbl_UserCertificate...'
END
ELSE
BEGIN
	PRINT 'ImagePath column does not exist in tbl_UserCertificate...'
END

IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'ImagePath'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificateHistory'))
BEGIN
	ALTER TABLE tbl_UserCertificateHistory
	DROP COLUMN ImagePath
	
	PRINT 'ImagePath column removed successfully from tbl_UserCertificateHistory...'
END
ELSE
BEGIN
	PRINT 'ImagePath column does not exist in tbl_UserCertificateHistory...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'FileUploadID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificate'))
BEGIN
	ALTER TABLE tbl_UserCertificate
	ADD FileUploadID INT 
	
	ALTER TABLE tbl_UserCertificate
	ADD CONSTRAINT FK_FileID
	FOREIGN KEY (FileUploadID) REFERENCES Tbl_FileUploads(FileUploadID);
	
	PRINT 'FileUploadID column added successfully to tbl_UserCertificate...'
END
ELSE
BEGIN
	PRINT 'FileUploadID column already exist in tbl_UserCertificate...'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'FileUploadID'
          AND Object_ID = Object_ID(N'dbo.tbl_UserCertificateHistory'))
BEGIN
	ALTER TABLE tbl_UserCertificateHistory
	ADD FileUploadID INT 
	
	PRINT 'FileUploadID column added successfully to tbl_UserCertificateHistory...'
END
ELSE
BEGIN
	PRINT 'FileUploadID column already exist in tbl_UserCertificateHistory...'
END



