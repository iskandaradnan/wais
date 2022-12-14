USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSSoiledLinenCollectionTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSSoiledLinenCollectionTxnDet](
	[SoiledLinenCollectionDetId] [int] IDENTITY(1,1) NOT NULL,
	[SoiledLinenCollectionId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[LLSUserAreaLocationId] [int] NOT NULL,
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
	[VerifiedDate] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[TotalBrownBag] [int] NULL,
 CONSTRAINT [PK_LLSSoiledLinenCollectionTxnDetNew] PRIMARY KEY CLUSTERED 
(
	[SoiledLinenCollectionDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSSoiledLinenCollectionTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSSoiledLinenCollectionTxnDet_LLSSoiledLinenCollectionTxn_SoiledLinenCollectionIdNew] FOREIGN KEY([SoiledLinenCollectionId])
REFERENCES [dbo].[LLSSoiledLinenCollectionTxn] ([SoiledLinenCollectionId])
GO
ALTER TABLE [dbo].[LLSSoiledLinenCollectionTxnDet] CHECK CONSTRAINT [FK_LLSSoiledLinenCollectionTxnDet_LLSSoiledLinenCollectionTxn_SoiledLinenCollectionIdNew]
GO
