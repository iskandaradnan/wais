USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SpareParts_Wodetails]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: UETrack                                       
Procedure Name		: uspFM_SpareParts
Author(s) Name(s)	: Aravinda Raja P
Date				: 17-July-2018
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
exec uspFM_SpareParts_Wodetails    @SparePartId  
exec uspFM_SpareParts_Wodetails    90
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/  
CREATE procedure [dbo].[uspFM_SpareParts_Wodetails]
(
	@StockUpdateDetId int
)
As
Begin
set nocount on
set transaction isolation level read uncommitted
begin try

select 
asset.AssetNo,
mwo.MaintenanceWorkNo,
stockupdate.InvoiceNo,
spare.PartNo,
mwopart.SparePartRunningHours
from EngMwoPartReplacementTxn mwopart
inner join EngStockUpdateRegisterTxnDet stockupdate on stockupdate.StockUpdateDetId=mwopart.StockUpdateDetId
inner join EngSpareParts spare on stockupdate.SparePartsId=spare.SparePartsId and spare.Active=1
inner join EngMaintenanceWorkOrderTxn mwo on mwo.WorkOrderId=mwopart.WorkOrderId
inner join EngAsset asset on mwo.AssetId=asset.AssetId and asset.Active=1
where mwopart.StockUpdateDetId=@StockUpdateDetId
End try

begin catch
--throw

insert into ErrorLog(Spname,ErrorMessage,createddate) values 
(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

end catch
set nocount off
End
GO
