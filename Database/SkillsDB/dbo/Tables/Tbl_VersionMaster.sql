CREATE TABLE [dbo].[Tbl_VersionMaster](
	[VersionID] [int] IDENTITY(1,1) NOT NULL,
	[Major] [int] NOT NULL,
	[Minor] [int] NOT NULL,
	[Customization] [int] NOT NULL,
	[Patch] [int] NULL,
 CONSTRAINT [PK_Tbl_VersionMaster] PRIMARY KEY CLUSTERED 
(
	[VersionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO