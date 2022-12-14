USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoCompletionInfoTxn_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext [UspFM_EngMwoCompletionInfoTxn_GetById]                ----Alter in BEMS AND FEMS
--sp_helptext [uspFM_EngMaintenanceWorkOrderTxn_Export]              ----Alter in BEMS AND FEMS
--sp_helptext [V_EngMaintenanceWorkOrderTxn_Export]                        --------Alter in BEMS AND FEMS



          
/*========================================================================================================          
Application Name : UETrack-BEMS                        
Version    : 1.0          
Procedure Name  : UspFM_EngMwoCompletionInfoTxn_GetById          
Description   : To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id          
Authors    : Balaji M S          
Date    : 30-Mar-2018          
-----------------------------------------------------------------------------------------------------------          
          
Unit Test:          
EXEC [UspFM_EngMwoCompletionInfoTxn_GetById] @pWorkOrderId=1914,@pPageIndex=1,@pPageSize=5,@pUserId=1          
          
-----------------------------------------------------------------------------------------------------------          
Version History           
-----:------------:---------------------------------------------------------------------------------------          
Init : Date       : Details          
========================================================================================================*/          
CREATE PROCEDURE  [dbo].[UspFM_EngMwoCompletionInfoTxn_GetById]                                     
  @pUserId   INT = NULL,          
  @pWorkOrderId  INT,          
  @pPageIndex  INT,          
  @pPageSize  INT           
          
AS                                                        
          
