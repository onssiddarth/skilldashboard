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

