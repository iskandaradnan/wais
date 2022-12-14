USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaDispenser]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaDispenser](
	[DispenserId] [int] IDENTITY(1,1) NOT NULL,
	[DeptAreaId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[HandPaperTowel] [int] NULL,
	[JumboRoll] [int] NULL,
	[HandSoap] [int] NULL,
	[Deodorant] [int] NULL,
	[FootPump] [int] NULL,
	[HandDryers] [int] NULL,
	[AutoTimer] [int] NULL,
	[UserAreaCode] [nvarchar](100) NULL
) ON [PRIMARY]
GO
