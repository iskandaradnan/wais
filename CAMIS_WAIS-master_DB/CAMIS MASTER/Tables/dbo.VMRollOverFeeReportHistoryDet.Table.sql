USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[VMRollOverFeeReportHistoryDet]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VMRollOverFeeReportHistoryDet](
	[RollOverFeeHistoryDetId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RollOverFeeId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[DoneBy] [int] NOT NULL,
	[DoneDate] [datetime] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_VMRollOverFeeReportHistoryDet] PRIMARY KEY CLUSTERED 
(
	[RollOverFeeHistoryDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VMRollOverFeeReportHistoryDet] ADD  CONSTRAINT [DF_VMRollOverFeeReportHistoryDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[VMRollOverFeeReportHistoryDet]  WITH CHECK ADD  CONSTRAINT [FK_VMRollOverFeeReportHistoryDet] FOREIGN KEY([RollOverFeeId])
REFERENCES [dbo].[VMRollOverFeeReport] ([RollOverFeeId])
GO
ALTER TABLE [dbo].[VMRollOverFeeReportHistoryDet] CHECK CONSTRAINT [FK_VMRollOverFeeReportHistoryDet]
GO
