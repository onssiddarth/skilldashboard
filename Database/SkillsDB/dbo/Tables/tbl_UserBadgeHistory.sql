CREATE TABLE [dbo].[tbl_UserBadgeHistory] (
    [UBHID]        INT      IDENTITY (1, 1) NOT NULL,
    [UserBadgeID]  INT      NULL,
    [UserID]       INT      NULL,
    [StatusID]     INT      NULL,
    [BadgeID]      INT      NULL,
    [BadgeGivenBy] INT      NULL,
    [IsActive]     BIT      NULL,
    [CreatedDate]  DATETIME NULL,
    [CreatedBy]    INT      NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy]   INT      NULL,
    PRIMARY KEY CLUSTERED ([UBHID] ASC),
    FOREIGN KEY ([BadgeID]) REFERENCES [dbo].[tbl_BadgeMaster] ([BadgeID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UserBadgeID]) REFERENCES [dbo].[tbl_UserBadge] ([UserBadgeID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);

