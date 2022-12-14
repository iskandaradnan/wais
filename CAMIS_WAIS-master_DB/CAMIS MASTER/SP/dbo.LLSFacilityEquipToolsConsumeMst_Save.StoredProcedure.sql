USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSFacilityEquipToolsConsumeMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : LLSFacilityEquipToolsConsumeMst_Save             
--DESCRIPTION  : SAVE RECORD IN [LLSFacilityEquipToolsConsumeMst] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 8-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 9-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
        
       
          
CREATE PROCEDURE  [dbo].[LLSFacilityEquipToolsConsumeMst_Save]                                         
              
(              
 @Block As [dbo].[LLSFacilityEquipToolsConsumeMst] READONLY              
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
       
      
DECLARE @Table TABLE (ID INT)              
INSERT INTO LLSFacilityEquipToolsConsumeMst (            
 CustomerId,            
 FacilityId,            
 ItemCode,            
 ItemDescription,            
 ItemType,            
 Status,            
 EffectiveFromDate,            
 EffectiveToDate,            
 CreatedBy,             
 CreatedDate,            
 CreatedDateUTC,    
 ModifiedBy,    
ModifiedDate,    
ModifiedDateUTC    
     
 )            
  OUTPUT INSERTED.FETCId INTO @Table              
 SELECT  CustomerId,            
 FacilityId,            
 ItemCode,            
 ItemDescription,            
 ItemType,            
 Status,            
 EffectiveFromDate,   
 EffectiveToDate,  
 --CASE WHEN ISNULL(EffectiveToDate,'')='0001-01-01 00:00:00.0000000' THEN '' ELSE   ISNULL(EffectiveToDate,'') END,          
CreatedBy,            
GETDATE(),            
GETUTCDATE(),    
ModifiedBy,    
GETDATE(),            
GETUTCDATE()    
    
FROM @Block              
              
SELECT FETCId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSFacilityEquipToolsConsumeMst WHERE FETCId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END        
GO
