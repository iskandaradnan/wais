USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PBICostContributionData_Upload]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC PBICostContributionData_Upload  
  
CREATE PROCEDURE [dbo].[PBICostContributionData_Upload]  
AS  
BEGIN  
  
IF OBJECT_ID('dbo.PBICostContribution', 'U') IS NOT NULL  
DROP TABLE dbo.PBICostContribution;  
  
  
;WITH CTE AS  
(  
SELECT  A.AssetId  
       ,B.WorkOrderId  
       ,CAST(ISNULL(PartsCost,0.00) AS NUMERIC(18,2)) AS  PartsCost  
       ,CAST(ISNULL(ContractorCost,0.00)AS NUMERIC(18,2)) AS ContractorCost  
       ,CAST(ISNULL(VendorCost,0.00)AS NUMERIC(18,2)) AS VendorCost  
       --,ISNULL(RepairHours,0) AS RepairHours  
       --,LabourCostPerHour AS LabourCostPerHour  
       ,CAST(ISNULL((ISNULL(ABS(RepairHours),0.00) * LabourCostPerHour),0.00) AS NUMERIC(18,2)) AS LabourCost   
--    ,ISNULL(ISNULL(PartsCost,0)+ISNULL(ContractorCost,0)+ISNULL(VendorCost,0)+(ISNULL(ABS(RepairHours),0) * LabourCostPerHour),0.00) AS MaintenanceCost  
FROM EngAsset A  
LEFT OUTER JOIN EngMaintenanceWorkOrderTxn B  
ON A.AssetId=B.AssetId  
LEFT OUTER JOIN EngMwoCompletionInfoTxn C  
ON B.WorkOrderId=C.WorkOrderId  
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
AND B.EngineerUserId=HH.[USERID]  
)  
,CTE_COST AS  
(  
SELECT AssetId,WorkOrderId,'PartCost' AS CostContribution,PartsCost AS Cost FROM CTE   
UNION ALL   
SELECT AssetId,WorkOrderId,'ContractorCost' AS CostContribution,ContractorCost AS Cost FROM CTE   
UNION ALL  
SELECT AssetId,WorkOrderId,'VendorCost'AS CostContribution,VendorCost AS Cost FROM CTE   
UNION ALL  
SELECT AssetId,WorkOrderId,'LabourCost' AS CostContribution,LabourCost AS Cost FROM CTE   
)  
SELECT * INTO PBICostContribution FROM CTE_COST  
WHERE Cost > 0.00  
  
END

GO
