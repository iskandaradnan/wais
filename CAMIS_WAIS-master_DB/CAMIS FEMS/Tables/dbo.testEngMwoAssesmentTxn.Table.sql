USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[testEngMwoAssesmentTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testEngMwoAssesmentTxn](
	[WorkOrderId] [int] NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[ResponseDateTimeUTC] [datetime] NULL
) ON [PRIMARY]
GO
