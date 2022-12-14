USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_ReportHeaderParamName]    Script Date: 20-09-2021 17:05:50 ******/
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
-- =============================================      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
EXEC [usp_ReportHeaderParamName] @ParamName = 'Year', @ParamValue = 1  
EXEC [usp_ReportHeaderParamName] @ParamName = 'AssetTypeCodeId', @ParamValue = 1  

EXEC [usp_ReportHeaderParamName] @ParamName = 'Month', @ParamValue = 11  
EXEC [usp_ReportHeaderParamName] @ParamName = 'Indicator', @ParamValue = 1  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/             
    
CREATE PROCEDURE [dbo].[usp_ReportHeaderParamName](  @ParamName   VARCHAR(500) = '',  
             @ParamValue   VARCHAR(500) = ''  
               
               )    
AS    
BEGIN    
    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
BEGIN TRY    
  
 IF(@ParamName = 'Facilityid')  
BEGIN   
 SELECT FacilityName  as ParamNameValue FROM MstLocationFacility WHERE Facilityid = @ParamValue  
   
END  
  
IF(@ParamName = 'Customerid')  
BEGIN   
 SELECT CustomerName ParamNameValue FROM MstCustomer WHERE Customerid = @ParamValue  
END  
  
IF(@ParamName = 'Serviceid')  
BEGIN   
 SELECT ServiceName FROM MstService WHERE Serviceid = @ParamValue  
END  
  
IF(@ParamName = 'AssetTypeCodeId')  
BEGIN   
 SELECT AssetTypeCode ParamNameValue FROM EngAssetTypeCode WHERE AssetTypeCodeId = @ParamValue  
END  
  
IF(@ParamName = 'Year')  
BEGIN   
 SELECT @ParamValue as ParamNameValue  
END 
------------------
IF(@ParamName = 'Month')  
BEGIN   

declare @MonthDesc varchar(30)

	set @MonthDesc= (Select DateName( month , DateAdd( month , cast(@ParamValue as int) , -1 ) ))

 SELECT @MonthDesc as ParamNameValue  
END 
 ------------------
IF(@ParamName = 'ScheduleType')  
BEGIN   
 SELECT FieldValue ParamNameValue FROM FMLovMst WHERE LovId = @ParamValue  
END  
IF(@ParamName = 'TaskCodeOption')  
BEGIN   
 SELECT FieldValue ParamNameValue FROM FMLovMst WHERE LovId = @ParamValue  
END  
IF(@ParamName = 'EngPlannerStatus')  
BEGIN   
 SELECT FieldValue ParamNameValue FROM FMLovMst WHERE LovId = @ParamValue  
END  
------------------
IF(@ParamName = 'Indicator')  
BEGIN   
 SELECT IndicatorCode ParamNameValue FROM MstQAPIndicator WHERE QAPIndicatorId = @ParamValue  
END  
------------------
        
        
        
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)      
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())      
      
END CATCH      
SET NOCOUNT OFF      
END
GO
