USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[ReportErrorLog]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportErrorLog](
	[ErrorId] [int] IDENTITY(1,1) NOT NULL,
	[Spname] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[createddate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportErrorLog] ADD  DEFAULT (getdate()) FOR [createddate]
GO
