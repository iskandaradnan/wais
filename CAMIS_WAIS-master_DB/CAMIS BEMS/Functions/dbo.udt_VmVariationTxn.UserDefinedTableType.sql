USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_VmVariationTxn]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_VmVariationTxn] AS TABLE(
	[VariationId] [int] NULL,
	[SNFDocumentNo] [nvarchar](50) NULL,
	[AssetId] [int] NULL,
	[AuthorizedStatus] [bit] NULL,
	[UserId] [int] NULL
)
GO
