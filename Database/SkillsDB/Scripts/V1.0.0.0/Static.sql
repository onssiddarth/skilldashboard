PRINT '========================================='
PRINT '================V1.0.0.0================='
PRINT '==============Static.sql================='
PRINT '========================================='

PRINT 'Creating data script for status...'
GO

MERGE INTO tbl_Status AS Target
USING(VALUES('MGR_PND','Pending with Manager'),
('MGR_APR','Manager Approved'),
('MGR_REJ','Manager Rejected'),
('SE_APR','SkillExpert Approved'),
('SE_REJ','SE_REJ')
)
AS Source(
[StatusCode],
[StatusDescription]
)
ON (Target.[StatusCode] = Source.[StatusCode])
WHEN MATCHED THEN
UPDATE SET
	[StatusDescription] = Source.[StatusDescription]
WHEN NOT MATCHED BY TARGET THEN
INSERT (
[StatusCode],
[StatusDescription]
)	
VALUES(
Source.[StatusCode],
Source.[StatusDescription]
);

GO


PRINT 'Creating data script for SkillMaster...'
GO

MERGE INTO tbl_SkillMaster AS Target
USING(VALUES('C#',1,GETDATE(),1,NULL,NULL),
('SQL',1,GETDATE(),1,NULL,NULL),
('Python',1,GETDATE(),1,NULL,NULL),
('Java',1,GETDATE(),1,NULL,NULL)
)
AS Source(
[SkillName],
[IsActive],
[CreatedDate],
[CreatedBy],
[ModifiedDate],
[ModifiedBy]
)
ON (Target.[SkillName] = Source.[SkillName])
WHEN MATCHED THEN
UPDATE SET
	[IsActive] = Source.[IsActive],
	[ModifiedDate] = GETDATE(),
	[ModifiedBy] = 1
WHEN NOT MATCHED BY TARGET THEN
INSERT (
[SkillName],
[IsActive],
[CreatedDate],
[CreatedBy],
[ModifiedDate],
[ModifiedBy]
)	
VALUES(
Source.[SkillName],
Source.[IsActive],
Source.[CreatedDate],
Source.[CreatedBy],
Source.[ModifiedDate],
Source.[ModifiedBy]
);

GO

PRINT 'Creating data script for SubSkillMaster...'
GO

PRINT 'Creating Inheritance subskills for C#...'
GO
DECLARE @SkillIDC# INT;

SELECT @SkillIDC# = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'C#';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDC# AND [SubskillName] = 'Inheritance')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDC# 
           ,'Inheritance'
           ,10
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Inheritance skill inserted...'
END
ELSE
BEGIN
	PRINT 'Inheritance skill already exists...'
END


GO

PRINT 'Creating polymorphism subskills for C#...'
GO
DECLARE @SkillIDC# INT;

SELECT @SkillIDC# = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'C#';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDC# AND [SubskillName] = 'Polymorphism')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDC# 
           ,'Polymorphism'
           ,10
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Polymorphism skill inserted...'
END
ELSE
BEGIN
	PRINT 'Polymorphism skill already exists...'
END


GO

PRINT 'Creating LINQ subskills for C#...'
GO
DECLARE @SkillIDC# INT;

SELECT @SkillIDC# = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'C#';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDC# AND [SubskillName] = 'LINQ')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDC# 
           ,'LINQ'
           ,30
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'LINQ skill inserted...'
END
ELSE
BEGIN
	PRINT 'LINQ skill already exists...'
END


GO

PRINT 'Creating Multithreading subskills for C#...'
GO
DECLARE @SkillIDC# INT;

SELECT @SkillIDC# = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'C#';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDC# AND [SubskillName] = 'Multithreading')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDC# 
           ,'Multithreading'
           ,50
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Multithreading skill inserted...'
END
ELSE
BEGIN
	PRINT 'Multithreading skill already exists...'
END


GO

PRINT 'Creating OOPS subskills for Java...'
GO
DECLARE @SkillIDJava INT;

SELECT @SkillIDJava = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Java';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDJava AND [SubskillName] = 'OOPS')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDJava 
           ,'OOPS'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'OOPS skill inserted...'
END
ELSE
BEGIN
	PRINT 'OOPS skill already exists...'
END


GO

PRINT 'Creating Hibernate subskills for Java...'
GO
DECLARE @SkillIDJava INT;

