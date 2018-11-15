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



