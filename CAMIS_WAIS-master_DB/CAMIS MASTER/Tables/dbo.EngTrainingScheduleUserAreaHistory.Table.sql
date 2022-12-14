USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngTrainingScheduleUserAreaHistory]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTrainingScheduleUserAreaHistory](
	[TrainingScheduleAreaId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingScheduleId] [int] NULL,
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
 CONSTRAINT [PK_EngTrainingScheduleUserAreaHistory] PRIMARY KEY CLUSTERED 
(
	[TrainingScheduleAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTrainingScheduleUserAreaHistory] ADD  CONSTRAINT [DF_EngTrainingScheduleUserAreaHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTrainingScheduleUserAreaHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngTrainingScheduleUserAreaHistory_EngTrainingScheduleTxn_TrainingScheduleId] FOREIGN KEY([TrainingScheduleId])
REFERENCES [dbo].[EngTrainingScheduleTxn] ([TrainingScheduleId])
GO
ALTER TABLE [dbo].[EngTrainingScheduleUserAreaHistory] CHECK CONSTRAINT [FK_EngTrainingScheduleUserAreaHistory_EngTrainingScheduleTxn_TrainingScheduleId]
GO
