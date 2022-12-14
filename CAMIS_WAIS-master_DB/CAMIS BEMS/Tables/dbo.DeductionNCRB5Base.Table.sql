USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionNCRB5Base]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionNCRB5Base](
	[CustomerID] [varchar](3) NOT NULL,
	[FacilityID] [varchar](3) NOT NULL,
	[DedNCRValidationId] [int] NOT NULL,
	[CRMRequestId] [int] NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[RequestDateTime] [datetime] NULL,
	[AssetId] [int] NULL,
	[AssetNo] [nvarchar](50) NULL,
	[Completed_Date] [datetime] NULL,
	[DeductionFigureAsset] [int] NOT NULL,
	[RequestStatus] [int] NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[IndicatorDetId] [int] NOT NULL,
	[DemeritPoint] [int] NULL,
	[Deduction] [int] NULL,
	[Flag] [varchar](47) NOT NULL,
	[Isvalid] [int] NOT NULL,
	[OperationalYear] [int] NULL,
	[OperationalMonth] [int] NULL
) ON [PRIMARY]
GO
