USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngARPDetails]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngARPDetails](
	[ARPID] [int] NOT NULL,
	[BERno] [nvarchar](50) NOT NULL,
	[BERApplicationDate] [datetime] NULL,
	[ConditionAppraisalNo] [nvarchar](50) NULL,
	[AssetNo] [nvarchar](50) NULL,
	[AssetName] [nvarchar](50) NULL,
	[AssetTypeCode] [nvarchar](50) NULL,
	[AssetTypeDescription] [nvarchar](250) NULL,
	[DepartmentName] [nvarchar](100) NULL,
	[LocationName] [nvarchar](100) NULL,
	[ItemNo] [nvarchar](100) NULL,
	[Quantity] [nvarchar](50) NULL,
	[PurchaseCostRM] [numeric](20, 2) NULL,
	[PurchaseDate] [datetime] NULL,
	[BatchNo] [nvarchar](100) NULL,
	[PackageCode] [nvarchar](100) NULL,
	[BERRemarks] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[ARPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
