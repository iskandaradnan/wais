USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[OtherEodParameterAnalysisRpt_L2_Body]    Script Date: 20-09-2021 16:42:59 ******/
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
EXEC Asis_EodParameterAnalysisRpt_L1 @From_Date='2016-11-23 09:35:00.000',@To_Date='2019-11-23 09:35:00.000',@Facilityid = 1, @TypeCode =1057 
EXEC Asis_EodParameterAnalysisRpt_L1 @From_Date='',@To_Date='',@Facilityid = 
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Modification History        
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
CREATE   PROCEDURE  [dbo].[OtherEodParameterAnalysisRpt_L2_Body](
								@Level			VARCHAR(20) = NULL,
								@AssetNo		VARCHAR(50) = '',
							    @Facilityid   VARCHAR(50) = '',							
								@TypeCodeId varchar(200) = ''	,
								@From_Date  VARCHAR(50) = '',  
                                @To_Date  VARCHAR(50) = ''
								)
AS
BEGIN
  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

declare  @From_Date_local datetime, @to_Date_local datetime    
Select    asset.AssetNo
		,capture.CaptureDocumentNo
        ,FORMAT( capture.RecordDate ,'dd-MMM-yyyy HH:mm') as RecordDate
        ,FORMAT( capture.NextCaptureDate,'dd-MMM-yyyy') as NextCaptureDate
		,capDet.ParamterValue
		,Uom.UnitOfMeasurement
		,capDet.Minimum
		,capDet.Maximum
		,capDet.ActualValue
		,(case when capDet.Status = 1 then 'Pass' else 'Fail' end ) Status
 from EngEODCaptureTxn capture 
left join EngEODCaptureTxnDet  capDet on capture.CaptureId = capDet.CaptureId
left join EngAssetTypeCode  typecode on typecode.AssetTypeCodeId = capture.AssetTypeCodeId
left join EngAsset  asset on asset.AssetId = capture.AssetId
left join FMUOM  Uom on Uom.UOMId = capDet.UOMId
Where asset.AssetNo= @AssetNo
AND ((capture.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = ''))  
AND CONVERT(DATE,capture.RecordDate) BETWEEN CAST(ISNULL(@From_Date_local, capture.RecordDate) AS DATE) AND CAST(ISNULL(@to_Date_local, capture.RecordDate) AS DATE)    
  
AND	((ISNULL(capDet.status,0) = @Level) OR (@Level IS NULL) OR (@Level = ''))
END TRY    
BEGIN CATCH    
    
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
SET NOCOUNT OFF    
    
END
GO
