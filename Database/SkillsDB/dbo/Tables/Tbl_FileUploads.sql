CREATE TABLE [dbo].[Tbl_FileUploads](
	[FileUploadID] [int] IDENTITY(1,1) NOT NULL,
	[FileGUID] [varchar](max) NOT NULL,
	[FileName] [varchar](max) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_Tbl_FileUploads] PRIMARY KEY CLUSTERED 
(
	[FileUploadID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]