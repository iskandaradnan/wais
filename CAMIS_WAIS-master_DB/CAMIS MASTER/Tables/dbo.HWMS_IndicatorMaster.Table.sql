USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_IndicatorMaster]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_IndicatorMaster](
	[IndicatorMasterId] [int] IDENTITY(1,1) NOT NULL,
	[Customerid] [int] NULL,
	[Facilityid] [int] NULL,
	[IndicatorNo] [varchar](250) NULL,
	[IndicatorName] [varchar](250) NULL,
	[IndicatorStandard] [numeric](24, 2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL
) ON [PRIMARY]
GO
