USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
        
                    
                        
CREATE PROCEDURE [dbo].[LLSLinenAdjustmentTxn_GetById]                        
(                        
 @Id INT                        
)                        
                         
AS                         
    -- Exec [LLSLinenAdjustmentTxn_GetById] 140                  
                      
--/*=====================================================================================================================                      
--APPLICATION  : UETrack                      
--NAME    : LLSLinenAdjustmentTxn_GetById                     
--DESCRIPTION  : GETS THE LLSLinenCondemnation                    
--AUTHORS   : SIDDHANT                      
--DATE    : 16-JAN-2020                      
-------------------------------------------------------------------------------------------------------------------------                      
--VERSION HISTORY                       
--------------------:---------------:---------------------------------------------------------------------------------------                      
--Init    : Date          : Details                      
--------------------:---------------:---------------------------------------------------------------------------------------                      
--SIDDHANT           : 16-JAN-2020 :                       
-------:------------:----------------------------------------------------------------------------------------------------*/                      
                      
BEGIN                        
SET NOCOUNT ON                        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
BEGIN TRY                        
                         
SELECT                
 A.LinenAdjustmentId,                
 A.DocumentNo,                  
 A.DocumentDate,                  
 C.StaffName AS AuthorisedBy,           
 C.UserRegistrationId AS hdnTypeCodeId,          
 B.DocumentNo AS LinenInventoryDocumentNo,                  
 A.Date,                  
 D.LovId AS Status,                  
 A.Remarks                  
FROM dbo.LLSLinenAdjustmentTxn A                  
Left JOIN dbo.LLSLinenInventoryTxn B                  
ON A.LinenInventoryId =B.LinenInventoryId                  
INNER JOIN dbo.UMUserRegistration C                  
ON A.AuthorisedBy=C.UserRegistrationId                  
INNER JOIN dbo.FMLovMst D                  
ON A.Status = D.LovId                  
WHERE LinenAdjustmentId=@Id       
--AND A.IsDeleted IS NULL    
AND ISNULL(A.IsDeleted,'')=''      
AND ISNULL(B.IsDeleted,'')=''      
      
                  
END TRY                        
BEGIN CATCH                        
                        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                        
                        
THROW                        
                        
END CATCH                        
SET NOCOUNT OFF                        
END 
GO