BEGIN TRY          
          
          
          
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;          
          
 DECLARE @TotalRecords INT          
 DECLARE @pTotalPage  NUMERIC(24,2)          
          
 IF(ISNULL(@pWorkOrderId,0) = 0) RETURN          
          
 SELECT @TotalRecords = COUNT(*)          
 FROM EngMwoCompletionInfoTxn      AS MwoCompletion          
   INNER JOIN EngMwoCompletionInfoTxnDet  AS MwoCompletionDet   WITH(NOLOCK) ON MwoCompletion.CompletionInfoId  = MwoCompletionDet.CompletionInfoId          
   LEFT  JOIN  UMUserRegistration    AS UserReg     WITH(NOLOCK) ON MwoCompletionDet.UserId    = UserReg.UserRegistrationId          
   LEFT  JOIN  EngAssetPPMCheckList   AS StandardTaskDetId  WITH(NOLOCK) ON MwoCompletionDet.StandardTaskDetId = StandardTaskDetId.PPMCheckListId          
   INNER JOIN EngMaintenanceWorkOrderTxn  AS MaintenanceWorkOrder  WITH(NOLOCK) ON MwoCompletion.WorkOrderId   = MaintenanceWorkOrder.WorkOrderId          
   INNER JOIN  MstService      AS ServiceKey    WITH(NOLOCK) ON MwoCompletion.ServiceId    = ServiceKey.ServiceId          
   LEFT  JOIN  UMUserRegistration    AS CompletedBy    WITH(NOLOCK) ON MwoCompletion.CompletedBy   = CompletedBy.UserRegistrationId          
   LEFT  JOIN  UMUserRegistration    AS AcceptedBy    WITH(NOLOCK) ON MwoCompletion.AcceptedBy    = AcceptedBy.UserRegistrationId          
   LEFT  JOIN  UserDesignation     AS CDesignation    WITH(NOLOCK) ON CompletedBy.UserDesignationId  = CDesignation.UserDesignationId          
   LEFT  JOIN  UserDesignation     AS ADesignation    WITH(NOLOCK) ON AcceptedBy.UserDesignationId   = ADesignation.UserDesignationId          
   LEFT  JOIN  MstContractorandVendor   AS ContractorandVendor  WITH(NOLOCK) ON MwoCompletion.ContractorId   = ContractorandVendor.ContractorId          
             
   LEFT  JOIN  FMLovMst      AS CauseCode    WITH(NOLOCK) ON MwoCompletion.CauseCode    = CauseCode.LovId          
   LEFT  JOIN  FMLovMst      AS QCCode     WITH(NOLOCK) ON MwoCompletion.QCCode     = QCCode.LovId          
   LEFT  JOIN  FMLovMst      AS ResourceType    WITH(NOLOCK) ON MwoCompletion.ResourceType   = ResourceType.LovId          
   LEFT  JOIN  FMLovMst      AS ProcessStatus   WITH(NOLOCK) ON MwoCompletion.ProcessStatus   = ProcessStatus.LovId       
         
   LEFT  JOIN  FMLovMst      AS ProcessStatusReason  WITH(NOLOCK) ON MwoCompletion.ProcessStatusReason = ProcessStatusReason.LovId          
  -- Add for Print 21/8/2020      
   LEFT  JOIN MstQAPQualityCauseDet AS CauseCodeFieldVaule    WITH(NOLOCK) ON MwoCompletion.CauseCode    = CauseCodeFieldVaule.QualityCauseDetId      
   --      
   LEFT  JOIN  FMLovMst      AS WorkOrderStatus   WITH(NOLOCK) ON MaintenanceWorkOrder.WorkOrderStatus = WorkOrderStatus.LovId          
   OUTER APPLY (select top 1     Portering.PorteringId,Portering.PorteringNo,engasset.AssetNo from   PorteringTransaction   AS Portering WITH(NOLOCK)             
   LEFT  JOIN  EngAsset      AS engasset     WITH(NOLOCK) ON engasset.AssetId = Portering.AssetId            
   where  Portering.WorkOrderId = MaintenanceWorkOrder.WorkOrderId ) as  Porter          
   OUTER APPLY ( SELECT ComDet.CompletionInfoId, SUM(ComDet.LabourCost) AS LabourCost          
       FROM EngMwoCompletionInfoTxnDet AS ComDet          
       WHERE MwoCompletion.CompletionInfoId = ComDet.CompletionInfoId          
       GROUP BY ComDet.CompletionInfoId          
      ) AS LabourCostInfo          
 WHERE MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId           
          
          
 SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))          
 SET @pTotalPage = CEILING(@pTotalPage)          
          
           
          
    SELECT MwoCompletion.CompletionInfoId      AS CompletionInfoId,          
   MwoCompletion.CustomerId       AS CustomerId,          
   MwoCompletion.FacilityId       AS FacilityId,          
   MwoCompletion.ServiceId        AS ServiceId,          
   ServiceKey.ServiceKey        AS ServiceKeyValue,          
   MwoCompletion.WorkOrderId       AS WorkOrderId,          
   MaintenanceWorkOrder.MaintenanceWorkNo    AS MaintenanceWorkNo,          
   MaintenanceWorkOrder.MaintenanceWorkDateTime  AS MaintenanceWorkDateTime,          
   MaintenanceWorkOrder.TargetDateTime     AS TargetDateTime,          
   MwoCompletion.RepairDetails       AS RepairDetails,          
   MwoCompletion.PPMAgreedDate       AS PPMAgreedDate,          
   MwoCompletion.PPMAgreedDateUTC      AS PPMAgreedDateUTC,          
   (select min (StartDateTime) from  EngMwoCompletionInfoTxnDet  where CompletionInfoId=MwoCompletionDet.CompletionInfoId) as StartDateTime,          
   --MwoCompletion.StartDateTime       AS StartDateTime,          
   MwoCompletion.StartDateTimeUTC      AS StartDateTimeUTC,          
   (select max (EndDateTime) from  EngMwoCompletionInfoTxnDet  where CompletionInfoId=MwoCompletionDet.CompletionInfoId) as EndDateTime,          
   --MwoCompletion.EndDateTime       AS EndDateTime,          
   MwoCompletion.EndDateTimeUTC      AS EndDateTimeUTC,          
   MwoCompletion.HandoverDateTime      AS HandoverDateTime,          
   MwoCompletion.HandoverDateTimeUTC     AS HandoverDateTimeUTC,          
   MwoCompletion.CompletedBy       AS CompletedBy,          
   CompletedBy.StaffName        AS CompletedByValue,          
   CDesignation.Designation       AS CompletedByDesignation,          
   MwoCompletion.AcceptedBy       AS AcceptedBy,          
   AcceptedBy.StaffName        AS AcceptedByName,          
   ADesignation.Designation       AS AcceptedByDesignation,          
   MwoCompletion.[Signature]       AS [Signature],          
   MwoCompletion.ServiceAvailability     AS ServiceAvailability,          
   MwoCompletion.LoanerProvision      AS LoanerProvision,          
   MwoCompletion.HandoverDelay       AS HandoverDelay,          
   MwoCompletion.DowntimeHoursMin      AS DowntimeHoursMin,          
   MwoCompletion.CauseCode        AS CauseCode,          
   CauseCode.FieldValue,   
   CauseCodeFieldVaule.Details AS CauseCodeValue,  
   MwoCompletion.QCCode        AS QCCode,          
   QCCode.FieldValue,    
   QCCodeFieldVaule.Description AS QCCodeValue,  
   MwoCompletion.ResourceType       AS ResourceType,          
   ResourceType.FieldValue        AS ResourceTypeValue,          
   MwoCompletion.LabourCost       AS LabourCost,          
   MwoCompletion.PartsCost        AS PartsCost,          
   MwoCompletion.ContractorCost      AS ContractorCost,          
   MwoCompletion.TotalCost        AS TotalCost,          
   MwoCompletion.ContractorId       AS ContractorId,          
   ContractorandVendor.SSMRegistrationCode    AS SSMRegistrationCode,          
   ContractorandVendor.ContractorName     AS ContractorName,          
   MwoCompletion.ContractorHours      AS ContractorHours,          
   MwoCompletion.PartsRequired       AS PartsRequired,          
   MwoCompletion.Approved        AS Approved,          
   MwoCompletion.AppType        AS AppType,          
   MwoCompletion.RepairHours       AS RepairHours,          
   MwoCompletion.ProcessStatus       AS ProcessStatus,          
   ProcessStatus.FieldValue       AS ProcessStatusValue,          
   MwoCompletion.ProcessStatusDate      AS ProcessStatusDate,          
   MwoCompletion.ProcessStatusReason     AS ProcessStatusReason,          
   ProcessStatusReason.FieldValue      AS ProcessStatusReasonValue,          
   MwoCompletion.VendorCost       AS VendorCost,          
   MwoCompletionDet.CompletionInfoDetId    AS CompletionInfoDetId,          
   MwoCompletionDet.CustomerId       AS CustomerId,          
   MwoCompletionDet.FacilityId       AS FacilityId,          
   MwoCompletionDet.ServiceId       AS ServiceId,          
   MwoCompletionDet.CompletionInfoId     AS CompletionInfoId,          
   MwoCompletionDet.UserId        AS StaffMasterId,          
   UserReg.StaffName         AS StaffMasterIdValue,          
   MwoCompletionDet.StandardTaskDetId     AS StandardTaskDetId,          
   StandardTaskDetId.TaskCode       AS TaskCode,          
   StandardTaskDetId.TaskDescription     AS TaskDescription,          
   MwoCompletionDet.StartDateTime      AS UdtStartDateTime,          
   MwoCompletionDet.StartDateTimeUTC     AS UdtStartDateTimeUTC,          
   MwoCompletionDet.EndDateTime      AS UdtEndDateTime,          
   MwoCompletionDet.EndDateTimeUTC      AS UdtEndDateTimeUTC,          
   MwoCompletionDet.RepairHours      AS RepairHours,          
   convert(varchar(5),DateDiff(s, MwoCompletionDet.StartDateTime, MwoCompletionDet.EndDateTime)/3600)+':'+convert(varchar(5),DateDiff(s, MwoCompletionDet.StartDateTime, MwoCompletionDet.EndDateTime)%3600/60) as RepairTiming,          
   @TotalRecords          AS TotalRecords,          
   @pTotalPage           AS TotalPageCalc,          
   MwoCompletion.Timestamp        AS Timestamp,          
   MwoCompletion.RunningHours       AS RunningHours,          
   MaintenanceWorkOrder.WorkOrderStatus    AS WorkOrderStatus,          
   WorkOrderStatus.FieldValue       AS WorkOrderStatusValue,          
   LabourCostInfo.LabourCost,          
   Porter.PorteringId,          
   Porter.PorteringNo,          
   Porter.AssetId as PorteringAssetId,          
   Porter.AssetNo as PorteringAssetNo,          
   MwoCompletion.DownTimeHours,             
   RES.RescheduleDate,          
   MwoCompletion.CustomerFeedback,          
   CustomerFeedback.FieldValue as CustomerFeedbackvalue,          
   MwoCompletion.WOSignature ,      
   -- Add for Print 21/8/2020      
   CauseCodeFieldVaule.QcCode as QCCodeFieldVaule      
          
 FROM EngMwoCompletionInfoTxn      AS MwoCompletion          
   INNER JOIN EngMwoCompletionInfoTxnDet  AS MwoCompletionDet   WITH(NOLOCK) ON MwoCompletion.CompletionInfoId  = MwoCompletionDet.CompletionInfoId          
   LEFT  JOIN  UMUserRegistration    AS UserReg     WITH(NOLOCK) ON MwoCompletionDet.UserId    = UserReg.UserRegistrationId          
   LEFT  JOIN  EngAssetPPMCheckList   AS StandardTaskDetId  WITH(NOLOCK) ON MwoCompletionDet.StandardTaskDetId = StandardTaskDetId.PPMCheckListId          
   INNER JOIN EngMaintenanceWorkOrderTxn  AS MaintenanceWorkOrder  WITH(NOLOCK) ON MwoCompletion.WorkOrderId   = MaintenanceWorkOrder.WorkOrderId          
   INNER JOIN  MstService      AS ServiceKey    WITH(NOLOCK) ON MwoCompletion.ServiceId    = ServiceKey.ServiceId          
   LEFT  JOIN  UMUserRegistration    AS CompletedBy    WITH(NOLOCK) ON MwoCompletion.CompletedBy   = CompletedBy.UserRegistrationId          
   LEFT  JOIN  UMUserRegistration    AS AcceptedBy  WITH(NOLOCK) ON MwoCompletion.AcceptedBy    = AcceptedBy.UserRegistrationId          
   LEFT  JOIN  UserDesignation     AS CDesignation    WITH(NOLOCK) ON CompletedBy.UserDesignationId  = CDesignation.UserDesignationId          
   LEFT  JOIN  UserDesignation     AS ADesignation    WITH(NOLOCK) ON AcceptedBy.UserDesignationId   = ADesignation.UserDesignationId          
   LEFT  JOIN  MstContractorandVendor   AS ContractorandVendor  WITH(NOLOCK) ON MwoCompletion.ContractorId   = ContractorandVendor.ContractorId             
   LEFT  JOIN  FMLovMst      AS CauseCode    WITH(NOLOCK) ON MwoCompletion.CauseCode    = CauseCode.LovId          
   LEFT  JOIN  FMLovMst      AS QCCode     WITH(NOLOCK) ON MwoCompletion.QCCode     = QCCode.LovId          
   LEFT  JOIN  FMLovMst      AS ResourceType    WITH(NOLOCK) ON MwoCompletion.ResourceType   = ResourceType.LovId          
   LEFT  JOIN  FMLovMst      AS ProcessStatus   WITH(NOLOCK) ON MwoCompletion.ProcessStatus   = ProcessStatus.LovId          
   LEFT  JOIN  FMLovMst      AS ProcessStatusReason  WITH(NOLOCK) ON MwoCompletion.ProcessStatusReason = ProcessStatusReason.LovId          
   LEFT  JOIN  FMLovMst      AS WorkOrderStatus   WITH(NOLOCK) ON MaintenanceWorkOrder.WorkOrderStatus = WorkOrderStatus.LovId          
   LEFT  JOIN  FMLovMst      AS CustomerFeedback   WITH(NOLOCK) ON MwoCompletion.CustomerFeedback = CustomerFeedback.LovId       
   -- Add for Print 21/8/2020  \\ using code side also    
   LEFT  JOIN MstQAPQualityCauseDet AS CauseCodeFieldVaule    WITH(NOLOCK) ON MwoCompletion.CauseCode    = CauseCodeFieldVaule.QualityCauseDetId      
   --     
    LEFT  JOIN MstQAPQualityCause AS QCCodeFieldVaule    WITH(NOLOCK) ON MwoCompletion.QCCode    = QCCodeFieldVaule.QualityCauseId  
   OUTER APPLY (select top 1 Portering.PorteringId,Portering.PorteringNo,engasset.AssetId,engasset.AssetNo           
      from   PorteringTransaction   AS Portering WITH(NOLOCK)             
      LEFT  JOIN  EngAsset      AS engasset     WITH(NOLOCK) ON engasset.AssetId = Portering.AssetId            
      WHERE  Portering.WorkOrderId = MaintenanceWorkOrder.WorkOrderId           
      order by PorteringId desc ) as  Porter          
   OUTER APPLY ( SELECT ComDet.CompletionInfoId, SUM(ComDet.LabourCost) AS LabourCost          
       FROM EngMwoCompletionInfoTxnDet AS ComDet          
       WHERE MwoCompletion.CompletionInfoId = ComDet.CompletionInfoId          
       GROUP BY ComDet.CompletionInfoId          
      ) AS LabourCostInfo          
   OUTER APPLY (SELECT TOP 1  RescheduleDate FROM EngMwoReschedulingTxn  AS ReschedulingTxn  WITH(NOLOCK) WHERE  MwoCompletion.WorkOrderId   = ReschedulingTxn.WorkOrderId          
   ORDER BY WorkOrderReschedulingId DESC ) RES          
 WHERE MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId           
 ORDER BY MaintenanceWorkOrder.ModifiedDate ASC          
 OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY          
          
          
          
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
