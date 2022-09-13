USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_CRMSummaryReport]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_CRMSummaryReport](
	[RequestNo] [varchar](max) NULL,
	[RequstDate] [varchar](max) NULL,
	[RequestDetails] [varchar](max) NULL,
	[UserArea] [varchar](max) NULL,
	[Requester] [varchar](max) NULL,
	[TypeOfRequest] [varchar](max) NULL,
	[Status] [varchar](max) NULL,
	[Compietion] [varchar](max) NULL,
	[Ageing] [varchar](max) NULL,
	[Month] [varchar](max) NULL,
	[Year] [varchar](max) NULL,
	[RequestType] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
