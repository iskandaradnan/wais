USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngTrainingScheduleTxnAttachment]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTrainingScheduleTxnAttachment](
	[TrainingScheduleAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[TrainingScheduleId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[FileType] [int] NOT NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngTrainingScheduleTxnAttachment] PRIMARY KEY CLUSTERED 
(
	[TrainingScheduleAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment] ADD  CONSTRAINT [DF_EngTrainingScheduleTxnAttachment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_EngTrainingScheduleTxn_TrainingScheduleId] FOREIGN KEY([TrainingScheduleId])
REFERENCES [dbo].[EngTrainingScheduleTxn] ([TrainingScheduleId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_EngTrainingScheduleTxn_TrainingScheduleId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_FMDocument_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[FMDocument] ([DocumentId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_FMDocument_DocumentId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnAttachment] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnAttachment_MstService_ServiceId]
GO
