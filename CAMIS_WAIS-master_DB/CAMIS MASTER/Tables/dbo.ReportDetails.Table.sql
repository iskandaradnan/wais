USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[ReportDetails]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](500) NULL,
	[RDLName] [varchar](50) NULL,
	[ModuleName] [varchar](50) NULL,
	[DatabaseName] [varchar](50) NULL,
	[ProcedureName] [varchar](50) NULL,
	[TableName] [varchar](max) NULL,
	[ProductionDate] [datetime] NULL,
	[FolderPath] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[ReportStatus] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
