USE [master]
GO
/****** Object:  Database [SkillsDB]    Script Date: 07-01-2019 20:46:07 ******/
CREATE DATABASE [SkillsDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SkillsDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\SkillsDB.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SkillsDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\SkillsDB_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SkillsDB] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SkillsDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SkillsDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SkillsDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SkillsDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SkillsDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SkillsDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SkillsDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SkillsDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SkillsDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SkillsDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SkillsDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SkillsDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SkillsDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SkillsDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SkillsDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SkillsDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SkillsDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SkillsDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SkillsDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SkillsDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SkillsDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SkillsDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SkillsDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SkillsDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SkillsDB] SET  MULTI_USER 
GO
ALTER DATABASE [SkillsDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SkillsDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SkillsDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SkillsDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [SkillsDB] SET DELAYED_DURABILITY = DISABLED 
GO
USE [SkillsDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetStatusIDFromCode]    Script Date: 07-01-2019 20:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetStatusIDFromCode] 
(
	@StatusCode VARCHAR(10)
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @StatusID INT;
	
	SELECT @StatusID = StatusID
	FROM tbl_Status
	WHERE StatusCode = @StatusCode;
	
	RETURN @StatusID;

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUserSkillPoints]    Script Date: 07-01-2019 20:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetUserSkillPoints] 
(
	@SkillID INT,
	@UserID INT
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SkillPoints INT;
	
	SELECT @SkillPoints = SUM(SSM.SkillPoints)
	FROM tbl_UserAcquiredSkillSubskill UA
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SkillID = UA.AcquiredSkillID
		AND SSM.SubskillID = UA.AcquiredSubskillID
	WHERE UA.AcquiredSkillID = @SkillID
	AND UA.UserID = @UserID;
	
	RETURN @SkillPoints;

END
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 07-01-2019 20:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 07-01-2019 20:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[MiddleName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_BadgeMaster]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_BadgeMaster](
	[BadgeID] [int] IDENTITY(1,1) NOT NULL,
	[BadgeName] [varchar](50) NULL,
	[BadgeImageURL] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BadgeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[BadgeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_ErrorLogs]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_ErrorLogs](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[StoredProcName] [varchar](100) NOT NULL,
	[Parameters] [varchar](max) NULL,
	[StackTrace] [varchar](max) NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Tbl_ErrorLogs] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_FileUploads]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_FileUploads](
	[FileUploadID] [int] IDENTITY(1,1) NOT NULL,
	[FileGUID] [varchar](max) NOT NULL,
	[FileName] [varchar](max) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_Tbl_FileUploads] PRIMARY KEY CLUSTERED 
