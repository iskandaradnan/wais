USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_JointInspectionSummaryReportFetch]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_JointInspectionSummaryReportFetch](
	[Id] [int] NOT NULL,
	[Year] [int] NULL,
	[Month] [nvarchar](max) NULL,
	[Hospital] [varchar](max) NULL,
	[UserAreaCode] [nvarchar](max) NULL,
	[UserArea] [nvarchar](max) NULL,
	[InspectionScheduled] [int] NULL,
	[Compliance] [int] NULL,
	[NonCompliance] [int] NULL,
	[NoofTotalRatings] [int] NULL,
	[NoofUserLocationInspected] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
