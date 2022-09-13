USE [uetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Dropdown]    Script Date: 12/22/2021 1:21:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_Dropdown  
Description   : Get lov values by passing LovKeys with Module & Screen name.  
Authors    : Balaganesh  
Date    : 22-Decemeber-2021  
-----------------------------------------------------------------------------------------------------------  
 
Unit Test:  

EXEC uspFM_Dropdown_By_ModuleScreen 'LicenseTypeValue' ,'LLS','License Type' 
SELECT * FROM FMLovMst  
-----------------------------------------------------------------------------------------------------------  
Version History  
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
 
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[uspFM_Dropdown_By_ModuleScreen]                            
  @pLovKey   nvarchar(4000),
  @ModuleName   nvarchar(400),
  @ScreenName  nvarchar(400)
 
AS                                                
 
BEGIN TRY  
 
-- Paramter Validation  
 
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
 
-- Declaration  
 
-- Default Values  
 
-- Execution  
 SELECT LovMst.LovId  AS LovId,  
     LovMst.FieldValue AS FieldValue,  
     LovMst.LovKey  AS LovKey ,  
     LovMst.IsDefault AS IsDefault  
   FROM FMLovMst AS LovMst WITH(NOLOCK)  
   WHERE Active = 1  
     AND LTRIM(RTRIM(UPPER(LovKey))) IN (SELECT UPPER(LTRIM(RTRIM(ITEM))) AS ITEM from dbo.[SplitString] (@pLovKey,','))    
     AND ModuleName=  @ModuleName AND ScreenName=@ScreenName
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

