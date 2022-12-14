USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionDemeritPointB1B2_Base07052021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionDemeritPointB1B2_Base07052021](
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetPurchasePrice] [numeric](24, 2) NULL,
	[WONo] [nvarchar](100) NOT NULL,
	[UserDept] [nvarchar](25) NOT NULL,
	[RequestDetails] [nvarchar](500) NOT NULL,
	[ResponseCategory] [nvarchar](100) NOT NULL,
	[WorkRequestDate] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[ResponseDateTime] [datetime] NULL,
	[ResponseDuration] [nvarchar](100) NULL,
	[WorkCompletedDate] [datetime] NULL,
	[LastDateOf7thDay] [datetime] NULL,
	[WOStatus] [nvarchar](100) NOT NULL,
	[B1_DeductionFigurePerAsset] [int] NULL,
	[B2_DeductionFigurePerAsset] [int] NULL,
	[ResponseDurationHHMM] [varchar](23) NULL,
	[RepairTimeDays] [int] NULL,
	[RepairTimeHours] [varchar](2) NULL,
	[DemeritPoint_B1] [int] NOT NULL,
	[Validate_Estatus_B1] [varchar](1) NOT NULL,
	[DemeritPoint_B2] [int] NULL,
	[Validate_Estatus_B2] [varchar](1) NOT NULL,
	[Flag] [varchar](47) NOT NULL,
	[DeductionProHawkRM_B1] [int] NULL,
	[DeductionEdgentaRM_B1] [int] NULL,
	[DeductionProHawkRM_B2] [int] NULL,
	[DeductionEdgentaRM_B2] [int] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[DemeritPoint_B1Post] [int] NULL,
	[Validate_Estatus_B1Post] [varchar](1) NULL,
	[DemeritPoint_B2Post] [int] NULL,
	[Validate_Estatus_B2Post] [varchar](1) NULL,
	[DeductionProHawkRM_B1Post] [int] NULL,
	[DeductionEdgentaRM_B1Post] [int] NULL,
	[DeductionProHawkRM_B2Post] [int] NULL,
	[DeductionEdgentaRM_B2Post] [int] NULL,
	[RemarksB1] [varchar](max) NULL,
	[RemarksB2] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
