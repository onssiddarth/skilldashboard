PRINT '========================================='
PRINT '================V1.0.0.0================='
PRINT '================DDL.sql=================='
PRINT '========================================='

PRINT 'Table creation started....'
GO
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = '__MigrationHistory')
BEGIN
	CREATE TABLE [dbo].[__MigrationHistory] (
    [MigrationId]    NVARCHAR (150)  NOT NULL,
    [ContextKey]     NVARCHAR (300)  NOT NULL,
    [Model]          VARBINARY (MAX) NOT NULL,
    [ProductVersion] NVARCHAR (32)   NOT NULL,
    CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED ([MigrationId] ASC, [ContextKey] ASC)
);
	PRINT '__MigrationHistory created...'
END
ELSE
BEGIN
	PRINT '__MigrationHistory already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'AspNetRoles')
BEGIN
	CREATE TABLE [dbo].[AspNetRoles] (
    [Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([Name] ASC);
	PRINT 'AspNetRoles created...'
END
ELSE
BEGIN
	PRINT 'AspNetRoles already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'AspNetUsers')
BEGIN
	CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]            NVARCHAR (MAX) NULL,
    [MiddleName]           NVARCHAR (MAX) NULL,
    [LastName]             NVARCHAR (MAX) NULL,
    [Address]              NVARCHAR (MAX) NULL,
    [Email]                NVARCHAR (256) NULL,
    [EmailConfirmed]       BIT            NOT NULL,
    [PasswordHash]         NVARCHAR (MAX) NULL,
    [SecurityStamp]        NVARCHAR (MAX) NULL,
    [PhoneNumber]          NVARCHAR (MAX) NULL,
    [PhoneNumberConfirmed] BIT            NOT NULL,
    [TwoFactorEnabled]     BIT            NOT NULL,
    [LockoutEndDateUtc]    DATETIME       NULL,
    [LockoutEnabled]       BIT            NOT NULL,
    [AccessFailedCount]    INT            NOT NULL,
    [UserName]             NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([UserName] ASC);
    
	PRINT 'AspNetUsers already exists...'

END
ELSE
BEGIN
	PRINT 'AspNetUsers already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'AspNetUserClaims')
BEGIN
	CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [UserId]     INT            NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserClaims]([UserId] ASC);

	PRINT 'AspNetUserClaims created...'
END
ELSE
BEGIN
	PRINT 'AspNetUserClaims already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'AspNetUserLogins')
BEGIN
	CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider] NVARCHAR (128) NOT NULL,
    [ProviderKey]   NVARCHAR (128) NOT NULL,
    [UserId]        INT            NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
    CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserLogins]([UserId] ASC);

	PRINT 'AspNetUserLogins created...'
END
ELSE
BEGIN
	PRINT 'AspNetUserLogins already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'AspNetUserRoles')
BEGIN
	CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] INT NOT NULL,
    [RoleId] INT NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
    CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserRoles]([UserId] ASC);


CREATE NONCLUSTERED INDEX [IX_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);

	PRINT 'AspNetUserRoles created...'
END
ELSE
BEGIN
	PRINT 'AspNetUserRoles already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_BadgeMaster')
BEGIN
	CREATE TABLE [dbo].[tbl_BadgeMaster] (
    [BadgeID]       INT           IDENTITY (1, 1) NOT NULL,
    [BadgeName]     VARCHAR (10)  NULL,
    [BadgeImageURL] VARCHAR (MAX) NULL,
    [IsActive]      BIT           NULL,
    [CreatedDate]   DATETIME      NULL,
    [CreatedBy]     INT           NULL,
    [ModifiedDate]  DATETIME      NULL,
    [ModifiedBy]    INT           NULL,
    PRIMARY KEY CLUSTERED ([BadgeID] ASC),
    UNIQUE NONCLUSTERED ([BadgeName] ASC)
);
	PRINT 'tbl_BadgeMaster created...'
END
ELSE
BEGIN
	PRINT 'tbl_BadgeMaster already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'Tbl_ErrorLogs')
