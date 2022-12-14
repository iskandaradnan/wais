USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspBEMS_PerformanceMonitoringReport]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------        
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
-- =============================================          
-- Author  :      
-- Create date :08-06-2018          
-- Description :VVF approve Details          
      
Asis_FEMS_PerformanceMonitoringRPT_L2      
-- =============================================          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
EXEC [uspBEMS_PerformanceMonitoringReport] @FacilityId = 2, @ServiceId = 1, @FromYear = 2017, @ToYear = 2019        
EXEC [uspBEMS_PerformanceMonitoringReport] @FacilityId = 1, @ServiceId = 2, @FromYear = 2010, @ToYear = 2019, @AssetTypeCodeId =1057      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                 
        
CREATE PROCEDURE [dbo].[uspBEMS_PerformanceMonitoringReport](        
             @FacilityId  VARCHAR(20),          
             @ServiceId  VARCHAR(100) = ''  ,       
             @AssetTypeCodeId VARCHAR(100) = ''  ,      
             @FromYear  VARCHAR(100) = ''  ,           
             @ToYear   VARCHAR(100) = ''  ,           
             @Level   VARCHAR(100) = ''        
               )        
AS        
BEGIN        
 SET FMTONLY OFF     

SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
BEGIN TRY        
        
DECLARE @@VVFTable TABLE(              
ID      INT IDENTITY(1,1),      
AssetTypeCodeId   INT,      
AssetTypeCode   NVARCHAR(512),      
AssetTypeDescription NVARCHAR(512),      
CustomerName   NVARCHAR(512),      
FacilityName   NVARCHAR(512),      
MaintenanceWorkCategory  INT,      
Assetid     INT,      
AssetsMeetingUptime  INT,      
AssetsNotMeetingUptime INT,      
AssetsMeetingUptimePer  INT,      
AssetsNotMeetingUptimeper INT,      
Facilityid     INT,      
ServiceId     INT,  
MaintenanceWorkDateTime  DATETIME,  
TargetDateTime    DATETIME,  
EndDateTime     DATETIME,  
assetno      nvarchar(512)  
--Month     NVARCHAR(200),      
--Year     NVARCHAR(200)      
)            

DECLARE @@PerformanceMonitoringReport TABLE(              
ID      INT IDENTITY(1,1),      
AssetTypeCodeId   INT,      
AssetTypeCode   NVARCHAR(512),      
AssetTypeDescription NVARCHAR(512),      
Facilityid    INT,      
ServiceId    INT,      
CustomerName   NVARCHAR(512),      
FacilityName   NVARCHAR(512),      
AssetCount     INT,      
AssetsMeetingUptime   INT,      
AssetsNotMeetingUptime  INT,      
AssetsMeetingUptimePer		NUMERIC(24,2),      
AssetsNotMeetingUptimeper	NUMERIC(24,2)      
)            
        
--MstLocationFacility      
--MstCustomer      

      
  INSERT INTO @@VVFTable(FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,       
  MaintenanceWorkCategory, Facilityid, ServiceId, MaintenanceWorkDateTime, TargetDateTime, EndDateTime,   
  Assetid, assetno)       
           
  SELECT DISTINCT MLF.FACILITYNAME, MC.CUSTOMERNAME, EATC.AssetTypeCodeId, EATC.AssetTypeCode, EATC.AssetTypeDescription,       
  EMWT.MaintenanceWorkCategory, EA.Facilityid, EA.ServiceId, EMWT.MaintenanceWorkDateTime,   
  ISNULL(EMWT.TargetDateTime, c.EndDateTime) as  TargetDateTime, isnull(c.EndDateTime,getdate()) as EndDateTime,  
   EA.Assetid, ea.assetno  
  FROM engasset AS EA WITH (NOLOCK)      
  INNER JOIN EngAssetTypeCode AS EATC WITH (NOLOCK) ON  EATC.AssetTypeCodeId = EA.AssetTypeCodeId      
  INNER JOIN EngMaintenanceWorkOrderTxn EMWT  WITH (NOLOCK) ON  EMWT.AssetId = EA.AssetId      
  INNER JOIN EngMwoCompletionInfoTxn C ON EMWT.WorkOrderId = C.WorkOrderId       
  INNER JOIN MstLocationFacility AS MLF ON EA.FACILITYID  = MLF.FACILITYID      
  INNER JOIN MstCustomer AS MC ON EA.CUSTOMERID = MC.CUSTOMERID      
  WHERE  EMWT.WorkOrderStatus = 194        
  AND  EMWT.MaintenanceWorkCategory =187      
  AND  EA.FacilityId = @FacilityId      
  AND  EA.ServiceId = @ServiceId      
