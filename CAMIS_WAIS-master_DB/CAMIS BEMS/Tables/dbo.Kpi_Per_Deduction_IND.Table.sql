USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[Kpi_Per_Deduction_IND]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kpi_Per_Deduction_IND](
	[KPI_PER_ID] [int] IDENTITY(1,1) NOT NULL,
	[KPI_IND_ID] [int] NOT NULL,
	[KPI_FRE] [int] NOT NULL,
	[KPI_BEPC_COST_FROM] [int] NOT NULL,
	[KPI_BEPC_COST_TO] [int] NOT NULL,
	[KPI_DEDUCTION_VALUE] [int] NOT NULL,
	[KPI_ACTIVE] [int] NOT NULL,
	[CALL_CONDITIONS_INDICATOR_IND_ID] [int] NULL
) ON [PRIMARY]
GO
