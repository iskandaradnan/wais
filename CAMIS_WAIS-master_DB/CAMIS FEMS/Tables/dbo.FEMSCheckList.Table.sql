USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FEMSCheckList]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEMSCheckList](
	[ASSET NO#] [nvarchar](255) NULL,
	[TYPE CODE] [nvarchar](255) NULL,
	[TypeCodeID Sub] [float] NULL,
	[TypeCodeID Mst] [float] NULL,
	[Model] [nvarchar](255) NULL,
	[ModelID Sub] [float] NULL,
	[ModelID Mst] [float] NULL,
	[Manuf] [nvarchar](255) NULL,
	[ManufID Sub] [float] NULL,
	[ManufID Mst] [float] NULL,
	[TaskCode 1] [nvarchar](255) NULL,
	[TaskCode 2] [nvarchar](255) NULL,
	[PPMFreq] [float] NULL,
	[PPMFreq2] [float] NULL,
	[is taskcode1=taskcode2] [nvarchar](255) NULL,
	[PPMChecklistNo_1] [nvarchar](255) NULL
) ON [PRIMARY]
GO
