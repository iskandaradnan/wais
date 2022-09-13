USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[PBI_LOG]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PBI_LOG](
	[ProcessStartDate] [datetime] NULL,
	[ProcessEndDate] [datetime] NULL,
	[Process] [varchar](20) NULL,
	[ID] [int] IDENTITY(0,1) NOT NULL
) ON [PRIMARY]
GO
