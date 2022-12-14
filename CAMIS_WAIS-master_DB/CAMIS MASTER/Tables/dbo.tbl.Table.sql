USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[tbl]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl](
	[NotificationTemplateId] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](30) NOT NULL,
	[Definition] [nvarchar](max) NOT NULL,
	[TypeId] [tinyint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Subject] [nvarchar](200) NULL,
	[ServiceId] [int] NULL,
	[AllowCustomToIds] [bit] NOT NULL,
	[AllowCustomCcIds] [bit] NOT NULL,
	[LeastEntityLevel] [int] NULL,
	[IsConfigurable] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
