CREATE TABLE [dbo].[tbl_BadgeMaster] (
    [BadgeID]       INT           IDENTITY (1, 1) NOT NULL,
    [BadgeName]     VARCHAR (50)  NULL,
    [BadgeImageURL] VARCHAR (50) NULL,
    [IsActive]      BIT           NULL,
    [CreatedDate]   DATETIME      NULL,
    [CreatedBy]     INT           NULL,
    [ModifiedDate]  DATETIME      NULL,
    [ModifiedBy]    INT           NULL,
    PRIMARY KEY CLUSTERED ([BadgeID] ASC),
    UNIQUE NONCLUSTERED ([BadgeName] ASC)
);

