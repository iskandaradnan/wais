USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenBagTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
                      
CREATE PROCEDURE [dbo].[LLSCleanLinenRequestLinenBagTxnDet_GetById]                      
(                      
 @Id INT                      
)                      
                       
AS                       
    -- Exec [LLSCleanLinenRequestLinenBagTxnDet_GetById] 135                   
                    
--/*=====================================================================================================================                    
--APPLICATION  : UETrack                    
--NAME    : LLSCleanLinenRequestLinenBagTxnDet_GetById                   
--DESCRIPTION  : GETS THE LLSCleanLinenRequestLinenBag                   
--AUTHORS   : SIDDHANT                    
--DATE    : 23-JAN-2020                    
-------------------------------------------------------------------------------------------------------------------------                    
--VERSION HISTORY                     
--------------------:---------------:---------------------------------------------------------------------------------------                    
--Init    : Date          : Details                    
--------------------:---------------:---------------------------------------------------------------------------------------                    
--SIDDHANT           : 23-JAN-2020 :                     
-------:------------:----------------------------------------------------------------------------------------------------*/                    
                    
BEGIN                      
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY                      
      
IF((SELECT DISTINCT ISNULL(A.CleanLinenIssueId,'') FROM LlsCleanLinenRequestLinenBagTxnDet A WHERE A.CleanLinenRequestId=@ID)<>'')      
      
BEGIN      
       
SELECT                  
FMLovMst1.FieldValue AS LaundryBag,                  
A.RequestedQuantity,                  
C.IssuedQuantity,                  
(A.RequestedQuantity - C.IssuedQuantity) AS Shortfall,                  
A.Remarks ,            
A.CLRLinenBagId            
FROM dbo.LlsCleanLinenRequestLinenBagTxnDet A                  
INNER JOIN dbo.LlsCleanLinenRequestTxn B                  
ON A.CleanLinenRequestId = B.CleanLinenRequestId                  
INNER JOIN dbo.FMLovMst AS FMLovMst1                   
ON A.LaundryBag = FMLovMst1.LovId                  
INNER JOIN dbo.LLSCleanLinenIssueLinenBagTxnDet C                  
ON A.CleanLinenIssueId =C.CleanLinenIssueId                  
AND A.LaundryBag =C.LaundryBag                   
WHERE A.CleanLinenRequestId=@Id          
AND  ISNULL(A.IsDeleted,'')=''         
                  
END      
ELSE      
BEGIN      
SELECT                  
FMLovMst1.FieldValue AS LaundryBag,                  
A.RequestedQuantity,                  
0 AS IssuedQuantity,                  
--(A.RequestedQuantity - C.IssuedQuantity) AS       
0 AS Shortfall,                  
A.Remarks ,            
A.CLRLinenBagId            
FROM dbo.LlsCleanLinenRequestLinenBagTxnDet A                  
INNER JOIN dbo.LlsCleanLinenRequestTxn B                  
ON A.CleanLinenRequestId = B.CleanLinenRequestId                  
INNER JOIN dbo.FMLovMst AS FMLovMst1                   
ON A.LaundryBag = FMLovMst1.LovId                  
--INNER JOIN dbo.LLSCleanLinenIssueLinenBagTxnDet C                  
--ON A.CleanLinenIssueId =C.CleanLinenIssueId                  
--AND A.LaundryBag =C.LaundryBag                   
WHERE A.CleanLinenRequestId=@Id          
AND  ISNULL(A.IsDeleted,'')=''         
       
      
END      
      
      
                  
                  
END TRY                      
BEGIN CATCH                      
                      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                      
                      
THROW                      
                      
END CATCH                     
SET NOCOUNT OFF                      
END 
GO
