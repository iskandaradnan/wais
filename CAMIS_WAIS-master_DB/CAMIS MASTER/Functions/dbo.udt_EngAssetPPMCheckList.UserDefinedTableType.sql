USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckList]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckList] AS TABLE(
	[PPMCheckListId] [int] NULL,
	[PPMRegisterId] [int] NULL,
	[ServiceId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[StandardTaskDetId] [int] NULL,
	[PPMChecklistNo] [nvarchar](120) NULL,
	[ManufacturerId] [int] NULL,
	[ModelId] [int] NULL,
	[PPMFrequency] [int] NULL,
	[PpmHours] [numeric](24, 2) NULL,
	[SpecialPrecautions] [nvarchar](2000) NULL,
	[DoneBy] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[Description] [nvarchar](510) NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[Active] [bit] NULL DEFAULT ((1)),
	[BuiltIn] [bit] NULL DEFAULT ((1))
)
GO
