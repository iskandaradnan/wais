USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSSoiledLinenCollectionTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSSoiledLinenCollectionTxnDet_Update] AS TABLE(
	[SoiledLinenCollectionDetId] [int] NULL,
	[LLSUserAreaId] [int] NULL,
	[LLSUserAreaLocationId] [int] NULL,
	[Weight] [numeric](24, 2) NULL,
	[TotalWhiteBag] [int] NULL,
	[TotalRedBag] [int] NULL,
	[TotalGreenBag] [int] NULL,
	[TotalQuantity] [int] NULL,
	[CollectionSchedule] [int] NULL,
	[CollectionStartTime] [time](7) NULL,
	[CollectionEndTime] [time](7) NULL,
	[CollectionTime] [time](7) NULL,
	[OnTime] [int] NULL,
	[VerifiedBy] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[SoiledLinenCollectionId] [int] NULL,
	[BrownBag] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
