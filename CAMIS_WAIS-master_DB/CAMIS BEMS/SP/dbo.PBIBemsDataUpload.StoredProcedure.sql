USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PBIBemsDataUpload]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC PBIBemsDataUpload  


  
CREATE PROCEDURE [dbo].[PBIBemsDataUpload]  
AS  
  
BEGIN  
  
  
/*Can Change the Logic To Incremental Load nee to get the logic on which we can implement the same*/  
  
  
IF OBJECT_ID('tempdb.dbo.#TempResult', 'U') IS NOT NULL  
DROP TABLE #TempResult;  
  
IF OBJECT_ID('tempdb.dbo.#TempResult1', 'U') IS NOT NULL  
DROP TABLE #TempResult1;  
  
IF OBJECT_ID('dbo.PBIBemsData', 'U') IS NOT NULL  
DROP TABLE PBIBemsData;  
  
  
SELECT    
        A.AssetId  
    ,B.AssetClassificationDescription  
    ,A.AssetDescription  
    ,B.AssetClassificationCode  
    ,A.AssetClassification  
    ,C.WorkOrderId  
    ,ISNULL(A.CustomerId,157) AS CustomerId  
    ,ISNULL([FACILITY ID],144) AS FacilityId  
    ,ISNULL(HH.USERID,0) AS UserID  
    ,ISNULL([USER NAME],'Undefined') AS UserName  
    ,ISNULL([FACILITY NAME],'HTA') AS FacilityName  
       ,C.WorkOrderStatus  
    ,C.MaintenanceWorkType  
    ,C.TypeOfWorkOrder  
       ,D.[NAME] AS WorkOrderStatusName  
       ,E.FieldValue AS FieldValue   
    ,K.FieldValue AS WorkOrderCategory  
    ,A.PurchaseCostRM  
       ,ISNULL(PartsCost,0) AS  PartsCost  
       ,ISNULL(ContractorCost,0) AS ContractorCost  
       ,ISNULL(VendorCost,0) AS VendorCost  
       ,ISNULL(RepairHours,0) AS RepairHours  
       ,LabourCostPerHour AS LabourCostPerHour  
       ,ISNULL(ABS(RepairHours),0) * LabourCostPerHour AS LabourCost   
    ,ISNULL(PartsCost,0)+ISNULL(ContractorCost,0)+ISNULL(VendorCost,0)+(ISNULL(ABS(RepairHours),0) * LabourCostPerHour) AS MaintenanceCost  
  
    --------------ASSET QUERY -------------  
    ,DATEDIFF(YEAR,A.PurchaseDate,GETDATE()) AS AgeDifference  
    ,CASE WHEN DATEDIFF(YEAR,A.PurchaseDate,GETDATE())>=0 AND DATEDIFF(YEAR,A.PurchaseDate,GETDATE()) <=5 THEN '0-5 Years'  
          WHEN DATEDIFF(YEAR,A.PurchaseDate,GETDATE())>=6 AND DATEDIFF(YEAR,A.PurchaseDate,GETDATE()) <=10 THEN '6-10 Years'  
    WHEN DATEDIFF(YEAR,A.PurchaseDate,GETDATE())> 10  THEN '>10 Years'  
    END AS AgeDiffBucket  
      
    ---WARRANTY  
      
    ,CASE WHEN GETDATE() < WarrantyEndDate THEN  'InWaranty' ELSE 'Out of Warranty'  END AS WarrantyStatus     
  
    ,A.PurchaseDate  
    ,A.WarrantyStartDate  
    ,A.WarrantyEndDate  
  
    ------------ASSET QUERY END---------------------------------------------------  
  
  
    ,G.CreatedDate  
    ,CONVERT(DATETIME,CAST(C.MaintenanceWorkDateTime AS DATE)) AS MaintenanceWorkDateTime  
    ,G.StartDateTime AS StartDateTime  
    ,G.EndDateTime   AS EndDateTime  
    ,C.TargetDateTime AS TargetDateTime  
       ,L.RescheduleDate  
    ,CASE WHEN  G.EndDateTime<=ISNULL(L.RescheduleDate,C.TargetDateTime)   
          THEN 'Total WO Within Target' ELSE 'Total WO Out of Target' END AS PPMCompletionStatus   
  
    --ADD +1 IF REQUIRED AS DATE PART IS COUNT THAT PARTICULAR DAY ALSO  
  
    -----TOTAL REPAIR TIME---------------------------  
    ,CASE WHEN (ISNULL(G.StartDateTime,'')='' OR ISNULL(G.EndDateTime,'')='') THEN 0   
          ELSE DATEDIFF(DAY,G.StartDateTime,G.EndDateTime)+1 END AS NumberOfDaysReqd  
       ,CASE WHEN (ISNULL(G.StartDateTime,'')='' OR ISNULL(G.EndDateTime,'')='') THEN 0   
          ELSE DATEPART(HOUR,G.EndDateTime - G.StartDateTime) END AS NumberOfhoursReqd  
       ,CASE WHEN (ISNULL(G.StartDateTime,'')='' OR ISNULL(G.EndDateTime,'')='') THEN 0   
          ELSE DATEPART(MINUTE,G.EndDateTime - G.StartDateTime)END AS NumberOfMintReqd  
       
  ---TURN AROUND TIME  
  ,CASE WHEN (ISNULL(C.MaintenanceWorkDateTime,'')='' OR ISNULL(G.EndDateTime,'')='') THEN 0   
          ELSE DATEDIFF(DAY,C.MaintenanceWorkDateTime,G.EndDateTime)+1 END AS DownTimeDays  
       
  ---AGEING  
  ,CASE WHEN (ISNULL(G.CreatedDate,'')='' OR ISNULL(G.EndDateTime,'')='') THEN 0   
          ELSE DATEDIFF(DAY,C.MaintenanceWorkDateTime,G.CreatedDate)+1 END AS AgeingDays  
