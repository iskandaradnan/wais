USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_JiDetails_LocationCode]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_JiDetails_LocationCode](
	[JILocationId] [int] IDENTITY(1,1) NOT NULL,
	[LocationCode] [nvarchar](100) NULL,
	[LocationName] [nvarchar](100) NULL,
	[Floor] [nvarchar](50) NULL,
	[Walls] [nvarchar](50) NULL,
	[Ceiling] [nvarchar](50) NULL,
	[WindowsDoors] [nvarchar](50) NULL,
	[ReceptaclesContainers] [nvarchar](50) NULL,
	[FFEquipment] [nvarchar](50) NULL,
	[Remarks] [nvarchar](50) NULL,
	[DetailsId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_JiDetails_LocationCode]  WITH CHECK ADD  CONSTRAINT [JILocation_FK_Idno] FOREIGN KEY([DetailsId])
REFERENCES [dbo].[CLS_JiDetails] ([DetailsId])
GO
ALTER TABLE [dbo].[CLS_JiDetails_LocationCode] CHECK CONSTRAINT [JILocation_FK_Idno]
GO
