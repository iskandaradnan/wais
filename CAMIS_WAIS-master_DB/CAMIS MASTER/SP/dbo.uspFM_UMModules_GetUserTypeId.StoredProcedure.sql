USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMModules_GetUserTypeId]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_UMModules_GetUserTypeId  
Description   : Get the Modules details by passing the UserType Id.  
Authors    : Dhilip V  
Date    : 24-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC uspFM_UMModules_GetUserTypeId  @pUserTypeId=2 
select * from FMModules
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[uspFM_UMModules_GetUserTypeId]                             
  
  @pUserTypeId  INT,  
  @pModuleId  INT = NULL  
  
AS                                                 
  
BEGIN TRY  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
  
  
-- Default Values  
  
  
-- Execution  
  
  
 IF(ISNULL(@pUserTypeId,0) = 0) RETURN  
  
 SELECT DISTINCT Modules.ModuleId  AS LovId,  
   Modules.ModuleName     AS FieldValue,  
   0         AS  IsDefault  
  FROM UMScreen AS Screen WITH(NOLOCK)  
   INNER JOIN UMScreenUserTypeMapping AS ScreenMapping WITH(NOLOCK) ON Screen.ScreenId = ScreenMapping.ScreenId  
   INNER JOIN FMModules AS Modules WITH(NOLOCK) ON Screen.ModuleId = Modules.ModuleId  
 WHERE ScreenMapping.UserTypeId = @pUserTypeId and  Modules.Active=1
 ORDER BY Modules.ModuleName ASC  
  
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
