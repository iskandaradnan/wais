USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLaundryPlantMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================              
APPLICATION  : UETrack 1.5              
NAME    : SaveUserAreaDetailsLLS             
DESCRIPTION  : SAVE RECORD IN [LLSLaundryPlantMst] TABLE               
AUTHORS   : SIDDHANT              
DATE    : 8-JAN-2020            
-----------------------------------------------------------------------------------------------------------------------              
VERSION HISTORY               
------------------:---------------:---------------------------------------------------------------------------------------              
Init    : Date          : Details              
------------------:---------------:---------------------------------------------------------------------------------------              
SIDDHANT          : 8-JAN-2020 :               
-----:------------:----------------------------------------------------------------------------------------------------*/              
         
--DROP PROCEDURE LLSLaundryPlantMst_Save         
              
CREATE PROCEDURE  [dbo].[LLSLaundryPlantMst_Save]                                         
(              
 @LaundryPlant As [dbo].[LLSLaundryPlantMst] READONLY              
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
              
INSERT INTO [dbo].[LLSLaundryPlantMst]          
           (          
     [CustomerId]          
           ,[FacilityId]          
           ,[LaundryPlantCode]          
           ,[LaundryPlantName]          
           ,[Ownership]          
           ,[Capacity]          
           ,[ContactPerson]          
           ,[Status]          
           ,[CreatedBy]          
           ,[CreatedDate]          
           ,[CreatedDateUTC]          
           ,[ModifiedBy]          
           ,[ModifiedDate]          
           ,[ModifiedDateUTC]          
                
                          
           )           
     OUTPUT INSERTED.LaundryPlantId INTO @Table              
 SELECT      [CustomerId]          
           ,[FacilityId]          
           ,[LaundryPlantCode]          
           ,[LaundryPlantName]          
           ,[Ownership]          
           ,[Capacity]          
           ,[ContactPerson]          
           ,[Status]          
           ,CreatedBy            
     ,GETDATE()            
      ,GETUTCDATE()            
           ,ModifiedBy            
     ,GETDATE()            
      ,GETUTCDATE()            
FROM @LaundryPlant              
              
SELECT LaundryPlantId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSLaundryPlantMst WHERE LaundryPlantId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END
GO
