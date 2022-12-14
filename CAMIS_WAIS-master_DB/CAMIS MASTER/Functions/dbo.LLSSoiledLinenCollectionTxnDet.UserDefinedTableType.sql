USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSSoiledLinenCollectionTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSSoiledLinenCollectionTxnDet] AS TABLE(
	[SoiledLinenCollectionId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[LLSUserAreaLocationId] [int] NOT NULL,
	[Weight] [numeric](24, 2) NOT NULL,
	[TotalWhiteBag] [int] NOT NULL,
	[TotalRedBag] [int] NOT NULL,
	[TotalGreenBag] [int] NOT NULL,
	[TotalBrownBag] [int] NOT NULL,
	[TotalQuantity] [int] NULL,
	[CollectionSchedule] [int] NOT NULL,
	[CollectionStartTime] [time](7) NULL,
	[CollectionEndTime] [time](7) NULL,
	[CollectionTime] [time](7) NULL,
	[OnTime] [int] NOT NULL,
	[VerifiedBy] [int] NULL,
	[VerifiedDate] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