(
	[FileUploadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SkillMaster]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SkillMaster](
	[SkillID] [int] IDENTITY(1,1) NOT NULL,
	[SkillName] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SkillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SkillName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Status]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [varchar](10) NULL,
	[StatusDescription] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[StatusCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SubskillMaster]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SubskillMaster](
	[SubskillID] [int] IDENTITY(1,1) NOT NULL,
	[SkillID] [int] NULL,
	[SubskillName] [varchar](100) NULL,
	[SkillPoints] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SubskillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserAcquiredSkillSubskill]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserAcquiredSkillSubskill](
	[UASSID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[AcquiredSubskillID] [int] NULL,
	[AcquiredSkillID] [int] NULL,
	[Type] [varchar](20) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UASSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserBadge]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserBadge](
	[UserBadgeID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[StatusID] [int] NULL,
	[BadgeID] [int] NULL,
	[BadgeGivenBy] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[Comments] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserBadgeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserBadgeHistory]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserBadgeHistory](
	[UBHID] [int] IDENTITY(1,1) NOT NULL,
	[UserBadgeID] [int] NULL,
	[UserID] [int] NULL,
	[StatusID] [int] NULL,
	[BadgeID] [int] NULL,
	[BadgeGivenBy] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[Comments] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[UBHID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserCertificate]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserCertificate](
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
PRIMARY KEY CLUSTERED 
(
	[UCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserCertificateHistory]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserCertificateHistory](
	[UCHID] [int] IDENTITY(1,1) NOT NULL,
	[UCID] [int] NULL,
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
PRIMARY KEY CLUSTERED 
(
	[UCHID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserDemo]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserDemo](
	[UDID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[AcquiredSubskillID] [int] NULL,
	[AcquiredSkillID] [int] NULL,
	[StatusID] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Room] [varchar](25) NULL,
	[DateAndTime] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserDemoHistory]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserDemoHistory](
	[UDHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[UDID] [int] NULL,
	[UserID] [int] NULL,
	[AcquiredSubskillID] [int] NULL,
	[AcquiredSkillID] [int] NULL,
	[StatusID] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Room] [varchar](25) NULL,
	[DateAndTime] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UDHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserInitialSkillRequest]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserInitialSkillRequest](
	[UISRID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[RequestedSubskillID] [int] NULL,
	[RequestedSkillID] [int] NULL,
	[StatusID] [int] NULL,
	[Comments] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UISRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserInitialSkillRequestHistory]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserInitialSkillRequestHistory](
	[UISRHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[UISRID] [int] NOT NULL,
	[UserID] [int] NULL,
	[RequestedSubskillID] [int] NULL,
	[RequestedSkillID] [int] NULL,
	[StatusID] [int] NULL,
	[Comments] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK__UserIntialHistoty] PRIMARY KEY CLUSTERED 
(
	[UISRHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserRequiredSkillSubskill]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserRequiredSkillSubskill](
	[URSSID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[RequiredSubskillID] [int] NULL,
	[RequiredSkillID] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[URSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_VersionMaster]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_VersionMaster](
	[VersionID] [int] IDENTITY(1,1) NOT NULL,
	[Major] [int] NOT NULL,
	[Minor] [int] NOT NULL,
	[Customization] [int] NOT NULL,
	[Patch] [int] NULL,
 CONSTRAINT [PK_Tbl_VersionMaster] PRIMARY KEY CLUSTERED 
(
	[VersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 07-01-2019 20:46:10 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserId]    Script Date: 07-01-2019 20:46:10 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserId]    Script Date: 07-01-2019 20:46:10 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoleId]    Script Date: 07-01-2019 20:46:10 ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserId]    Script Date: 07-01-2019 20:46:10 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 07-01-2019 20:46:10 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[tbl_SubskillMaster]  WITH CHECK ADD FOREIGN KEY([SkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserAcquiredSkillSubskill]  WITH CHECK ADD FOREIGN KEY([AcquiredSubskillID])
REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID])
GO
ALTER TABLE [dbo].[tbl_UserAcquiredSkillSubskill]  WITH CHECK ADD FOREIGN KEY([AcquiredSkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserAcquiredSkillSubskill]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserBadge]  WITH CHECK ADD FOREIGN KEY([BadgeID])
REFERENCES [dbo].[tbl_BadgeMaster] ([BadgeID])
GO
ALTER TABLE [dbo].[tbl_UserBadge]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserBadge]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserBadgeHistory]  WITH CHECK ADD FOREIGN KEY([BadgeID])
REFERENCES [dbo].[tbl_BadgeMaster] ([BadgeID])
GO
ALTER TABLE [dbo].[tbl_UserBadgeHistory]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserBadgeHistory]  WITH CHECK ADD FOREIGN KEY([UserBadgeID])
REFERENCES [dbo].[tbl_UserBadge] ([UserBadgeID])
GO
ALTER TABLE [dbo].[tbl_UserBadgeHistory]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserCertificate]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserCertificate]  WITH CHECK ADD  CONSTRAINT [FK_FileID] FOREIGN KEY([FileUploadID])
REFERENCES [dbo].[Tbl_FileUploads] ([FileUploadID])
GO
ALTER TABLE [dbo].[tbl_UserCertificate] CHECK CONSTRAINT [FK_FileID]
GO
ALTER TABLE [dbo].[tbl_UserCertificateHistory]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserCertificateHistory]  WITH CHECK ADD FOREIGN KEY([UCID])
REFERENCES [dbo].[tbl_UserCertificate] ([UCID])
GO
ALTER TABLE [dbo].[tbl_UserDemo]  WITH CHECK ADD FOREIGN KEY([AcquiredSubskillID])
REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID])
GO
ALTER TABLE [dbo].[tbl_UserDemo]  WITH CHECK ADD FOREIGN KEY([AcquiredSkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserDemo]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserDemo]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserDemoHistory]  WITH CHECK ADD FOREIGN KEY([AcquiredSubskillID])
REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID])
GO
ALTER TABLE [dbo].[tbl_UserDemoHistory]  WITH CHECK ADD FOREIGN KEY([AcquiredSkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserDemoHistory]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserDemoHistory]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserDemoHistory]  WITH CHECK ADD FOREIGN KEY([UDID])
REFERENCES [dbo].[tbl_UserDemo] ([UDID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([RequestedSubskillID])
REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([RequestedSkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([RequestedSubskillID])
REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([RequestedSkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([StatusID])
REFERENCES [dbo].[tbl_Status] ([StatusID])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequest]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[tbl_UserInitialSkillRequestHistory]  WITH CHECK ADD FOREIGN KEY([UISRID])
REFERENCES [dbo].[tbl_UserInitialSkillRequest] ([UISRID])
GO
ALTER TABLE [dbo].[tbl_UserRequiredSkillSubskill]  WITH CHECK ADD FOREIGN KEY([RequiredSubskillID])
REFERENCES [dbo].[tbl_SubskillMaster] ([SubskillID])
GO
ALTER TABLE [dbo].[tbl_UserRequiredSkillSubskill]  WITH CHECK ADD FOREIGN KEY([RequiredSkillID])
REFERENCES [dbo].[tbl_SkillMaster] ([SkillID])
GO
ALTER TABLE [dbo].[tbl_UserRequiredSkillSubskill]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllBadges]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllBadges] 
    @LoggedInUserID int,
    @Type VARCHAR(50) = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT BadgeID,
			   BadgeName,
			   BadgeImageURL
		FROM tbl_BadgeMaster
		WHERE IsActive=1
		AND BadgeName = ISNULL(@Type,BadgeName);

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						'Type='+CONVERT(NVARCHAR(MAX),@Type);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllBadges',@Params;
		END
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSkillsAvailable]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSkillsAvailable] 
    @LoggedInUserID int
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT sm.SkillID, sm.SkillName from tbl_SkillMaster sm WHERE sm.IsActive=1;

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllSkillsAvailable',@Params;
		END
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSubSkillsForASkill]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSubSkillsForASkill] 
    @LoggedInUserID int,
	@SkillID int
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT SkillID, 
				SubskillID, 
				SubskillName 
		FROM tbl_SubskillMaster
		WHERE SkillID=@SkillID 
				AND IsActive=1;

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | SkillID ='+CONVERT(NVARCHAR,@SkillID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllSubSkillsForASkill',@Params;
		END
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllUsersByName]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllUsersByName] 
    @LoggedInUserID int,
    @NamePrefix VARCHAR(50) 
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

		SELECT FirstName + ISNULL(' '+LastName,'')AS [UserName],
			   Id AS [UserID]
		FROM AspNetUsers
		WHERE Id <> @LoggedInUserID
		AND FirstName LIKE @NamePrefix+'%';

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						'NamePrefix='+CONVERT(NVARCHAR(MAX),@NamePrefix);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getAllUsersByName',@Params;
		END
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_getDashboardDetails]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getDashboardDetails] 
	@LoggedInUserID INT,
	@UserID INT
