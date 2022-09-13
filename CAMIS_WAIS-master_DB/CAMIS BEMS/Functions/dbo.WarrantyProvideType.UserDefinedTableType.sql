USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[WarrantyProvideType]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[WarrantyProvideType] AS TABLE(
	[SupplierWarrantyId] [int] NULL,
	[Category] [int] NULL,
	[ContractorId] [int] NULL,
	[pAssetId] [int] NULL,
	[UserId] [int] NULL
)
GO
