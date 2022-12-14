USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_QAPPerformanceIndicatorSummary_L2]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
Application Name : ASIS            
Version    :            
File Name   :            
Procedure Name  : Asis_EodParameterRpt_L1            
Author(s) Name(s) : KRISHNA S      
Date    : 27-02-2017                
Purpose    : SP to EOD parameter report                
Sub Report sp name :       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
           
EXEC usp_QAPPerformanceIndicatorSummary_L2 @Facilityid = 1, @CARNumber = 'CAR/PAN101/201807/000025'      
EXEC [usp_QAPPerformanceIndicatorSummary_L2]  @FromMonth =1 , @FromYear = 2015, @ToMonth = 12, @ToYear = 2019, @facilityid = 1, @Indicator= 1       
       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
Modification History                    
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai                
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/            
CREATE PROCEDURE  [dbo].[usp_QAPPerformanceIndicatorSummary_L2] (    
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
SET FMTONLY OFF      
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
      
         
SELECT DISTINCT MC.CustomerName, MLF.FacilityName, EA.CustomerID, EA.FacilityID,  EA.ASSETID AssetsInvolvedCount,       
lovTypeOfAsset.FieldValue AS TypeOfAsset, QCT.CARNumber, EA.ASSETNO, EA.ExpectedLifespan AS AssetAge,     
QCT.ExpectedPercentage AS UptimeHoursTarget, QCT.ActualPercentage AS UptimeHoursActual, EATC.QAPUptimeTargetPerc AS UptimePerTarget,   
CASE WHEN EA.ExpectedLifespan <5 THEN TRPILessThan5YrsPerc  
  WHEN EA.ExpectedLifespan >5 and EA.ExpectedLifespan >10 THEN TRPI5to10YrsPerc  
  WHEN EA.ExpectedLifespan >10 THEN TRPIGreaterThan10YrsPerc END AS UptimePerActual  
FROM       
------EngMaintenanceWorkOrderTxn as wo  WITH(NOLOCK) INNER JOIN       
EngAsset      AS EA    WITH(NOLOCK) --ON EA.AssetId       = wo.AssetId  --engasset AS EA          
INNER JOIN QapB1AdditionalInformationTxn AS QAPAI WITH (NOLOCK) ON QAPAI.assetid = EA.assetid          
inner join QapCarTxn AS QCT WITH (NOLOCK) on qct.carid = QAPAI.carid          
INNER JOIN MstLocationFacility AS MLF WITH (NOLOCK) ON ea.facilityid = MLF.facilityid          
INNER JOIN MstCustomer AS MC WITH (NOLOCK) ON MC.CustomerId = MLF.CustomerId      
LEFT JOIN FMLovMst    AS lovTypeOfAsset   WITH(NOLOCK) ON lovTypeOfAsset.lovid = EA.TypeOfAsset      
left join EngAssetTypeCode AS EATC WITH(NOLOCK) ON EATC.AssetTypeCodeId = EA.AssetTypeCodeId      
WHERE ((ea.facilityid = @facilityid) OR (@facilityid IS NULL) OR (@facilityid = ''))       
AND  CAST(QCT.CARDATE AS DATETIME) BETWEEN  CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE )
and	((QAPIndicatorid = @Indicator) OR (@Indicator is null) or (@Indicator  = ''))
--AND EA.ASSETID IN ( SELECT ind.assetid FROM QAPCarTxn AS QPA  WITH(NOLOCK)           
--      inner join QapB1AdditionalInformationTxn as ind  WITH(NOLOCK) on ind.carid = qpa.carid          
--      where ((QAPIndicatorid = @Indicator) OR (@Indicator is null) or (@Indicator  = '')))          
      
------EXEC usp_QAPPerformanceIndicatorSummary_L2 @Facilityid = 1, @CARNumber = 'CAR/PAN101/201807/000025'      
--EXEC [usp_QAPPerformanceIndicatorSummary_L2]  @FromMonth =1 , @FromYear = 2015, @ToMonth = 12, @ToYear = 2019, @facilityid = 1, @Indicator= 1       
       
END TRY                
BEGIN CATCH                
                
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)                
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())                
                
END CATCH                
SET NOCOUNT OFF                
                
END
GO
