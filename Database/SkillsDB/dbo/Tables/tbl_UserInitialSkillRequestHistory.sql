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

