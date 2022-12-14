USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EmailQueue]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailQueue](
	[EmailQueueId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ToIds] [nvarchar](max) NOT NULL,
	[CcIds] [nvarchar](max) NULL,
	[BccIds] [nvarchar](max) NULL,
	[ReplyIds] [nvarchar](max) NULL,
	[Subject] [nvarchar](250) NULL,
	[EmailTemplateId] [int] NOT NULL,
	[TemplateVars] [nvarchar](max) NOT NULL,
	[ContentBody] [nvarchar](max) NULL,
	[SendAsHtml] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[TypeId] [int] NULL,
	[GroupId] [int] NULL,
	[QueuedOn] [smalldatetime] NOT NULL,
	[QueuedBy] [nvarchar](200) NULL,
	[SentOn] [datetime] NULL,
	[FailedOn] [datetime] NULL,
	[FailCount] [int] NULL,
	[SubjectVars] [nvarchar](max) NULL,
	[DataSource] [int] NULL,
	[SourceIp] [nvarchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EQEmailQueueId] PRIMARY KEY CLUSTERED 
(
	[EmailQueueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailQueue] ADD  CONSTRAINT [DF_EmailQueue_SendAsHtml]  DEFAULT ((1)) FOR [SendAsHtml]
GO
ALTER TABLE [dbo].[EmailQueue] ADD  CONSTRAINT [DF_EmailQueue_Priority]  DEFAULT ((3)) FOR [Priority]
GO
ALTER TABLE [dbo].[EmailQueue] ADD  CONSTRAINT [DF_EmailQueue_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[EmailQueue] ADD  CONSTRAINT [DF_EmailQueue_DataSource]  DEFAULT ((0)) FOR [DataSource]
GO
ALTER TABLE [dbo].[EmailQueue] ADD  CONSTRAINT [DF_EmailQueue_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EmailQueue]  WITH CHECK ADD  CONSTRAINT [FK_EQTemplateId] FOREIGN KEY([EmailTemplateId])
REFERENCES [dbo].[NotificationTemplate] ([NotificationTemplateId])
GO
ALTER TABLE [dbo].[EmailQueue] CHECK CONSTRAINT [FK_EQTemplateId]
GO
