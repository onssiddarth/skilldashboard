CREATE TABLE [dbo].[tbl_UserCertificate] (
    [UCID] [int] IDENTITY(1,1) NOT NULL,
	[StatusID] [int] NULL,
	[Comments] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[RequestedSubskillID] [int] NULL,
	[RequestedSkillID] [int] NULL,
	[UserID] [int] NULL,
	[FileUploadID] [int] NULL,
    PRIMARY KEY CLUSTERED ([UCID] ASC),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
	FOREIGN KEY ([FileUploadID]) REFERENCES [dbo].[Tbl_FileUploads] ([FileUploadID])
);

