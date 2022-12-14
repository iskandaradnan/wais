USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_ChemicalInUseChemicals]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_ChemicalInUseChemicals](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[ChemicalInUseId] [int] NULL,
	[Category] [int] NULL,
	[AreaOfApplication] [int] NULL,
	[ChemicalId] [int] NULL,
	[KMMNo] [nvarchar](50) NULL,
	[Properties] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[EffectiveDate] [date] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_ChemicalInUseChemicals]  WITH CHECK ADD FOREIGN KEY([ChemicalInUseId])
REFERENCES [dbo].[CLS_ChemicalInUse] ([ChemicalId])
GO
ALTER TABLE [dbo].[CLS_ChemicalInUseChemicals]  WITH CHECK ADD FOREIGN KEY([ChemicalInUseId])
REFERENCES [dbo].[CLS_ChemicalInUse] ([ChemicalId])
GO
