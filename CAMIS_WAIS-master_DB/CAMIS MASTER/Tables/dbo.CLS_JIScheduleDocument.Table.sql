USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_JIScheduleDocument]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_JIScheduleDocument](
	[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[UserAreaCode] [nvarchar](30) NULL,
	[UserAreaName] [nvarchar](30) NULL,
	[Day] [nvarchar](30) NULL,
	[TargetDate] [nvarchar](30) NULL,
	[Status] [int] NULL,
	[JIId] [int] NOT NULL
) ON [PRIMARY]
GO
