USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxnVVFReCalc_GetAll_bak1]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
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
creATE PROCEDURE  [dbo].[uspFM_VmVariationTxnVVFReCalc_GetAll_bak1]                                 
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
       , MonthlyProposedFeePW
 into  #variationlist from       
 (SELECT row_number() over(partition by assetid order by VariationId desc) sno, VariationId, assetid,VariationRaisedDate, ContractType,PurchaseDate, 
 MonthlyProposedFeePW
 FROM VmVariationTxn V where FacilityId=@pFacilityId and isnull(V.VariationWFStatus,0) ! = 0 
 and not exists (select 1 FROM VmVariationTxn V1 where v1.FacilityId=@pFacilityId and isnull(V1.VariationWFStatus,0)  = 0 and v1.AssetId=v.AssetId ))a      
 where sno=1      
      
      
 select a.VariationId, b.Assetid, b.AssetTypeCodeId, b.ContractType  
 into #variationlist_final      
 from #variationlist  a join engasset b on a.assetid = b.AssetId      
 and Not ( case when  datediff(month,b.PurchaseDate,getdate())/12.0  <=5 then 1      
    when   datediff(month,b.PurchaseDate,getdate())/12.0 >5 and  datediff(month,b.PurchaseDate,getdate())/12.0 <=10 then  2      
    ELSE 3 end   = a.AGEID      
   and
   a.V_ContractType = b.ContractType      
   )      
  And ( WarrantyEndDate is not null and cast( getdate() as date) >  cast( WarrantyEndDate as date) )      


 SELECT a.Assetid,a.AssetTypeCodeId,        
 isnull(max(case when B.TypeCodeParameterId =1 then B.VariationRate else null end),0) as Parameter1,        
 isnull(max(case when B.TypeCodeParameterId =2 then B.VariationRate else null end),0) as Parameter2,        
 isnull(max(case when B.TypeCodeParameterId =3 then B.VariationRate else null end),0) as Parameter3,        
 isnull(max(case when B.TypeCodeParameterId =4 then B.VariationRate else null end),0) as Parameter4,        
 isnull(max(case when B.TypeCodeParameterId =5 then B.VariationRate else null end),0) as Parameter5,        
 isnull(max(case when B.TypeCodeParameterId =6 then B.VariationRate else null end),0) as Parameter6,        
 isnull(max(case when B.TypeCodeParameterId =7 then B.VariationRate else null end),0) as Parameter7,        
 isnull(max(case when B.TypeCodeParameterId =8 then B.VariationRate else null end),0) as Parameter8,        
 isnull(max(case when B.TypeCodeParameterId =9 then B.VariationRate else null end),0) as Parameter9,        
 isnull(max(case when B.TypeCodeParameterId =10 then B.VariationRate else null end),0) as Parameter10,        
 isnull(max(case when B.TypeCodeParameterId =11 then B.VariationRate else null end),0) as Parameter11,        
 isnull(max(case when B.TypeCodeParameterId =12 then B.VariationRate else null end),0) as Parameter12,        
 isnull(max(case when B.TypeCodeParameterId =13 then B.VariationRate else null end),0) as Parameter13         
 into #AssetTypeCodeVariationSep        
 FROM #variationlist_final a join EngAssetTypeCodeVariationRate b        
 on  A.AssetTypeCodeId = B.AssetTypeCodeId and b.active=1        
 group by a.Assetid,a.AssetTypeCodeId    
    
--select * from #AssetTypeCodeVariationSep

SELECT Variation.VariationId,        
   Variation.AssetId,  
   Asset.AssetNo,                
   Variation.PurchaseProjectCost as PurchaseCost,  
   Case when CAST(Asset.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)  Then Result.Parameter13             
     ELSE  0.00 END as [MaintenanceRateDW],        
        
    Case when CAST(Asset.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)  Then 0.00        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=279 then Parameter1        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=279 then Parameter2        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=279 then Parameter3        
        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=280 then Parameter4        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=280 then Parameter5        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=280 then Parameter6        
        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=281 then Parameter7        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=281 then Parameter8        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=281 then Parameter9        
        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=282 then Parameter10        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=282 then Parameter11        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=282 then Parameter12        
     ELSE        
     0.00        
     END as [MaintenanceRatePW],      
   Variation.PurchaseProjectCost as PurchaseCostRM,        
   Variation.VariationRaisedDate     
 INTO #VmVariationTxnResult        
  FROM VmVariationTxn         AS Variation   WITH(NOLOCK)
   INNER JOIN EngAsset        AS Asset    WITH(NOLOCK) ON Variation.AssetId     = Asset.AssetId   
   inner join #variationlist_final as test  ON Variation.AssetId     = test.AssetId  
   LEFT  JOIN #AssetTypeCodeVariationSep   AS  Result    WITH(NOLOCK) ON Asset.AssetId      =   Result.AssetId    

