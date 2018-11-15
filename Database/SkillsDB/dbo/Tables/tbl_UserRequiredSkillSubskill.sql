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

