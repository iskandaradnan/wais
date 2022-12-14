USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[OtherEodParameterAnalysisRpt_L1]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
      
Application Name : ASIS  
Version    :  
File Name   :  
Procedure Name  : Asis_EodParameterRpt_L1  
Author(s) Name(s) : Senthilkumar E  
Date    : 27-02-2017      
Purpose    : SP to EOD parameter report      
Sub Report sp name : Asis_EodParameterAnalysisRpt_L1_Details    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
EXEC OtherEodParameterAnalysisRpt_L1 @From_Date='2016-11-23 09:35:00.000',@To_Date='2019-11-23 09:35:00.000',@Facilityid = 1, @TypeCode =1057   
EXEC OtherEodParameterAnalysisRpt_L1 @From_Date='',@To_Date='',@Facilityid =   
   
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
Modification History          
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/  
CREATE PROCEDURE  [dbo].[OtherEodParameterAnalysisRpt_L1](  
        @Level   VARCHAR(20) = NULL,  
        @From_Date  VARCHAR(50) = '',  
        @To_Date  VARCHAR(50) = '',  
        @Facilityid  INT = null,  
		@AssetNo		VARCHAR(150) = '',
        @TypeCode  INT = null  
        )  
AS  
BEGIN  
    
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY  
  
DECLARE @@ER_Parameter_Report TABLE(    
AssetId   INT,    
AssetNo   NVARCHAR(200),    
FacilityName NVARCHAR(200),    
PassCount  INT,    
FailCount  INT 
--Percentage  NUMERIC(24,2) 
--GrandTotalPass INT,  
--GrandTotalFail      INT,  
--GrandTotalPercentage  NUMERIC(24,2)  
)    
--select @From_Date_local, @to_Date_local, @service    
  
INSERT INTO @@ER_Parameter_Report  (AssetId, AssetNo, FacilityName, PassCount,FailCount )  
  
SELECT EA.AssetId, EA.AssetNo, FAC.FacilityName
      , SUM( CASE WHEN ECD.STATUS = 1 THEN 1 ELSE 0 END) AS PassCount
	  , SUM( CASE WHEN ECD.Status = 2 THEN 1 ELSE 0 END) AS FailCount  
FROM EngEODCaptureTxn AS EC  WITH (NOLOCK)          
JOIN EngEODCaptureTxnDet AS ECD WITH (NOLOCK) ON EC.CaptureId   = ECD.CaptureId     
JOIN engasset AS EA ON EA.ASSETID = EC.ASSETID     
JOIN EngAssetTypeCode AS EATC ON EATC.AssetTypeCodeId = EA.AssetTypeCodeId    
INNER JOIN MstLocationFacility AS FAC ON FAC.FACILITYID = EC.FACILITYID    
WHERE ISNULL(ECD.status,0) in (1,2)   
AND  CAST(EC.RecordDate AS DATE) BETWEEN CAST(@From_Date AS DATE) AND CAST(@To_Date AS DATE)  
and  ((EA.AssetTypeCodeId = @TypeCode) OR (@TypeCode IS NULL) OR (@TypeCode  = ''))    
AND  ((EC.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = ''))  
GROUP BY EA.AssetId, EA.AssetNo, FAC.FacilityName    
    
declare @FacilityNamePraram nvarchar(1024)    
declare @TypeCodeName nvarchar(1024)    
if(isnull(@Facilityid,'') <> '')    
begin    
 SELECT @FacilityNamePraram = FacilityName from mstlocationfacility WITH (NOLOCK) WHERE facilityid = @Facilityid    
end    
if(isnull(@TypeCode,'') <> '')    
begin    
 SELECT @TypeCodeName = AssetTypeCode from EngAssetTypeCode WITH (NOLOCK) WHERE AssetTypeCodeId = @TypeCode    
end    
    




declare @GrandTotalPercentage numeric(24,2) 

declare @mPassCount int = (select sum(PassCount) from @@ER_Parameter_Report)

declare @mFailCount int = (select sum(FailCount) from @@ER_Parameter_Report)
set @GrandTotalPercentage = ( cast( @mPassCount as numeric(10,2)) / (    cast( @mPassCount as numeric(10,2)) + cast( @mFailCount as numeric(10,2))    )   *100   )




SELECT *  , CAST(( cast(   PassCount as numeric(10,2))/ (cast(PassCount as numeric(10,2)) + cast(FailCount as numeric(10,2))) ) *100 AS NUMERIC(24,2)) AS Percentage, @GrandTotalPercentage as GrandTotalPercentage
,  ISNULL(@From_Date, '') as FromDateParam, ISNULL(@To_Date, '') as ToDateParam  
,  ISNULL(@FacilityNamePraram, '') as FacilityNameParam   
,  ISNULL(@TypeCodeName,'') as AssetTypeCode, isnull(@Level, '') as LevelParam   
FROM @@ER_Parameter_Report    
    
END TRY      
BEGIN CATCH      
      
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)      
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())      
      
END CATCH      
SET NOCOUNT OFF      
      
END
GO
