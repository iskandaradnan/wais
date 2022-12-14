USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoPartReplacementPopup]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoPartReplacementPopup](
	[PartReplacementPopupId] [int] IDENTITY(1,1) NOT NULL,
	[StockUpdateDetId] [int] NULL,
	[ActualQuantity] [int] NULL,
	[QuantityTaken] [int] NULL,
	[PartReplacementDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
