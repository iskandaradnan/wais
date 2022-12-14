USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedIndicatorFormula]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedIndicatorFormula](
	[IndicatorFormulaId] [int] IDENTITY(1,1) NOT NULL,
	[IndicatorDetId] [int] NULL,
	[AssetStartPrice] [numeric](18, 2) NULL,
	[AssetEndPrice] [numeric](18, 2) NULL,
	[DeductionFigure] [numeric](18, 2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_MstDedIndicatorFormula] PRIMARY KEY CLUSTERED 
(
	[IndicatorFormulaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstDedIndicatorFormula] ADD  CONSTRAINT [DF_MstDedIndicatorFormula_Active]  DEFAULT ((1)) FOR [Active]
GO
