USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationFacility_Mapping]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationFacility_Mapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityId] [int] NULL,
	[FEMS_ID] [int] NULL,
	[BEMS_ID] [int] NULL,
	[CLS_ID] [int] NULL,
	[LLS_ID] [int] NULL,
	[HWMS_ID] [int] NULL
) ON [PRIMARY]
GO
