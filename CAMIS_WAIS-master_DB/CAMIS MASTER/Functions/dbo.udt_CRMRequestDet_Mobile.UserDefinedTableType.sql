USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequestDet_Mobile]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[udt_CRMRequestDet_Mobile] AS TABLE(
	[CRMRequestDetId] [int] NULL,
	[AssetId] [int] NULL,
	[DetailGuid] [nvarchar](max) NULL,
	[UserId] [int] NULL
)
GO
