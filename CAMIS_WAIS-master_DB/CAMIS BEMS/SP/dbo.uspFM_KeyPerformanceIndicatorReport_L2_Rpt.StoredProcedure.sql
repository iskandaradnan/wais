USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_KeyPerformanceIndicatorReport_L2_Rpt]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
    
Application Name : UETrack-BEMS                  
    
Version    : 1.0    
    
Procedure Name  : [uspFM_BERApplicationTxn_BERSummary_Rpt]     
    
Description   : Get the BER Summary Report    
    
Authors    : Ganesan S    
    
Date    : 06-June-2018    
    
-----------------------------------------------------------------------------------------------------------    
Unit Test:    
EXEC [uspFM_KeyPerformanceIndicatorReport_L1_Rpt]  @FromYear ='2017', @ToYear='2018',   @FacilityId = 1,@TypecodeId=11   
EXEC [uspFM_KeyPerformanceIndicatorReport_L2_Rpt]  @FromYear ='2017', @ToYear='2018',   @FacilityId = 1,@TypecodeId=11   
-----------------------------------------------------------------------------------------------------------    
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
CREATE PROCEDURE [dbo].[uspFM_KeyPerformanceIndicatorReport_L2_Rpt](                                                      
   @FromYear  VARCHAR(100) = '',        
   @ToYear   VARCHAR(100) = ''  ,     
   @FacilityId  INT ,    
   @TypecodeId  INT = NULL     
 )  
AS  
BEGIN  
SET NOCOUNT ON  
SET FMTONLY OFF  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
BEGIN TRY    
    
  DECLARE @StartDate datetime , @endDate datetime    
  SET @StartDate= (SELECT DATEFROMPARTS(@FromYear, 1, 1))    
  SET @endDate= (SELECT DATEFROMPARTS(@ToYear, 12, 31))  
    
    
DECLARE @@TempTable TABLE(  
ID    INT IDENTITY(1,1),  
FacilityName NVARCHAR(512),  
CustomerName NVARCHAR(512),  
AssetTypeCode  NVARCHAR(512),  
AssetTypeDescription  NVARCHAR(512),  
AssetCount INT,  
Dummy1 INT ,  
Dummy2 INT  
)  
    
  
SELECT  Asset.FacilityId, FAC.FacilityName, Asset.CustomerId, MC.CustomerName, Asset.AssetId, Asset.AssetNo,  
TypeCode.AssetTypeCodeId,TypeCode.AssetTypeCode AS AssetTypeCode, TypeCode.AssetTypeDescription AS AssetTypeDescription,  
MLUA.UserAreaCode AS UserArea, MLUA.UserAreaName AS UserLocation, ISNULL(Asset.ExpectedLifespan,0) AS AssetAgeYrs, ----Asset.WarrantyDuration   
CASE WHEN ETCT.WarrantyEndDate >= GETDATE() THEN 'Yes'    
  WHEN ETCT.WarrantyEndDate <  GETDATE() THEN 'No' ELSE NULL END AS UnderWarranty, TypeCode.QAPUptimeTargetPerc,   
CASE WHEN ISNULL(Asset.ExpectedLifespan,0) <= 5 THEN TypeCode.TRPILessThan5YrsPerc  
  WHEN ISNULL(Asset.ExpectedLifespan,0) > 5 AND ISNULL(Asset.ExpectedLifespan,0) <= 10THEN TypeCode.TRPI5to10YrsPerc  
  WHEN ISNULL(Asset.ExpectedLifespan,0) >10  THEN TypeCode.TRPIGreaterThan10YrsPerc END AS UptimeTargetPer    
, CASE  WHEN ISNULL(Asset.ContractType,0) = 279 THEN   
  CASE WHEN ISNULL(Asset.ExpectedLifespan,0) <= 5 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 1)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) > 5 AND ISNULL(Asset.ExpectedLifespan,0) <= 10 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 2)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) >10  THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 3) END  
  WHEN ISNULL(Asset.ContractType,0) = 280 THEN   
  CASE WHEN ISNULL(Asset.ExpectedLifespan,0) <= 5 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 4)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) > 5 AND ISNULL(Asset.ExpectedLifespan,0) <= 10 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 5)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) >10  THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 6) END  
  WHEN ISNULL(Asset.ContractType,0) = 281 THEN   
  CASE WHEN ISNULL(Asset.ExpectedLifespan,0) <= 5 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 7)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) > 5 AND ISNULL(Asset.ExpectedLifespan,0) <= 10 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 8)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) >10  THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 9) END  
  WHEN ISNULL(Asset.ContractType,0) = 282 THEN   
  CASE WHEN ISNULL(Asset.ExpectedLifespan,0) <= 5 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 10)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) > 5 AND ISNULL(Asset.ExpectedLifespan,0) <= 10 THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 10)  
    WHEN ISNULL(Asset.ExpectedLifespan,0) >10  THEN (select ISNULL(VariationRate,0.00) from EngAssetTypeCodeVariationRate where AssetTypeCodeId = @TypecodeId and TypeCodeParameterId = 12) END  
  END AS UptimePercentage,   
