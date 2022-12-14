USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERSummary_Rpt_L3]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1]     
Description   : Get the BER Analysis Report(Level1)    
Authors    : Ganesan S    
Date    : 13-June-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
exec [uspFM_BERApplicationTxn_BERSummary_Rpt_L3] @Service = 2,@From_Month='06',@From_Year= 2018,    
@To_Month= '07',@To_Year=2018 ,@Type_id=2,@MenuName = ''    
-----------------------------------------------------------------------------------------------------------    
exec [uspFM_BERApplicationTxn_BERSummary_Rpt_L3] @FacilityId = 1,  @From_Date = '01/01/2015', @To_Date= '01/01/2019', @BerNo = 'BER/PAN/201811/000004'  
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
CREATE  PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERSummary_Rpt_L3]                                      
(            
       @From_Date  VARCHAR(100) = '',        
          @To_Date   VARCHAR(100) = ''  ,     
          @FacilityId       int  ='',    
    @Level   INT  =''           
    ,@BerNo   Varchar(300)    
 )               
AS                                                  
BEGIN     
    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
BEGIN TRY    
      
    declare @pApplicationId int =262    
 declare @BER2Syor  nvarchar(50) = ''  
    
   set @pApplicationId = (select ApplicationId from BERApplicationTxn where BERno = @BerNo)    
   set @BER2Syor = (select BER2Syor from BERApplicationTxn where BERno = @BerNo)    
--select * from BERApplicationTxn    
     
      
  declare @ContractorCost decimal(30,2),@TotalCost decimal(30,2)    
   select @ContractorCost= isnull( sum(case when  B.ApplicationDate>=ContractEndDate then  ContractOutdet.ContractValue else    
           ( ContractOutdet.ContractValue/datediff(dd,ContractstartDate, ContractendDate)) *(datediff(dd,ContractstartDate, ContractendDate)-  datediff(dd,ApplicationDate,ContractEndDate))    
         end ),0)  from  EngContractOutRegisterDet  AS ContractOutdet     
 join  BERApplicationTxn B     on ContractOutdet.AssetId = b.AssetId    
 join  EngContractOutRegister  ContractOut on ContractOutdet.ContractId=ContractOut.ContractId    
 where   ApplicationId =@pApplicationId    
 and     ContractstartDate<= ApplicationDate      
     
    
    
  SELECT @TotalCost=ISNULL(SUM(PartReplacement.LabourCost),0) + ISNULL(SUM(PartReplacement.TotalPartsCost),0) +ISNULL(SUM(MwoCompletionInfo.VendorCost),0)     
 FROM BERApplicationTxn         AS BERApplication   WITH(NOLOCK)    
   INNER JOIN EngMaintenanceWorkOrderTxn    AS MaintenanceWorkOrder  WITH(NOLOCK)  ON BERApplication.AssetId      = MaintenanceWorkOrder.AssetId    
   left JOIN EngMwoCompletionInfoTxn     AS MwoCompletionInfo  WITH(NOLOCK)  ON MaintenanceWorkOrder.WorkOrderId    = MwoCompletionInfo.WorkOrderId    
   LEFT  JOIN EngMwoPartReplacementTxn     AS PartReplacement   WITH(NOLOCK)  ON MaintenanceWorkOrder.WorkOrderId    = PartReplacement.WorkOrderId    
 WHERE BERApplication.ApplicationId = @pApplicationId     
 and   year(MaintenanceWorkDateTime) = year(getdate())    
 select @TotalCost=isnull(@ContractorCost,0)+isnull(@TotalCost,0)    
     
    
    
