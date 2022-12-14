USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckList25012021]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckList25012021](
	[PPMCheckListId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetTypeCodeId] [int] NULL,
	[PPMChecklistNo] [nvarchar](60) NULL,
	[ManufacturerId] [int] NULL,
	[ModelId] [int] NULL,
	[PPMFrequency] [int] NULL,
	[PpmHours] [numeric](24, 2) NULL,
	[SpecialPrecautions] [nvarchar](1000) NULL,
	[DoneBy] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[Description] [nvarchar](255) NULL,
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
	[TaskCode] [nvarchar](50) NOT NULL,
	[TaskDescription] [nvarchar](550) NULL,
	[VersionNo] [numeric](24, 2) NULL,
	[Model] [varchar](1000) NULL,
	[Manufacturer] [varchar](1000) NULL,
	[AssetTypeCode] [varchar](1000) NULL
) ON [PRIMARY]
GO
