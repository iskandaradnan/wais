USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaToilet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaToilet](
	[ToiletId] [int] IDENTITY(1,1) NOT NULL,
	[DeptAreaId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[LocationId] [int] NULL,
	[LocationCode] [nvarchar](50) NULL,
	[Type] [int] NULL,
	[Frequency] [int] NULL,
	[Details] [int] NULL,
	[Mirror] [bit] NULL,
	[Floor] [bit] NULL,
	[Wall] [bit] NULL,
	[Urinal] [bit] NULL,
	[Bowl] [bit] NULL,
	[Basin] [bit] NULL,
	[ToiletRoll] [bit] NULL,
	[SoapDispenser] [bit] NULL,
	[AutoAirFreshner] [bit] NULL,
	[Waste] [bit] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
