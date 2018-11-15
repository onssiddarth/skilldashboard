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

