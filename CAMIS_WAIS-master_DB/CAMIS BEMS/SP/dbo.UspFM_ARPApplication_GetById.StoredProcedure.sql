USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_ARPApplication_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : UspFM_ARPApplication_GetById  
Description   : To Get the data from table BERApplicationTxn using the Primary Key id  
Authors    : Srinivas Gangula 
Date    : 26-Nov-2019  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [UspFM_BERApplicationTxn_GetById] @pApplicationId=32 ,@pPageIndex=1,@pPageSize=5 
EXEC [UspFM_ARPApplication_GetById] @pApplicationId=32 ,@pPageIndex=1,@pPageSize=5 
 
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[UspFM_ARPApplication_GetById]                             
  --@pUserId   INT = NULL,  
  @pApplicationId   INT = NULL,  
  @pPageIndex  INT = NULL,  
  @pPageSize  INT = NULL   
  
AS                                                
  
BEGIN TRY  
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  

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
   
  
 DECLARE   @TotalRecords  INT  
 DECLARE   @pTotalPage  NUMERIC(24,2)  
 DECLARE   @pTotalPageCalc NUMERIC(24,2)  
  
 IF(ISNULL(@pApplicationId,0) = 0) RETURN  
  
 SELECT @TotalRecords = COUNT(*)  
 FROM BERApplicationTxn         AS BERApplication  WITH(NOLOCK)  
   LEFT  JOIN  EngAsset        AS Asset    WITH(NOLOCK) ON BERApplication.AssetId    = Asset.AssetId  
   inner join EngAssetTypeCode       as typecode    WITH(NOLOCK) ON Asset.AssetTypeCodeId    = typecode.AssetTypeCodeId  
  -- LEFT  JOIN  CRMRequest        AS Request    WITH(NOLOCK) ON BERApplication.CRMRequestId   = Request.CRMRequestId  
   LEFT  JOIN MstService        AS ServiceKey   WITH(NOLOCK) ON BERApplication.ServiceId    = ServiceKey.ServiceId  
   LEFT  JOIN UMUserRegistration      AS ApplicationStaff  WITH(NOLOCK) ON BERApplication.ApplicantUserId  = ApplicationStaff.UserRegistrationId  
   LEFT  JOIN UserDesignation       AS ApplicationStaffDes WITH(NOLOCK) ON ApplicationStaff.UserDesignationId = ApplicationStaffDes.UserDesignationId  
   LEFT  JOIN FMLovMst        AS BERStatus   WITH(NOLOCK) ON BERApplication.BERStatus    = BERStatus.LovId  
   LEFT  JOIN MstLocationUserLocation        AS UserLocation      WITH(NOLOCK)    ON Asset.UserLocationId  = UserLocation.UserLocationId  
   LEFT  JOIN MstLocationUserArea        AS Department      WITH(NOLOCK)    ON Asset.UserAreaid         = Department.UserAreaid 
   LEFT  JOIN EngARP_Details        AS Details      WITH(NOLOCK)    ON           Details.BERno= BERApplication.BERno
  --LEFT  JOIN EngARP_Proposal        AS Proposal      WITH(NOLOCK)    ON        Proposal.ARPID= Details.ARPID
   LEFT JOIN EngAssetStandardizationManufacturer  AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer     = Manufacturer.ManufacturerId  
   LEFT JOIN EngAssetStandardizationModel   AS Model    WITH(NOLOCK) ON Asset.Model       = Model.ModelId  
      LEFT  JOIN UMUserRegistration      AS RequestorStaff  WITH(NOLOCK) ON BERApplication.RequestorUserId  = RequestorStaff.UserRegistrationId  
   LEFT  JOIN UserDesignation       AS RequestorStaffDes WITH(NOLOCK) ON RequestorStaff.UserDesignationId  = RequestorStaffDes.UserDesignationId    
 WHERE BERApplication.ApplicationId = @pApplicationId   
  
  
   
 SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
 SET @pTotalPageCalc = CEILING(@pTotalPage)  
  
   SELECT BERApplication.ApplicationId      AS ApplicationId,  
   BERApplication.CustomerId       AS CustomerId,  
   BERApplication.FacilityId       AS FacilityId,  
   BERApplication.ServiceId       AS ServiceId,  
   BERApplication.BERno        AS BERno,  
   BERApplication.AssetId        AS AssetId,  
   Asset.AssetNo          AS AssetNo,  
   typecode.AssetTypeDescription        AS AssetDescription,  
   --Request.RequestNo         AS Request,  
     
   BERApplication.BERStatus       AS BERStatus,  
   BERStatus.FieldValue        AS BERStatusValue,  
   BERApplication.BER2Remarks       AS BER2Remarks,  
   BERApplication.BER1Remarks       AS BER1Remarks,  
   BERApplication.ApplicationDate      AS ApplicationDate,  
   @TotalRecords          AS TotalRecords,  
   BERApplication.Timestamp,  
   UserLocation.UserLocationCode, 
   UserLocation.UserLocationName,  
	  --Department.UserAreaName,
   Manufacturer.Manufacturer,  
   Contractor.ContractorName MainSupplier,  
   Asset.PurchaseCostRM,  
   Asset.PurchaseDate,  
   Model.Model,  
   BERApplication.GuId,  
   Asset.Item_Code,
   Asset.Asset_Name,
   BERApplication.CurrentValue,  
   Berapplication.CurrentRepairCost,  
   Engineer.UserRegistrationId AS EngId,  
   Engineer.Email AS EngEmail,  
   berapplication.ApplicantUserId RequestorId,   
   RequestorStaff.StaffName RequestorName,   
   RequestorStaffDes.Designation RequestorDesignation,  
  
   CAST(CAST((DATEDIFF(m, Asset.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +   
   CASE WHEN DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12 = 0 THEN '1'   
     ELSE CAST((ABS(DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12))   
   AS VARCHAR) END as NUMERIC(24,2))    AS AssetAge,  
   CASE WHEN ((CAST(CONVERT(char(8), GETDATE(), 112) AS INT) - CAST(CONVERT(char(8), COALESCE(Asset.PurchaseDate,CommissioningDate), 112) AS int)) / 10000 < Asset.ExpectedLifespan) THEN '99'  
   ELSE '100' END AS StillWithInLifeSpan,  
   @pTotalPageCalc          AS TotalPageCalc,  
   @TotalCost as  TotalCost  
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
   LEFT  JOIN UMUserRegistration      AS Engineer  WITH(NOLOCK) ON BERApplication.CreatedBy  = RequestorStaff.UserRegistrationId  
     
 WHERE BERApplication.ApplicationId = @pApplicationId   
 ORDER BY BERApplication.ModifiedDate ASC  
 OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY  
  
 SELECT RemarksHis.Remarks,  
   UserReg.StaffName EnteredBy,  
   RemarksHis.ModifiedDate UpdatedDate  
 FROM BERApplicationRemarksHistoryTxn AS RemarksHis  WITH(NOLOCK)  
   INNER JOIN UMUserRegistration  AS UserReg ON  RemarksHis.ModifiedBy = UserReg.UserRegistrationId  
 WHERE ApplicationId = @pApplicationId  
 ORDER BY RemarksHis.RemarksHistoryId desc  
  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH
GO
