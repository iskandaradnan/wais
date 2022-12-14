USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenDespatchTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
         
                  
CREATE PROCEDURE [dbo].[LLSCleanLinenDespatchTxnDet_GetById]                  
(                  
 @Id INT                  
)                  
                   
AS                   
                  
                
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                   
SELECT                
 B.LinenCode,                
 B.LinenDescription,      
 A.DespatchedQuantity,                
 A.ReceivedQuantity,                
 A.Variance,                
 A.Remarks,     
 A.LinenItemId,  
 A.CleanLinenDespatchDetId          
FROM                
 dbo.LLSCleanLinenDespatchTxnDet A                
 INNER JOIN dbo.LLSLinenItemDetailsMst B                
 ON A.LinenItemId =B.LinenItemId                 
 WHERE CleanLinenDespatchId=@Id      
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