and  ((ea.AssetTypeCodeId = @AssetTypeCodeId) or (@AssetTypeCodeId is null) or (@AssetTypeCodeId = ''))      
  AND  YEAR(EMWT.MaintenanceWorkDateTime) BETWEEN @FromYear AND @ToYear      
  --GROUP BY MLF.FACILITYNAME, MC.CUSTOMERNAME, EATC.AssetTypeCodeId, EATC.AssetTypeCode, EATC.AssetTypeDescription,       
  --EMWT.MaintenanceWorkCategory, EA.Facilityid, EA.ServiceId      
        
  INSERT INTO @@VVFTable(FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,       
  MaintenanceWorkCategory, Facilityid, ServiceId, MaintenanceWorkDateTime, TargetDateTime, EndDateTime, Assetid, assetno )       
        
  SELECT DISTINCT MLF.FACILITYNAME, MC.CUSTOMERNAME, EATC.AssetTypeCodeId, EATC.AssetTypeCode, EATC.AssetTypeDescription,       
  EMWT.MaintenanceWorkCategory, EA.Facilityid, EA.ServiceId, EMWT.MaintenanceWorkDateTime,   
  ISNULL(EMWT.TargetDateTime, c.EndDateTime) as  TargetDateTime, isnull(c.EndDateTime,getdate()) as EndDateTime,  
   EA.Assetid, ea.assetno    
  --COUNT(DISTINCT EA.Assetid)      
  FROM engasset AS EA WITH (NOLOCK)      
  INNER JOIN EngAssetTypeCode AS EATC WITH (NOLOCK) ON  EATC.AssetTypeCodeId = EA.AssetTypeCodeId      
  INNER JOIN EngMaintenanceWorkOrderTxn EMWT  WITH (NOLOCK) ON  EMWT.AssetId = EA.AssetId      
  INNER JOIN EngMwoCompletionInfoTxn C ON EMWT.WorkOrderId = C.WorkOrderId       
  INNER JOIN MstLocationFacility AS MLF ON EA.FACILITYID  = MLF.FACILITYID      
  INNER JOIN MstCustomer AS MC ON EA.CUSTOMERID = MC.CUSTOMERID      
  WHERE  EMWT.WorkOrderStatus = 194        
  AND  EMWT.MaintenanceWorkCategory =188        
  AND  EA.FacilityId = @FacilityId      
  AND  EA.ServiceId = @ServiceId      
  and  ((ea.AssetTypeCodeId = @AssetTypeCodeId) or (@AssetTypeCodeId is null) or (@AssetTypeCodeId = ''))      
  AND  YEAR(EMWT.MaintenanceWorkDateTime) BETWEEN @FromYear AND @ToYear      
  
  --insert into @@VVFTableCount(FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,
  --MaintenanceWorkCategory, Facilityid, ServiceId, Assetid, assetno )
  --select distinct FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,       
  --MaintenanceWorkCategory, Facilityid, ServiceId, Assetid, assetno 
  --from @@VVFTable
  --select * from @@VVFTableCount

  INSERT INTO  @@PerformanceMonitoringReport(FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode,       
  AssetTypeDescription, Facilityid, ServiceId, AssetCount )       
    
  SELECT distinct FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,       
  Facilityid, ServiceId, COUNT(distinct assetno) AS AssetCount  
  FROM @@VVFTable  
  GROUP BY FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,       
  Facilityid, ServiceId  

  
