PRINT '========================================='
PRINT '================V11.0.0.0================'
PRINT '==============Static.sql================='
PRINT '========================================='

IF NOT EXISTS(SELECT 1 FROM [dbo].[tbl_BadgeMaster] WHERE [BadgeName] = 'SKILLEXPERTBADGE')
BEGIN
	INSERT INTO [SkillsDB].[dbo].[tbl_BadgeMaster]
           ([BadgeName]
           ,[BadgeImageURL]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (
			'EXPERTBADGE',
			'EXPERT.png',
			1,
			GETDATE(),
			1,
			NULL,
			NULL
           )
    PRINT 'SKILLEXPERTBADGE badge inserted...'
END
ELSE
BEGIN
	PRINT 'SKILLEXPERTBADGE already exists...'
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[tbl_BadgeMaster] WHERE [BadgeName] = 'USERBADGE')
BEGIN
	INSERT INTO [SkillsDB].[dbo].[tbl_BadgeMaster]
           ([BadgeName]
           ,[BadgeImageURL]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (
			'USERBADGE',
			'USERBADGE.png',
			1,
			GETDATE(),
			1,
			NULL,
			NULL
           )
    PRINT 'USERBADGE badge inserted...'
END
ELSE
BEGIN
	PRINT 'USERBADGE already exists...'
END
