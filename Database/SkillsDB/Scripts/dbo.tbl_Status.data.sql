SET IDENTITY_INSERT [dbo].[tbl_Status] ON
INSERT INTO [dbo].[tbl_Status] ([StatusID], [StatusCode], [StatusDescription]) VALUES (1, N'MGR_PND
', N'Pending with Manager
')
INSERT INTO [dbo].[tbl_Status] ([StatusID], [StatusCode], [StatusDescription]) VALUES (2, N'MGR_APR
', N'Manager Approved
')
INSERT INTO [dbo].[tbl_Status] ([StatusID], [StatusCode], [StatusDescription]) VALUES (3, N'MGR_REJ
', N'Manager Rejected
')
INSERT INTO [dbo].[tbl_Status] ([StatusID], [StatusCode], [StatusDescription]) VALUES (4, N'SE_APR

', N'SkillExpert Approved
')
INSERT INTO [dbo].[tbl_Status] ([StatusID], [StatusCode], [StatusDescription]) VALUES (5, N'SE_REJ
', N'SkillExpert Rejected
')
SET IDENTITY_INSERT [dbo].[tbl_Status] OFF
