USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMWORemarkChange_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE  [dbo].[uspFM_EngMWORemarkChange_Save]
 @EngMWORemarkChangeUDT	AS	[dbo].[udt_EngMWORemarkChange] READONLY
as 
begin

	update a set MaintenanceDetails=b.MaintenanceDetails 
		from EngMaintenanceWorkOrderTxn a join @EngMWORemarkChangeUDT b on a.workorderid=b.workorderid
end
GO