SELECT @SkillIDJava = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Java';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDJava AND [SubskillName] = 'Hibernate')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDJava 
           ,'Hibernate'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Hibernate skill inserted...'
END
ELSE
BEGIN
	PRINT 'Hibernate skill already exists...'
END


GO

PRINT 'Creating Spring subskills for Java...'
GO
DECLARE @SkillIDJava INT;

SELECT @SkillIDJava = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Java';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDJava AND [SubskillName] = 'Spring')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDJava 
           ,'Spring'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Spring skill inserted...'
END
ELSE
BEGIN
	PRINT 'Spring skill already exists...'
END


GO

PRINT 'Creating File Handling subskills for Java...'
GO
DECLARE @SkillIDJava INT;

SELECT @SkillIDJava = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Java';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDJava AND [SubskillName] = 'File Handling')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDJava 
           ,'File Handling'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'File Handling skill inserted...'
END
ELSE
BEGIN
	PRINT 'File Handling skill already exists...'
END


GO

PRINT 'Creating OOPS subskills for Python...'
GO
DECLARE @SkillIDPython INT;

SELECT @SkillIDPython = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Python';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDPython AND [SubskillName] = 'OOPS')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDPython 
           ,'OOPS'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'OOPS skill inserted...'
END
ELSE
BEGIN
	PRINT 'OOPS skill already exists...'
END


GO

PRINT 'Creating Django subskills for Python...'
GO
DECLARE @SkillIDPython INT;

SELECT @SkillIDPython = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Python';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDPython AND [SubskillName] = 'Django')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDPython 
           ,'Django'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Django skill inserted...'
END
ELSE
BEGIN
	PRINT 'Django skill already exists...'
END


GO

PRINT 'Creating Flask subskills for Python...'
GO
DECLARE @SkillIDPython INT;

SELECT @SkillIDPython = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Python';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDPython AND [SubskillName] = 'Flask')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDPython 
           ,'Flask'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Flask skill inserted...'
END
ELSE
BEGIN
	PRINT 'Flask skill already exists...'
END

GO

PRINT 'Creating Numpy subskills for Python...'
GO
DECLARE @SkillIDPython INT;

SELECT @SkillIDPython = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'Python';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDPython AND [SubskillName] = 'Numpy')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDPython 
           ,'Numpy'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Numpy skill inserted...'
END
ELSE
BEGIN
	PRINT 'Numpy skill already exists...'
END

GO

PRINT 'Creating DDL subskills for SQL...'
GO
DECLARE @SkillIDSQL INT;

SELECT @SkillIDSQL = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'SQL';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDSQL AND [SubskillName] = 'DDL')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDSQL 
           ,'DDL'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'DDL skill inserted...'
END
ELSE
BEGIN
	PRINT 'DDL skill already exists...'
END

GO

PRINT 'Creating DML subskills for SQL...'
GO
DECLARE @SkillIDSQL INT;

SELECT @SkillIDSQL = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'SQL';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDSQL AND [SubskillName] = 'DML')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDSQL 
           ,'DML'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'DDL skill inserted...'
END
ELSE
BEGIN
	PRINT 'DDL skill already exists...'
END

GO

PRINT 'Creating PLSQL subskills for SQL...'
GO
DECLARE @SkillIDSQL INT;

SELECT @SkillIDSQL = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'SQL';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDSQL AND [SubskillName] = 'PLSQL')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDSQL 
           ,'PLSQL'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'PLSQL skill inserted...'
END
ELSE
BEGIN
	PRINT 'PLSQL skill already exists...'
END

GO

PRINT 'Creating Transactions subskills for SQL...'
GO
DECLARE @SkillIDSQL INT;

SELECT @SkillIDSQL = SkillID
FROM tbl_SkillMaster
WHERE SkillName = 'SQL';

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_SubskillMaster] WHERE [SkillID] = @SkillIDSQL AND [SubskillName] = 'Transactions')
BEGIN
INSERT INTO [dbo].[tbl_SubskillMaster]
           ([SkillID]
           ,[SubskillName]
           ,[SkillPoints]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@SkillIDSQL 
           ,'Transactions'
           ,25
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL)
     PRINT 'Transactions skill inserted...'
END
ELSE
BEGIN
	PRINT 'Transactions skill already exists...'
END

GO

GO

