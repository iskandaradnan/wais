USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[TEMPOPENPREVMONTH]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMPOPENPREVMONTH](
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetPurchasePrice] [numeric](24, 2) NULL,
	[WONo] [nvarchar](100) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[UserDept] [nvarchar](25) NOT NULL,
	[RequestDetails] [nvarchar](500) NOT NULL,
	[ResponseCategory] [nvarchar](100) NOT NULL,
	[WorkRequestDate] [datetime] NULL,
	[WorkRequestYear] [int] NULL,
	[WorkRequestMonth] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[ResponseDateTime] [datetime] NULL,
	[ResponseDuration] [nvarchar](100) NULL,
	[WorkCompletedDate] [datetime] NULL,
	[RepairTimeDays] [int] NULL,
	[LastDateOf7thDay] [datetime] NULL,
	[WOStatus] [nvarchar](100) NOT NULL,
	[B1_DeductionFigurePerAsset] [int] NULL,
	[B2_DeductionFigurePerAsset] [int] NULL,
	[ResponseDurationHHMM] [varchar](23) NULL,
	[WO_StartDate] [datetime] NULL,
	[WO_RequestStartDate] [datetime] NULL
) ON [PRIMARY]
GO
