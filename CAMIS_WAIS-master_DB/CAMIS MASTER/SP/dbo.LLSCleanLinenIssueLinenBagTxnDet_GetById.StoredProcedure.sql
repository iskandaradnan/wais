USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenBagTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                    
                        
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueLinenBagTxnDet_GetById]                         
(                        
 @Id INT                        
)                        
                         
AS                         
    -- Exec [LLSCleanLinenIssueLinenBagTxnDet_GetById ] 68                     
                      
--/*=====================================================================================================================                      
--APPLICATION  : UETrack                      
--NAME    : LLSCleanLinenIssueLinenBagTxnDet_GetById                      
--DESCRIPTION  : GETS THE LLSCleanLinenIssueLinenBagTxnDet                      
--AUTHORS   : SIDDHANT                      
--DATE    : 4-FEB-2020                      
-------------------------------------------------------------------------------------------------------------------------                      
--VERSION HISTORY                       
--------------------:---------------:---------------------------------------------------------------------------------------                      
--Init    : Date          : Details                      
--------------------:---------------:---------------------------------------------------------------------------------------                      
--SIDDHANT           : 4-FEB-2020 :                       
-------:------------:----------------------------------------------------------------------------------------------------*/                      
                      
BEGIN                        
SET NOCOUNT ON                        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
BEGIN TRY                        
      
DECLARE @RequestedQuantity INT      
SET @RequestedQuantity=      
(      
SELECT SUM(B.RequestedQuantity) AS RequestedQuantity      
FROM dbo.LLSCleanLinenIssueLinenBagTxnDet A                 
INNER JOIN dbo.LLSCleanLinenRequestLinenBagTxnDet B                     
ON A.CleanLinenIssueId = B.CleanLinenIssueId                    
AND A.LaundryBag = B.LaundryBag                     
WHERE A.CleanLinenIssueId=@Id                   
)      
      
--SELECT @RequestedQuantity      
      
      
      
                         
SELECT                   
 FMLovMst1.FieldValue AS LaundryBag,                    
 B.RequestedQuantity,                    
 A.IssuedQuantity,                    
 (B.RequestedQuantity - A.IssuedQuantity) AS Shortfall,                    
A.Remarks ,                 
  A.LaundryBag AS LovId ,          
  A.CLILinenBagId,      
  @RequestedQuantity AS TotalRequestedQuantity      
FROM dbo.LLSCleanLinenIssueLinenBagTxnDet A                    
INNER JOIN dbo.FMLovMst AS FMLovMst1                     
ON A.LaundryBag = FMLovMst1.LovId                    
                    
INNER JOIN dbo.LLSCleanLinenRequestLinenBagTxnDet B                     
ON A.CleanLinenIssueId = B.CleanLinenIssueId                    
AND A.LaundryBag = B.LaundryBag                     
                    
WHERE A.CleanLinenIssueId=@Id                    
AND ISNULL(A.IsDeleted,'')=''  
                    
END TRY                        
BEGIN CATCH                        
                        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                        
                        
THROW                        
                        
END CATCH                        
SET NOCOUNT OFF                        
END 
GO
