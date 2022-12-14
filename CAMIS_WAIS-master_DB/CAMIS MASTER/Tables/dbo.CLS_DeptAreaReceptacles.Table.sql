USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaReceptacles]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaReceptacles](
	[ReceptaclesId] [int] IDENTITY(1,1) NOT NULL,
	[DeptAreaId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[Bin660L] [int] NULL,
	[BIn240L] [int] NULL,
	[WastePaperBasket] [int] NULL,
	[PedalBin] [int] NULL,
	[BedsideBin] [int] NULL,
	[FlipFlop] [int] NULL,
	[FoodBin] [int] NULL,
	[UserAreaCode] [nvarchar](100) NULL
) ON [PRIMARY]
GO
