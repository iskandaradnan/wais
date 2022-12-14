USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]                          
AS                          
                          
 SELECT  DISTINCT          
    MWO.MaintenanceWorkNo,     
    MWO.CustomerId,                          
    Customer.CustomerName,                          
    MWO.FacilityId,                          
    Facility.FacilityName,                          
    MWO.WorkOrderId,                  
  MaintenanceWorkDateTime AS MaintenanceWorkDateTimeNew,                    
    cast(MWO.MaintenanceWorkDateTime as date) AS MaintenanceWorkDateTime,                          
    Asset.AssetNo,                          
    Asset.AssetDescription,                   
 --Taskcode,                  
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
  EngMwoAssesmen.ResponseDateTime,EngMwoAssesmen.ResponseDuration,Comp.HandoverDateTime as HandOverDate,AssetClassification.AssetClassificationDescription as WorkGroup,                          
 UserArea.UserAreaName,UserArea.UserAreaCode as Department,Req.StaffName AS RequesterName,Req.MobileNumber,req.PhoneNumber,Desig.Designation,                          
 Comp.StartDateTime,Comp.EndDateTime,MWO.MaintenanceDetails AS BreakDownDetails,AssesmentTxn.Justification AS ActionTaken,                          
 Cause.Details AS FailureRootCause,RootCause.Description AS FailureSymptomDescription,comp.RepairDetails,UserComp.StaffName AS VerifiedBy                           
                          
                           
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
                              
    LEFT JOIN                          
EngMwoAssesmentTxn AS EngMwoAssesmen WITH (NOLOCK) ON MWO.WorkOrderId = EngMwoAssesmen.WorkOrderId                          
                          
LEFT JOIN                          
EngMWOHandOverHistoryTxn AS EngMWOHandOverHistor WITH (NOLOCK) ON MWO.WorkOrderId = EngMWOHandOverHistor.WorkOrderId                          
LEFT JOIN                          
EngAssetClassification AS EngAssetClass WITH (NOLOCK) ON Asset.AssetClassification = EngAssetClass.AssetClassificationId                                
                           
    ---ADDED ON                           
 LEFT JOIN MstLocationUserArea AS UserArea WITH (NOLOCK) ON ASSET.UserAreaId=UserArea.UserAreaId                          
 LEFT JOIN UMUserRegistration AS Req WITH(NOLOCK) ON MWO.RequestorUserId=Req.UserRegistrationId                            
 LEFT OUTER JOIN UserDesignation AS Desig WITH(NOLOCK) ON REQ.UserDesignationId=Desig.UserDesignationId                           
  LEFT OUTER JOIN EngMwoCompletionInfoTxn Comp  WITH(NOLOCK) ON MWO.WorkOrderId=Comp.WorkOrderId                        
   LEFT OUTER JOIN MstQAPQualityCauseDet AS Cause WITH(NOLOCK) ON Cause.QualityCauseDetId=comp.CauseCode                                 
 LEFT OUTER JOIN MstQAPQualityCause AS RootCause WITH(NOLOCK) ON RootCause.QualityCauseId=comp.QCCode                               
                           
    LEFT JOIN UMUserRegistration AS UserComp WITH(NOLOCK) ON comp.AcceptedBy=UserComp.UserRegistrationId                            
     LEFT JOIN EngAssetPPMCheckList AS Taskcode WITH  (NOLOCK) ON Asset.AssetTypeCodeId =Taskcode.AssetTypeCodeId                  
 AND Model.ModelId =Taskcode.ModelId                   
 AND Manufacturer.ManufacturerId = Taskcode.ManufacturerId                      
 LEFT  JOIN EngAssetClassification as AssetClassification  WITH(NOLOCK) ON MWO.WorkGroupType  = AssetClassification.AssetClassificationId                       
   WHERE MWO.MaintenanceWorkCategory = 188     
     
GO
