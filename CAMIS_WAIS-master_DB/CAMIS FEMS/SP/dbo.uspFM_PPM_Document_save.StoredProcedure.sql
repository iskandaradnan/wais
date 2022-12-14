USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPM_Document_save]    Script Date: 20-09-2021 16:56:53 ******/
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
  @pType_Of_Planner varchar(50),              
   @pYear     int,              
        @pWeek_No       INT   ,            
  @pStart_Date datetime,          
  @pEnd_Date datetime,          
  @pGenerated_On datetime,          
  @pPrint_File varchar(50),          
  @puniq varchar(50),          
  @pFacilityId int  ,      
  @pclass int        
          
          
          
              
AS                                                            
              
BEGIN TRY              
              
              
-- Declaration              
             
               
 DECLARE @uniq  INT            
  DECLARE @Typeofworkorder  varchar(50)        
              
              
              
              
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------              
   SELECT  @uniq=count(uniq) from PPM_Document where uniq=@puniq          
   SELECT  @Typeofworkorder=FieldValue from FMLovMst where LovId=@pType_Of_Planner    
            
            
  IF (@uniq>0)          
      select * from PPM_Document           
ELSE           
       insert into PPM_Document( Type_Of_Planner,Year,Week_No,Start_Date,End_Date,Generated_On,Print_File,Uniq,FacilityId,WorkGroup) values(@Typeofworkorder,@pYear,@pWeek_No,@pStart_Date,@pEnd_Date,@pGenerated_On,@pPrint_File,@puniq,@pFacilityId,@pclass)
  
    
          
          
              
              
              
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
