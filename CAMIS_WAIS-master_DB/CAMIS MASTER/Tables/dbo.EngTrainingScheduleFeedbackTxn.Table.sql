USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngTrainingScheduleFeedbackTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTrainingScheduleFeedbackTxn](
	[TrainingFeedbackId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[TrainingScheduleId] [int] NOT NULL,
	[Curriculum1] [int] NOT NULL,
	[Curriculum2] [int] NOT NULL,
	[Curriculum3] [int] NOT NULL,
	[Curriculum4] [int] NOT NULL,
	[Curriculum5] [int] NOT NULL,
	[CourseIntructors1] [int] NOT NULL,
	[CourseIntructors2] [int] NOT NULL,
	[CourseIntructors3] [int] NOT NULL,
	[TrainingDelivery1] [int] NOT NULL,
	[TrainingDelivery2] [int] NOT NULL,
	[TrainingDelivery3] [int] NOT NULL,
	[Recommendation] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FTDFTrainingFeedbackId] PRIMARY KEY CLUSTERED 
(
	[TrainingFeedbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn] ADD  CONSTRAINT [DF_EngTrainingScheduleFeedbackTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_EngTrainingScheduleTxn_TrainingScheduleId] FOREIGN KEY([TrainingScheduleId])
REFERENCES [dbo].[EngTrainingScheduleTxn] ([TrainingScheduleId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_EngTrainingScheduleTxn_TrainingScheduleId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleFeedbackTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleFeedbackTxn_MstService_ServiceId]
GO
