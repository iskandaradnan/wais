USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspBEMS_PerformanceMonitoringReport_L2]    Script Date: 20-09-2021 16:56:52 ******/
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
EXEC [uspBEMS_PerformanceMonitoringReport_L2] @FacilityId = 2, @ServiceId = 2, @AssetsMeetingtype = 1, @FromYear = 2017, @ToYear = 2019      
EXEC [uspBEMS_PerformanceMonitoringReport_L2] @FacilityId = 1, @ServiceId = 2, @AssetsMeetingtype = 2, @FromYear = 2010, @ToYear = 2019, @AssetTypeCodeId =1057      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/      
CREATE PROCEDURE [dbo].[uspBEMS_PerformanceMonitoringReport_L2](      
             @FacilityId  VARCHAR(20),      
             @ServiceId   VARCHAR(100) = '',      
             @AssetTypeCodeId VARCHAR(100) = '',      
             @FromYear   VARCHAR(100) = '',      
             @ToYear   VARCHAR(100) = '',      
             @AssetsMeetingtype INT = NULL,  ----1 -AssetsMeetingUptime, 2 - AssetsNotMeetingUptime      
             @Level    VARCHAR(100) = ''      
               )      
AS      
BEGIN      
      
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
AssetNo   NVARCHAR(512),      
AssetLifespan NUMERIC(24,1),      
--AssetsMeetingUptime  INT,          
--AssetsNotMeetingUptime INT,          
QAPUptimeTargetPer  NUMERIC(24,2) DEFAULT 0.00,          
UptimeOfForMonthPer NUMERIC(24,2) DEFAULT 0.00,          
Facilityid     INT,          
ServiceId     INT,      
MaintenanceWorkDateTime  DATETIME,      
TargetDateTime    DATETIME,      
EndDateTime     DATETIME          
)                
           
--MstLocationFacility          
--MstCustomer          
    
  INSERT INTO @@VVFTable(FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,           
  MaintenanceWorkCategory, Facilityid, ServiceId, MaintenanceWorkDateTime, TargetDateTime, EndDateTime,       
  Assetid, assetno, AssetLifespan, QAPUptimeTargetPer, UptimeOfForMonthPer)           
  
 SELECT DISTINCT MLF.FACILITYNAME, MC.CUSTOMERNAME, EATC.AssetTypeCodeId, EATC.AssetTypeCode, EATC.AssetTypeDescription,           
 EMWT.MaintenanceWorkCategory, EA.Facilityid, EA.ServiceId, EMWT.MaintenanceWorkDateTime,       
 ISNULL(EMWT.TargetDateTime, c.EndDateTime) as  TargetDateTime, isnull(c.EndDateTime,getdate()) as EndDateTime,      
 EA.Assetid, EA.assetno, --ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) AS ExpectedLifespan, 
 CAST(CAST((DATEDIFF(m, EA.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +   
	CASE	WHEN DATEDIFF(m, EA.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
			ELSE cast((abs(DATEDIFF(m, EA.PurchaseDate, GETDATE())%12)) AS VARCHAR) END as NUMERIC(24,1)) AS AssetAge, 
 ISNULL(EATC.QAPUptimeTargetPerc, 0.00) AS QAPUptimeTargetPerc   
 ,ISNULL(CASE WHEN ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) <=5 THEN TRPILessThan5YrsPerc      
    WHEN ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) >5 and ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) >=10 THEN TRPI5to10YrsPerc      
    WHEN ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) >10 THEN TRPIGreaterThan10YrsPerc END,0.00) AS UptimePerActual      
    
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
  and ((@AssetsMeetingtype = 1 and ISNULL(ISNULL(EMWT.TargetDateTime, c.EndDateTime),GETDATE())  >= ISNULL(C.ENDDATETIME,GETDATE()))       
  OR (@AssetsMeetingtype = 2 and (ISNULL(ISNULL(EMWT.TargetDateTime, c.EndDateTime),GETDATE()) < ISNULL(C.ENDDATETIME,GETDATE()))))      
      