BEGIN
	CREATE TABLE [dbo].[Tbl_ErrorLogs] (
    [ErrorLogID]     INT           IDENTITY (1, 1) NOT NULL,
    [StoredProcName] VARCHAR (100) NOT NULL,
    [Parameters]     VARCHAR (MAX) NULL,
    [StackTrace]     VARCHAR (MAX) NULL,
    [DateCreated]    DATETIME      NOT NULL,
    CONSTRAINT [PK_Tbl_ErrorLogs] PRIMARY KEY CLUSTERED ([ErrorLogID] ASC)
);
	PRINT 'Tbl_ErrorLogs created...'
END
ELSE
BEGIN
	PRINT 'Tbl_ErrorLogs already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_SkillMaster')
BEGIN
	CREATE TABLE [dbo].[tbl_SkillMaster] (
    [SkillID]      INT           IDENTITY (1, 1) NOT NULL,
    [SkillName]    VARCHAR (100) NULL,
    [IsActive]     BIT           NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    PRIMARY KEY CLUSTERED ([SkillID] ASC),
    UNIQUE NONCLUSTERED ([SkillName] ASC)
);


	PRINT 'tbl_SkillMaster created...'
END
ELSE
BEGIN
	PRINT 'tbl_SkillMaster already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_SubskillMaster')
BEGIN
	CREATE TABLE [dbo].[tbl_SubskillMaster] (
    [SubskillID]   INT           IDENTITY (1, 1) NOT NULL,
    [SkillID]      INT           NULL,
    [SubskillName] VARCHAR (100) NULL,
    [SkillPoints]  INT           NULL,
    [IsActive]     BIT           NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    PRIMARY KEY CLUSTERED ([SubskillID] ASC),
    FOREIGN KEY ([SkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
);
	PRINT 'tbl_SubskillMaster created...'
END
ELSE
BEGIN
	PRINT 'tbl_SubskillMaster already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_Status')
BEGIN
	CREATE TABLE [dbo].[tbl_Status] (
    [StatusID]          INT           IDENTITY (1, 1) NOT NULL,
    [StatusCode]        VARCHAR (10)  NULL,
    [StatusDescription] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([StatusID] ASC),
    UNIQUE NONCLUSTERED ([StatusCode] ASC)
);
	PRINT 'tbl_Status created...'
END
ELSE
BEGIN
	PRINT 'tbl_Status already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'Tbl_testUsers')
BEGIN
	CREATE TABLE [dbo].[Tbl_testUsers] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (100) NULL,
    [Age]          INT           NULL,
    [Address]      VARCHAR (100) NULL,
    [AddedBy]      VARCHAR (100) NULL,
    [AddedDate]    DATETIME      NULL,
    [ModifiedBy]   VARCHAR (100) NULL,
    [ModifiedDate] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);
	PRINT 'Tbl_testUsers created...'
END
ELSE
BEGIN
	PRINT 'Tbl_testUsers already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserAcquiredSkillSubskill')
BEGIN
	CREATE TABLE [dbo].[tbl_UserAcquiredSkillSubskill] (
    [UASSID]             INT      IDENTITY (1, 1) NOT NULL,
    [UserID]             INT      NULL,
    [AcquiredSubskillID] INT      NULL,
    [AcquiredSkillID]    INT      NULL,
    [Type]               INT      NULL,
    [IsActive]           BIT      NULL,
    [CreatedDate]        DATETIME NULL,
    [CreatedBy]          INT      NULL,
    [ModifiedDate]       DATETIME NULL,
    [ModifiedBy]         INT      NULL,
    PRIMARY KEY CLUSTERED ([UASSID] ASC),
    FOREIGN KEY ([AcquiredSkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID]),
    FOREIGN KEY ([AcquiredSubskillID]) REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserAcquiredSkillSubskill created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserAcquiredSkillSubskill already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserBadge')
BEGIN
	CREATE TABLE [dbo].[tbl_UserBadge] (
    [UserBadgeID]  INT      IDENTITY (1, 1) NOT NULL,
    [UserID]       INT      NULL,
    [StatusID]     INT      NULL,
    [BadgeID]      INT      NULL,
    [BadgeGivenBy] INT      NULL,
    [IsActive]     BIT      NULL,
    [CreatedDate]  DATETIME NULL,
    [CreatedBy]    INT      NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy]   INT      NULL,
    PRIMARY KEY CLUSTERED ([UserBadgeID] ASC),
    FOREIGN KEY ([BadgeID]) REFERENCES [dbo].[tbl_BadgeMaster] ([BadgeID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserBadge created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserBadge already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserBadgeHistory')
BEGIN
	CREATE TABLE [dbo].[tbl_UserBadgeHistory] (
    [UBHID]        INT      IDENTITY (1, 1) NOT NULL,
    [UserBadgeID]  INT      NULL,
    [UserID]       INT      NULL,
    [StatusID]     INT      NULL,
    [BadgeID]      INT      NULL,
    [BadgeGivenBy] INT      NULL,
    [IsActive]     BIT      NULL,
    [CreatedDate]  DATETIME NULL,
    [CreatedBy]    INT      NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy]   INT      NULL,
    PRIMARY KEY CLUSTERED ([UBHID] ASC),
    FOREIGN KEY ([BadgeID]) REFERENCES [dbo].[tbl_BadgeMaster] ([BadgeID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UserBadgeID]) REFERENCES [dbo].[tbl_UserBadge] ([UserBadgeID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserBadgeHistory created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserBadgeHistory already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserCertificate')
BEGIN
	CREATE TABLE [dbo].[tbl_UserCertificate] (
    [UCID]         INT           IDENTITY (1, 1) NOT NULL,
    [ImagePath]    VARCHAR (MAX) NULL,
    [StatusID]     INT           NULL,
    [Comments]     VARCHAR (MAX) NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    PRIMARY KEY CLUSTERED ([UCID] ASC),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID])
);
	PRINT 'tbl_UserCertificate created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserCertificate already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserCertificateHistory')
BEGIN
	CREATE TABLE [dbo].[tbl_UserCertificateHistory] (
    [UCHID]        INT           IDENTITY (1, 1) NOT NULL,
    [UCID]         INT           NULL,
    [ImagePath]    VARCHAR (MAX) NULL,
    [StatusID]     INT           NULL,
    [Comments]     VARCHAR (MAX) NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    PRIMARY KEY CLUSTERED ([UCHID] ASC),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UCID]) REFERENCES [dbo].[tbl_UserCertificate] ([UCID])
);
	PRINT 'tbl_UserCertificateHistory created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserCertificateHistory already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserDemo')
