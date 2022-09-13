USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMWOStatusChange_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[uspFM_EngMWOStatusChange_Save]
 @EngMWOStatusChangeUDT	AS	[dbo].[udt_EngMWOStatusChange] READONLY
as 
begin

	update a set WorkOrderStatus=b.WorkOrderStatus 
		from EngMaintenanceWorkOrderTxn a join @EngMWOStatusChangeUDT b on a.workorderid=b.workorderid
end
GO
