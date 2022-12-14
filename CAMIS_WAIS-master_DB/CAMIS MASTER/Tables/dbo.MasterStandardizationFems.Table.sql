USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MasterStandardizationFems]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterStandardizationFems](
	[MASTER_ASSET_CODE] [nvarchar](255) NULL,
	[MASTER_ASSETTYPECODEID] [int] NOT NULL,
	[MASTER_MANUFACURER] [nvarchar](255) NULL,
	[MASTER_MANU_ID] [int] NOT NULL,
	[MASTER_MODEL] [nvarchar](255) NULL,
	[MASTER_MODEL_ID] [int] NOT NULL,
	[CHILD_ASSET_CODE] [nvarchar](255) NULL,
	[CHILD_ASSETTYPECODEID] [int] NOT NULL,
	[CHILD_MANUFACURER] [nvarchar](255) NULL,
	[CHILD_MANU_ID] [int] NOT NULL,
	[CHILD_MODEL] [nvarchar](255) NULL,
	[CHILD_MODEL_ID] [int] NOT NULL,
	[CHILD_STANDARD_ID] [int] NOT NULL
) ON [PRIMARY]
GO
