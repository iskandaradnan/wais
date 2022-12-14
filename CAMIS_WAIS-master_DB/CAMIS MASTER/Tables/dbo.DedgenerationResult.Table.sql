USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[DedgenerationResult]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedgenerationResult](
	[IndicatorDetId] [int] NULL,
	[DeductionValue] [numeric](24, 2) NULL,
	[DeductionPer] [numeric](24, 2) NULL,
	[TransDemeritPoints] [numeric](24, 2) NULL
) ON [PRIMARY]
GO