BEGIN
	CREATE TABLE [dbo].[tbl_UserDemo] (
    [UDID]               INT           IDENTITY (1, 1) NOT NULL,
    [UserID]             INT           NULL,
    [AcquiredSubskillID] INT           NULL,
    [AcquiredSkillID]    INT           NULL,
    [StatusID]           INT           NULL,
    [Comments]           VARCHAR (MAX) NULL,
    [Room]               VARCHAR (25)  NULL,
    [DateAndTime]        DATETIME      NULL,
    [CreatedDate]        DATETIME      NULL,
    [CreatedBy]          INT           NULL,
    [ModifiedDate]       DATETIME      NULL,
    [ModifiedBy]         INT           NULL,
    PRIMARY KEY CLUSTERED ([UDID] ASC),
    FOREIGN KEY ([AcquiredSkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID]),
    FOREIGN KEY ([AcquiredSubskillID]) REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserDemo created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserDemo already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserDemoHistory')
BEGIN
	CREATE TABLE [dbo].[tbl_UserDemoHistory] (
    [UDHistoryID]        INT           IDENTITY (1, 1) NOT NULL,
    [UDID]               INT           NULL,
    [UserID]             INT           NULL,
    [AcquiredSubskillID] INT           NULL,
    [AcquiredSkillID]    INT           NULL,
    [StatusID]           INT           NULL,
    [Comments]           VARCHAR (MAX) NULL,
    [Room]               VARCHAR (25)  NULL,
    [DateAndTime]        DATETIME      NULL,
    [CreatedDate]        DATETIME      NULL,
    [CreatedBy]          INT           NULL,
    PRIMARY KEY CLUSTERED ([UDHistoryID] ASC),
    FOREIGN KEY ([AcquiredSkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID]),
    FOREIGN KEY ([AcquiredSubskillID]) REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UDID]) REFERENCES [dbo].[tbl_UserDemo] ([UDID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserDemoHistory created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserDemoHistory already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserInitialSkillRequest')
BEGIN
	CREATE TABLE [dbo].[tbl_UserInitialSkillRequest] (
    [UISRID]              INT           IDENTITY (1, 1) NOT NULL,
    [UserID]              INT           NULL,
    [RequestedSubskillID] INT           NULL,
    [RequestedSkillID]    INT           NULL,
    [StatusID]            INT           NULL,
    [Comments]            VARCHAR (MAX) NULL,
    [CreatedDate]         DATETIME      NULL,
    [CreatedBy]           INT           NULL,
    [ModifiedDate]        DATETIME      NULL,
    [ModifiedBy]          INT           NULL,
    PRIMARY KEY CLUSTERED ([UISRID] ASC),
    FOREIGN KEY ([RequestedSkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID]),
    FOREIGN KEY ([RequestedSkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID]),
    FOREIGN KEY ([RequestedSubskillID]) REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID]),
    FOREIGN KEY ([RequestedSubskillID]) REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserInitialSkillRequest created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserInitialSkillRequest already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserInitialSkillRequestHistory')
BEGIN
	CREATE TABLE [dbo].[tbl_UserInitialSkillRequestHistory] (
    [UISRHistoryID]       INT           IDENTITY (1, 1) NOT NULL,
    [UISRID]              INT           NOT NULL,
    [UserID]              INT           NULL,
    [RequestedSubskillID] INT           NULL,
    [RequestedSkillID]    INT           NULL,
    [StatusID]            INT           NULL,
    [Comments]            VARCHAR (MAX) NULL,
    [CreatedDate]         DATETIME      NULL,
    [CreatedBy]           INT           NULL,
    [ModifiedDate]        DATETIME      NULL,
    [ModifiedBy]          INT           NULL,
    PRIMARY KEY CLUSTERED ([UISRID] ASC),
    FOREIGN KEY ([UISRID]) REFERENCES [dbo].[tbl_UserInitialSkillRequest] ([UISRID])
);
	PRINT 'tbl_UserInitialSkillRequestHistory created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserInitialSkillRequestHistory already exists...'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'tbl_UserRequiredSkillSubskill')
BEGIN
	CREATE TABLE [dbo].[tbl_UserRequiredSkillSubskill] (
    [URSSID]             INT      IDENTITY (1, 1) NOT NULL,
    [UserID]             INT      NULL,
    [RequiredSubskillID] INT      NULL,
    [RequiredSkillID]    INT      NULL,
    [IsActive]           BIT      NULL,
    [CreatedDate]        DATETIME NULL,
    [CreatedBy]          INT      NULL,
    [ModifiedDate]       DATETIME NULL,
    [ModifiedBy]         INT      NULL,
    PRIMARY KEY CLUSTERED ([URSSID] ASC),
    FOREIGN KEY ([RequiredSkillID]) REFERENCES [dbo].[tbl_SkillMaster] ([SkillID]),
    FOREIGN KEY ([RequiredSubskillID]) REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);
	PRINT 'tbl_UserRequiredSkillSubskill created...'
END
ELSE
BEGIN
	PRINT 'tbl_UserRequiredSkillSubskill already exists...'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'Tbl_VersionMaster')
BEGIN
	CREATE TABLE [dbo].[Tbl_VersionMaster](
	[VersionID] [int] IDENTITY(1,1) NOT NULL,
	[Major] [int] NOT NULL,
	[Minor] [int] NOT NULL,
	[Customization] [int] NOT NULL,
	[Patch] [int] NULL,
 CONSTRAINT [PK_Tbl_VersionMaster] PRIMARY KEY CLUSTERED 
(
	[VersionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

	PRINT 'Tbl_VersionMaster created...'
END
ELSE
BEGIN
	PRINT 'Tbl_VersionMaster already exists...'
END

GO
PRINT 'Table Creation ends here...'