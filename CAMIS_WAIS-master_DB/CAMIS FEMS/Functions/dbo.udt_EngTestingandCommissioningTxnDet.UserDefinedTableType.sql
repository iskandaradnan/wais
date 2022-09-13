USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngTestingandCommissioningTxnDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngTestingandCommissioningTxnDet] AS TABLE(
	[TestingandCommissioningDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[AssetPreRegistrationNo] [nvarchar](50) NULL
)
GO
