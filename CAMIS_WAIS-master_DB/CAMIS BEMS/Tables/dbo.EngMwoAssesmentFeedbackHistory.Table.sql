USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoAssesmentFeedbackHistory]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoAssesmentFeedbackHistory](
	[AssesmentHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[AssesmentId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[FeedBack] [nvarchar](500) NULL,
	[ResponseDateTime] [datetime] NULL,
	[ResponseDuration] [nvarchar](100) NULL,
	[DoneBy] [int] NULL,
	[DoneDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[GuId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EngMwoAssesmentFeedbackHistory] PRIMARY KEY CLUSTERED 
(
	[AssesmentHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoAssesmentFeedbackHistory] ADD  CONSTRAINT [DF_EngMwoAssesmentFeedbackHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentFeedbackHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentFeedbackHistory_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentFeedbackHistory] CHECK CONSTRAINT [FK_EngMwoAssesmentFeedbackHistory_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentFeedbackHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentFeedbackHistory_EngMwoAssesmentTxn_AssesmentId] FOREIGN KEY([AssesmentId])
REFERENCES [dbo].[EngMwoAssesmentTxn] ([AssesmentId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentFeedbackHistory] CHECK CONSTRAINT [FK_EngMwoAssesmentFeedbackHistory_EngMwoAssesmentTxn_AssesmentId]
GO
