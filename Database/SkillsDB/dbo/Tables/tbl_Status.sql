CREATE TABLE [dbo].[tbl_Status] (
    [StatusID]          INT           IDENTITY (1, 1) NOT NULL,
    [StatusCode]        VARCHAR (10)  NULL,
    [StatusDescription] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([StatusID] ASC),
    UNIQUE NONCLUSTERED ([StatusCode] ASC)
);

