USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SpareParts]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
    
    
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name : UETrack                                           
Procedure Name  : uspFM_SpareParts    
Author(s) Name(s) : Aravinda Raja P    
Date    : 17-July-2018    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
exec uspFM_SpareParts    @SparePartId      
exec uspFM_SpareParts    32,'',''    
exec uspFM_SpareParts    23,'',''    
exec uspFM_SpareParts @FromDate = '2016-10-01', @ToDate = '2019-12-20'  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/      
CREATE procedure [dbo].[uspFM_SpareParts]    
(    
 @SparePartId int = null,    
 @FromDate datetime =null,    
 @ToDate datetime = null    
)    
As    
Begin    
set nocount on    
set transaction isolation level read uncommitted    
begin try    
  
select * into #temp_SparePartRunningHours from (  
select asset.AssetId,asset.Assetno,stockupdate.InvoiceNo,spare.PartNo,mwopart.SparePartRunningHours as PartUsage, mwopart.PartReplacementId,   
row_number() over(partition by asset.AssetId,stockupdate.InvoiceNo,spare.PartNo order by mwopart.createddate desc) as test_no  
from EngMwoPartReplacementTxn mwopart    
inner join EngStockUpdateRegisterTxnDet stockupdate on stockupdate.StockUpdateDetId=mwopart.StockUpdateDetId    
inner join EngSpareParts spare on stockupdate.SparePartsId=spare.SparePartsId and spare.Active=1    
inner join EngMaintenanceWorkOrderTxn mwo on mwo.WorkOrderId=mwopart.WorkOrderId    
inner join EngAsset asset on asset.AssetId=mwo.AssetId and asset.Active=1  ) as test where test. test_no= 1  
  
select distinct     
asset.AssetNo,    
asset.AssetDescription,    
spare.PartNo,    
spare.PartDescription,    
stockupdate.InvoiceNo,    
mwopart.EstimatedLifeSpan AS EstimatedLifeSpanInHours,    
convert(nvarchar(25),sparedet.UsedDateTime,106) 'PartInroducedDate_StartDate',    
--convert(nvarchar(25),dateadd(DAY,(cast(floor(mwopart.EstimatedLifeSpan) as int)/8),sparedet.UsedDateTime),106) ActualPartReplacementDate,  
CASE WHEN EstimatedLifeSpanId = 353 THEN convert(nvarchar(25),dateadd(DAY,(cast(floor(mwopart.EstimatedLifeSpan) as int)/8),sparedet.UsedDateTime),106)   
  WHEN EstimatedLifeSpanId = 354 THEN CONVERT(NVARCHAR(25),dateadd(DAY,mwopart.EstimatedLifeSpan,sparedet.UsedDateTime) ,106)  
  WHEN EstimatedLifeSpanId = 355 THEN CONVERT(NVARCHAR(25),dateadd(MONTH,mwopart.EstimatedLifeSpan,sparedet.UsedDateTime) ,106)  
  WHEN EstimatedLifeSpanId = 356 THEN CONVERT(NVARCHAR(25),dateadd(YEAR,mwopart.EstimatedLifeSpan,sparedet.UsedDateTime) ,106)  
  WHEN EstimatedLifeSpanId = 357 THEN CONVERT(NVARCHAR(25),StockExpiryDate ,106) END as ActualPartReplacementDate,     
convert(nvarchar(25),isnull(spareusage.PartUsage,(datediff(HH,sparedet.UsedDateTime,getdate()))),106) PartUsage,    
--convert(nvarchar(25),dateadd(DAY,(cast((floor(mwopart.EstimatedLifeSpan-(isnull(spareusage.PartUsage,(datediff(HH,sparedet.UsedDateTime,getdate())))))) as int)/8),sparedet.UsedDateTime),106) NextPartReplacementDate    
CASE WHEN EstimatedLifeSpanId = 353 THEN convert(nvarchar(25),dateadd(DAY,(cast((floor(mwopart.EstimatedLifeSpan-(isnull(spareusage.PartUsage,(datediff(HH,sparedet.UsedDateTime,getdate())))))) as int)/8),sparedet.UsedDateTime),106)  
  WHEN EstimatedLifeSpanId = 354 THEN CONVERT(NVARCHAR(25),dateadd(DAY,mwopart.EstimatedLifeSpan,sparedet.UsedDateTime) ,106)  
  WHEN EstimatedLifeSpanId = 355 THEN CONVERT(NVARCHAR(25),dateadd(MONTH,mwopart.EstimatedLifeSpan,sparedet.UsedDateTime) ,106)  
  WHEN EstimatedLifeSpanId = 356 THEN CONVERT(NVARCHAR(25),dateadd(YEAR,mwopart.EstimatedLifeSpan,sparedet.UsedDateTime) ,106)  
  WHEN EstimatedLifeSpanId = 357 THEN CONVERT(NVARCHAR(25),StockExpiryDate ,106) END as NextPartReplacementDate  
from EngMwoPartReplacementTxn mwopart    
inner join EngStockUpdateRegisterTxnDet stockupdate on stockupdate.StockUpdateDetId=mwopart.StockUpdateDetId    
inner join EngSpareParts spare on stockupdate.SparePartsId=spare.SparePartsId and spare.Active=1    
inner join EngMaintenanceWorkOrderTxn mwo on mwo.WorkOrderId=mwopart.WorkOrderId    
inner join EngAsset asset on mwo.AssetId=asset.AssetId and asset.Active=1    
  
inner join (select asset.AssetId,stockupdate.InvoiceNo,spare.PartNo,min(mwopart.UsedDateTime) UsedDateTime from EngMwoPartReplacementTxn mwopart    
   inner join EngStockUpdateRegisterTxnDet stockupdate on stockupdate.StockUpdateDetId=mwopart.StockUpdateDetId    
   inner join EngSpareParts spare on stockupdate.SparePartsId=spare.SparePartsId and spare.Active=1    
   inner join EngMaintenanceWorkOrderTxn mwo on mwo.WorkOrderId=mwopart.WorkOrderId    
   inner join EngAsset asset on asset.AssetId=mwo.AssetId and asset.Active=1    
   group by asset.AssetId,stockupdate.InvoiceNo,spare.PartNo) sparedet on sparedet.PartNo=spare.PartNo and sparedet.InvoiceNo=stockupdate.InvoiceNo and sparedet.AssetId=asset.AssetId    
  
inner join #temp_SparePartRunningHours as spareusage on spareusage.PartNo=spare.PartNo and sparedet.InvoiceNo=stockupdate.InvoiceNo and spareusage.AssetId=asset.AssetId    
   AND mwopart.PartReplacementId = spareusage.PartReplacementId  
  
where stockupdate.SparePartsId=isnull(@SparePartId,stockupdate.SparePartsId)    
--and cast ( sparedet.UsedDateTime as date) between @FromDate and @ToDate    
and convert(nvarchar(25),dateadd(DAY,(cast((floor(mwopart.EstimatedLifeSpan-(isnull(spareusage.PartUsage,(datediff(HH,sparedet.UsedDateTime,getdate())))))) as int)/8),sparedet.UsedDateTime),106) between @FromDate and @ToDate    
--and EstimatedLifeSpanInHours is not null    
and  EstimatedLifeSpanId not in (358)  
End try    
    
begin catch    
--throw    
    
insert into ErrorLog(Spname,ErrorMessage,createddate) values     
(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
end catch    
set nocount off    
End
GO
