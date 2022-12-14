USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EmailQueueDuo]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailQueueDuo](
	[EmailQueueDuoId] [int] IDENTITY(1,1) NOT NULL,
	[EmailQueueId] [int] NOT NULL,
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
	[QueuedOn] [datetime] NOT NULL,
	[QueuedBy] [nvarchar](100) NOT NULL,
	[SentOn] [datetime] NULL,
	[FailedOn] [datetime] NULL,
	[FailCount] [int] NULL,
	[SubjectVars] [nvarchar](max) NULL,
	[DataSource] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EmailQueueDuo] PRIMARY KEY CLUSTERED 
(
	[EmailQueueDuoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailQueueDuo] ADD  CONSTRAINT [DF_EmailQueueDuo_SendAsHtml]  DEFAULT ((1)) FOR [SendAsHtml]
GO
ALTER TABLE [dbo].[EmailQueueDuo] ADD  CONSTRAINT [DF_EmailQueueDuo_Priority]  DEFAULT ((3)) FOR [Priority]
GO
ALTER TABLE [dbo].[EmailQueueDuo] ADD  CONSTRAINT [DF_EmailQueueDuo_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[EmailQueueDuo] ADD  CONSTRAINT [DF_EmailQueueDuo_DataSource]  DEFAULT ((0)) FOR [DataSource]
GO
ALTER TABLE [dbo].[EmailQueueDuo] ADD  CONSTRAINT [DF_EmailQueueDuo_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EmailQueueDuo]  WITH CHECK ADD  CONSTRAINT [FK_EmailQueueDuo_EmailQueue_EmailQueueId] FOREIGN KEY([EmailQueueId])
REFERENCES [dbo].[EmailQueue] ([EmailQueueId])
GO
ALTER TABLE [dbo].[EmailQueueDuo] CHECK CONSTRAINT [FK_EmailQueueDuo_EmailQueue_EmailQueueId]
GO
ALTER TABLE [dbo].[EmailQueueDuo]  WITH CHECK ADD  CONSTRAINT [FK_EmailQueueDuo_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EmailQueueDuo] CHECK CONSTRAINT [FK_EmailQueueDuo_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EmailQueueDuo]  WITH CHECK ADD  CONSTRAINT [FK_EmailQueueDuo_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EmailQueueDuo] CHECK CONSTRAINT [FK_EmailQueueDuo_MstLocationFacility_FacilityId]
GO
