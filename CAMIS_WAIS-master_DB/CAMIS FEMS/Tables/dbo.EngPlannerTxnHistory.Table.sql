USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngPlannerTxnHistory]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngPlannerTxnHistory](
	[PlannerHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[PlannerId] [int] NOT NULL,
	[ScheduleType] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Date] [int] NULL,
	[Week] [int] NULL,
	[Day] [int] NULL,
	[PlannerDate] [datetime] NULL,
	[PlannerDateUTC] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngPlannerHistoryTxn] PRIMARY KEY CLUSTERED 
(
	[PlannerHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngPlannerTxnHistory] ADD  CONSTRAINT [DF_EngPlannerHistoryTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngPlannerTxnHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerHistoryTxn_EngPlannerTxn_PlannerId] FOREIGN KEY([PlannerId])
REFERENCES [dbo].[EngPlannerTxn] ([PlannerId])
GO
ALTER TABLE [dbo].[EngPlannerTxnHistory] CHECK CONSTRAINT [FK_EngPlannerHistoryTxn_EngPlannerTxn_PlannerId]
GO
