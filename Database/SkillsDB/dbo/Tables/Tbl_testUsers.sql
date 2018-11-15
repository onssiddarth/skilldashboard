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

