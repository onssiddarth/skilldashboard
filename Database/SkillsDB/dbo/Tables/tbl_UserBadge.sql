CREATE TABLE [dbo].[tbl_UserBadge] (
    [UserBadgeID]  INT      IDENTITY (1, 1) NOT NULL,
    [UserID]       INT      NULL,
    [StatusID]     INT      NULL,
    [BadgeID]      INT      NULL,
    [BadgeGivenBy] INT      NULL,
    [IsActive]     BIT      NULL,
    [CreatedDate]  DATETIME NULL,
    [CreatedBy]    INT      NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy]   INT      NULL,
    PRIMARY KEY CLUSTERED ([UserBadgeID] ASC),
    FOREIGN KEY ([BadgeID]) REFERENCES [dbo].[tbl_BadgeMaster] ([BadgeID]),
    FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbl_Status] ([StatusID]),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id])
);

