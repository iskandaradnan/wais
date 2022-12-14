USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSWeighingScaleMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : LLSWeighingScaleMst _Save           
--DESCRIPTION  : SAVE RECORD IN [LLSWeighingScaleMst] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 9-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 9-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
            
        
            
CREATE PROCEDURE  [dbo].[LLSWeighingScaleMst_Save]                                       
            
(            
 @Block As [dbo].[LLSWeighingScaleMst] READONLY            
)                  
            
AS                 
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
DECLARE @Table TABLE (ID INT)            
INSERT INTO LLSWeighingScaleMst (          
 CustomerId,          
 FacilityId,          
 IssuedBy,          
 ItemDescription,          
 SerialNo,          
 IssuedDate,          
 ExpiryDate,          
 Status,          
 CreatedBy,           
 CreatedDate,          
 CreatedDateUTC,  
 ModifiedBy,    
ModifiedDate,    
ModifiedDateUTC   
)  
           
  OUTPUT INSERTED.WeighingScaleId INTO @Table            
 SELECT CustomerId,          
 FacilityId,          
 IssuedBy,          
 ItemDescription,          
 SerialNo,          
 IssuedDate,          
 ExpiryDate,          
 Status,          
CreatedBy,          
GETDATE(),          
GETUTCDATE(),   
ModifiedBy,        
GETDATE(),        
GETUTCDATE()          
FROM @Block            
            
SELECT WeighingScaleId          
      ,[Timestamp]          
   ,'' ErrorMsg    ,      
      GuId           
FROM LLSWeighingScaleMst WHERE WeighingScaleId IN (SELECT ID FROM @Table)            
            
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END

GO
