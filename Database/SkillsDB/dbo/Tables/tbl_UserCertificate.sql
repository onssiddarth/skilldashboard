CREATE TABLE [dbo].[tbl_UserCertificate] (
    [UCID]         INT           IDENTITY (1, 1) NOT NULL,
    [ImagePath]    VARCHAR (MAX) NULL,
    [StatusID]     INT           NULL,
    [Comments]     VARCHAR (MAX) NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    PRIMARY KEY CLUSTERED ([UCID] ASC),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID])
);

