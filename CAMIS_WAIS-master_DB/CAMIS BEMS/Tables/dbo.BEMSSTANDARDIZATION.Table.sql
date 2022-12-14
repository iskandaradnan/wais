USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[BEMSSTANDARDIZATION]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BEMSSTANDARDIZATION](
	[AssetStandardizationId] [int] NOT NULL,
	[Asset Type Code] [nvarchar](255) NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[ManufacturerId] [int] NOT NULL,
	[Model] [nvarchar](255) NULL,
	[ModelId] [int] NOT NULL
) ON [PRIMARY]
GO
