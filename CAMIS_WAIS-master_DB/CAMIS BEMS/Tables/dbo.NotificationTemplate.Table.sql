USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[NotificationTemplate]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationTemplate](
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
	[DisableNotification] [bit] NULL,
 CONSTRAINT [PK_ETEmailTemplateId] PRIMARY KEY CLUSTERED 
(
	[NotificationTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_ETName] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[NotificationTemplate] ADD  DEFAULT ((1)) FOR [TypeId]
GO
ALTER TABLE [dbo].[NotificationTemplate] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[NotificationTemplate] ADD  DEFAULT ((0)) FOR [AllowCustomToIds]
GO
ALTER TABLE [dbo].[NotificationTemplate] ADD  DEFAULT ((0)) FOR [AllowCustomCcIds]
GO
ALTER TABLE [dbo].[NotificationTemplate] ADD  CONSTRAINT [DF_NotificationTemplate_GuId]  DEFAULT (newid()) FOR [GuId]
GO
