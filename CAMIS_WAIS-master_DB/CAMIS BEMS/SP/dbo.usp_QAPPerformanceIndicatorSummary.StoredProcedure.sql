USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_QAPPerformanceIndicatorSummary]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------          
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          
-- =============================================            
-- Author  : Krishna S        
-- Create date :08-06-2018            
-- Description :VVF approve Details            
-- =============================================            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                    
EXEC [usp_QAPPerformanceIndicatorSummary] @ParamName = 'Year', @ParamValue = 1    
EXEC [usp_QAPPerformanceIndicatorSummary] @facilityid = 2, @Indicator= 2, @FromMonth =8 , @FromYear = 2018    
EXEC [usp_QAPPerformanceIndicatorSummary]  @FromMonth =1 , @FromYear = 2015, @ToMonth = 12, @ToYear = 2019, @facilityid = 1, @Indicator= 1     
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    
    
CREATE PROCEDURE [dbo].[usp_QAPPerformanceIndicatorSummary](         
             @FromMonth   VARCHAR(50) = '',        
             @ToMonth   VARCHAR(50) = '',        
             @FromYear   VARCHAR(50) = '',        
             @ToYear    VARCHAR(50) = '',                     
             @Indicator   VARCHAR(500) = '',        
             @facilityid   int = NULL,        
             @Level    VARCHAR(100) = ''          
               )          
AS          
BEGIN          
          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
BEGIN TRY          
        
DECLARE @FromDate DATE              
DECLARE @ToDate  DATE              
--      SELECT '1'        
        
IF ISNULL(@ToYear, '') = ''        
 SET @ToYear = NULL        
IF ISNULL(@ToMonth, '') = ''        
 SET @ToMonth = NULL        
 ----EXEC [usp_QAPPerformanceIndicatorSummary] @facilityid = 2, @Indicator= 2, @FromMonth =8 , @FromYear = 2018        
         
SET @FromDate = CAST(@FromYear +'-'+ @FromMonth +'-'+ '01' AS DATE)            
SET @ToDate = DATEADD(DD,-1,DATEADD(MM,1, CAST(isnull(@ToYear,@FromYear) +'-'+ isnull(@ToMonth,@FromMonth) +'-'+ '01' AS DATE)))           
--SELECT @FromDate, @ToDate        
        
IF ISNULL(@FromDate, '') = ''        
 SET @FromDate = GETDATE()        
IF ISNULL(@ToDate, '') = ''        
 SET @ToDate = GETDATE()        
  
--SELECT @FromDate as FromDate, @ToDate as ToDate  
  
DECLARE @QAPPerformanceIndicatorSummary TABLE(        
CustomerName  NVARCHAR(512), FacilityName  NVARCHAR(512), CustomerID   INT,     
FacilityID   INT, AssetsInvolvedCount INT, AssetsMeetingUptimeTarget numeric(15,2),     
NotMeetingTarget   INT )        
    
CREATE TABLE #DOWNTIME(CustomerID INT,FacilityId INT,AssetId INT,AssetTypeCodeId INT,    
MaintenanceWorkDateTime dateTIME,CommissioningDate DATE, --AssetDescription VARCHAR(MAX),        
StartDateTime DATETIME, Downtime NUMERIC(13,2),          
Uptime_Percentage NUMERIC(13,2),Uptime_Met VARCHAR(2),    
Day_Diff INT,cummulative_downtime numeric(24,2),Asset_Uptime_met int)          
        
INSERT INTO @QAPPerformanceIndicatorSummary(CustomerName, FacilityName, CustomerID, FacilityID,     
AssetsInvolvedCount, AssetsMeetingUptimeTarget, NotMeetingTarget)        
        
SELECT MC.CustomerName, MLF.FacilityName, EA.CustomerID, EA.FacilityID, COUNT(DISTINCT EA.ASSETID) AS AssetsInvolvedCount,     
0 as AssetsMeetingUptimeTarget, 0 as NotMeetingTarget       
FROM --EngMaintenanceWorkOrderTxn as wo  WITH(NOLOCK) INNER JOIN 
EngAsset      AS EA    WITH(NOLOCK) --ON EA.AssetId       = wo.AssetId  --engasset AS EA        
INNER JOIN QapB1AdditionalInformationTxn AS QAPAI WITH (NOLOCK) ON QAPAI.assetid = EA.assetid        
inner join QapCarTxn AS QCT WITH (NOLOCK) on qct.carid = QAPAI.carid        
INNER JOIN MstLocationFacility AS MLF WITH (NOLOCK) ON EA.facilityid = MLF.facilityid        
INNER JOIN MstCustomer AS MC WITH (NOLOCK) ON MC.CustomerId = MLF.CustomerId        
WHERE ((EA.facilityid = @facilityid) OR (@facilityid IS NULL) OR (@facilityid = ''))     
AND  CAST(QCT.CARDATE AS DATETIME) BETWEEN  CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE ) 
and	 ((QAPIndicatorid = @Indicator) OR (@Indicator is null) or (@Indicator  = ''))       
--and  EA.assetid in (select ind.assetid from QAPCarTxn as qpa  WITH(NOLOCK)         
--     inner join QapB1AdditionalInformationTxn as ind  WITH(NOLOCK) on ind.carid = qpa.carid        
--     where ((QAPIndicatorid = @Indicator) or (@Indicator is null) or (@Indicator  = '')))        
GROUP BY MC.CustomerName, MLF.FacilityName, EA.CustomerID, EA.FacilityID        
    
