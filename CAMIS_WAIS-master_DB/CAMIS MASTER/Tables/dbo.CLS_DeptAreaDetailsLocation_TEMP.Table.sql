USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaDetailsLocation_TEMP]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaDetailsLocation_TEMP](
	[DeptAreaId] [int] NULL,
	[UserAreaId] [int] NULL,
	[PreviousCode] [nvarchar](255) NULL,
	[LocationId] [int] NULL,
	[LocationCode] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[Floor] [bit] NULL,
	[Walls] [bit] NULL,
	[Celling] [bit] NULL,
	[WindowsDoors] [bit] NULL,
	[ReceptaclesContainers] [bit] NULL,
	[FurnitureFixtureEquipments] [bit] NULL,
	[user_locn_areacode] [nvarchar](20) NULL
) ON [PRIMARY]
GO
