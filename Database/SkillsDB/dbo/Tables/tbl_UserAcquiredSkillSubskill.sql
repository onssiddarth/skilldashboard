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

