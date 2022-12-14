USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserLocationDetailsReceptaclesMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserLocationDetailsReceptaclesMstDet](
	[ReceptaclesId] [int] IDENTITY(1,1) NOT NULL,
	[CLSUserLocationId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Bin660L] [numeric](24, 2) NULL,
	[Bin240L] [numeric](24, 2) NULL,
	[WastePaperBasketBin] [numeric](24, 2) NULL,
	[PedalBin] [numeric](24, 2) NULL,
	[BedsideBin] [numeric](24, 2) NULL,
	[FlipFlopBin] [numeric](24, 2) NULL,
	[FoodBin] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSUserLocationDetailsMstReceptaclesMstDet] PRIMARY KEY CLUSTERED 
(
	[ReceptaclesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
