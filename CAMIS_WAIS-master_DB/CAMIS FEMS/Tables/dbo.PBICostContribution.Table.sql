USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[PBICostContribution]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PBICostContribution](
	[AssetId] [int] NOT NULL,
	[WorkOrderId] [int] NULL,
	[CostContribution] [varchar](14) NOT NULL,
	[Cost] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