--TypeCode.TRPILessThan5YrsPerc, '' AS UptimePercentage,   
0.00 AS ScheduledPPMHoursMonth, 0.00 AS UnscheduledDowntimeMonth,   
0.00 AS ScheduledPPMHoursYear, 0.00 AS UnscheduledDowntimeYear  
INTO #TEMP_KeyPerformanceIndicatorReport_L2  
FROM EngAsset Asset     
INNER JOIN EngAssetTypeCode TypeCode on Asset.AssetTypeCodeId = TypeCode.AssetTypeCodeId    
INNER JOIN MstLocationFacility fac on fac.FacilityId = Asset.FacilityId    
INNER JOIN MstCustomer AS MC on Asset.CustomerId = MC.CustomerId  
INNER JOIN MstLocationUserArea AS MLUA ON MLUA.UserAreaId = Asset.UserAreaId  
left join EngTestingandCommissioningTxn AS ETCT WITH (NOLOCK) ON ETCT.AssetId =  Asset.AssetId AND Asset.AssetTypeCodeId = ETCT.AssetTypeCodeId  
Where Asset.Active=1 and     
((Asset.FacilityId =  @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))     
and ((Asset.AssetTypeCodeId = @TypecodeId) OR (@TypecodeId IS NULL) OR (@TypecodeId = ''))     
and  (CAST(Asset.CreatedDate AS DATE) BETWEEN CAST(@StartDate  AS DATE) AND CAST(@endDate AS DATE))  
AND	IsLoaner = 0

 UPDATE #TEMP_KeyPerformanceIndicatorReport_L2  
   SET  ScheduledPPMHoursMonth = PPMHoursMonth.RepairHours  
 FROM #TEMP_KeyPerformanceIndicatorReport_L2 AS TEMP  
 INNER JOIN (SELECT EA.assetid, EA.AssetTypeCodeId, SUM(EMCID.RepairHours) AS RepairHours   
    FROM EngAsset AS EA WITH(NOLOCK)  
    INNER JOIN EngMaintenanceWorkOrderTxn AS EMWO WITH(NOLOCK) ON EA.ASSETID = EMWO.ASSETID   
    INNER JOIN EngMwoCompletionInfoTxn AS EMCI WITH(NOLOCK) ON EMWO.WORKORDERID = EMCI.WORKORDERID  
    INNER JOIN EngMwoCompletionInfoTxnDet AS EMCID WITH(NOLOCK) ON EMCID.CompletionInfoId = EMCI.CompletionInfoId  
    WHERE CAST(EMCID.CreatedDate AS DATE) BETWEEN DATEADD(M, -1, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)  
    AND  EMWO.MaintenanceWorkCategory = 187  --Scheduled  
    GROUP BY EA.assetid, EA.AssetTypeCodeId) AS PPMHoursMonth on PPMHoursMonth.AssetId = TEMP.AssetId   
   
 UPDATE #TEMP_KeyPerformanceIndicatorReport_L2  
   SET  UnscheduledDowntimeMonth = UNSEC.RepairHours  
 FROM #TEMP_KeyPerformanceIndicatorReport_L2 AS TEMP  
 INNER JOIN (SELECT EA.assetid, EA.AssetTypeCodeId, SUM(EMCID.RepairHours) AS RepairHours   
    FROM EngAsset AS EA WITH(NOLOCK)  
    INNER JOIN EngMaintenanceWorkOrderTxn AS EMWO WITH(NOLOCK) ON EA.ASSETID = EMWO.ASSETID   
    INNER JOIN EngMwoCompletionInfoTxn AS EMCI WITH(NOLOCK) ON EMWO.WORKORDERID = EMCI.WORKORDERID  
    INNER JOIN EngMwoCompletionInfoTxnDet AS EMCID WITH(NOLOCK) ON EMCID.CompletionInfoId = EMCI.CompletionInfoId  
    WHERE CAST(EMCID.CreatedDate AS DATE) BETWEEN DATEADD(M, -1, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)  
    AND  EMWO.MaintenanceWorkCategory = 188  --UNScheduled  
    GROUP BY EA.assetid, EA.AssetTypeCodeId) AS UNSEC ON UNSEC.assetid = TEMP.assetid  
   
 UPDATE #TEMP_KeyPerformanceIndicatorReport_L2  
   SET  ScheduledPPMHoursYear = PPMHoursMonth.RepairHours  
 FROM #TEMP_KeyPerformanceIndicatorReport_L2 AS TEMP  
 INNER JOIN (SELECT EA.assetid, EA.AssetTypeCodeId, SUM(EMCID.RepairHours) AS RepairHours   
    FROM EngAsset AS EA WITH(NOLOCK)  
    INNER JOIN EngMaintenanceWorkOrderTxn AS EMWO WITH(NOLOCK) ON EA.ASSETID = EMWO.ASSETID   
    INNER JOIN EngMwoCompletionInfoTxn AS EMCI WITH(NOLOCK) ON EMWO.WORKORDERID = EMCI.WORKORDERID  
    INNER JOIN EngMwoCompletionInfoTxnDet AS EMCID WITH(NOLOCK) ON EMCID.CompletionInfoId = EMCI.CompletionInfoId  
    WHERE CAST(EMCID.CreatedDate AS DATE) BETWEEN DATEADD(M, -1, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)  
    AND  EMWO.MaintenanceWorkCategory = 187  --Scheduled  
    GROUP BY EA.assetid, EA.AssetTypeCodeId) AS PPMHoursMonth on PPMHoursMonth.AssetId = TEMP.AssetId   
   
 UPDATE #TEMP_KeyPerformanceIndicatorReport_L2  
   SET  UnscheduledDowntimeYear = UNSEC.RepairHours  
 FROM #TEMP_KeyPerformanceIndicatorReport_L2 AS TEMP  
 INNER JOIN (SELECT EA.assetid, EA.AssetTypeCodeId, SUM(EMCID.RepairHours) AS RepairHours   
    FROM EngAsset AS EA WITH(NOLOCK)  
    INNER JOIN EngMaintenanceWorkOrderTxn AS EMWO WITH(NOLOCK) ON EA.ASSETID = EMWO.ASSETID   
    INNER JOIN EngMwoCompletionInfoTxn AS EMCI WITH(NOLOCK) ON EMWO.WORKORDERID = EMCI.WORKORDERID  
    INNER JOIN EngMwoCompletionInfoTxnDet AS EMCID WITH(NOLOCK) ON EMCID.CompletionInfoId = EMCI.CompletionInfoId  
    WHERE CAST(EMCID.CreatedDate AS DATE) BETWEEN DATEADD(M, -1, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)  
    AND  EMWO.MaintenanceWorkCategory = 188  --UNScheduled  
    GROUP BY EA.assetid, EA.AssetTypeCodeId) AS UNSEC ON UNSEC.assetid = TEMP.assetid  
  
  
SELECT FacilityId, FacilityName, CustomerId, CustomerName, AssetId, AssetNo, AssetTypeCodeId, AssetTypeCode,   
AssetTypeDescription, UserArea, UserLocation, AssetAgeYrs, UnderWarranty, QAPUptimeTargetPerc, UptimeTargetPer,  
UptimePercentage, ScheduledPPMHoursMonth, UnscheduledDowntimeMonth, ScheduledPPMHoursYear,   
UnscheduledDowntimeYear, ISNULL(@FromYear,'') AS FromYearParam, ISNULL(@ToYear, '') as ToYearParam
FROM #TEMP_KeyPerformanceIndicatorReport_L2 ORDER BY ASSETID , AssetTypeCodeId  
  
  
------EXEC [uspFM_KeyPerformanceIndicatorReport_L2_Rpt]  @FromYear ='2017', @ToYear='2018',   @FacilityId = 1,@TypecodeId=1057    
  
END TRY    
BEGIN CATCH    
    
INSERT INTO ERRORLOG(Spname,ErrorMessage,createddate)    
values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
    
SET NOCOUNT OFF                                                 
    
END
GO