select * from #VmVariationTxnResult order by AssetId
 -- INSERT INTO VmVariationTxn   (      
 --            CustomerId,      
 --            FacilityId,      
 --            ServiceId,      
 --            SNFDocumentNo,      
 --            SnfDate,      
 --            AssetId,      
 --            AssetClassification,      
 --            VariationStatus,      
 --            PurchaseProjectCost,      
 --            VariationDate,      
 --            VariationDateUTC,      
 --            StartServiceDate,      
 --            StartServiceDateUTC,      
 --            ServiceStopDate,      
 --            ServiceStopDateUTC,      
 --            CommissioningDate,      
 --            CommissioningDateUTC,      
 --            WarrantyDurationMonth,      
 --            WarrantyStartDate,      
 --            WarrantyStartDateUTC,      
 --            WarrantyEndDate,      
 --            WarrantyEndDateUTC,      
 --            ClosingMonth,      
 --            ClosingYear,      
 --            VariationApprovedStatus,      
 --            OldUsage,      
 --            NewUsage,      
 --            UserLocation,      
 --Justification,      
 --            ApprovedDate,      
 --            ApprovedDateUTC,      
 --            ApprovedAmount,      
 --            Remarks,      
 --            AuthorizedStatus,      
 --            IsMonthClosed,      
 --            Period,      
 --            PaymentStartDate,      
 --            PaymentStartDateUTC,      
 --            PWPaymentStartDate,      
 --            PWPaymentStartDateUTC,      
 --            ProposedRateDW,      
 --            ProposedRatePW,      
 --            MonthlyProposedFeeDW,      
 --            MonthlyProposedFeePW,      
 --            CalculatedFeePW,      
 --            CalculatedFeeDW,      
 --            VariationRaisedDate,      
 --            VariationRaisedDateUTC,      
 --            AssetOldVariationData,      
 --            VariationWFStatus,      
 --            DoneBy,      
 --            DoneDate,      
 --            DoneDateUTC,      
 --            DoneRemarks,      
 --            IsVerify,      
 --            GovernmentAssetNo,      
 --            GovernmentAssetNoDescription,      
 --            PurchaseDate,      
 --            PurchaseDateUTC,      
 --            VariationPurchaseCost,      
 --            ContractCost,      
 --            ContractLpoNo,      
 --            CompanyAssetPraId,      
 --            CompanyAssetRegId,      
 --            WarrantyProvision,      
 --            UserAreaId,      
 --            AOId,      
 --            AODate,      
 --            AODateUTC,      
 --            JOHNId,      
 --            JOHNDate,      
 --            JOHNDateUTC,      
 --            HosDirectorId,      
 --            HosDirectorDate,      
 --            HosDirectorDateUTC,      
 --            AvailableCost,      
 --            MainSupplierCode,      
 --            MainSupplierName,      
 --            CreatedBy,      
 --            CreatedDate,      
 --            CreatedDateUTC,      
 --            ModifiedBy,      
 --            ModifiedDate,      
 --            ModifiedDateUTC  ,      
 --            ContractType       
 --            )      
  select       
     CustomerId,      
     FacilityId,      
     ServiceId,      
     SNFDocumentNo,      
     SnfDate,      
     AssetId,      
     AssetClassification,      
     VariationStatus,      
     PurchaseProjectCost,      
     getdate(),      
     getUTCdate(),      
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
     null,      
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
     NULL,      
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
     ContractType      
  from VmVariationTxn  where VariationId in (select VariationId from #variationlist_final)      
      
  SELECT @@ROWCOUNT AS varationAssetCount    
    
  IF @@ROWCOUNT > 0  
  UPDATE [MstLocationFacility] SET IsContractPeriodChanged = 0   
  where FacilityId= @pFacilityId  
      
/*      
      
 select year(PurchaseDate) from       
      
      
 SELECT Variation.VariationId, Asset.Assetid,Asset.AssetTypeCodeId,Asset.ContractType,TypeCodeVariation.VariationRate,TypeCodeVariation.TypeCodeParameterId,Variation.ProposedRateDW,Variation.ProposedRatePW      
 INTO #VmResult      
  FROM VmVariationTxn        AS Variation   WITH(NOLOCK)       
   INNER JOIN MstCustomer       AS Customer   WITH(NOLOCK) ON Variation.CustomerId     = Customer.CustomerId      
   INNER JOIN MstLocationFacility     AS Facility   WITH(NOLOCK) ON Variation.FacilityId     = Facility.FacilityId      
   INNER JOIN EngAsset        AS Asset    WITH(NOLOCK) ON Variation.AssetId     = Asset.AssetId      
   INNER JOIN EngAssetTypeCodeVariationRate  AS  TypeCodeVariation   WITH(NOLOCK)    ON Asset.AssetTypeCodeId    = TypeCodeVariation.AssetTypeCodeId      
   LEFT JOIN MstLocationUserArea     AS UserArea   WITH(NOLOCK) ON Asset.UserAreaId      = UserArea.UserAreaId      
   LEFT JOIN  FMLovMst        AS LovVariationStatus WITH(NOLOCK) ON Variation.VariationStatus   = LovVariationStatus.LovId      
   LEFT JOIN  FMLovMst        AS LovApproveStatus WITH(NOLOCK) ON Variation.VariationApprovedStatus = LovApproveStatus.LovId      
   LEFT JOIN  FMLovMst        AS LovWorkFlowStatus WITH(NOLOCK) ON Variation.VariationApprovedStatus = LovWorkFlowStatus.LovId      
   LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer     = Manufacturer.ManufacturerId      
   LEFT JOIN EngAssetStandardizationModel   AS Model  WITH(NOLOCK)  ON Asset.Model   = Model.ModelId      
 WHERE --AuthorizedStatus = 0    AND       
   --YEAR(Variation.VariationRaisedDate)   = @pYear       
   --AND  MONTH(Variation.VariationRaisedDate)  = @pMonth      
   --AND( ( @pVariationWFStatus = 232 and ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus  and ISNULL(Variation.VariationApprovedStatus,0)= 99)      
   -- or  ( @pVariationWFStatus = 0 and  ISNULL(Variation.VariationWFStatus,0) in (0, 232)  and   ISNULL(Variation.VariationApprovedStatus,0) in (0,100,229))      
   -- or (@pVariationWFStatus not in (0, 233)  and ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus  )      
   -- )      
   --AND       
   Variation.VariationWFStatus ! = 0      
   --AND (ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus OR ISNULL(Variation.VariationApprovedStatus,0) = 229)      
   --AND ISNULL(Variation.VariationApprovedStatus,0) = 229      
   --AND ((ISNULL(@pVariationWFStatus,'') = '' ) OR (ISNULL(@pVariationWFStatus,'') <> '' AND Variation.VariationWFStatus = @pVariationWFStatus ))      
   AND Variation.IsMonthClosed = 1      
   AND Variation.FacilityId = @pFacilityId      
      
   ;WITH Ordered as      
   (      
   select *,ROW_NUMBER() over(Partition by Assetid order by VariationId desc) as rownumber      
    from #VmResult       
   )      
   select * INTO #TotalAssetList from Ordered where rownumber=1      
      
         
         
    CREATE TABLE #AssetTypeCodeVariationSep(AssetId int,AssetTypeCodeId int,Parameter1 numeric(24,2),Parameter2 numeric(24,2),Parameter3 numeric(24,2)      
    ,Parameter4 numeric(24,2),Parameter5 numeric(24,2),Parameter6 numeric(24,2)      
    ,Parameter7 numeric(24,2),Parameter8 numeric(24,2),Parameter9 numeric(24,2)      
    ,Parameter10 numeric(24,2),Parameter11 numeric(24,2),Parameter12 numeric(24,2)      
    ,Parameter13 numeric(24,2))      
      
      
     INSERT INTO #AssetTypeCodeVariationSep(AssetId,AssetTypeCodeId)      
     SELECT DISTINCT AssetId,AssetTypeCodeId FROM #TotalAssetList      
      
     UPDATE A SET A.Parameter1 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 279 AND B.TypeCodeParameterId =1      
      
     UPDATE A SET A.Parameter2 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 279 AND B.TypeCodeParameterId =2      
      
     UPDATE A SET A.Parameter3 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 279 AND B.TypeCodeParameterId =3      
      
     UPDATE A SET A.Parameter4 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 280 AND B.TypeCodeParameterId =4      
      
     UPDATE A SET A.Parameter5 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 280 AND B.TypeCodeParameterId =5      
      
     UPDATE A SET A.Parameter6 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 280 AND B.TypeCodeParameterId =6      
      
     UPDATE A SET A.Parameter7 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 281 AND B.TypeCodeParameterId =7      
      
     UPDATE A SET A.Parameter8 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 281 AND B.TypeCodeParameterId =8      
      
     UPDATE A SET A.Parameter9 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 281 AND B.TypeCodeParameterId =9      
      
     UPDATE A SET A.Parameter10 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 282 AND B.TypeCodeParameterId =10      
      
     UPDATE A SET A.Parameter11 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 282 AND B.TypeCodeParameterId =11      
      
     UPDATE A SET A.Parameter12 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.ContractType = 282 AND B.TypeCodeParameterId =12      
      
     UPDATE A SET A.Parameter13 = B.VariationRate FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetId = B.AssetId AND A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE B.TypeCodeParameterId =13      
         
     ALTER TABLE #TotalAssetList ADD UpdatedVaritionRateDW numeric(24,2)      
     ALTER TABLE #TotalAssetList ADD UpdatedVaritionRatePW numeric(24,2)      
     ALTER TABLE #TotalAssetList ADD AssetAge int      
      
     UPDATE A SET A.AssetAge = DATEDIFF(YY,B.CommissioningDate,GETDATE()) from #TotalAssetList A INNER JOIN EngAsset B ON A.AssetId = B.AssetId      
      
     select * from #TotalAssetList order by AssetId      
           
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter1 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 279 AND AssetAge<=5      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter2 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 279 AND AssetAge BETWEEN 5 AND 10      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter3 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 279 AND AssetAge > 10      
     -----------------------------------------------------------      
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter4 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 280 AND AssetAge<=5      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter5 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 280 AND AssetAge BETWEEN 5 AND 10      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter6 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 280 AND AssetAge > 10      
      
     -----------------------------------------------------------      
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter7 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 281 AND AssetAge<=5      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter8 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 281 AND AssetAge BETWEEN 5 AND 10      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter9 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 281 AND AssetAge > 10      
      
     -----------------------------------------------------------      
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter10 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 282 AND AssetAge<=5      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter11 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 282 AND AssetAge BETWEEN 5 AND 10      
           
     UPDATE B SET B.UpdatedVaritionRatePW = A.Parameter12 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
     WHERE ContractType = 282 AND AssetAge > 10      
      
     -----------------------------------------------------------      
     UPDATE B SET B.UpdatedVaritionRateDW = A.Parameter13 FROM #AssetTypeCodeVariationSep A INNER JOIN #TotalAssetList B ON A.AssetTypeCodeId = B.AssetTypeCodeId      
      
      
      
     select * from #TotalAssetList WHERE ((ProposedRateDW <> UpdatedVaritionRateDW) OR (ProposedRatePW<>UpdatedVaritionRatePW))      
      
     select * INTO #FinalResult from #TotalAssetList WHERE ((ISNULL(ProposedRateDW,0) <> ISNULL(UpdatedVaritionRateDW,0)) OR (ISNULL(ProposedRatePW,0)<>ISNULL(UpdatedVaritionRatePW,0)))      
      
     UPDATE VmVariationTxn set VariationWFStatus = 0 where VariationId IN( SELECT VariationId FROM #FinalResult)      
      
      
     update MstLocationFacility      
     set      
        IsContractPeriodChanged = 0       
     where FacilityId= @pFacilityId      
      
     select @pFacilityId as FacilityId      
*/        
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