AS
	BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_DemoScheduled INT,
			@InitialSkillExists BIT;
		
	    SET @StatusID_DemoScheduled = [dbo].[fn_GetStatusIDFromCode]('DEMO_SCH');
	    
	    --Check if initial skill exists or not
	    IF EXISTS(SELECT 1 FROM tbl_UserInitialSkillRequest WHERE UserID = @UserID)
	    BEGIN
			SET @InitialSkillExists = 1;
	    END
	    ELSE
	    BEGIN
			SET @InitialSkillExists = 0;
	    END
	    
	    -- User Details
	    SELECT Id AS [UserID],
			   FirstName+' '+MiddleName+' '+LastName AS [UserName],
			   Email AS [EmailID],
			   @InitialSkillExists AS [InitialSkillExists]
		FROM AspNetUsers
		WHERE Id=@UserID;
			
	   -- Get Skill Set
	   SELECT * FROM(
	   SELECT SM.SkillID,
			  SM.SkillName,
			  SUM(SSM.SkillPoints) AS [SkillPoints],
			  'Required' AS [SkillType]
		FROM tbl_UserRequiredSkillSubskill UR
		INNER JOIN tbl_SkillMaster SM
			ON SM.SkillID = UR.RequiredSkillID
		INNER JOIN tbl_SubskillMaster SSM
			ON SSM.SubskillID = UR.RequiredSubskillID
		WHERE UserID = @UserID
		GROUP BY SM.SkillID,SM.SkillName
		UNION
		SELECT SM.SkillID,
				SM.SkillName,
				ISNULL(SUM(SSM.SkillPoints),0) AS [SkillPoints],
				'Acquired' AS [SkillType]
		FROM tbl_SkillMaster SM
		LEFT JOIN  tbl_UserAcquiredSkillSubskill UR
			ON SM.SkillID = UR.AcquiredSkillID
			AND UR.UserID=@UserID
		LEFT JOIN tbl_SubskillMaster SSM
			ON SSM.SubskillID = UR.AcquiredSubskillID
		GROUP BY SM.SkillID,SM.SkillName)X
		ORDER BY X.SkillID;
		
	   -- Subskill set	
	   
	   SELECT RequiredSkillID,
			   RequiredSubskillID,
			   SM.SkillName,
			   SSM.SubskillName,
			   'Required' AS [SubSkillType],
			   SSM.SkillPoints
		FROM tbl_UserRequiredSkillSubskill UR
		INNER JOIN tbl_SkillMaster SM
			ON SM.SkillID = UR.RequiredSkillID
		INNER JOIN tbl_SubskillMaster SSM
			ON SSM.SubskillID = UR.RequiredSubskillID
		WHERE UserID = @UserID
		UNION
		SELECT AcquiredSkillID,
			   AcquiredSubskillID,
			   SM.SkillName,
			   SSM.SubskillName,
			   'Acquired' AS [SubSkillType],
			   SSM.SkillPoints
		FROM tbl_UserAcquiredSkillSubskill AQ
		INNER JOIN tbl_SkillMaster SM
			ON SM.SkillID = AQ.AcquiredSkillID
		INNER JOIN tbl_SubskillMaster SSM
			ON SSM.SubskillID = AQ.AcquiredSubskillID
		WHERE UserID = @UserID;
		
			
		-- Get badge Count
		SELECT BM.BadgeID,
			   BM.BadgeName,
			   BM.BadgeImageURL,
			   COUNT(UB.BadgeID) AS [BadgeCount]
		FROM tbl_BadgeMaster BM
		LEFT JOIN tbl_UserBadge UB
			ON UB.BadgeID = BM.BadgeID
			AND UB.UserID = @UserID
		GROUP BY BM.BadgeID,BM.BadgeName,BM.BadgeImageURL
		
		-- Get Events
	    SELECT UD.UDID,
			   UD.Room,
			   UD.DateAndTime,
			   UD.UserID,
			   AU.FirstName +' '+ISNULL(AU.LastName,'') AS [EventConductedBy],
			   SM.SkillID,
			   SSM.SubskillID,
			   SM.SkillName,
			   SSM.SubskillName
		FROM tbl_UserDemo UD
		INNER JOIN AspNetUsers AU
			ON AU.Id = UD.UserID
		INNER JOIN tbl_SkillMaster SM
			ON SM.SkillID = UD.AcquiredSkillID
		INNER JOIN tbl_SubskillMaster SSM
			ON SSM.SubskillID = UD.AcquiredSubskillID
		WHERE StatusID = @StatusID_DemoScheduled

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID);
			EXEC usp_sav_ErrorLog @StackTrace,'usp_syncEmployeeRequiredPoints',@Params;
		END
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeeRequests]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getEmployeeRequests]
    @LoggedInUserID int,
    @Type VARCHAR(50) = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

    IF UPPER(@Type) = 'INIT'
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
				uir.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status], 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uir.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserInitialSkillRequest uir 
		INNER JOIN tbl_Status s
			ON uir.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = uir.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = uir.RequestedSubskillID
		WHERE uir.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
		SELECT 'Demonstration' AS [Request type], 
				ud.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				ud.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserDemo ud 
		INNER JOIN tbl_Status s
			ON ud.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = ud.AcquiredSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = ud.AcquiredSubskillID
		WHERE ud.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
		SELECT 'Certification' AS [Request type], 
				uc.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uc.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserCertificate uc 
		INNER JOIN tbl_Status s
			ON uc.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = uc.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = uc.RequestedSubskillID
		WHERE uc.UserID = @LoggedInUserID;
	END
	ELSE IF UPPER(@Type) = 'BADGE'
	BEGIN
		SELECT 'Badge' AS [Request type], 
				UB.CreatedDate AS [Request date], 
				ST.StatusDescription AS [Status] , 
				NULL AS [Skill],
				NULL AS [Sub-skill],
				UB.Comments,
				BM.BadgeID,
				BM.BadgeName,
				BM.BadgeImageURL,
				GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor]
		FROM tbl_UserBadge UB
		INNER JOIN AspNetUsers GivenFor
			ON GivenFor.Id = UB.UserID
		INNER JOIN tbl_BadgeMaster BM
			ON BM.BadgeID = UB.BadgeID
		INNER JOIN tbl_Status ST
			ON ST.StatusID = UB.StatusID
		WHERE BadgeGivenBy = @LoggedInUserID
	END
	ELSE
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
				uir.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status], 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uir.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserInitialSkillRequest uir 
		INNER JOIN tbl_Status s
			ON uir.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = uir.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = uir.RequestedSubskillID
		WHERE uir.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Demonstration' AS [Request type], 
				ud.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				ud.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserDemo ud 
		INNER JOIN tbl_Status s
			ON ud.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = ud.AcquiredSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = ud.AcquiredSubskillID
		WHERE ud.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Certification' AS [Request type], 
				uc.CreatedDate AS [Request date], 
				s.StatusDescription AS [Status] , 
				sm.SkillName AS [Skill],
				ssm.SubskillName AS [Sub-skill],
				uc.Comments,
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL,
				NULL AS [BadgeGivenFor]
		FROM tbl_UserCertificate uc 
		INNER JOIN tbl_Status s
			ON uc.StatusID  = s.StatusID
		INNER JOIN tbl_SkillMaster sm
			ON sm.SkillID = uc.RequestedSkillID
		INNER JOIN tbl_SubskillMaster ssm
			ON ssm.SubskillID = uc.RequestedSubskillID
		WHERE uc.UserID = @LoggedInUserID
		UNION ALL
		SELECT 'Badge' AS [Request type], 
				UB.CreatedDate AS [Request date], 
				ST.StatusDescription AS [Status] , 
				NULL AS [Skill],
				NULL AS [Sub-skill],
				UB.Comments,
				BM.BadgeID,
				BM.BadgeName,
				BM.BadgeImageURL,
				GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor]
		FROM tbl_UserBadge UB
		INNER JOIN AspNetUsers GivenFor
			ON GivenFor.Id = UB.UserID
		INNER JOIN tbl_BadgeMaster BM
			ON BM.BadgeID = UB.BadgeID
		INNER JOIN tbl_Status ST
			ON ST.StatusID = UB.StatusID
		WHERE BadgeGivenBy = @LoggedInUserID;
	END
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_getEmployeeRequests',@Params;
	END
			
END CATCH
END	



GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeesForASkillSubskill]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getEmployeesForASkillSubskill] 
	@LoggedInUserID int, 
	@SkillID int,
	@SubskillID int
