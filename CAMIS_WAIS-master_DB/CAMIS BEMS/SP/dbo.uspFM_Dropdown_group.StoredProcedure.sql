USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Dropdown_group]    Script Date: 20-09-2021 17:05:51 ******/
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
EXEC uspFM_Dropdown  @pLovKey='StatusValue'  
EXEC uspFM_Dropdown 'RiskRatingValue,MaintenanceFlagValue,EquipmentFunctionDescriptionValue,YesNoValue,TypeCodeSpecTypeValue,TypeCodeSpecUnitValue'  
SELECT * FROM EngAssetWorkGroup  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
2  04/07/2018 COMMA SEPARATED  
exec [uspFM_Dropdown_group] 
========================================================================================================*/  
create PROCEDURE  [dbo].[uspFM_Dropdown_group]                             
 
AS                                                
  
BEGIN TRY  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
   DECLARE @mtypes BIT = 1    
-- Default Values  
  
-- Execution  

  BEGIN  
   select WorkGroupId  as LovId,WorkGroupDescription as FieldValue,WorkGroupCode as LovKey,@mtypes as IsDefault from  EngAssetWorkGroup
  END  
select WorkGroupId  as LovId,WorkGroupDescription as FieldValue,WorkGroupCode as LovKey,@mtypes as IsDefault from  EngAssetWorkGroup
  
  
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
