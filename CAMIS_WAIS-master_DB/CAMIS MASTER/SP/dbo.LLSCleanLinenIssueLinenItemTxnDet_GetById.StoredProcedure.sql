USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenItemTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
                          
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueLinenItemTxnDet_GetById]                          
(                          
 @Id INT                          
)                          
                           
AS                           
    -- Exec [LLSCleanLinenIssueLinenItemTxnDet_GetById] 67                       
                        
--/*=====================================================================================================================                        
--APPLICATION  : UETrack                        
--NAME    : LLSCleanLinenIssueLinenItemTxnDet_GetById                       
--DESCRIPTION  : GETS THE License LLSCleanLinenIssueLinenItemTxnDet                        
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
                           
SELECT                      
 A.CleanLinenIssueId,                    
 C.LinenCode,                      
 C.LinenDescription,                      
 E.AgreedShelfLevel,                      
 F.RequestedQuantity,                      
 A.DeliveryIssuedQty1st,                      
 A.DeliveryIssuedQty2nd,                      
COALESCE(F.RequestedQuantity,0)-                      
COALESCE(A.DeliveryIssuedQty1st,0)-                       
COALESCE(A.DeliveryIssuedQty2nd, 0) AS                      
Shortfall,                      
--0 AS StoreBalance          
G.OpeningBalance AS StoreBalance,                      
 A.Remarks ,            
 A.CLILinenItemId ,    
 A.LinenitemId    
                      
FROM dbo.LLSCleanLinenIssueLinenItemTxnDet A                      
                      
INNER JOIN dbo.LLSCleanLinenIssueTxn B                      
ON A.CleanLinenIssueId = B.CleanLinenIssueId                      
                      
                      
INNER JOIN dbo.LLSLinenItemDetailsMst C                      
ON A.LinenItemId = C.LinenItemId                      
                      
INNER JOIN dbo.LLSCleanLinenRequestTxn D                      
ON B.CleanLinenRequestId =D.CleanLinenRequestId                      
                      
INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet E                      
ON A.LinenItemId =E.LinenItemId                      
AND D.LLSUserAreaLocationId = E.UserLocationId                      
                      
INNER JOIN dbo.LlsCleanLinenRequestLinenItemTxnDet F                      
ON A.CleanLinenIssueId =F.CleanLinenIssueId                      
AND A.Linenitemid = F.Linenitemid                      
                      
INNER JOIN dbo.LLSCentralCleanLinenStoreMstDet G                      
ON C.LinenItemId =G.LinenItemId                       
                      
WHERE A.CleanLinenIssueId=@Id        
AND (A.IsDeleted IS NULL OR A.IsDeleted = 0)    
AND (E.IsDeleted IS NULL OR E.IsDeleted = 0)    
--AND E.IsDeleted<>1  
                      
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                          
SET NOCOUNT OFF                          
END    
    
GO
