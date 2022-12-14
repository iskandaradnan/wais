USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB1B2_Temp]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---EXEC DeductionB1B2_Temp 2020,8

CREATE PROCEDURE [dbo].[DeductionB1B2_Temp]
(
@YEAR INT 
,@MONTH INT
)

AS

BEGIN



;WITH CTE AS 
(
SELECT DocumentNo 
,IndicatorName
,Flag
,CASE WHEN IndicatorName='B1' THEN  DemeritPoint ELSE 0 END AS DemeritPointB1
,CASE WHEN IndicatorName='B2' THEN  DemeritPoint ELSE 0 END AS DemeritPointB2
,CASE WHEN IndicatorName='B1' THEN  DeductionValue ELSE 0 END AS DeductionProHawkB1
,CASE WHEN IndicatorName='B2' THEN  DeductionValue ELSE 0 END AS DeductionProHawkB2
,CASE WHEN IndicatorName='B1' THEN  DeductionValue ELSE 0 END AS DeductionEdgentaB1
,CASE WHEN IndicatorName='B2' THEN  DeductionValue ELSE 0 END AS DeductionEdgentaB2
FROM DedTransactionMappingTxnDet
WHERE ISNULL(DocumentNo,'')<>''

)
,CTE_BASE AS
(
SELECT DocumentNo
,Flag
,SUM(DemeritPointB1) AS DemeritPointB1
,SUM(DemeritPointB2) AS DemeritPointB2
,SUM(DeductionProHawkB1) AS  DeductionProHawkB1
,SUM(DeductionProHawkB2) AS DeductionProHawkB2
,SUM(DeductionEdgentaB1) AS DeductionEdgentaB1
,SUM(DeductionEdgentaB2) AS DeductionEdgentaB2
FROM CTE 
GROUP BY DocumentNo,Flag
)


--SELECT * FROM CTE_BASE

SELECT 
 B.AssetNo
,B.AssetDescription
,B.PurchaseCostRM AS AssetPurchasePrice             
,A.MaintenanceWorkNo AS WONo             
,A.WorkOrderId            
,C.UserAreaCode AS UserDept             
,A.MaintenanceDetails AS RequestDetails             
,D.FieldValue AS ResponseCategory             
,A.MaintenanceWorkDateTime AS WorkRequestDate             
,YEAR(MaintenanceWorkDateTime) AS WorkRequestYear            
,MONTH(MaintenanceWorkDateTime) AS WorkRequestMonth            
,F.StartDateTime            
,F.EndDateTime            
,G.ResponseDateTime             
,G.ResponseDuration             
,F.EndDateTime AS WorkCompletedDate            
,CASE WHEN ISNULL(F.EndDateTime,'')='' THEN 0 ELSE DATEDIFF(DAY,A.MaintenanceWorkDateTime,F.EndDateTime)+1 END AS RepairTimeDays            
,DATEADD(day, 7, A.MaintenanceWorkDateTime)-1 AS LastDateOf7thDay             
,E.FieldValue AS WOStatus            
,CASE WHEN B.PurchaseCostRM BETWEEN 0 AND 30000 THEN 50            
      WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 100            
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 1000000000 THEN 200            
   END AS B1_DeductionFigurePerAsset            
,CASE WHEN B.PurchaseCostRM BETWEEN 0 AND 5000 THEN 10            
      WHEN B.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 20            
   WHEN B.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 30            
   WHEN B.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 40            
   WHEN B.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 50            
   WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 75            
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 100            
   WHEN B.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 200            
   WHEN B.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 500            
   WHEN B.PurchaseCostRM > 1000000 THEN 1000            
   END AS B2_DeductionFigurePerAsset            
,CASE WHEN CAST(DATEPART(HOUR, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)) IN             
(0,1,2,3,4,5,6,7,8,9)  THEN CONCAT('0',CAST(DATEPART(HOUR, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)))            
ELSE CAST(DATEPART(HOUR, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10))            
END             
+':'+            
CASE WHEN CAST(DATEPART(MINUTE, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)) IN             
(0,1,2,3,4,5,6,7,8,9)  THEN CONCAT('0',CAST(DATEPART(MINUTE, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)))            
ELSE CAST(DATEPART(MINUTE, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10))            
END            
AS ResponseDurationHHMM            
,CASE WHEN DemeritPointB1>=1 THEN 'Y' ELSE 'N' END AS IsValidB1
,CASE WHEN DemeritPointB2>=1 THEN 'Y' ELSE 'N' END AS IsValidB2
,DemeritPointB1
,DemeritPointB2
,DeductionProHawkB1
,DeductionProHawkB2
,DeductionEdgentaB1
,DeductionEdgentaB2

--,DeductionValue AS DeductionProHawk 
--,DeductionValue AS DeductionEdgenta
,'' AS Remarks
,Flag
FROM CTE_BASE XY
INNER JOIN dbo.EngMaintenanceWorkOrderTxn A            
ON XY.DocumentNo=A.MaintenanceWorkNo
INNER JOIN dbo.EngAsset B            
ON A.AssetId = B.AssetId             
INNER JOIN dbo.MstLocationUserArea C             
ON B.UserAreaId = C.UserAreaId             
INNER JOIN dbo.FMLovMst D             
ON A.WorkOrderPriority = D.LovId             
INNER JOIN dbo.FMLovMst E              
ON A.WorkOrderStatus =E.LovId             
LEFT OUTER JOIN dbo.EngMwoCompletionInfoTxn F             
ON A.WorkOrderId = F.WorkOrderId             
LEFT OUTER JOIN dbo.EngMwoAssesmentTxn G            
ON A.WorkOrderId = G.WorkOrderId            
WHERE TypeOfWorkOrder IN ( 270,271,272,273,274)            
--AND MaintenanceWorkDateTime >=@STARTOFYEAR AND   MaintenanceWorkDateTime<=@EndDate          


END
GO
