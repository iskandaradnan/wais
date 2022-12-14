USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[getTypeofRequsetbyServiceid]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_Dropdown    
Description   : Get lov values by passing LovKeys.    
Authors    : Dhilip V    
Date    : 02-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC uspFM_Dropdown  @pLovKey='CRMRequestTypeValue'    
EXEC uspFM_Dropdown 'RiskRatingValue,MaintenanceFlagValue,EquipmentFunctionDescriptionValue,YesNoValue,TypeCodeSpecTypeValue,TypeCodeSpecUnitValue'    
SELECT * FROM FMLovMst    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
2  04/07/2018 COMMA SEPARATED    
========================================================================================================*/    
CREATE PROCEDURE  [dbo].[getTypeofRequsetbyServiceid]                               
  @id int   
AS                                                  
    
BEGIN TRY    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
-- Declaration    
    
-- Default Values    
    
-- Execution    
 IF  (@id=1)     
  BEGIN    
     SELECT LovId,FieldValue FROM FMLovMst WHERE LovKey='CRMRequestTypeValue' and LovId NOT in(133,136,137,135,138,374,10022) order by FieldCode;
  END    
 ELSE IF  (@id=2)     
  BEGIN    
SELECT LovId,FieldValue FROM FMLovMst WHERE LovKey='CRMRequestTypeValue' and LovId NOT in(133) order by FieldCode;    
  END    
 ELSE  
  BEGIN    
  SELECT LovId,FieldValue FROM FMLovMst WHERE LovKey='CRMRequestTypeValue' and LovId in(134,10020,10021,10801) order by FieldCode;    

  END    
  -- ELSE IF  (@id=4)     
  --BEGIN    
  --SELECT * FROM FMLovMst WHERE LovKey='CRMRequestTypeValue' and LovId in(134,10020,10021);    

  --END 
  -- ELSE IF  (@id=5)     
  --BEGIN    
  --SELECT * FROM FMLovMst WHERE LovKey='CRMRequestTypeValue' and LovId NOT in(133,136,137,135,138,374,10022);    

  --END 
 --ELSE    
    
 -- BEGIN    
   
    
   --select * into #temp from dbo.[SplitString] (@pLovKey,',')    
    
   SELECT LovMst.LovId  AS LovId,    
     LovMst.FieldValue AS FieldValue,    
     LovMst.LovKey  AS LovKey ,    
     LovMst.IsDefault AS IsDefault    
   FROM FMLovMst AS LovMst WITH(NOLOCK)    
   WHERE Active = 1     
     AND LTRIM(RTRIM(UPPER(LovKey))) IN (SELECT UPPER(LTRIM(RTRIM(ITEM))) AS ITEM from dbo.[SplitString] (@id,','))       
     --AND LTRIM(RTRIM(UPPER(LovKey))) IN (SELECT UPPER(LTRIM(RTRIM(ITEM))) AS ITEM from #temp)     
   ORDER BY SortNo ASC    
      
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
GO
