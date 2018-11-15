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