AS
	BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);

	 SELECT acq.UserID, acq.AcquiredSkillID, 
			 emp.FirstName + ' ' + emp.LastName as [Employee Name],
			 emp.Email,
			 emp.Phonenumber as [Contact Number],
			 [dbo].[fn_GetUserSkillPoints](@SkillID,emp.Id) as [Skill Points]
	 FROM AspNetUsers emp 	 
	 INNER JOIN tbl_UserAcquiredSkillSubskill acq
		ON acq.UserID=emp.Id
	 INNER JOIN tbl_subskillmaster ssm
		ON acq.AcquiredSubskillID=ssm.SubskillID	 
	 WHERE acq.AcquiredSkillID = @SkillID
	 AND acq.AcquiredSubskillID = @SubskillID	 

	 END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)
						+' | SkillID ='+CONVERT(NVARCHAR(MAX),@SkillID)
						+' | SubskillID ='+CONVERT(NVARCHAR(MAX),@SubskillID);
		
			EXEC usp_sav_ErrorLog @StackTrace,'usp_getEmployeesForASkillSubskill',@Params;
		END
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_getPendingManagerApprovals]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getPendingManagerApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50) = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_PendingWithManager INT;
	
	SET @StatusID_PendingWithManager = [dbo].[fn_GetStatusIDFromCode]('MGR_PND');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'INIT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
	WHERE ST.StatusID = @StatusID_PendingWithManager;
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	SELECT 'Demonstration' AS [Request type], 
			UD.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			UD.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UD.UDID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'DEMO' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'CERT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	END
	ELSE IF UPPER(@Type) = 'BADGE'
	BEGIN
	
	SELECT 'Badge' AS [Request type], 
			UB.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			UB.Comments,
			NULL AS SkillName,
			NULL AS SubskillName,
			NULL AS SkillPoints,
			NULL AS FileGUID,
			NULL AS [FileName],
			UB.UserBadgeID AS [UniqueID],
			GivenBy.FirstName + ISNULL(' '+GivenBy.LastName,'') AS [UserName],
			'BADGE' AS [RequestCode],
			GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor],
			BM.BadgeID,
			BM.BadgeName,
			BM.BadgeImageURL
	FROM tbl_UserBadge UB
	INNER JOIN AspNetUsers GivenFor
		ON GivenFor.Id = UB.UserID
	INNER JOIN AspNetUsers GivenBy
		ON GivenBy.Id = UB.BadgeGivenBy
	INNER JOIN tbl_BadgeMaster BM
		ON BM.BadgeID = UB.BadgeID
	INNER JOIN tbl_Status ST
		ON ST.StatusID = UB.StatusID
	WHERE UB.StatusID = @StatusID_PendingWithManager
	
	END
	ELSE
	BEGIN
		SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'INIT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	UNION ALL
	
	SELECT 'Demonstration' AS [Request type], 
				UD.CreatedDate AS [Request date], 
				ST.StatusDescription AS [Status] , 
				UD.Comments,
				SM.SkillName,
				SSM.SubskillName,
				SSM.SkillPoints,
				NULL AS [FileGUID],
				NULL AS [FileName],
				UD.UDID AS [UniqueID],
				AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			    'DEMO' AS [RequestCode],
			    NULL AS [BadgeGivenFor],
				NULL AS BadgeID,
				NULL AS BadgeName,
				NULL AS BadgeImageURL
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	UNION ALL
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments,
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			'CERT' AS [RequestCode],
			NULL AS [BadgeGivenFor],
			NULL AS BadgeID,
			NULL AS BadgeName,
			NULL AS BadgeImageURL
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
	WHERE ST.StatusID = @StatusID_PendingWithManager
	
	UNION ALL
	
	SELECT 'Badge' AS [Request type], 
			UB.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			UB.Comments,
			NULL AS SkillName,
			NULL AS SubskillName,
			NULL AS SkillPoints,
			NULL AS FileGUID,
			NULL AS [FileName],
			UB.UserBadgeID AS [UniqueID],
			GivenBy.FirstName + ISNULL(' '+GivenBy.LastName,'') AS [UserName],
			'BADGE' AS [RequestCode],
			GivenFor.FirstName + ISNULL(' '+GivenFor.LastName,'') AS [BadgeGivenFor],
			BM.BadgeID,
			BM.BadgeName,
			BM.BadgeImageURL
	FROM tbl_UserBadge UB
	INNER JOIN AspNetUsers GivenFor
		ON GivenFor.Id = UB.UserID
	INNER JOIN AspNetUsers GivenBy
		ON GivenBy.Id = UB.BadgeGivenBy
	INNER JOIN tbl_BadgeMaster BM
		ON BM.BadgeID = UB.BadgeID
	INNER JOIN tbl_Status ST
		ON ST.StatusID = UB.StatusID
	WHERE UB.StatusID = @StatusID_PendingWithManager
	
	END
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_getPendingManagerApprovals',@Params;
	END
			
END CATCH
END	