----EXEC [uspBEMS_PerformanceMonitoringReport] @FacilityId = 1, @ServiceId = 2, @FromYear = 2010, @ToYear = 2019, @AssetTypeCodeId =1057    

 UPDATE @@PerformanceMonitoringReport      
   SET  AssetsMeetingUptime  = AssetsMeetingUptimeCOUNT     
 FROM @@PerformanceMonitoringReport as TEMP  
 INNER JOIN (SELECT  PMR.AssetTypeCodeId, COUNT( DISTINCT assetno) AS AssetsMeetingUptimeCOUNT FROM @@PerformanceMonitoringReport AS PMR     
    INNER JOIN @@VVFTable as TEMP ON PMR.AssetTypeCodeId = TEMP.AssetTypeCodeId  
    WHERE ISNULL(TEMP.TargetDateTime,GETDATE())  >= EndDateTime group by PMR.AssetTypeCodeId)  TEMPAssetsMeetingUpTIME   
    ON TEMP.AssetTypeCodeId = TEMPAssetsMeetingUpTIME.AssetTypeCodeId  

 UPDATE @@PerformanceMonitoringReport      
   SET  AssetsNotMeetingUptime  = AssetsNotMeetingUptimeCOUNT     
 FROM @@PerformanceMonitoringReport as TEMP  
 INNER JOIN (SELECT DISTINCT PMR.AssetTypeCodeId, COUNT( DISTINCT assetno) AS AssetsNotMeetingUptimeCOUNT FROM @@PerformanceMonitoringReport AS PMR      
    INNER JOIN @@VVFTable as TEMP ON PMR.AssetTypeCodeId = TEMP.AssetTypeCodeId  
    WHERE (isnull(TEMP.TargetDateTime,getdate()) < EndDateTime) group by PMR.AssetTypeCodeId)  TEMPAssetsMeetingUpTIME   
    ON TEMP.AssetTypeCodeId = TEMPAssetsMeetingUpTIME.AssetTypeCodeId   
   
  UPDATE @@PerformanceMonitoringReport  
		set	AssetCount = isnull(AssetsMeetingUptime,0) + isnull(AssetsNotMeetingUptime,0)

 UPDATE @@PerformanceMonitoringReport      
   SET  AssetsMeetingUptimePer  =  CAST(AssetsMeetingUptime AS NUMERIC(24,2)) * 100 / CAST(AssetCount AS NUMERIC(24,2))  
 FROM @@PerformanceMonitoringReport as TEMP  
  
 UPDATE @@PerformanceMonitoringReport      
   SET  AssetsNotMeetingUptimeper  = CAST(AssetsNotMeetingUptime AS NUMERIC(24,2)) * 100/ CAST(AssetCount AS NUMERIC(24,2))    
 FROM @@PerformanceMonitoringReport as TEMP  
   
--EXEC [uspBEMS_PerformanceMonitoringReport] @FacilityId = 1, @ServiceId = 2, @FromYear = 2018, @ToYear = 2019    
     
--SELECT *, ISNULL(@FromYear,'') AS FromYearParam , ISNULL(@ToYear,'') AS ToYearParam  From @@VVFTable          
--select * from @@PerformanceMonitoringReport order by AssetTypeCodeId asc     
 
select ID, AssetTypeCodeId, AssetTypeCode , AssetTypeDescription, Facilityid,ServiceId, CustomerName,FacilityName, 
AssetCount ,AssetsMeetingUptime ,AssetsNotMeetingUptime ,AssetsMeetingUptimePer,AssetsNotMeetingUptimeper
from @@PerformanceMonitoringReport order by AssetTypeCodeId asc    
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)          
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