----EXEC [usp_QAPPerformanceIndicatorSummary]  @FromMonth =8 , @FromYear = 2018, @facilityid = 1, @Indicator= 2        
    
 UPDATE @QAPPerformanceIndicatorSummary        
 SET  NotMeetingTarget  = asset        
 FROM @QAPPerformanceIndicatorSummary AS TEST        
 INNER JOIN (SELECT A.CustomerID, A.FacilityID, count(distinct A.assetid) as asset FROM EngMaintenanceWorkOrderTxn as A  WITH(NOLOCK)         
    --INNER JOIN EngAsset      AS EA    WITH(NOLOCK) ON EA.AssetId       = A.AssetId         
    INNER JOIN QapB1AdditionalInformationTxn AS QAP  WITH(NOLOCK) on a.assetid = qap.assetid    
    INNER JOIN QAPCarTxn as QAPT  WITH(NOLOCK) ON QAPT.carid = QAP.carid    
    where ((A.facilityid = @facilityid) OR (@facilityid IS NULL) OR (@facilityid = '')) AND        
    CAST(a.MaintenanceWorkDateTime AS DATETIME) BETWEEN  CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE )       
    and ((QAPT.QAPIndicatorid = @Indicator) or (@Indicator is null) or (@Indicator  = ''))     
    --and  qap.carid in (select qpa.carid from QAPCarTxn as qpa  WITH(NOLOCK)         
    --  where ((QAPIndicatorid = @Indicator) or (@Indicator is null) or (@Indicator  = '')))        
    GROUP BY A.CustomerID, A.FacilityID) AS TARGE         
    ON TARGE.FacilityID = TEST.FacilityID AND TARGE.CustomerID = TEST.CustomerID        
      
         
 ------UPDATE @QAPPerformanceIndicatorSummary        
 ------  SET  AssetsMeetingUptimeTarget  = asset        
 ------FROM @QAPPerformanceIndicatorSummary AS TEST        
 ------INNER JOIN (SELECT A.CustomerID, A.FacilityID, count(distinct a.assetid) as asset FROM EngMaintenanceWorkOrderTxn AS A  WITH(NOLOCK)         
 ------   INNER JOIN EngAsset      AS EA    WITH(NOLOCK) ON EA.AssetId       = A.AssetId         
 ------   --INNER JOIN QapB1AdditionalInformationTxn AS QAP  WITH(NOLOCK) on a.assetid = qap.assetid        
 ------   where CAST(a.MaintenanceWorkDateTime AS DATETIME) BETWEEN  CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE )        
 ------   AND  A.WorkOrderId NOT IN (SELECT distinct a.WorkOrderId  as asset FROM EngMaintenanceWorkOrderTxn AS A        
 ------   INNER JOIN QapB1AdditionalInformationTxn AS QAP  WITH(NOLOCK) on a.assetid = qap.assetid        
 ------   where CAST(a.MaintenanceWorkDateTime AS DATETIME) BETWEEN  CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE ))        
 ------   GROUP BY A.CustomerID, A.FacilityID) AS TARGE ON TARGE.FacilityID = TEST.FacilityID AND TARGE.CustomerID = TEST.CustomerID        
         
UPDATE @QAPPerformanceIndicatorSummary        
   SET  AssetsMeetingUptimeTarget  = ((AssetsInvolvedCount - NotMeetingTarget)/AssetsInvolvedCount *100)        
           
   --select AssetsInvolvedCount, NotMeetingTarget,AssetsInvolvedCount,(AssetsInvolvedCount - NotMeetingTarget)*100/AssetsInvolvedCount as per,        
   -- ((AssetsInvolvedCount - NotMeetingTarget)*100/AssetsInvolvedCount )as tet from @QAPPerformanceIndicatorSummary        
           
SELECT CustomerName, FacilityName, CustomerID, FacilityID, AssetsInvolvedCount,         
 (AssetsInvolvedCount - NotMeetingTarget)*100/AssetsInvolvedCount as AssetsMeetingUptimeTarget, NotMeetingTarget           
FROM @QAPPerformanceIndicatorSummary    
        
        
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)            
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())            
            
END CATCH            SET NOCOUNT OFF            
END
GO
