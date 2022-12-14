USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetStandardization30012021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetStandardization30012021](
	[AssetStandardizationId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ManufacturerId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[UpperCost] [numeric](24, 2) NULL,
	[LowerCost] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Status] [int] NULL
) ON [PRIMARY]
GO
