CREATE TABLE [dbo].[tbl_UserCertificateHistory] (
    [UCHID]        INT           IDENTITY (1, 1) NOT NULL,
    [UCID]         INT           NULL,
    [ImagePath]    VARCHAR (MAX) NULL,
    [StatusID]     INT           NULL,
    [Comments]     VARCHAR (MAX) NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    PRIMARY KEY CLUSTERED ([UCHID] ASC),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UCID]) REFERENCES [dbo].[tbl_UserCertificate] ([UCID])
);

