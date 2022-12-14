USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngTrainingScheduleTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTrainingScheduleTxnDet](
	[TrainingScheduleDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[TrainingScheduleId] [int] NULL,
	[ParticipantsUserId] [int] NULL,
	[UserAreaId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EngTrainingScheduleTxnDet] PRIMARY KEY CLUSTERED 
(
	[TrainingScheduleDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] ADD  CONSTRAINT [DF_EngTrainingScheduleTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnDet_EngTrainingScheduleTxn_TrainingScheduleId] FOREIGN KEY([TrainingScheduleId])
REFERENCES [dbo].[EngTrainingScheduleTxn] ([TrainingScheduleId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnDet_EngTrainingScheduleTxn_TrainingScheduleId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstLocationUserArea_UserAreaId] FOREIGN KEY([UserAreaId])
REFERENCES [dbo].[MstLocationUserArea] ([UserAreaId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstLocationUserArea_UserAreaId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnDet_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxnDet_UMUserRegistration_ParticipantsUserId] FOREIGN KEY([ParticipantsUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxnDet] CHECK CONSTRAINT [FK_EngTrainingScheduleTxnDet_UMUserRegistration_ParticipantsUserId]
GO
