USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequestDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[udt_CRMRequestDet] AS TABLE(
	[CRMRequestDetId] [int] NULL,
	[CRMRequestId] [int] NULL,
	[AssetId] [int] NULL
)
GO
