USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorId] [int] IDENTITY(1,1) NOT NULL,
	[SpName] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ErrorLog] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
