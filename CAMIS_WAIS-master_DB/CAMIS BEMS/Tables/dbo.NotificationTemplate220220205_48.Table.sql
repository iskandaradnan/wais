USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[NotificationTemplate220220205_48]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationTemplate220220205_48](
	[NotificationTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](60) NOT NULL,
	[Definition] [nvarchar](max) NOT NULL,
	[TypeId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Subject] [nvarchar](200) NULL,
	[ServiceId] [int] NULL,
	[AllowCustomToIds] [bit] NOT NULL,
	[AllowCustomCcIds] [bit] NOT NULL,
	[LeastEntityLevel] [int] NULL,
	[IsConfigurable] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ModuleId] [int] NULL,
	[TransactionCreator] [bit] NULL,
	[AllowAdditionalRecipientsCc] [bit] NULL,
	[DisableNotification] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
