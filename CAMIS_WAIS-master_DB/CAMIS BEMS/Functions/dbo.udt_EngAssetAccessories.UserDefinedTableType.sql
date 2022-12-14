USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetAccessories]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetAccessories] AS TABLE(
	[AccessoriesId] [int] NULL,
	[AssetId] [int] NULL,
	[AccessoriesDescription] [nvarchar](510) NULL,
	[SerialNo] [nvarchar](100) NULL,
	[Manufacturer] [nvarchar](200) NULL,
	[Model] [nvarchar](200) NULL,
	[UserId] [int] NULL,
	[DocumentTitle] [nvarchar](300) NULL,
	[DocumentExtension] [nvarchar](255) NULL,
	[FileName] [nvarchar](255) NULL,
	[DocumentRemarks] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL,
	[DocumentGuid] [nvarchar](500) NULL
)
GO
