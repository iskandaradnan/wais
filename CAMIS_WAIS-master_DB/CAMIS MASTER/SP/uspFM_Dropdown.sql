
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_Dropdown  
Description   : Get lov values by passing LovKeys.  
Authors    : Dhilip V  
Date    : 02-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC uspFM_Dropdown  @pLovKey='StatusValue'  
EXEC uspFM_Dropdown 'RiskRatingValue,MaintenanceFlagValue,EquipmentFunctionDescriptionValue,YesNoValue,TypeCodeSpecTypeValue,TypeCodeSpecUnitValue'  
SELECT * FROM FMLovMst  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
2  04/07/2018 COMMA SEPARATED  
========================================================================================================*/  
ALTER PROCEDURE  [dbo].[uspFM_Dropdown]                             
  @pLovKey   nvarchar(4000)  
AS                                                
  
BEGIN TRY  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
  
-- Default Values  
  
-- Execution  
 IF  (@pLovKey='CommonGender')   
  BEGIN  
   SELECT LovId  AS LovId,  
     FieldValue AS FieldValue,  
     LovKey  AS LovKey,  
     IsDefault AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey='CommonGender'  
  END  
 ELSE IF  (@pLovKey='CustomerThemeColor')   
  BEGIN  
   SELECT LovId  AS LovId,  
     FieldValue AS FieldValue,  
     LovKey  AS LovKey,  
     IsDefault AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey='CustomerThemeColor'  
  END  
 ELSE IF  (@pLovKey='StatusValue')   
  BEGIN  
   SELECT LovId  AS LovId,  
     FieldValue AS FieldValue,  
     LovKey  AS LovKey ,  
     IsDefault AS IsDefault  
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey='StatusValue'  
  END  
  
 ELSE  
  
  BEGIN  
  
  
   --select * into #temp from dbo.[SplitString] (@pLovKey,',')  
  
   SELECT LovMst.LovId  AS LovId,  
     LovMst.FieldValue AS FieldValue,  
     LovMst.LovKey  AS LovKey ,  
     LovMst.IsDefault AS IsDefault  
   FROM FMLovMst AS LovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LTRIM(RTRIM(UPPER(LovKey))) IN (SELECT UPPER(LTRIM(RTRIM(ITEM))) AS ITEM from dbo.[SplitString] (@pLovKey,','))     
     --AND LTRIM(RTRIM(UPPER(LovKey))) IN (SELECT UPPER(LTRIM(RTRIM(ITEM))) AS ITEM from #temp)   
   ORDER BY SortNo ASC  
    
  END   
  
  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH