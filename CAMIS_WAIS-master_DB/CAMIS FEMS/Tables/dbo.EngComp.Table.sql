USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngComp]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngComp](
	[WORK ORDER NO] [nvarchar](255) NULL,
	[WorkOrderId] [float] NULL,
	[RepairDetails] [nvarchar](255) NULL,
	[PPMAgreedDate] [nvarchar](255) NULL,
	[StartDateTime] [nvarchar](255) NULL,
	[EndDateTime] [nvarchar](255) NULL,
	[HandoverDateTime] [nvarchar](255) NULL,
	[completedby] [float] NULL,
	[AcceptedBy] [float] NULL,
	[RepairHours] [datetime] NULL,
	[UserId] [float] NULL,
	[StandardTaskDetId] [float] NULL,
	[StartDateTime1] [nvarchar](255) NULL,
	[EndDateTime1] [nvarchar](255) NULL
) ON [PRIMARY]
GO
