USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_IndicatorMaster]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_IndicatorMaster](
	[IndicatorMasterId] [int] IDENTITY(1,1) NOT NULL,
	[Customerid] [int] NULL,
	[Facilityid] [int] NULL,
	[IndicatorNo] [varchar](250) NULL,
	[IndicatorName] [varchar](250) NULL,
	[IndicatorStandard] [numeric](24, 2) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL
) ON [PRIMARY]
GO
