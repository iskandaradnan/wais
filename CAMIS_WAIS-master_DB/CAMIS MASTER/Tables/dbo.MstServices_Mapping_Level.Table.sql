USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstServices_Mapping_Level]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstServices_Mapping_Level](
	[MstServicesId_Level] [int] IDENTITY(1,1) NOT NULL,
	[Master_Level_ID] [int] NULL,
	[BEMS] [int] NULL,
	[FEMS] [int] NULL,
	[CLS] [int] NULL,
	[LLS] [int] NULL,
	[HWMS] [int] NULL,
	[Created_By] [int] NULL,
 CONSTRAINT [PK_MstServices_Level] PRIMARY KEY CLUSTERED 
(
	[MstServicesId_Level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
