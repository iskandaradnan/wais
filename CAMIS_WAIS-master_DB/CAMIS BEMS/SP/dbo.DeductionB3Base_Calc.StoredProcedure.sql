USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB3Base_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
---ONLY RUN ONCE FOR A MONTH  
--EXEC DeductionB3Base_Calc  
  
CREATE PROCEDURE [dbo].[DeductionB3Base_Calc]  
AS  
  
BEGIN  
  
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY  
  
  
DECLARE @YEAR INT
DECLARE @MONTH INT

SET @YEAR=(CASE WHEN MONTH(GETDATE())=1 THEN YEAR(GETDATE())-1 ELSE YEAR(GETDATE()) END)
SET @MONTH=(CASE WHEN MONTH(GETDATE())=1 THEN 12 ELSE MONTH(GETDATE())-1 END)        
  
DELETE FROM DeductionB3Base WHERE YEAR=@YEAR AND MONTH=@MONTH  
  
;WITH CTE AS   
(  
SELECT   
 A.AssetNo  
,A.AssetTypeCode  
,A.AssetPurchasePrice  
,A.AssetAge  
,A.OperatingHours  
,A.OperatingDaysWeeks  
,CASE WHEN B.Month=@MONTH THEN B.DownTimeAging  ELSE 0 END DownTimeAging  
,A.TotalAnnualHours  
,A.TargetUptime  
,A.AssetTypeDescription  
,A.TotalAccumDowtimeHours  
,DeductionFigurePerAsset1  
,DeductionFigurePerAsset2  
,CASE WHEN B.Month=@MONTH THEN B.Uptime  ELSE 0 END CurrentUptime  
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
,CASE WHEN Uptime < 0.80 THEN B.DemritPoint_1*B.DeductionFigurePerAssetLessThenEighty   
      ELSE B.DemritPoint_1*B.DeductionFigurePerAsset   
   END AS DeductionForMonth1  
,CASE WHEN Uptime < 0.80 THEN B.DemritPoint_2*B.DeductionFigurePerAssetLessThenEighty   
      ELSE B.DemritPoint_2*B.DeductionFigurePerAsset   
   END AS DeductionForMonth2  
,B.DemritPoint_1 AS DemeritPointForMonth1  
,B.DemritPoint_2 AS DemeritPointForMonth2  
,TotalProHawkDeduction  
,B.Year  
,B.Month  
,Remarks  
FROM DeductionB3OutPut A  
INNER JOIN DeductionB3BaseDemerit B  
ON A.AssetNo=B.AssetNo  
WHERE B.Year=@YEAR  
AND B.Month=@MONTH  
--AND A.AssetNo='WB219001798A'  
)  
INSERT INTO DeductionB3Base  
(  
 AssetNo  
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
,Year  
,Month  
,Remarks  
)  
  
  
SELECT AssetNo  
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
,DeductionForMonth1 AS DeductionValue1  
,DeductionForMonth2 AS DeductionValue2  
,DemeritPointForMonth1 AS DemeritPointValue1  
,DemeritPointForMonth2 AS  DemeritPointValue2  
,DeductionForMonth1+DeductionForMonth2 AS TotalProHawkDeduction  
,Year  
,Month  
,Remarks  
--INTO DeductionB3Base  
FROM CTE  
  
  
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
  
END  
  
  
  
  
  
GO
