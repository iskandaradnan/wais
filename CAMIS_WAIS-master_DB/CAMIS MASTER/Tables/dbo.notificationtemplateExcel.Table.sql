USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[notificationtemplateExcel]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[notificationtemplateExcel](
	[NotificationTemplateId] [int] NULL,
	[Name] [varchar](120) NULL,
	[Definition] [varchar](5000) NULL,
	[TypeId] [int] NULL,
	[IsActive] [int] NULL,
	[Subject] [varchar](400) NULL,
	[ServiceId] [int] NULL,
	[AllowCustomToIds] [int] NULL,
	[AllowCustomCcIds] [int] NULL,
	[LeastEntityLevel] [int] NULL,
	[IsConfigurable] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [varchar](500) NULL,
	[GuId] [varchar](500) NULL,
	[ModuleId] [int] NULL,
	[TransactionCreator] [varchar](50) NULL,
	[AllowAdditionalRecipientsCc] [varchar](50) NULL,
	[DisableNotification] [varchar](50) NULL
) ON [PRIMARY]
GO