--     -LICENSING  
  ,H.LicenseId  
  ,I.LicenseNo  
  ,I.ExpireDate   
  
  ,CASE WHEN GETDATE() > ExpireDate  THEN 'License Expired'  
      WHEN (CASE WHEN GETDATE() < ExpireDate THEN DATEDIFF(DAY,ExpireDate,GETDATE()) END) < 30 THEN 'Less than a month'    
   WHEN (CASE WHEN GETDATE() < ExpireDate THEN DATEDIFF(DAY,ExpireDate,GETDATE()) END) >=30   
   AND  (CASE WHEN GETDATE() < ExpireDate THEN DATEDIFF(DAY,ExpireDate,GETDATE()) END) <=90 THEN '1 -3 Months'    
   WHEN (CASE WHEN GETDATE() < ExpireDate THEN DATEDIFF(DAY,ExpireDate,GETDATE()) END) >90 THEN 'More than 3 months'  
   END AS LicenseExpireStatus   
  
   ---------CONTRACT EXPIRE DATE  
   ,J.ContractId  
   ,J.ContractStartDate  
   ,J.ContractEndDate  
      ,CASE WHEN GETDATE() > ContractEndDate  THEN 'Contract Expired'  
      WHEN (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) < 30 THEN 'Less than a month'    
   WHEN (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) >=30   
   AND  (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) <=90 THEN '1 -3 Months'    
   WHEN (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) >90 THEN 'More than 3 months'  
   END AS ContractExpireStatus   
  
  
  
  
   ,MONTH(C.MaintenanceWorkDateTime) AS MonthNo  
   ,CASE WHEN MONTH(C.MaintenanceWorkDateTime)=1   
         THEN 'Jan'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=2   
         THEN 'Feb'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=3   
         THEN 'Mar'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=4   
         THEN 'Apr'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=5   
         THEN 'May'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=6   
         THEN 'Jun'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=7   
         THEN 'Jul'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=8   
         THEN 'Aug'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=9   
         THEN 'Sep'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=10   
         THEN 'Oct'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=11   
         THEN 'Nov'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
   WHEN MONTH(C.MaintenanceWorkDateTime)=12   
         THEN 'Dec'+'-'+RIGHT(YEAR(C.MaintenanceWorkDateTime),2)  
  END AS [MonthName]  
   ,YEAR(C.MaintenanceWorkDateTime) AS [Year]  
   ,CASE WHEN TypeOfWorkOrder IN ( 270,271,272,273,274) THEN 'UnSchedule'   
         WHEN TypeOfWorkOrder IN  (34,35,36,83,84,85,198,343) THEN 'Schedule'  
   END AS WorkOrderType  
     ,ROW_NUMBER()OVER(PARTITION BY A.ASSETID ORDER BY A.ASSETID) AS RN  
   -- ,DATEPART(HOUR,G.EndDateTime - G.StartDateTime) AS NumberOfhoursReqd  
   -- ,DATEPART(MINUTE,G.EndDateTime - G.StartDateTime) AS NumberOfMintReqd  
   -- ,A.CreatedDate AS AseetCreatedDate  
   -- ,C.CreatedDate AS WorkOrderCreatedDate  
  
