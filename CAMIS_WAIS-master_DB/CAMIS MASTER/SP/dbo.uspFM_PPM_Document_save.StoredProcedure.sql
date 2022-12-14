USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPM_Document_save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : [uspFM_PPM_Document_save]      
Description   : Insert  
Authors    : Vijay V      
Date    : 02-APR-2020     
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
     
      
SELECT * FROM FMDocument      
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init :  Date       : Details      
========================================================================================================*/      
      
CREATE PROCEDURE  [dbo].[uspFM_PPM_Document_save]     
  @pType_Of_Planner int,      
   @pYear     int,      
        @pWeek_No       INT   ,    
  @pStart_Date datetime,  
  @pEnd_Date datetime,  
  @pGenerated_On datetime,  
  @pPrint_File varchar(50),  
  @puniq varchar(50)  
  
  
  
      
AS                                                    
      
BEGIN TRY      
      
      
-- Declaration      
     
       
 DECLARE @uniq  INT    
   
      
      
      
      
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------      
   SELECT  @uniq= uniq from PPM_Document where uniq=@puniq  
  
    
    
    
  
      
      
      
    
    
      
END TRY      
      
BEGIN CATCH      
      
     
      
 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     );      
THROW;      
END CATCH
GO
