USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[ScheduleDate]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleDate](
	[Asset No] [nvarchar](255) NULL,
	[Schdule Date] [datetime] NULL,
	[WorkOrderNo] [nvarchar](255) NULL
) ON [PRIMARY]
GO
