USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequestDet]    Script Date: 20-09-2021 17:00:54 ******/
CREATE TYPE [dbo].[udt_CRMRequestDet] AS TABLE(
	[CRMRequestDetId] [int] NULL,
	[CRMRequestId] [int] NULL,
	[AssetId] [int] NULL
)
GO
