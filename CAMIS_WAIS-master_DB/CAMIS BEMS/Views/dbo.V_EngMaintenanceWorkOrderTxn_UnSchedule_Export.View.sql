USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]                              
AS                              
--WITH CTE AS                 
--(                
--SELECT A.ManufacturerId,A.ModelId,A.AssetTypeCodeId,A.AssetTypeCode,A.TaskCode FROM EngAssetPPMCheckList A                
--)                
                
--SELECT * FROM CTE                 
                
                
                
 SELECT  Distinct                              
    MWO.CustomerId,                              
    Customer.CustomerName,                              
    MWO.FacilityId,                              
    Facility.FacilityName,                              
      -- TaskCode,                       
    MWO.WorkOrderId,                              
    MWO.MaintenanceWorkNo,                              
 MaintenanceWorkDateTime AS MaintenanceWorkDateTimeNew,                       
    CAST(MWO.MaintenanceWorkDateTime AS DATE)AS MaintenanceWorkDateTime,                              
    Asset.AssetNo,                              
    Asset.AssetDescription,                              
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,                              
    LovTypeOfPlanner.FieldValue AS WorkOrderCategoryGrid,                              
    WorkGroup.WorkGroupCode,                              
    MWO.TargetDateTime,                              
    LovPriority.FieldValue  AS WorkOrderPriority,                              
    LovPriority.FieldValue  AS WorkOrderPriorityGrid,                              
    LovMWOStatus.LovId   AS WorkOrderStatusId,                              
    LovMWOStatus.FieldValue  AS WorkOrderStatus,                              
    LovMWOStatus.FieldValue  AS WorkOrderStatusGrid,                              
    MWO.MaintenanceDetails,                              
    MWO.EngineerUserId,                              
    EngineerUserId.StaffName AS EngineerUserName,                              
    MWO.MaintenanceWorkType,                              
    MaintenanceWorkType.FieldValue AS MaintenanceWorkTypeValue,                              
    Model.Model,                              
    Manufacturer.Manufacturer,                              
    MWO.ModifiedDateUTC,                              
    SuppUserReg.UserRegistrationId,                              
    UserLocation.UserLocationId as UserLocationId,                              
    UserLocation.UserLocationCode as UserLocationCode,                              
    UserLocation.UserLocationName as UserLocationName,                              
    Assignee.UserRegistrationId as Assignee_UserRegistrationId,                              
    Assignee.StaffName as AssigneeName,                              
    DATEDIFF(DD,MWO.MaintenanceWorkDateTime,GETDATE()) CountingDays,                              
    AssesmentTxn.AssignedVendor  as AssignedVendorid,                              
    AssesmentTxn.ResponseDateTime as AssessmentResponsedate,                              
                              
  ----added later 28-05-2020                            
  EngMwoAssesmen.ResponseDateTime,EngMwoAssesmen.ResponseDuration,EngMWOHandOverHistor.HandoverDateTime as HandOverDate,EngAssetClass.AssetClassificationDescription,                            
 UserArea.UserAreaName,UserArea.UserAreaCode as Department,Req.StaffName AS RequesterName,Req.MobileNumber,req.PhoneNumber,Desig.Designation,                            
 EngMWOHandOverHistor.StartDateTime,EngMWOHandOverHistor.EndDateTime,MWO.MaintenanceDetails AS BreakDownDetails,AssesmentTxn.Justification AS ActionTaken,                            
