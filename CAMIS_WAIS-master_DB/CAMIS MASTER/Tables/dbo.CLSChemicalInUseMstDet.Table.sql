USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSChemicalInUseMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSChemicalInUseMstDet](
	[ChemicalDetId] [int] IDENTITY(1,1) NOT NULL,
	[ChemicalId] [int] NULL,
	[Category] [int] NULL,
	[AreaOfApplication] [int] NULL,
	[ApprovedChemicalId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSChemicalInUseMstDet] PRIMARY KEY CLUSTERED 
(
	[ChemicalDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