--EXEC [uspBEMS_PerformanceMonitoringReport_L2] @FacilityId = 1, @ServiceId = 2, @AssetsMeetingtype = 1,@FromYear = 2018, @ToYear = 2019        
        
  INSERT INTO @@VVFTable(FacilityName,CustomerName, AssetTypeCodeId, AssetTypeCode, AssetTypeDescription,           
  MaintenanceWorkCategory, Facilityid, ServiceId, MaintenanceWorkDateTime, TargetDateTime, EndDateTime,       
  Assetid, assetno, AssetLifespan, QAPUptimeTargetPer, UptimeOfForMonthPer)           
            
  SELECT DISTINCT MLF.FACILITYNAME, MC.CUSTOMERNAME, EATC.AssetTypeCodeId, EATC.AssetTypeCode, EATC.AssetTypeDescription,           
  EMWT.MaintenanceWorkCategory, EA.Facilityid, EA.ServiceId, EMWT.MaintenanceWorkDateTime,       
  ISNULL(EMWT.TargetDateTime, c.EndDateTime) as  TargetDateTime, isnull(c.EndDateTime,getdate()) as EndDateTime,      
  EA.Assetid, ea.assetno, --ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) AS ExpectedLifespan, 
  CAST(CAST((DATEDIFF(m, EA.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +   
	CASE	WHEN DATEDIFF(m, EA.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
			ELSE cast((abs(DATEDIFF(m, EA.PurchaseDate, GETDATE())%12)) AS VARCHAR) END as NUMERIC(24,1)) AS AssetAge,
  EATC.QAPUptimeTargetPerc      
  ,CASE WHEN ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) <=5 THEN TRPILessThan5YrsPerc      
    WHEN ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) >5 and ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) >=10 THEN TRPI5to10YrsPerc      
    WHEN ISNULL(EA.ExpectedLifespan,EATC.ExpectedLifespan) >10 THEN TRPIGreaterThan10YrsPerc END AS UptimePerActual      
  --COUNT(DISTINCT EA.Assetid)          
  FROM engasset AS EA WITH (NOLOCK)          
  INNER JOIN EngAssetTypeCode AS EATC WITH (NOLOCK) ON  EATC.AssetTypeCodeId = EA.AssetTypeCodeId          
  INNER JOIN EngMaintenanceWorkOrderTxn EMWT  WITH (NOLOCK) ON  EMWT.AssetId = EA.AssetId          
  INNER JOIN EngMwoCompletionInfoTxn C ON EMWT.WorkOrderId = C.WorkOrderId           
  INNER JOIN MstLocationFacility AS MLF ON EA.FACILITYID  = MLF.FACILITYID          
  INNER JOIN MstCustomer AS MC ON EA.CUSTOMERID = MC.CUSTOMERID      
  --left join EngAssetTypeCode AS EATC      
  WHERE  EMWT.WorkOrderStatus = 194            
  AND  EMWT.MaintenanceWorkCategory =188            
  AND  EA.FacilityId = @FacilityId          
  AND  EA.ServiceId = @ServiceId          
  and  ((ea.AssetTypeCodeId = @AssetTypeCodeId) or (@AssetTypeCodeId is null) or (@AssetTypeCodeId = ''))          
  AND  YEAR(EMWT.MaintenanceWorkDateTime) BETWEEN @FromYear AND @ToYear          
  and ((@AssetsMeetingtype = 1 and ISNULL(ISNULL(EMWT.TargetDateTime, c.EndDateTime),GETDATE())  >= ISNULL(C.ENDDATETIME,GETDATE()))       
  OR (@AssetsMeetingtype = 2 and (ISNULL(ISNULL(EMWT.TargetDateTime, c.EndDateTime),GETDATE()) < ISNULL(C.ENDDATETIME,GETDATE()))))      
    
--SELECT *, ISNULL(@FromYear,'') AS FromYearParam , ISNULL(@ToYear,'') AS ToYearParam  From @@VVFTable              
SELECT distinct AssetNo ,UptimeOfForMonthPer, AssetTypeCode,AssetTypeDescription,AssetLifespan,QAPUptimeTargetPer,  ISNULL(@FromYear,'') AS FromYearParam , ISNULL(@ToYear,'') AS ToYearParam  From @@VVFTable                     
                
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)              
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())              
              
END CATCH              
SET NOCOUNT OFF              
END
GO
