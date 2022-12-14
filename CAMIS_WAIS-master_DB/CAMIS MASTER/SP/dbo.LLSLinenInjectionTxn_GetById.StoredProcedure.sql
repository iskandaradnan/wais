USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
                
                    
CREATE PROCEDURE [dbo].[LLSLinenInjectionTxn_GetById]                    
(                    
 @Id INT                    
)                    
                     
AS                     
    -- Exec [LLSLinenInjectionTxn_GetById] 135                 
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack                  
--NAME    : LLSLinenInjectionTxn_GetById                 
--DESCRIPTION  : GETS THE LLSLinenInjectionTxn                
--AUTHORS   : SIDDHANT                  
--DATE    : 20-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT           : 20-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                  
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                     
SELECT             
 A.LinenInjectionId,            
 A.DocumentNo,              
 A.InjectionDate,              
 A.DONo,
 A.PONo,
 A.DODate,
 A.Remarks,      
 A.GuId    
FROM dbo.LLSLinenInjectionTxn A              
--INNER JOIN dbo.PMSDeliveryOrderMst B               
--ON A.DOId =B.DOId              
WHERE LinenInjectionId=@Id             
AND ISNULL(IsDeleted,'')=''        
                
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END
GO
