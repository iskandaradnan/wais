USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionLog]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionLog](
	[ProcessID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessStartDate] [datetime] NULL,
	[ProcessEndDate] [datetime] NULL,
	[Process] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
