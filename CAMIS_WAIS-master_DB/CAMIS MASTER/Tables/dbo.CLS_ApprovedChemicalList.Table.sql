USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_ApprovedChemicalList]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_ApprovedChemicalList](
	[ChemicalId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Category] [nvarchar](50) NULL,
	[AreaofApplication] [nvarchar](50) NULL,
	[ChemicalName] [nvarchar](50) NULL,
	[KKMNumber] [nvarchar](50) NULL,
	[Properties] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[EffectiveFromDate] [date] NULL,
	[EffectiveToDate] [date] NULL
) ON [PRIMARY]
GO