--       ,COUNT(*) AS [Count]      
      
  
--    ,CASE   
INTO #TempResult   
FROM EngAsset (NOLOCK) A    
LEFT OUTER JOIN EngAssetClassification (NOLOCK) B   
ON A.AssetClassification = B.AssetClassificationId    
LEFT OUTER JOIN EngMaintenanceWorkOrderTxn (NOLOCK) C  
ON A.AssetId = C.AssetId  
LEFT OUTER JOIN (SELECT 192 AS [ID],'Open' AS [NAME]    
UNION ALL  
SELECT 193 AS [ID],'Work In Progress' AS [NAME]    
UNION ALL  
SELECT 194 AS [ID],'Completed' AS [NAME]    
UNION ALL  
SELECT 195 AS [ID],'Closed' AS [NAME]    
UNION ALL  
SELECT 196 AS [ID],'Cancelled' AS [NAME]    
UNION ALL  
SELECT 197 AS [ID],'Not Done & Closed' AS [NAME]   
UNION ALL
SELECT 385 AS [ID],'Resassign' AS [NAME]   

) D  
ON C.WorkOrderStatus = D.ID   
LEFT OUTER JOIN FMLovMst (NOLOCK)E  
ON C.WorkOrderPriority=E.LovId  
LEFT OUTER JOIN FMLovMst (NOLOCK) K  
ON C.TypeOfWorkOrder=K.LovId  
  
--OR C.TypeOfWorkOrder=E.LovId  
LEFT OUTER JOIN EngMwoCompletionInfoTxn G  
ON C.WorkOrderId=G.WorkOrderId  
LEFT OUTER JOIN   
(  
SELECT U.[UserRegistrationId] as USERID,  
              U.[StaffName] as   [USER NAME],  
              U.[CustomerId] as [CUSTOMER ID],  
              MstCustomer.CustomerName as [CUSTOMER NAME],  
              U.[FacilityId] as [FACILITY ID],  
              MstLocationFacility.FacilityName as[FACILITY NAME]  
     ,ISNULL(LabourCostPerHour,0) AS LabourCostPerHour  
FROM UMUserRegistration as U  
LEFT OUTER JOIN MstCustomer on U.[CustomerId]=MstCustomer.[CustomerId]  
LEFT OUTER JOIN MstLocationFacility on u.[FacilityId]= MstLocationFacility.[FacilityId]  
)HH  
ON A.FacilityId=HH.[FACILITY ID]  
AND A.CustomerID=HH.[CUSTOMER ID]  
AND C.EngineerUserId=HH.[USERID]  --COMMENTED OUT AS THEY ARE ASSIGINING THE WORK ORDER MANUALLY TO THE ENGINEERS.
LEFT OUTER JOIN EngLicenseandCertificateTxnDet H  
ON A.AssetId=H.AssetId  
LEFT OUTER JOIN EngLicenseandCertificateTxn I  
ON H.LicenseId=I.LicenseId  
LEFT JOIN PBITBLContractCreation J  
ON A.AssetId=J.AssetId  
LEFT OUTER JOIN PBITBLRescheduleDate L  
ON C.ASSETID=L.ASSETID  
AND C.WORKORDERID=L.WORKORDERID  
  
  
WHERE AssetStatusLovId = 1  
---AND C.WorkOrderStatus IN (192,193,194,195,197)   
AND C.MaintenanceWorkCategory IN (188,187)  
 --AND FacilityId = @pFacilityId    
AND ISNULL(a.IsLoaner,0)=0    
AND A.AssetStatusLovId=1----1--FOR ACTIVE AND 273 UNSCHDULED  
--AND C.MaintenanceWorkType IN (273,270)  
AND C.WorkOrderId NOT IN ('1773','1774','1779','1812','1826','1869','1876','1887')  
-- ----SCHEDULE   
-- 270  
--,271  
--,272  
--,273  
--,274  
-------UNSCHEDULE  
--,34  
--,35  
--,36  
--,83  
--,84  
--,85  
--,198  
--,343  
AND TypeOfWorkOrder IN ( 270,271,272,273,274,34,35,36,83,84,85,198,343)  
AND WorkOrderStatus<>143  
  
-----------------------------*************** Master Data ******************-------------------------  
  
