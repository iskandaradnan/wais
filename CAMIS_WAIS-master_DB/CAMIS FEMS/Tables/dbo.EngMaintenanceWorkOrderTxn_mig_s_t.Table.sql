USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMaintenanceWorkOrderTxn_mig_s_t]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMaintenanceWorkOrderTxn_mig_s_t](
	[MaintenanceWorkNo] [nvarchar](100) NOT NULL,
	[TargetDateTime] [datetime] NULL
) ON [PRIMARY]
GO
