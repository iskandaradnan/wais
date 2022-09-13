USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_PeriodicWorkRecordSummmaryReport_DuplicateData]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_PeriodicWorkRecordSummmaryReport_DuplicateData](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Hospital] [varchar](max) NULL,
	[Year] [int] NULL,
	[Month] [varchar](max) NULL,
	[UserAreaCode] [varchar](max) NULL,
	[UserArea] [varchar](max) NULL,
	[Done] [varchar](max) NULL,
	[NotDone] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
