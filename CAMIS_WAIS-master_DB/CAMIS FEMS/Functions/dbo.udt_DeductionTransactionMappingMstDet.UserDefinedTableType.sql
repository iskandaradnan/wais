USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_DeductionTransactionMappingMstDet]    Script Date: 20-09-2021 17:00:54 ******/
CREATE TYPE [dbo].[udt_DeductionTransactionMappingMstDet] AS TABLE(
	[DedTxnMappingDetId] [int] NULL,
	[ServiceWorkDateTime] [datetime] NULL,
	[ServiceWorkNo] [nvarchar](200) NULL,
	[AssetNo] [nvarchar](100) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[ScreenName] [nvarchar](2000) NULL,
	[DemeritPoint] [int] NULL,
	[IsValid] [bit] NULL,
	[DisputedPendingResolution] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[DeductionValue] [int] NULL,
	[FinalDemerit] [int] NULL
)
GO
