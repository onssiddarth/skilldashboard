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

