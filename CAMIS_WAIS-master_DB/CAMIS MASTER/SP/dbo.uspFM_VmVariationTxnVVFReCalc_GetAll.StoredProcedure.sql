USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxnVVFReCalc_GetAll]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------ALTER TABLE VmVariationTxn ADD AGEID INT
/*========================================================================================================              
Application Name : UETrack-BEMS                            
Version    : 1.0              
Procedure Name  : uspFM_VmVariationTxnVVF_GetAll              
Description   : Get the variation details for bulk authorization.              
Authors    : Dhilip V              
Date    : 06-May-2018              
-----------------------------------------------------------------------------------------------------------              

Unit Test:
EXEC [uspFM_VmVariationTxnVVFReCalc_GetAll] @pFacilityId =1              

-----------------------------------------------------------------------------------------------------------              
Version History               
-----:------------:---------------------------------------------------------------------------------------              
Init : Date       : Details              
========================================================================================================*/              
CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxnVVFReCalc_GetAll]                                         
  @pFacilityId       INT,              
  @pUserId        int =NUll              
              
AS                                                             
              
BEGIN TRY              
              
-- Paramter Validation               
              
 SET NOCOUNT ON;               
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;              
              
-- Declaration              
              
/*              
 1 = <=5 Years              
 2 = >5 & <=10 Years              
 3 >10 Years              
*/               
 select VariationId,               
   assetid,              
   VariationRaisedDate,               
   ContractType as V_ContractType,              
   PurchaseDate as V_PurchaseDate ,               
   case when  datediff(month,PurchaseDate,VariationRaisedDate)/12.0  <=5 then 1              
     when datediff(month,PurchaseDate,VariationRaisedDate)/12.0 >5 and                 
       datediff(month,PurchaseDate,VariationRaisedDate)/12.0 <=10 then  2              
      ELSE 3 end AGEID                
       , VVT_AGEID        
 into  #variationlist from               
 (SELECT row_number() over(partition by assetid order by VariationId desc) sno, VariationId, assetid,VariationRaisedDate, ContractType,PurchaseDate, 
 AGEID as VVT_AGEID
 FROM VmVariationTxn V where FacilityId=@pFacilityId and isnull(V.VariationWFStatus,0) ! = 0              
 and not exists (select 1 FROM VmVariationTxn V1 where v1.FacilityId=@pFacilityId and isnull(V1.VariationWFStatus,0)  = 0 and v1.AssetId=v.AssetId ))a              
 where sno=1              
         
     --SELECT row_number() over(partition by assetid, AGEID order by assetid desc) assetid_NO,* INTO #variationlist_1 FROM #variationlist        
     --SELECT * FROM #variationlist_1        
  --SELECT row_number() over(partition by assetid, AGEID order by assetid desc) assetid_NO,* INTO #variationlist_1 FROM #variationlist        
  --DELETE FROM #variationlist WHERE sno > 1        
             
 select a.VariationId, A.AGEID , a.assetid, case when  datediff(month,b.PurchaseDate,getdate())/12.0  <=5 then 1            
    when   datediff(month,b.PurchaseDate,getdate())/12.0 >5 and  datediff(month,b.PurchaseDate,getdate())/12.0 <=10 then  2            
    ELSE 3 end AS FINAL_AGEID        
 --,b.*, VariationRaisedDate, V_ContractType, V_PurchaseDate, AGEID        
 into #variationlist_final              
 from #variationlist  a join engasset b on a.assetid = b.AssetId              
 and Not ( case when  datediff(month,b.PurchaseDate,getdate())/12.0  <=5 then 1              
    when   datediff(month,b.PurchaseDate,getdate())/12.0 >5 and  datediff(month,b.PurchaseDate,getdate())/12.0 <=10 then  2              
    ELSE 3 end   = a.AGEID              
   and                
   a.V_ContractType = b.ContractType          
   )              
  And (WarrantyEndDate is not null and cast( getdate() as date) >  cast( WarrantyEndDate as date))  
         
              
  INSERT INTO VmVariationTxn   (              
             CustomerId,              
    FacilityId,              
             ServiceId,              
             SNFDocumentNo,              
             SnfDate,              
             AssetId,        
             AssetClassification,              
             VariationStatus,              
             PurchaseProjectCost,              
             VariationDate,              
    VariationDateUTC,              
             StartServiceDate,              
             StartServiceDateUTC,              
             ServiceStopDate,              
             ServiceStopDateUTC,              
             CommissioningDate,              
             CommissioningDateUTC,              
             WarrantyDurationMonth,              
             WarrantyStartDate,              
             WarrantyStartDateUTC,              
             WarrantyEndDate,              
             WarrantyEndDateUTC,              
             ClosingMonth,              
             ClosingYear,              
             VariationApprovedStatus,              
             OldUsage,              
             NewUsage,              
             UserLocation,              
    Justification,              
             ApprovedDate,              
             ApprovedDateUTC,              
             ApprovedAmount,              
             Remarks,              
             AuthorizedStatus,              
             IsMonthClosed,              
             Period,              
             PaymentStartDate,              
             PaymentStartDateUTC,              
             PWPaymentStartDate,              
             PWPaymentStartDateUTC,              
             ProposedRateDW,              
             ProposedRatePW,              
             MonthlyProposedFeeDW,              
             MonthlyProposedFeePW,              
             CalculatedFeePW,              
             CalculatedFeeDW,              
             VariationRaisedDate,              
             VariationRaisedDateUTC,              
             AssetOldVariationData,              
             VariationWFStatus,              
             DoneBy,              
             DoneDate,              
             DoneDateUTC,              
             DoneRemarks,              
             IsVerify,              
             GovernmentAssetNo,              
             GovernmentAssetNoDescription,              
             PurchaseDate,              
             PurchaseDateUTC,              
             VariationPurchaseCost,              
             ContractCost,              
             ContractLpoNo,              
             CompanyAssetPraId,              
             CompanyAssetRegId,              
             WarrantyProvision,              
             UserAreaId,              
             AOId,              
             AODate,              
             AODateUTC,              
             JOHNId,              
             JOHNDate,              
             JOHNDateUTC,              
             HosDirectorId,              
             HosDirectorDate,              
             HosDirectorDateUTC,              
             AvailableCost,              
             MainSupplierCode,              
             MainSupplierName,              
             CreatedBy,              
             CreatedDate,              
             CreatedDateUTC,              
             ModifiedBy,              
             ModifiedDate,              
             ModifiedDateUTC  ,              
             ContractType, AGEID
             )              
  SELECT               
     CustomerId,              
     FacilityId,              
     ServiceId,              
     SNFDocumentNo,              
     SnfDate,              
     VVT.AssetId,              
     AssetClassification,              
     VariationStatus,              
     PurchaseProjectCost,              
     GETDATE(),              
     GETUTCDATE(),              
     StartServiceDate,              
     StartServiceDateUTC,              
     ServiceStopDate,    
     ServiceStopDateUTC,              
     CommissioningDate,              
     CommissioningDateUTC,              
     WarrantyDurationMonth,              
     WarrantyStartDate,                 
     WarrantyStartDateUTC,              
     WarrantyEndDate,              
     WarrantyEndDateUTC,              
     ClosingMonth,              
     ClosingYear,              
     null as VariationApprovedStatus,              
     OldUsage,              
     NewUsage,              
     UserLocation,              
     Justification,              
     ApprovedDate,              
     ApprovedDateUTC,              
     ApprovedAmount,              
     Remarks,              
     AuthorizedStatus,              
     IsMonthClosed,              
     Period,              
     PaymentStartDate,              
     PaymentStartDateUTC,              
     PWPaymentStartDate,              
     PWPaymentStartDateUTC,              
     ProposedRateDW,              
     ProposedRatePW,              
     MonthlyProposedFeeDW,              
     MonthlyProposedFeePW,              
     CalculatedFeePW,              
     CalculatedFeeDW,              
     GETDATE() AS VariationRaisedDate,              
     GETUTCDATE() AS VariationRaisedDateUTC,              
     AssetOldVariationData,              
     NULL AS VariationWFStatus,              
     DoneBy,              
     DoneDate,              
     DoneDateUTC,              
     DoneRemarks,              
     IsVerify,              
     GovernmentAssetNo,              
     GovernmentAssetNoDescription,              
     PurchaseDate,              
     PurchaseDateUTC,              
     VariationPurchaseCost,              
     ContractCost,              
     ContractLpoNo,              
     CompanyAssetPraId,              
     CompanyAssetRegId,              
     WarrantyProvision,              
     UserAreaId,              
     AOId,              
     AODate,              
     AODateUTC,              
     JOHNId,              
     JOHNDate,              
     JOHNDateUTC,              
     HosDirectorId,              
     HosDirectorDate,              
     HosDirectorDateUTC,              
     AvailableCost,              
     MainSupplierCode,              
     MainSupplierName,              
     isnull(@pUserId,1) as CreatedBy,              
     getdate(),              
     getUTCdate(),              
     isnull(@pUserId,1) as ModifiedBy,              
     getdate(),              
     getUTCdate(),              
     ContractType, TEMP.FINAL_AGEID 
  from VmVariationTxn  AS VVT		----where VariationId in (select VariationId from #variationlist_final)              
	INNER  JOIN #variationlist_final AS TEMP ON VVT.VariationId = TEMP.VariationId
	WHERE NOT EXISTS (select FINAL_AGEID from #variationlist_final AS T WHERE T.FINAL_AGEID = VVT.AGEID AND T.ASSETID = VVT.ASSETID)

  SELECT @@ROWCOUNT AS varationAssetCount            
  
  if @@ROWCOUNT > 0          
  UPDATE [MstLocationFacility] SET IsContractPeriodChanged = 0           
  where FacilityId= @pFacilityId          
  
  
END TRY              
              
BEGIN CATCH              
              
 INSERT INTO ErrorLog(              
    Spname,              
    ErrorMessage,              
    createddate)              
 VALUES(  OBJECT_NAME(@@PROCID),              
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),              
    getdate()              
     );              
  THROW;              
              
END CATCH
GO
