USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[PBITBLRescheduleDate]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PBITBLRescheduleDate](
	[ASSETID] [int] NULL,
	[WorkOrderId] [int] NULL,
	[RescheduleDate] [datetime] NULL
) ON [PRIMARY]
GO
