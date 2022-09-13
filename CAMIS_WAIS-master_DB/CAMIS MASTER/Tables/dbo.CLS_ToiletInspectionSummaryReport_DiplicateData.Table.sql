USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_ToiletInspectionSummaryReport_DiplicateData]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_ToiletInspectionSummaryReport_DiplicateData](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Hospital] [varchar](max) NULL,
	[Month] [varchar](max) NULL,
	[Year] [int] NULL,
	[TotalToiletLocation] [varchar](max) NULL,
	[TotalDone] [varchar](max) NULL,
	[TotalNotDone] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
