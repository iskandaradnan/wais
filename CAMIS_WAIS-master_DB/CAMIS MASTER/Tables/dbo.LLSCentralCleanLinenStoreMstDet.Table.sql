USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCentralCleanLinenStoreMstDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCentralCleanLinenStoreMstDet](
	[CCLSDetId] [int] IDENTITY(1,1) NOT NULL,
	[CCLSId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[OpeningBalance] [numeric](24, 2) NULL,
	[PrevStoreBalance] [int] NULL,
	[StoreBalance] [numeric](24, 2) NULL,
	[StockLevel] [numeric](24, 2) NULL,
	[ReorderQuantity] [numeric](24, 2) NULL,
	[Par1] [numeric](24, 2) NULL,
	[Par2] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CurrStoreCal] [int] NULL,
	[PrevCurrStoreCal] [int] NULL
) ON [PRIMARY]
GO
