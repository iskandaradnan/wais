USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[BIS_Email_Notification_WO]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BIS_Email_Notification_WO](
	[Id] [int] NOT NULL,
	[BISWOID] [int] NOT NULL,
	[Created date] [datetime] NOT NULL,
	[Email_sent] [int] NULL
) ON [PRIMARY]
GO
