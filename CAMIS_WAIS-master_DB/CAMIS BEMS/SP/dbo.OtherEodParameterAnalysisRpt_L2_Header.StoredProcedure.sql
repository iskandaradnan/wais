USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[OtherEodParameterAnalysisRpt_L2_Header]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE   PROCEDURE  [dbo].[OtherEodParameterAnalysisRpt_L2_Header](
								@Level			VARCHAR(20) = NULL,
								@AssetNo		VARCHAR(50) = '',
							    @Facilityid   VARCHAR(50) = '',							
								@TypeCodeId varchar(200) = ''	
								) 
AS
BEGIN
  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
Select  top 1  asset.AssetNo
		,asset.AssetDescription
        ,typecode.AssetTypeCode
        ,area.UserAreaCode
		,area.UserAreaName
		,location.UserLocationCode
		,location.UserLocationName
		,class.AssetClassificationDescription
		,class.AssetClassificationCode
 from EngEODCaptureTxn capture 
inner join EngAssetTypeCode  typecode on typecode.AssetTypeCodeId = capture.AssetTypeCodeId
inner join EngAsset  asset on asset.AssetId = capture.AssetId
inner join MstLocationUserArea  area on area.UserAreaId = capture.UserAreaId
inner join MstLocationUserLocation  location on location.UserLocationId = capture.UserLocationId
inner join EngAssetClassification  class on class.AssetClassificationId = capture.AssetClassificationId
Where asset.AssetNo= @AssetNo
  
END TRY    
BEGIN CATCH    
    
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
SET NOCOUNT OFF    
    
END
GO
