USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSDriverDetailsMst_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                  
--APPLICATION  : UETrack 1.5                  
--NAME    : LLSDriverDetailsMstDet_Delete                 
--DESCRIPTION  : DELETE RECORD  (UPDATE ISELDETED COLUMN) IN [LLSDriverDetailsMstDet] TABLE                   
--AUTHORS   : SIDDHANT                  
--DATE    : 13-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT          : 13-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                
              
                  
CREATE PROCEDURE  [dbo].[LLSDriverDetailsMst_Delete]                                             
                  
(                  
@ID AS INT  
,@ModifiedBy AS INT
)                        
                  
AS                        
                  
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                
             
                 
                
--UPDATE LLSDriverDetailsMstDet                
--SET IsDeleted = 1              
--WHERE DriverId = @ID           
----WHERE DriverId IN (SELECT ITEM FROM dbo.[SplitString] ( @ID,','))            
              
--END TRY                  
--BEGIN CATCH                  
-- --SELECT 'This record can''t be deleted as it is referenced by another screen' AS ErrorMessage                 
          
UPDATE LLSDriverDetailsMst       
SET IsDeleted = 1          
,ModifiedBy=@ModifiedBy
WHERE DriverId = @ID          
          
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
