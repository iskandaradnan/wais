USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_EodParameterAnalysisRpt_L1_Details]    Script Date: 20-09-2021 16:42:59 ******/
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
Report Parent SP : Asis_EodParameterAnalysisRpt_L1    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          
EXEC Asis_EodParameterAnalysisRpt_L1 @MenuName = '' , @Level='consortia',@Option='',@service=2, @Frequency='yearly',@Frequency_Key='',@Year='2018',@From_Date='',@To_Date=''       
EXEC Asis_EodParameterAnalysisRpt_L1 @MenuName = '' , @Level='consortia',@Option='',@service=2, @Frequency='halfyear',@Frequency_Key='H2',@Year='2018',@From_Date='',@To_Date=''     
EXEC [Asis_EodParameterAnalysisRpt_L1_Details] @Facilityid = 1, @AssetNo = 'PANH00066' , @Level = 1
EXEC [Asis_EodParameterAnalysisRpt_L1_Details] @Facilityid = 1  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
Modification History          
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                       
CREATE PROCEDURE  [dbo].[Asis_EodParameterAnalysisRpt_L1_Details](    
         @Level   VARCHAR(20) = '',    
         @From_Date  VARCHAR(20) = '',    
         @To_Date  VARCHAR(20) = '',    
         @Facilityid  INT,    
         @TypeCode  INT = NULL,    
         @AssetNo  NVARCHAR(150) = ''
         --@STATUS	NVARCHAR(10) = ''  
         )    
AS    
BEGIN                                      
    
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
BEGIN TRY            
    
declare  @From_Date_local datetime, @to_Date_local datetime      
Declare  @Hospital_Master  table (  FacilityId int)                             
    

    
  
    
SELECT      
EA.AssetNo, EA.AssetDescription, EC.CaptureDocumentNo, EATC.AssetTypeCode, EATC.AssetTypeDescription, MLUA.UserAreaCode,     
MLUA.UserAreaName,MLIL.UserLocationName, EAC.AssetClassificationCode,FORMAT( EC.RecordDate ,'dd-MMM-yyyy HH:mm') as RecordDate,FORMAT( EC.NextCaptureDate ,'dd-MMM-yyyy') as NextCaptureDate,ECD.ParamterValue,     
ECD.Standard, ECD.Minimum, ECD.Maximum, ECD.ActualValue, ECD.Status, FU.UnitOfMeasurement, FU.UnitOfMeasurementDescription,     
case when ECD.Status = 2 then 'Fail' when ECD.Status = 1 then 'Pass' end as Status_Name    
  
FROM EngEODCaptureTxn EC  WITH (NOLOCK)          
JOIN EngEODCaptureTxnDet ECD WITH (NOLOCK) ON EC.CaptureId   = ECD.CaptureId     
JOIN engasset AS EA ON EA.ASSETID = EC.ASSETID     
JOIN EngAssetTypeCode AS EATC ON EATC.AssetTypeCodeId = EA.AssetTypeCodeId    
JOIN EngAssetClassification AS EAC ON EA.AssetClassification = EAC.AssetClassificationId    
INNER JOIN MstLocationFacility AS FAC ON FAC.FACILITYID = EC.FACILITYID    
INNER JOIN EngAssetStandardizationModel AS EASM ON EA.MODEL = EASM.ModelId    
INNER JOIN MstLocationUserArea AS MLUA ON MLUA.UserAreaId = EC.UserAreaId    
INNER JOIN MstLocationUserLocation AS MLIL ON MLIL.UserLocationId = EC.UserLocationId    
LEFT JOIN FMUOM AS FU ON FU.UOMID = ECD.UOMID    
WHERE ISNULL(ECD.status,0) in (1,2)  
AND	((ISNULL(ECD.status,0) = @Level) OR (@Level IS NULL) OR (@Level = ''))
AND CONVERT(DATE,EC.RecordDate) BETWEEN CAST(ISNULL(@From_Date_local, EC.RecordDate) AS DATE) AND CAST(ISNULL(@to_Date_local, EC.RecordDate) AS DATE)    
AND ((EA.AssetTypeCodeId = @TypeCode) OR (@TypeCode IS NULL) OR (@TypeCode  = ''))    
AND ((EC.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = ''))  
AND ((ea.assetno = @AssetNo) or (@AssetNo is null) or (@AssetNo = ''))    
  
END TRY      
BEGIN CATCH      
      
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)      
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())      
      
END CATCH      
SET NOCOUNT OFF      
      
END
GO
