USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaDetailsTable]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaDetailsTable](
	[DeptAreaId] [int] NULL,
	[UserAreaId] [int] NULL,
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[LocationCode] [nvarchar](50) NULL,
	[Status] [nvarchar](30) NULL,
	[Floor] [bit] NULL,
	[Walls] [bit] NULL,
	[Ceiling] [bit] NULL,
	[WindowsDoors] [bit] NULL,
	[ReceptaclesContainers] [bit] NULL,
	[FurnitureFixtureEquipment] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_DeptAreaDetailsTable]  WITH CHECK ADD  CONSTRAINT [FK_Location] FOREIGN KEY([DeptAreaId])
REFERENCES [dbo].[CLS_DeptAreaDetails] ([DeptAreaId])
GO
ALTER TABLE [dbo].[CLS_DeptAreaDetailsTable] CHECK CONSTRAINT [FK_Location]
GO