GO
/****** Object:  StoredProcedure [dbo].[usp_getPendingSkillExpertApprovals]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getPendingSkillExpertApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50) = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_ManagerApproved INT,
			@StatusID_DemoScheduled INT,
			@StatusID_ManagerPending INT;
	
	SET @StatusID_ManagerApproved = [dbo].[fn_GetStatusIDFromCode]('MGR_APR');
	SET @StatusID_DemoScheduled = [dbo].[fn_GetStatusIDFromCode]('DEMO_SCH');
	SET @StatusID_ManagerPending = [dbo].[fn_GetStatusIDFromCode]('MGR_PND');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UISKH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'INIT' AS [RequestCode]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
	INNER JOIN tbl_UserInitialSkillRequestHistory UISKH
		ON UISKH.UISRID = UIR.UISRID
		AND UISKH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved;
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	SELECT 'Demonstration' AS [Request type], 
			UD.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			Manager.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UD.UDID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			UD.Room,
			UD.DateAndTime AS [DemoSchedule],
			UDH.Comments AS [UserComments],
			SkillExpert.Comments AS [SkillExpertComments],
			'DEMO' AS [RequestCode]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
	INNER JOIN tbl_UserDemoHistory UDH
		ON UDH.UDID = UD.UDID
		AND UDH.StatusID = @StatusID_ManagerPending
	INNER JOIN tbl_UserDemoHistory Manager
		ON Manager.UDID = UD.UDID
		AND Manager.StatusID = @StatusID_ManagerApproved
	LEFT JOIN tbl_UserDemoHistory SkillExpert
		ON SkillExpert.UDID = UD.UDID
		AND SkillExpert.StatusID = @StatusID_DemoScheduled
	WHERE ST.StatusID IN (@StatusID_ManagerApproved,@StatusID_DemoScheduled);
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UCH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'CERT' AS [RequestCode]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
	INNER JOIN tbl_UserCertificateHistory UCH
		ON UCH.UCID = UC.UCID
		AND UCH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved;
	
	END
	ELSE
	BEGIN
	
	SELECT 'Initial Skill Request' AS [Request type], 
			UIR.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status], 
			UIR.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UIR.UISRID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UISKH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'INIT' AS [RequestCode]
	FROM tbl_UserInitialSkillRequest UIR 
	INNER JOIN tbl_Status ST
		ON uir.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UIR.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UIR.RequestedSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UIR.UserID
	INNER JOIN tbl_UserInitialSkillRequestHistory UISKH
		ON UISKH.UISRID = UIR.UISRID
		AND UISKH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved
	
	UNION ALL
	
	SELECT 'Demonstration' AS [Request type], 
			UD.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			Manager.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			NULL AS [FileGUID],
			NULL AS [FileName],
			UD.UDID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			UD.Room,
			UD.DateAndTime AS [DemoSchedule],
			UDH.Comments AS [UserComments],
			SkillExpert.Comments AS [SkillExpertComments],
			'DEMO' AS [RequestCode]
	FROM tbl_UserDemo UD 
	INNER JOIN tbl_Status ST
		ON ud.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UD.AcquiredSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UD.AcquiredSubskillID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UD.UserID
	INNER JOIN tbl_UserDemoHistory UDH
		ON UDH.UDID = UD.UDID
		AND UDH.StatusID = @StatusID_ManagerPending
	INNER JOIN tbl_UserDemoHistory Manager
		ON Manager.UDID = UD.UDID
		AND Manager.StatusID = @StatusID_ManagerApproved
	LEFT JOIN tbl_UserDemoHistory SkillExpert
		ON SkillExpert.UDID = UD.UDID
		AND SkillExpert.StatusID = @StatusID_DemoScheduled
	WHERE ST.StatusID IN (@StatusID_ManagerApproved,@StatusID_DemoScheduled)
	
	UNION ALL
	
	SELECT 'Certification' AS [Request type], 
			UC.CreatedDate AS [Request date], 
			ST.StatusDescription AS [Status] , 
			uc.Comments AS [ManagerComments],
			SM.SkillName,
			SSM.SubskillName,
			SSM.SkillPoints,
			FU.FileGUID,
			FU.[FileName],
			UC.UCID AS [UniqueID],
			AU.FirstName + ISNULL(' '+AU.LastName,'') AS [UserName],
			NULL AS Room,
			NULL AS [DemoSchedule],
			UCH.Comments AS [UserComments],
			NULL AS [SkillExpertComments],
			'CERT' AS [RequestCode]
	FROM tbl_UserCertificate UC 
	INNER JOIN tbl_Status ST
		ON UC.StatusID  = ST.StatusID
	INNER JOIN tbl_SkillMaster SM
		ON SM.SkillID = UC.RequestedSkillID
	INNER JOIN tbl_SubskillMaster SSM
		ON SSM.SubskillID = UC.RequestedSubskillID
	INNER JOIN Tbl_FileUploads FU
		ON FU.FileUploadID = UC.FileUploadID
	INNER JOIN AspNetUsers AU
		ON AU.Id = UC.UserID
	INNER JOIN tbl_UserCertificateHistory UCH
		ON UCH.UCID = UC.UCID
		AND UCH.StatusID = @StatusID_ManagerPending
	WHERE ST.StatusID = @StatusID_ManagerApproved;
	
	END
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_getPendingSkillExpertApprovals',@Params;
	END
			
END CATCH
END	

GO
/****** Object:  StoredProcedure [dbo].[usp_sav_DemoScheduleBySkillExpert]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_DemoScheduleBySkillExpert] 
	-- Add the parameters for the stored procedure here
	@LoggedInUserID INT, -- Logged In User
	@DemoSchedule DATETIME,
	@Comments VARCHAR(MAX),
	@UniqueID INT,
	@Room VARCHAR(25)
AS
BEGIN
	
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_DemoScheduled INT;
			
	SET @StatusID_DemoScheduled = [dbo].[fn_GetStatusIDFromCode]('DEMO_SCH');
			
	UPDATE Tbl_UserDemo
	SET StatusID = @StatusID_DemoScheduled,
		Comments = @Comments,
		Room = @Room,
		DateAndTime = @DemoSchedule,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UDID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserDemoHistory]
           ([UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy])
     SELECT [UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,ISNULL(ModifiedDate,CreatedDate)
           ,ISNULL(ModifiedBy,CreatedBy)
      FROM tbl_UserDemo
      WHERE UDID = @UniqueID;
			
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	IF XACT_STATE() <> 0  
			ROLLBACK TRAN 
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @DemoSchedule ='+CONVERT(NVARCHAR(MAX),@DemoSchedule)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @UniqueID ='+CONVERT(NVARCHAR(MAX),@UniqueID)+
						' | @Room ='+CONVERT(NVARCHAR(MAX),@Room);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_sav_DemoScheduleBySkillExpert',@Params;
	END
			
END CATCH
END



GO
/****** Object:  StoredProcedure [dbo].[usp_sav_EmployeeInitialRequest]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_EmployeeInitialRequest] 
	-- Add the parameters for the stored procedure here
	@LoggedInUserID INT, -- Logged In User
	@SkillSetXML XML,
	@Comments VARCHAR(MAX)
AS
BEGIN
	
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX);
			
	
	DECLARE @TempEmployeeSkill AS TABLE(SkillID INT, SubSkillID INT);
	DECLARE @SkillIDInserted AS TABLE(REQUESTID INT)
	
	-- Move XML data to Temp Table
	INSERT INTO @TempEmployeeSkill(
			SkillID,
			SubSkillID
	)
	SELECT  x.SkillDataTable.value('SkillID[1]','INT') AS SkillID,
			 x.SkillDataTable.value('SubskillID[1]','INT') AS SubskillID			 
		FROM @SkillSetXML.nodes('SkillSet/Skill')
		AS x(SkillDataTable);
	
		
	--Insert data into request table	
	INSERT INTO [dbo].[tbl_UserInitialSkillRequest]
           ([UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     OUTPUT INSERTED.UISRID INTO @SkillIDInserted
     SELECT @LoggedInUserID,
			SubSkillID,
			SkillID,
			[dbo].[fn_GetStatusIDFromCode]('MGR_PND'),
			@Comments,
			GETDATE(),
			@LoggedInUserID,
			NULL,
			NULL
     FROM @TempEmployeeSkill;
     
     -- Create history of the record inserted
     INSERT INTO [dbo].[tbl_UserInitialSkillRequestHistory]
           ([UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
      SELECT UISRID 
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
      FROM tbl_UserInitialSkillRequest
      WHERE UISRID IN (SELECT REQUESTID FROM @SkillIDInserted); 
			
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	IF XACT_STATE() <> 0  
			ROLLBACK TRAN 
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @SkillSetXML ='+CONVERT(NVARCHAR(MAX),@SkillSetXML);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_sav_EmployeeInitialRequest',@Params;
	END
			
	

END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_sav_ErrorLog]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Siddarth Nair
-- Create date: 1-April-2018
-- Description:	This stored procedure is used to save information about error logs
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_ErrorLog] 
	@StackTrace VARCHAR(MAX),
	@StoredProcName VARCHAR(100),
	@Parameters VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO [dbo].[Tbl_ErrorLogs]
           ([StoredProcName]
           ,[Parameters]
           ,[StackTrace]
           ,[DateCreated])
     VALUES
           (@StoredProcName
           ,@Parameters
           ,@StackTrace
           ,GETDATE());
    
END
GO
/****** Object:  StoredProcedure [dbo].[usp_sav_ImproveSkills]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sav_ImproveSkills] 
	-- Add the parameters for the stored procedure here
	@LoggedInUserID INT, -- Logged In User
	@SkillSetXML XML,
	@Comments VARCHAR(MAX),
	@Type VARCHAR(50), -- DEMO/CERTIFICATE
	@FileUploadGUID VARCHAR(MAX) = NULL,
	@FileUploadName VARCHAR(MAX) = NULL
AS
BEGIN
	
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@LastInsertedFileID INT;
			
	
	DECLARE @TempEmployeeSkill AS TABLE(SkillID INT, SubSkillID INT);
	DECLARE @SkillIDInserted AS TABLE(REQUESTID INT)
	
	-- Move XML data to Temp Table
	INSERT INTO @TempEmployeeSkill(
			SkillID,
			SubSkillID
	)
	SELECT  x.SkillDataTable.value('SkillID[1]','INT') AS SkillID,
			 x.SkillDataTable.value('SubskillID[1]','INT') AS SubskillID			 
		FROM @SkillSetXML.nodes('SkillSet/Skill')
		AS x(SkillDataTable);
	
	IF @Type = 'DEMO'
	BEGIN
		INSERT INTO [dbo].[tbl_UserDemo]
           ([UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
        OUTPUT INSERTED.UDID INTO @SkillIDInserted
		SELECT @LoggedInUserID,
				SubSkillID,
				SkillID,
				[dbo].[fn_GetStatusIDFromCode]('MGR_PND'),
				@Comments,
				NULL,
				NULL,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
     FROM @TempEmployeeSkill;
     
     -- Create History
     INSERT INTO [dbo].[tbl_UserDemoHistory]
           ([UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy])
     SELECT UDID
           ,UserID
           ,AcquiredSubskillID
           ,AcquiredSkillID
           ,StatusID
           ,Comments
           ,Room
           ,DateAndTime
           ,CreatedDate
           ,CreatedBy
     FROM [dbo].[tbl_UserDemo] 
     WHERE [UDID] IN (SELECT REQUESTID FROM @SkillIDInserted);
     
	END
	ELSE IF @Type = 'CERTIFICATE' 
	BEGIN
		--Save details to file upload table
		INSERT INTO [dbo].[Tbl_FileUploads]
           ([FileGUID]
           ,[FileName]
           ,[DateCreated]
           ,[CreatedBy])
		VALUES
           (
           @FileUploadGUID
           ,@FileUploadName
           ,GETDATE()
           ,@LoggedInUserID
           )
		
		SET @LastInsertedFileID = @@IDENTITY;
		
		INSERT INTO [dbo].[tbl_UserCertificate]
           ([FileUploadID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID])
       OUTPUT INSERTED.UCID INTO @SkillIDInserted
       SELECT @LastInsertedFileID,
			  [dbo].[fn_GetStatusIDFromCode]('MGR_PND'),
			  @Comments,
			  GETDATE(),
			  @LoggedInUserID,
			  NULL,
			  NULL,
			  SubSkillID,
			  SkillID,
			  @LoggedInUserID		
     FROM @TempEmployeeSkill;
     
     -- Create History
     INSERT INTO [dbo].[tbl_UserCertificateHistory]
           ([UCID]
           ,[FileUploadID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID])
     SELECT UCID
           ,FileUploadID
           ,StatusID
           ,Comments
           ,CreatedDate
           ,CreatedBy
           ,ModifiedDate
           ,ModifiedBy
           ,RequestedSubskillID
           ,RequestedSkillID
           ,UserID
     FROM [dbo].[tbl_UserCertificate]
     WHERE UCID IN (SELECT REQUESTID FROM @SkillIDInserted);
	END
			
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	IF XACT_STATE() <> 0  
			ROLLBACK TRAN 
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @SkillSetXML ='+CONVERT(NVARCHAR(MAX),@SkillSetXML)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @FileUploadGUID ='+CONVERT(NVARCHAR(MAX),@FileUploadGUID) +
						' | @FileUploadName ='+CONVERT(NVARCHAR(MAX),@FileUploadName);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_sav_ImproveSkills',@Params;
	END
			
END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_savApproveBadge]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savApproveBadge]
    @LoggedInUserID INT,
    @Comments VARCHAR(MAX),
    @UserBadgeID INT,
    @Status VARCHAR(50) -- APPROVED/REJECTED
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_ManagerApproved INT,
			@StatusID_ManagerRejected INT;
	
	SET @StatusID_ManagerApproved = [dbo].[fn_GetStatusIDFromCode]('MGR_APR');
	SET @StatusID_ManagerRejected = [dbo].[fn_GetStatusIDFromCode]('MGR_REJ');
	
	-- Update the status as manager approved
	UPDATE tbl_UserBadge
	SET [StatusID] = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		[ModifiedBy] = @LoggedInUserID,
		[ModifiedDate] = GETDATE(),
		[Comments] = @Comments
	WHERE UserBadgeID = @UserBadgeID;
   
	-- Create an entry in history table         
	INSERT INTO [dbo].[tbl_UserBadgeHistory]
				(
				 [UserBadgeID]
				,[UserID]
				,[StatusID]
				,[BadgeID]
				,[BadgeGivenBy]
				,[IsActive]
				,[CreatedDate]
				,[CreatedBy]
				,[ModifiedDate]
				,[ModifiedBy]
				,[Comments]
				)
		SELECT UserBadgeID,
				UserID,
				StatusID,
				BadgeID, 
				BadgeGivenBy,
				IsActive, 
				CreatedDate, 
				CreatedBy, 
				ModifiedDate, 
				ModifiedBy, 
				Comments
		FROM tbl_UserBadge
		WHERE UserBadgeID = @UserBadgeID;
	
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @UserBadgeID ='+CONVERT(NVARCHAR(MAX),@UserBadgeID)+
						' | @Status ='+CONVERT(NVARCHAR(MAX),@Status);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savApproveBadge',@Params;
	END
			
END CATCH
END	

GO
/****** Object:  StoredProcedure [dbo].[usp_savBadge]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savBadge]
    @LoggedInUserID INT,
    @Type VARCHAR(50), --EXPERT/USER
    @Comments VARCHAR(MAX),
    @BadgeGivenTo INT,
    @BadgeID INT
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_PendingWithManager INT,
			@StatusID_SkillExpertApproved INT,
			@BadgeInsertedValue INT;
	
	SET @StatusID_PendingWithManager = [dbo].[fn_GetStatusIDFromCode]('MGR_PND');
	SET @StatusID_SkillExpertApproved = [dbo].[fn_GetStatusIDFromCode]('SE_APR');

    IF UPPER(@Type) = 'EXPERT'
    BEGIN
		-- If expert gives a badge user directly gets it
		INSERT INTO [dbo].[tbl_UserBadge]
           ([UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		VALUES
           (@BadgeGivenTo
           ,@StatusID_SkillExpertApproved
           ,@BadgeID
           ,@LoggedInUserID
           ,1
           ,GETDATE()
           ,@LoggedInUserID
           ,NULL
           ,NULL
           ,@Comments)
           
         SET @BadgeInsertedValue = @@IDENTITY;
         
         INSERT INTO [dbo].[tbl_UserBadgeHistory]
           ([UserBadgeID]
           ,[UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		SELECT UserBadgeID,
			UserID,
			StatusID,
			BadgeID, 
			BadgeGivenBy,
			IsActive, 
			CreatedDate, 
			CreatedBy, 
			ModifiedDate, 
			ModifiedBy, 
			Comments
		FROM tbl_UserBadge
		WHERE UserBadgeID = @BadgeInsertedValue;
			 
    END
    ELSE IF UPPER(@Type) = 'USER'
    BEGIN
		-- If user gives a badge it goes to manager for approval
		INSERT INTO [dbo].[tbl_UserBadge]
           ([UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		VALUES
           (@BadgeGivenTo
           ,@StatusID_PendingWithManager
           ,@BadgeID
           ,@LoggedInUserID
           ,1
           ,GETDATE()
           ,@LoggedInUserID
           ,NULL
           ,NULL
           ,@Comments)
           
         SET @BadgeInsertedValue = @@IDENTITY;
         
         INSERT INTO [dbo].[tbl_UserBadgeHistory]
           ([UserBadgeID]
           ,[UserID]
           ,[StatusID]
           ,[BadgeID]
           ,[BadgeGivenBy]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Comments])
		SELECT UserBadgeID,
			UserID,
			StatusID,
			BadgeID, 
			BadgeGivenBy,
			IsActive, 
			CreatedDate, 
			CreatedBy, 
			ModifiedDate, 
			ModifiedBy, 
			Comments
		FROM tbl_UserBadge
		WHERE UserBadgeID = @BadgeInsertedValue;
    END
	
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+ 
						' | @BadgeGivenTo ='+CONVERT(NVARCHAR(MAX),@BadgeGivenTo)+ 
						' | @BadgeID ='+CONVERT(NVARCHAR(MAX),@BadgeID);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savBadge',@Params;
	END
			
END CATCH
END	

GO
/****** Object:  StoredProcedure [dbo].[usp_savManagerApprovals]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savManagerApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50),
    @UniqueID INT,
    @Comments VARCHAR(MAX),
    @Status VARCHAR(50) -- APPROVED/REJECTED
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_ManagerApproved INT,
			@StatusID_ManagerRejected INT;
	
	SET @StatusID_ManagerApproved = [dbo].[fn_GetStatusIDFromCode]('MGR_APR');
	SET @StatusID_ManagerRejected = [dbo].[fn_GetStatusIDFromCode]('MGR_REJ');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	UPDATE tbl_UserInitialSkillRequest
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UISRID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserInitialSkillRequestHistory]
           ([UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
      SELECT [UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
      FROM [dbo].[tbl_UserInitialSkillRequest]
      WHERE UISRID = @UniqueID;
	
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	UPDATE tbl_UserDemo
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UDID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserDemoHistory]
           ([UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy])
     SELECT [UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,ISNULL(ModifiedDate,CreatedDate)
           ,ISNULL(ModifiedBy,CreatedBy)
      FROM tbl_UserDemo
      WHERE UDID = @UniqueID;
     
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	UPDATE tbl_UserCertificate
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_ManagerApproved
					  ELSE @StatusID_ManagerRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UCID = @UniqueID;
	
	INSERT INTO [dbo].[tbl_UserCertificateHistory]
           ([UCID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID]
           ,[FileUploadID])
     SELECT [UCID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID]
           ,[FileUploadID]
     FROM [dbo].[tbl_UserCertificate]
     WHERE UCID = @UniqueID;
	
	END
	
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @UniqueID ='+CONVERT(NVARCHAR(MAX),@UniqueID)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+
						' | @Status ='+CONVERT(NVARCHAR(MAX),@Status);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savManagerApprovals',@Params;
	END
			
END CATCH
END	



GO
/****** Object:  StoredProcedure [dbo].[usp_savSkillExpertApprovals]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_savSkillExpertApprovals]
    @LoggedInUserID INT,
    @Type VARCHAR(50),--INIT/DEMO/CERT
    @UniqueID INT,
    @Comments VARCHAR(MAX),
    @Status VARCHAR(50) -- APPROVED/REJECTED
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@StatusID_SkillExpertApproved INT,
			@StatusID_SkillExpertRejected INT,
			@RequestedSkillID INT,
			@RequestedSubSkillID INT,
			@RequestorID INT;
	
	SET @StatusID_SkillExpertApproved = [dbo].[fn_GetStatusIDFromCode]('SE_APR');
	SET @StatusID_SkillExpertRejected = [dbo].[fn_GetStatusIDFromCode]('SE_REJ');

    IF UPPER(@Type) = 'INIT'
	BEGIN
	
	UPDATE tbl_UserInitialSkillRequest
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_SkillExpertApproved
					  ELSE @StatusID_SkillExpertRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UISRID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserInitialSkillRequestHistory]
           ([UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
      SELECT [UISRID]
           ,[UserID]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
      FROM [dbo].[tbl_UserInitialSkillRequest]
      WHERE UISRID = @UniqueID;
      
      -- If status is approved make an entry in table tbl_UserAcquiredSkillSubskill
      IF UPPER(@Status) = 'APPROVED'
      BEGIN
			-- Get the requested skill and subskill ID
		  SELECT @RequestedSkillID = RequestedSkillID, 
				 @RequestedSubSkillID = RequestedSubskillID,
				 @RequestorID = UserID
		  FROM tbl_UserInitialSkillRequest
		  WHERE UISRID = @UniqueID;
		  
		  -- Make entry in table tbl_UserAcquiredSkillSubskill
		  INSERT INTO [dbo].[tbl_UserAcquiredSkillSubskill]
			   ([UserID]
			   ,[AcquiredSubskillID]
			   ,[AcquiredSkillID]
			   ,[Type]
			   ,[IsActive]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[ModifiedDate]
			   ,[ModifiedBy])
			VALUES
				(
				@RequestorID,
				@RequestedSubSkillID,
				@RequestedSkillID,
				@Type,
				1,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
				)
      END 
	
	END
	ELSE IF UPPER(@Type) = 'DEMO'
	BEGIN
	
	UPDATE tbl_UserDemo
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_SkillExpertApproved
					  ELSE @StatusID_SkillExpertRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UDID = @UniqueID;
	
	-- Make an entry in history table
	INSERT INTO [dbo].[tbl_UserDemoHistory]
           ([UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,[CreatedDate]
           ,[CreatedBy])
     SELECT [UDID]
           ,[UserID]
           ,[AcquiredSubskillID]
           ,[AcquiredSkillID]
           ,[StatusID]
           ,[Comments]
           ,[Room]
           ,[DateAndTime]
           ,ISNULL(ModifiedDate,CreatedDate)
           ,ISNULL(ModifiedBy,CreatedBy)
      FROM tbl_UserDemo
      WHERE UDID = @UniqueID;
     
      -- If status is approved make an entry in table tbl_UserAcquiredSkillSubskill
      IF UPPER(@Status) = 'APPROVED'
      BEGIN
			-- Get the requested skill and subskill ID
		  SELECT @RequestedSkillID = AcquiredSkillID, 
				 @RequestedSubSkillID = AcquiredSubskillID,
				 @RequestorID = UserID
		  FROM tbl_UserDemo
		  WHERE UDID = @UniqueID;
		  
		  -- Make entry in table tbl_UserAcquiredSkillSubskill
		  INSERT INTO [dbo].[tbl_UserAcquiredSkillSubskill]
			   ([UserID]
			   ,[AcquiredSubskillID]
			   ,[AcquiredSkillID]
			   ,[Type]
			   ,[IsActive]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[ModifiedDate]
			   ,[ModifiedBy])
			VALUES
				(
				@RequestorID,
				@RequestedSubSkillID,
				@RequestedSkillID,
				@Type,
				1,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
				)
      END
	
	END
	ELSE IF UPPER(@Type) = 'CERT'
	BEGIN
	
	UPDATE tbl_UserCertificate
	SET StatusID = CASE
					  WHEN UPPER(@Status) = 'APPROVED' THEN @StatusID_SkillExpertApproved
					  ELSE @StatusID_SkillExpertRejected
				   END,
		Comments = @Comments,
		ModifiedDate = GETDATE(),
		ModifiedBy = @LoggedInUserID
	WHERE UCID = @UniqueID;
	
	INSERT INTO [dbo].[tbl_UserCertificateHistory]
           ([UCID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID]
           ,[FileUploadID])
     SELECT [UCID]
           ,[StatusID]
           ,[Comments]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[RequestedSubskillID]
           ,[RequestedSkillID]
           ,[UserID]
           ,[FileUploadID]
     FROM [dbo].[tbl_UserCertificate]
     WHERE UCID = @UniqueID;
     
     -- If status is approved make an entry in table tbl_UserAcquiredSkillSubskill
      IF UPPER(@Status) = 'APPROVED'
      BEGIN
			-- Get the requested skill and subskill ID
		  SELECT @RequestedSkillID = RequestedSkillID, 
				 @RequestedSubSkillID = RequestedSubskillID,
				 @RequestorID = UserID
		  FROM tbl_UserCertificate
		  WHERE UCID = @UniqueID;
		  
		  -- Make entry in table tbl_UserAcquiredSkillSubskill
		  INSERT INTO [dbo].[tbl_UserAcquiredSkillSubskill]
			   ([UserID]
			   ,[AcquiredSubskillID]
			   ,[AcquiredSkillID]
			   ,[Type]
			   ,[IsActive]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[ModifiedDate]
			   ,[ModifiedBy])
			VALUES
				(
				@RequestorID,
				@RequestedSubSkillID,
				@RequestedSkillID,
				@Type,
				1,
				GETDATE(),
				@LoggedInUserID,
				NULL,
				NULL
				)
      END
	
	END
	
END TRY
BEGIN CATCH

	SET @ErrorSeverity = ERROR_SEVERITY();  
	SET @ErrorState = ERROR_STATE();  
	SET @StackTrace = ERROR_MESSAGE(); 
	
	
	IF(ERROR_NUMBER()=50000) -- User defined error 
	BEGIN
		RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
	END
	ELSE
	BEGIN
		-- Save error to log table
		SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID)+
						' | @UniqueID ='+CONVERT(NVARCHAR(MAX),@UniqueID)+
						' | @Comments ='+CONVERT(NVARCHAR(MAX),@Comments)+
						' | @Type ='+CONVERT(NVARCHAR(MAX),@Type)+
						' | @Status ='+CONVERT(NVARCHAR(MAX),@Status);
		EXEC usp_sav_ErrorLog @StackTrace,'usp_savSkillExpertApprovals',@Params;
	END
			
END CATCH
END	

GO
/****** Object:  StoredProcedure [dbo].[usp_syncEmployeeRequiredPoints]    Script Date: 07-01-2019 20:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_syncEmployeeRequiredPoints] 
	@LoggedInUserID int
AS
	BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @ErrorSeverity INT,
			@ErrorState INT,  
			@StackTrace NVARCHAR(MAX),
			@Params NVARCHAR(MAX),
			@UserSelected INT;
			
		DECLARE @PendingUserID AS TABLE(UserID INT, IsProcessed BIT);
		DECLARE @RequiredSkillSet AS TABLE(SkillID INT, SubSkillID INT);
		
		-- Get all users whose acquired skills are pending to be added
		INSERT INTO @PendingUserID 
					(
					UserID, 
					IsProcessed
					)
		SELECT AU.Id,
			   0
		FROM AspNetUsers AU
		LEFT JOIN Tbl_UserRequiredSkillSubskill UR
			ON AU.Id = UR.UserID
			AND UR.IsActive = 1
		WHERE UR.UserID IS NULL;
		
		-- Get Top 2 subskills for every skills with most points
		INSERT INTO @RequiredSkillSet
		SELECT SkillID, 
			   SubskillID
	    FROM (SELECT *, 
			   ROW_NUMBER() OVER (PARTITION BY SkillID ORDER BY SkillPoints DESC) AS Rn
		FROM tbl_SubskillMaster) X
		WHERE Rn <= 2
		 
		-- Set the required skill set for each user
		WHILE EXISTS(SELECT 1 FROM @PendingUserID WHERE IsProcessed = 0)
		BEGIN
			
			--Select a user whose required skill set is not set
			SELECT @UserSelected = UserID
			FROM @PendingUserID
			WHERE IsProcessed = 0;
			
			-- Create skill set for selected user
			INSERT INTO [dbo].[tbl_UserRequiredSkillSubskill]
			(
				[UserID]
				,[RequiredSubskillID]
				,[RequiredSkillID]
				,[IsActive]
				,[CreatedDate]
				,[CreatedBy]
				,[ModifiedDate]
				,[ModifiedBy]
			)
			SELECT @UserSelected
				  ,SubSkillID
				  ,SkillID
				  ,1
				  ,GETDATE()
				  ,@LoggedInUserID
				  ,NULL
				  ,NULL
			FROM @RequiredSkillSet;
			
			-- Mark IsProcessed as 1 for user whose skill set is inserted
			UPDATE @PendingUserID
			SET IsProcessed = 1
			WHERE UserID = @UserSelected;
			
		END;
	 

	END TRY
	BEGIN CATCH

		SET @ErrorSeverity = ERROR_SEVERITY();  
		SET @ErrorState = ERROR_STATE();  
		SET @StackTrace = ERROR_MESSAGE(); 
	
	
		IF(ERROR_NUMBER()=50000) -- User defined error 
		BEGIN
			RAISERROR(@StackTrace, @ErrorSeverity, @ErrorState);  
		END
		ELSE
		BEGIN
			-- Save error to log table
		
			SET	@Params='LoggedInUserID='+CONVERT(NVARCHAR(MAX),@LoggedInUserID);
			EXEC usp_sav_ErrorLog @StackTrace,'usp_syncEmployeeRequiredPoints',@Params;
		END
	END CATCH
END

GO
USE [master]
GO
ALTER DATABASE [SkillsDB] SET  READ_WRITE 
GO
