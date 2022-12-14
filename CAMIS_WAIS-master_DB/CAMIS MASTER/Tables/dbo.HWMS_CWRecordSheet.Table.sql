USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CWRecordSheet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CWRecordSheet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[TotalUserArea] [bigint] NULL,
	[TotalBagCollected] [bigint] NULL,
	[TotalSanitized] [bigint] NULL,
	[UserAreaCode] [bigint] NULL,
	[CollectionFequency] [bigint] NULL,
	[CollectionTime] [time](7) NULL,
	[CollectionStatus] [varchar](max) NULL,
	[QC] [varchar](max) NULL,
	[NoofBags] [bigint] NULL,
	[NoofReceptaclesOnsite] [bigint] NULL,
	[NoofReceptacleSanitize] [bigint] NULL,
	[Sanitize] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