Cause.Details AS FailureRootCause,RootCause.Description AS FailureSymptomDescription,EngMWOHandOverHistor.RepairDetails,Comp.StaffName AS VerifiedBy                             
                            
                             
                            
                            
 FROM  EngMaintenanceWorkOrderTxn AS MWO    WITH(NOLOCK)                              
    INNER JOIN MstCustomer     AS Customer   WITH(NOLOCK) ON MWO.CustomerId = Customer.CustomerId                              
    INNER JOIN MstLocationFacility   AS Facility   WITH(NOLOCK) ON MWO.FacilityId = Facility.FacilityId                              
    INNER JOIN EngAsset      AS Asset    WITH(NOLOCK) ON MWO.AssetId    = Asset.AssetId                              
    LEFT  JOIN MstLocationUserLocation  AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId  = UserLocation.UserLocationId                              
    INNER JOIN FMLovMst      AS LovTypeOfPlanner WITH(NOLOCK) ON MWO.TypeOfWorkOrder  = LovTypeOfPlanner.LovId                              
    LEFT JOIN EngAssetWorkGroup   AS WorkGroup   WITH(NOLOCK) ON Asset.WorkGroupId  = WorkGroup.WorkGroupId                              
    LEFT JOIN FMLovMst      AS LovPriority   WITH(NOLOCK) ON MWO.WorkOrderPriority  = LovPriority.LovId                              
    LEFT JOIN FMLovMst      AS LovMWOStatus  WITH(NOLOCK) ON MWO.WorkOrderStatus  = LovMWOStatus.LovId                                
    LEFT JOIN UMUserRegistration   AS EngineerUserId  WITH(NOLOCK) ON MWO.EngineerUserId  = EngineerUserId.UserRegistrationId                                
    LEFT JOIN FMLovMst      AS MaintenanceWorkType WITH(NOLOCK) ON MWO.MaintenanceWorkType  = MaintenanceWorkType.LovId                               
    LEFT JOIN EngAssetStandardizationModel AS Model    WITH(NOLOCK) ON Asset.Model  = Model.ModelId                           
    LEFT JOIN EngAssetStandardizationManufacturer  AS Manufacturer WITH(NOLOCK) ON Asset.Manufacturer  = Manufacturer.ManufacturerId                                
    LEFT  JOIN UMUserRegistration   AS Assignee   WITH(NOLOCK) ON MWO.AssignedUserId  = Assignee.UserRegistrationId                              
    OUTER APPLY (select ContractorId,AssetId from                              
       (select COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue                              
       from EngContractOutRegister COR                              
       inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId                               
       WHERE CORDet.AssetId=Asset.AssetId                              
       group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor                              
                              
    LEFT JOIN UMUserRegistration     AS SuppUserReg  WITH(NOLOCK) ON Contractor.ContractorId = SuppUserReg.ContractorId                              
    LEFT JOIN   EngMwoAssesmentTxn                  AS AssesmentTxn     WITH(NOLOCK)     ON MWO.WorkOrderId         =    AssesmentTxn.WorkOrderId                               
                                  
    LEFT JOIN  EngMwoAssesmentTxn AS EngMwoAssesmen WITH (NOLOCK) ON MWO.WorkOrderId = EngMwoAssesmen.WorkOrderId                              
                              
LEFT JOIN                              
EngMwoCompletionInfoTxn AS EngMWOHandOverHistor WITH (NOLOCK) ON MWO.WorkOrderId = EngMWOHandOverHistor.WorkOrderId                              
LEFT JOIN                              
EngAssetClassification AS EngAssetClass WITH (NOLOCK) ON Asset.AssetClassification = EngAssetClass.AssetClassificationId                                    
                               
 ---ADDED ON                             
 LEFT JOIN MstLocationUserArea AS UserArea WITH (NOLOCK) ON ASSET.UserAreaId=UserArea.UserAreaId                            
 LEFT JOIN UMUserRegistration AS Req WITH(NOLOCK) ON MWO.RequestorUserId=Req.UserRegistrationId                              
 LEFT OUTER JOIN UserDesignation AS Desig WITH(NOLOCK) ON REQ.UserDesignationId=Desig.UserDesignationId                             
   LEFT OUTER JOIN MstQAPQualityCauseDet AS Cause WITH(NOLOCK) ON Cause.QualityCauseDetId=EngMWOHandOverHistor.CauseCode                 
 LEFT OUTER JOIN MstQAPQualityCause AS RootCause WITH(NOLOCK) ON RootCause.QualityCauseId=EngMWOHandOverHistor.QCCode                             
  LEFT JOIN UMUserRegistration AS Comp WITH(NOLOCK) ON EngMWOHandOverHistor.AcceptedBy=Comp.UserRegistrationId                              
                    
 LEFT JOIN EngAssetPPMCheckList AS Taskcode WITH  (NOLOCK) ON Asset.AssetTypeCodeId =Taskcode.AssetTypeCodeId                    
 AND Asset.Model =Taskcode.ModelId                     
 AND Asset.Manufacturer = Taskcode.ManufacturerId                        
                            
  WHERE MWO.MaintenanceWorkCategory = 188                 
  --AND MaintenanceWorkNo='MWRWAC/19/000405'                
                
                  
                
  --SELECT COUNT(MaintenanceWorkNo),MaintenanceWorkNo FROM [V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]                
  --GROUP BY MaintenanceWorkNo                
  --HAVING COUNT(MaintenanceWorkNo) > 1 
GO
