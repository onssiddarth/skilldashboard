CREATE TABLE [dbo].[Tbl_ErrorLogs] (
    [ErrorLogID]     INT           IDENTITY (1, 1) NOT NULL,
    [StoredProcName] VARCHAR (100) NOT NULL,
    [Parameters]     VARCHAR (MAX) NULL,
    [StackTrace]     VARCHAR (MAX) NULL,
    [DateCreated]    DATETIME      NOT NULL,
    CONSTRAINT [PK_Tbl_ErrorLogs] PRIMARY KEY CLUSTERED ([ErrorLogID] ASC)
);

