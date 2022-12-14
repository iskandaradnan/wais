USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaVariationDetails]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaVariationDetails](
	[VariationDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[DeptAreaId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[AreaCode] [nvarchar](30) NULL,
	[AreaName] [nvarchar](100) NULL,
	[SNFReferenceNo] [nvarchar](100) NULL,
	[VariationStatus] [int] NULL,
	[Sqft] [int] NULL,
	[Price] [decimal](18, 0) NULL,
	[CommissioningDate] [datetime] NULL,
	[ServiceStartDate] [datetime] NULL,
	[WarrentyEndDate] [datetime] NULL,
	[VariationDate] [datetime] NULL,
	[ServiceStopDate] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
