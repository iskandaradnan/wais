USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[PBITBLRescheduleDate]    Script Date: 20-09-2021 16:25:44 ******/
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