SELECT AssetId  
,AssetClassificationDescription  
,AssetDescription  
,AssetClassificationCode  
,AssetClassification  
,WorkOrderId  
,CustomerId  
,FacilityId  
,UserID  
,UserName  
,FacilityName  
,WorkOrderStatus  
,MaintenanceWorkType  
,TypeOfWorkOrder  
,WorkOrderStatusName  
,FieldValue  
,WorkOrderCategory  
,PurchaseCostRM  
,PartsCost  
,ContractorCost  
,VendorCost  
,RepairHours  
,LabourCostPerHour  
,LabourCost  
,MaintenanceCost  
,AgeDifference  
,AgeDiffBucket  
,WarrantyStatus  
,PurchaseDate  
,WarrantyStartDate  
,WarrantyEndDate  
,CreatedDate  
,MaintenanceWorkDateTime  
,StartDateTime  
,EndDateTime  
,TargetDateTime  
,RescheduleDate  
,PPMCompletionStatus  
,NumberOfDaysReqd  
,NumberOfhoursReqd  
,NumberOfMintReqd  
,DownTimeDays  
,AgeingDays  
,LicenseId  
,LicenseNo  
,ExpireDate  
,LicenseExpireStatus  
,ContractId  
,ContractStartDate  
,ContractEndDate  
,ContractExpireStatus  
,MonthNo  
,MonthName  
,Year  
,WorkOrderType  
,RN  
,CASE WHEN DownTimeDays <=7 THEN '<=7 Days' ELSE '>=7 Days' END AS PenaltyDays  
,CASE WHEN AgeingDays BETWEEN 0 AND 3 THEN '0-3 Days'  
      WHEN AgeingDays BETWEEN 4 AND 7 THEN '4-7 Days'  
   WHEN AgeingDays >=8 THEN '>8 Days'  
   --WHEN AgeingDays>10 THEN '>10 Days'  
   END AS AgeingBucket  
,CASE WHEN MaintenanceCost > PurchaseCostRM THEN 'Maintenance Cost More' ELSE 'Maintenance Cost Less' END AS AssetCostStatus  
,ROW_NUMBER()OVER(PARTITION BY CUSTOMERID,FACILITYID,WORKORDERID,ASSETID,NumberOfDaysReqd ORDER BY CUSTOMERID,FACILITYID) AS Distinct_RN  
,CASE WHEN RN >1 THEN 0.00 ELSE ISNULL(PurchaseCostRM,0) END AS PurchaseCost  
INTO #TempResult1  
FROM #TempResult  
  
----------------**********MASTER Data Ends Here********************-----------------------  
SELECT AssetId  
,AssetClassificationDescription  
,AssetDescription  
,AssetClassificationCode  
,AssetClassification  
,WorkOrderId  
,CustomerId  
,FacilityId  
,UserID  
,UserName  
,FacilityName  
,WorkOrderStatus  
,MaintenanceWorkType  
,TypeOfWorkOrder  
,WorkOrderStatusName  
,FieldValue  
,WorkOrderCategory  
,PurchaseCostRM  
,PartsCost  
,ContractorCost  
,VendorCost  
,RepairHours  
,LabourCostPerHour  
,LabourCost  
,MaintenanceCost  
,AgeDifference  
,AgeDiffBucket  
,WarrantyStatus  
,PurchaseDate  
,WarrantyStartDate  
,WarrantyEndDate  
,CreatedDate  
,MaintenanceWorkDateTime  
,StartDateTime  
,EndDateTime  
,TargetDateTime  
,RescheduleDate  
,PPMCompletionStatus  
,NumberOfDaysReqd  
,NumberOfhoursReqd  
,NumberOfMintReqd  
,DownTimeDays  
,AgeingDays  
,LicenseId  
,LicenseNo  
,ExpireDate  
,LicenseExpireStatus  
,ContractId  
,ContractStartDate  
,ContractEndDate  
,ContractExpireStatus  
,MonthNo  
,MonthName  
,Year  
,WorkOrderType  
,RN  
,PenaltyDays  
,AgeingBucket  
,AssetCostStatus  
,Distinct_RN  
,PurchaseCost  
,CASE WHEN AgeingBucket='0-3 Days' THEN 1  
      WHEN AgeingBucket='4-7 Days' THEN 2  
   WHEN AgeingBucket='>8 Days' THEN 3  
   END AS AgeingBucketOrder   
  
,CASE WHEN AgeDiffBucket='0-5 Years' THEN 1  
      WHEN AgeDiffBucket='6-10 Years' THEN 2  
   WHEN AgeDiffBucket='>10 Years' THEN 3  
   END AS AgeDiffBucketOrder  
,CASE WHEN LicenseExpireStatus='Less than a month' THEN 1  
      WHEN LicenseExpireStatus='1 -3 Months' THEN 2  
   WHEN LicenseExpireStatus='More than 3 months' THEN 3  
   WHEN LicenseExpireStatus='License Expired' THEN 4  
   END LicenseExpireStatusOrder  
,CASE WHEN ContractExpireStatus='Less than a month' THEN 1  
      WHEN ContractExpireStatus='1 -3 Months' THEN 2  
   WHEN ContractExpireStatus='More than 3 months' THEN 3  
   WHEN ContractExpireStatus='Contract Expired' THEN 4  
   END ContractExpireStatusOrder  
  
INTO PBIBemsData  
FROM #TempResult1  
WHERE Distinct_RN=1  
  
END
GO
