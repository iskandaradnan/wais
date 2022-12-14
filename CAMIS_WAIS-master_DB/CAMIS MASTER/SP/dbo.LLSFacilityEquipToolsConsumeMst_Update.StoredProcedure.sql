USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSFacilityEquipToolsConsumeMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================                
APPLICATION  : UETrack 1.5                
NAME    : SaveUserAreaDetailsLLS               
DESCRIPTION  : UPDATE RECORD IN [LLSFacilityEquipToolsConsumeMst] TABLE            
        
exec LLSFacilityEquipToolsConsumeMst_Update         
AUTHORS   : SIDDHANT                
DATE    : 9-JAN-2020              
-----------------------------------------------------------------------------------------------------------------------                
VERSION HISTORY                 
------------------:---------------:---------------------------------------------------------------------------------------                
Init    : Date          : Details                
------------------:---------------:---------------------------------------------------------------------------------------                
SIDDHANT          : 9-JAN-2020 :                 
-----:------------:----------------------------------------------------------------------------------------------------*/                
              
                
              
              
                
CREATE PROCEDURE  [dbo].[LLSFacilityEquipToolsConsumeMst_Update]                                           
                
(                
 @ItemDescription AS nvarchar(200)            
,@ItemType AS NVARCHAR(40)            
,@Status AS INT            
,@EffectiveFromDate AS DATETIME            
,@EffectiveToDate AS DATETIME          
,@FETCId AS INT         
,@ModifiedBy AS INT       
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)                
              
UPDATE LLSFacilityEquipToolsConsumeMst              
SET              
 ItemDescription = @ItemDescription,              
 ItemType = @ItemType,              
 Status = @Status,              
 EffectiveFromDate = @EffectiveFromDate,              
 EffectiveToDate = @EffectiveToDate,              
 ModifiedBy = @ModifiedBy,              
 ModifiedDate = GETDATE(),              
 ModifiedDateUTC = GETUTCDATE()  
WHERE FETCId = @FETCId             
              
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