SELECT DISTINCT  
   BERApplication.BERno        AS BERno,    
   format(cast(BERApplication.ApplicationDate as Date),'dd-MMM-yyyy') as ApplicationDate,  
   format(cast(BERApplication.ApprovedDate as Date),'dd-MMM-yyyy')        AS ApprovedDate,       
   Asset.AssetNo          AS AssetNo,    
   typecode.AssetTypeDescription      AS AssetDescription,    
   UserLocation.UserLocationCode,    
      UserLocation.UserLocationName,    
      Manufacturer.Manufacturer,    
   Model.Model,       
   Contractor.ContractorName as SupplierName,    
   Asset.PurchaseCostRM,    
   format(cast(Asset.PurchaseDate  as Date),'dd-MMM-yyyy') as PurchaseDate ,    
   @TotalCost           as PastMaintenanceCost,     
   BERApplication.RepairEstimate      AS EstimatedRepairCost,    
   Isnull(Berapplication.CannotRepair,0)    AS CannotRepair,    
    
       
   BERApplication.CurrentValue,    
   2 as EstimatedMaintenanceCost,  -- caluclation  totalcost + EstimatedRepairCost    
   BERApplication.EstDurUsgAfterRepair     AS EstDurUsgAfterRepair,    
   RequestorStaff.StaffName RequestorName,     
   RequestorStaffDes.Designation RequestorDesignation,    
       
   isnull(BERApplication.EstRepcostToExpensive,0)  AS BeyondEconomicRepair,    
   isnull(BERApplication.NotReliable,0)    AS NotReliable,    
   isnull(BERApplication.StatutoryRequirements,0)  AS StatutoryRequirements,    
   isnull(BERApplication.Obsolescence,0)    As Obsolescence,      
      BERApplication.BER1Remarks       AS BER1Remarks,    
      BERApplication.OtherObservations     AS OtherObservations,    
    
   ApplicationStaff.StaffName       AS ApplicantStaffName,    
   ApplicationStaffDes.Designation      AS ApplicantDesignation,    
   BERStatus.FieldValue        AS BERStatusValue,    
    
    
   --BER 2     
   Berapplication.CurrentRepairCost,    
   CAST(CAST((DATEDIFF(m, Asset.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +     
   CASE WHEN DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12 = 0 THEN '1'     
   ELSE CAST((ABS(DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12))     
   AS VARCHAR) END as NUMERIC(24,2))    AS AssetAge,    
   BERApplication.CurrentValue      As TotalRepairCost,     
        
       CASE WHEN ((CAST(CONVERT(char(8), GETDATE(), 112) AS INT) - CAST(CONVERT(char(8), COALESCE(Asset.PurchaseDate,CommissioningDate), 112) AS int)) / 10000 < Asset.ExpectedLifespan) THEN '99'    
   ELSE '100' END AS StillWithInLifeSpan,    
    
   '' as CurrentValueRemarks,     
   BERApplication.ValueAfterRepair      AS ValueAfterRepair,    
  
   BERApplication.BER2TechnicalCondition    AS BER2TechnicalCondition,    
   BERApplication.BER2RepairedWell      AS BER2RepairedWell,    
   BERApplication.BER2SafeReliable      AS BER2SafeReliable,    
   BERApplication.BER2EstimateLifeTime     AS BER2EstimateLifeTime,    
   --BERApplication.BER2Syor        AS BER2Syor,    
   REPLACE(REPLACE(REPLACE(REPLACE(BER2Syor, 1, 'Spare Parts not Available'), 2, ' Authorized Vendor not Available'),   
   3, ' The asset is beyond economical repair. However, it can be used and maintained until condemned'),   
   4, ' The asset must be decommissioned immediately due to safety reason and/or major breakdown') as BER2Syor,  
   BERApplication.BER2Remarks       AS BER2Remarks,    
   BERApplication.TBER2StillLifeSpan     AS TBER2StillLifeSpan,    
   BERApplication.BIL         AS BIL,    
       
   BERApplication.ParentApplicationId     AS ParentApplicationId,    
       
      
   BERApplication.JustificationForCertificates   AS JustificationForCertificates,    
   BERApplication.ApplicationDate      AS ApplicationDate,    
   BERApplication.RejectedBERReferenceId    AS RejectedBERReferenceId,    
   BERApplication.BER2TechnicalConditionOthers   AS BER2TechnicalConditionOthers,    
   BERApplication.BER2SafeReliableOthers    AS BER2SafeReliableOthers,    
   BERApplication.BER2EstimateLifeTimeOthers   AS BER2EstimateLifeTimeOthers,    
   BERApplication.BERStage        AS BERStage,    
   BERApplication.CircumstanceOthers     AS CircumstanceOthers,    
   BERApplication.ExaminationFirstResultOthers   AS ExaminationFirstResultOthers,    
   BERApplication.EstimatedRepairCost     AS EstimatedRepairCost--,    
       
   --Engineer.UserRegistrationId AS EngId,    
   --Engineer.Email AS EngEmail    
  
 FROM BERApplicationTxn         AS BERApplication  WITH(NOLOCK)    
   LEFT  JOIN  EngAsset        AS Asset    WITH(NOLOCK) ON BERApplication.AssetId    = Asset.AssetId    
  
  
   left join EngTestingandCommissioningTxnDet   AS  Test        WITH(NOLOCK) ON Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId        
   inner join  EngTestingandCommissioningTxn  as te      WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId    
   left join  MstContractorandVendor    as Contractor     WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId    
  
  
   inner join EngAssetTypeCode       as typecode    WITH(NOLOCK) ON Asset.AssetTypeCodeId    = typecode.AssetTypeCodeId    
  -- LEFT  JOIN  CRMRequest        AS Request    WITH(NOLOCK) ON BERApplication.CRMRequestId   = Request.CRMRequestId    
   LEFT  JOIN MstService        AS ServiceKey   WITH(NOLOCK) ON BERApplication.ServiceId    = ServiceKey.ServiceId    
   LEFT  JOIN UMUserRegistration      AS ApplicationStaff  WITH(NOLOCK) ON BERApplication.ApplicantUserId  = ApplicationStaff.UserRegistrationId    
   LEFT  JOIN UserDesignation       AS ApplicationStaffDes WITH(NOLOCK) ON ApplicationStaff.UserDesignationId = ApplicationStaffDes.UserDesignationId    
   LEFT  JOIN FMLovMst        AS BERStatus   WITH(NOLOCK) ON BERApplication.BERStatus    = BERStatus.LovId    
   LEFT  JOIN MstLocationUserLocation        AS UserLocation      WITH(NOLOCK)    ON Asset.UserLocationId         = UserLocation.UserLocationId    
   LEFT JOIN EngAssetStandardizationManufacturer  AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer     = Manufacturer.ManufacturerId    
   LEFT JOIN EngAssetStandardizationModel   AS Model    WITH(NOLOCK) ON Asset.Model       = Model.ModelId    
      LEFT  JOIN UMUserRegistration      AS RequestorStaff  WITH(NOLOCK) ON BERApplication.RequestorUserId  = RequestorStaff.UserRegistrationId    
   LEFT  JOIN UserDesignation       AS RequestorStaffDes WITH(NOLOCK) ON RequestorStaff.UserDesignationId  = RequestorStaffDes.UserDesignationId    
   --LEFT  JOIN UMUserRegistration      AS Engineer  WITH(NOLOCK) ON BERApplication.CreatedBy  = RequestorStaff.UserRegistrationId    
    
 WHERE BERApplication.ApplicationId = @pApplicationId     
 --ORDER BY BERApplication.ModifiedDate ASC    
    
--exec [uspFM_BERApplicationTxn_BERSummary_Rpt_L3] @FacilityId = 1,  @From_Date = '01/01/2015', @To_Date= '01/01/2019', @BerNo = 'BER/PAN/201811/000004'  
  
END TRY    
BEGIN CATCH    
    
insert into ErrorLog(Spname,ErrorMessage,createddate)    
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
SET NOCOUNT OFF    
    
    
END
GO
