USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenItemTxnDet_FetchLinenDetails]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
---EXEC LLSCleanLinenIssueLinenItemTxnDet_FetchLinenDetails ''    
      
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueLinenItemTxnDet_FetchLinenDetails]      
@CleanLinenRequestId AS INT    
    
AS      
BEGIN      
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
      
      
SELECT    
C.LinenCode    
,C.LinenDescription    
,D.AgreedShelfLevel    
,A.RequestedQuantity    
,E.StoreBalance    
    
FROM dbo.LlsCleanLinenRequestLinenItemTxnDet A    
INNER JOIN dbo.LlsCleanLinenRequestTxn B    
ON A.CleanLinenRequestId = B.CleanLinenRequestId    
    
INNER JOIN dbo.LLSLinenItemDetailsMst C    
ON A.LinenItemId = C.LinenItemId    
    
INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet D    
ON A.LinenItemId = D.LinenItemId    
AND B.LLSUserAreaId = D.LLSUserAreaId     
AND B.CustomerId = C.CustomerId    
AND B.FacilityId = C.FacilityId    
    
INNER JOIN dbo.LLSCentralCleanLinenStoreMstDet E    
ON A.LinenItemId = E.LinenItemId    
WHERE A.CleanLinenRequestId = @CleanLinenRequestId     
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
