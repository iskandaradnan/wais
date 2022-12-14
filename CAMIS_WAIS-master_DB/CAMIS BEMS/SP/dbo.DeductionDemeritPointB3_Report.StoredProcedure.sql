USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB3_Report]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--EXEC [DeductionDemeritPointB3_Report] 2020,8  
CREATE PROCEDURE [dbo].[DeductionDemeritPointB3_Report]  
(  
 @YEAR INT  
,@MONTH INT  
)  
AS  
  
BEGIN  
  
  
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY  
  
  
--DECLARE @YEAR INT =2020  
--DECLARE @MONTH INT=1  
  
-----FINDING WORK ORDER FOR THAT MONTH ONLY  
WITH CTE AS   
(  
SELECT A.AssetNo,MAX(D.MaintenanceWorkDateTime) AS [Date]   
FROM EngAsset A WITH (NOLOCK)   
LEFT OUTER JOIN [uetrackbemsdbPreProd].[DBO].EngAssetTypeCode B WITH (NOLOCK)  
ON A.AssetTypeCodeId=B.AssetTypeCodeId  
LEFT JOIN [uetrackbemsdbPreProd].[DBO].EngMaintenanceWorkOrderTxn D WITH (NOLOCK)  
ON A.AssetId=D.AssetId  
WHERE D.WorkOrderStatus IN (194,195)  
AND MaintenanceWorkType=273  
GROUP BY A.AssetNo  
)  
  
,CTE_YEAR_MONTH AS  
(  
SELECT   
A.AssetNo  
,CONVERT(DATETIME,CAST([DATE] AS DATE)) AS [DATE]  
,YEAR([Date]) AS [Year]  
,MONTH([Date]) AS [Month]   
FROM CTE A   
)  
  
SELECT A.AssetNo  
,AssetTypeCode  
,AssetPurchasePrice  
,AssetAge  
,OperatingHours  
,OperatingDaysWeeks  
,DownTimeAging  
,TotalAnnualHours  
,TargetUptime  
,AssetTypeDescription  
,TotalAccumDowtimeHours  
,DeductionFigurePerAsset1  
,DeductionFigurePerAsset2  
,CurrentUptime  
,Jan  
,Feb  
,Mar  
,Apr  
,May  
,Jun  
,Jul  
,Aug  
,Sep  
,Oct  
,Nov  
,Dec  
,DeductionValue1  
,DeductionValue2  
,DemeritPointValue1  
,DemeritPointValue2  
,TotalProHawkDeduction  
,A.Year  
,A.Month  
,Remarks   
FROM DeductionB3Base A  
INNER JOIN CTE_YEAR_MONTH B  
ON A.AssetNo=B.AssetNo  
AND A.Year=B.Year  
AND A.Month=B.Month  
  
WHERE A.Year=@YEAR  
AND A.MONTH=@MONTH  
  
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
  
  
END  
  
  
  
GO
