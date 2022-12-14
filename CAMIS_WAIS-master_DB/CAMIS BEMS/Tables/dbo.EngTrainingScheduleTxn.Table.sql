USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngTrainingScheduleTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTrainingScheduleTxn](
	[TrainingScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[TrainingScheduleNo] [nvarchar](50) NOT NULL,
	[TrainingDescription] [nvarchar](500) NULL,
	[TrainingType] [int] NULL,
	[PlannedDate] [datetime] NULL,
	[PlannedDateUTC] [datetime] NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NULL,
	[TrainingModule] [nvarchar](100) NULL,
	[MinimumNoOfParticipants] [int] NULL,
	[ActualDate] [datetime] NULL,
	[ActualDateUTC] [datetime] NULL,
	[TrainingStatus] [int] NULL,
	[TrainerSource] [int] NULL,
	[TrainerStaffExperience] [int] NULL,
	[TotalParticipants] [int] NULL,
	[Venue] [nvarchar](200) NULL,
	[TrainingRescheduleDate] [datetime] NULL,
	[TrainingRescheduleDateUTC] [datetime] NULL,
	[OverallEffectiveness] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[TrainerUserId] [int] NULL,
	[TrainerUserName] [nvarchar](200) NULL,
	[Designation] [nvarchar](200) NULL,
	[IsConfirmed] [bit] NULL,
	[Email] [nvarchar](100) NULL,
	[NotificationDate] [datetime] NULL,
	[IsMailSent] [bit] NULL,
 CONSTRAINT [PK_EngTrainingScheduleTxn] PRIMARY KEY CLUSTERED 
(
	[TrainingScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn] ADD  CONSTRAINT [DF_EngTrainingScheduleTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn] ADD  DEFAULT ((0)) FOR [IsMailSent]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleTxn_UMUserRegistration_TrainerUserName] FOREIGN KEY([TrainerUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleTxn] CHECK CONSTRAINT [FK_EngTrainingScheduleTxn_UMUserRegistration_TrainerUserName]
GO
