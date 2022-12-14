USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngContractOutRegisterDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngContractOutRegisterDet] AS TABLE(
	[ContractDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[ContractId] [int] NULL,
	[AssetId] [int] NULL,
	[ContractType] [int] NULL,
	[ContractValue] [numeric](24, 2) NULL
)
GO
