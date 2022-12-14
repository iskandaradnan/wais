USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenItemTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM LLSUserAreaDetailsLinenItemMstDet A      
--WHERE  A.UserLocationId=725      
--AND A.LinenItemId IN (520,529)      
      
--SELECT * FROM LLSUserAreaDetailsLocationMstDet      
--WHERE UserLocationCode='L4-OHR-010'      
                          
                              
      
      
CREATE PROCEDURE [dbo].[LLSCleanLinenRequestLinenItemTxnDet_GetById]                              
(                              
 @Id INT                              
)                              
                               
AS                               
    -- Exec [LLSCleanLinenRequestLinenItemTxnDet_GetById] 105443                           
                            
--/*=====================================================================================================================                            
--APPLICATION  : UETrack                            
--NAME    : LLSCleanLinenRequestLinenItemTxnDet_GetById                           
--DESCRIPTION  : GETS THE LLSCleanLinenRequestLinenItemTxnDet                           
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
    
    
       
        
        
IF((SELECT DISTINCT ISNULL(A.CleanLinenIssueId,null) FROM LlsCleanLinenRequestLinenItemTxnDet A WHERE A.CleanLinenRequestId=@Id)<>'')        
BEGIN        
                               
SELECT                       
C.LinenCode,                          
C.LinenDescription,                          
D.AgreedShelfLevel,                          
A.BalanceOnShelf,                          
A.RequestedQuantity,                          
E.DeliveryIssuedQty1st,                          
E.DeliveryIssuedQty2nd,                           
A.RequestedQuantity-(E.DeliveryIssuedQty1st+E.DeliveryIssuedQty2nd) AS Shortfall,                          
F.OpeningBalance AS StoreBalance, --F.StoreBalance                   
A.CLRLinenItemId,
A.LinenItemId
                          
FROM dbo.LlsCleanLinenRequestLinenItemTxnDet A                          
                          
INNER JOIN dbo.LlsCleanLinenRequestTxn B                          
ON A.CleanLinenRequestId = B.CleanLinenRequestId                          
                          
INNER JOIN dbo.LLSLinenItemDetailsMst C                           
ON A.LinenItemId = C.LinenItemId                          
                          
INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet D                          
ON A.LinenItemId =D.LinenItemId                          
AND B.LLSUserAreaLocationId =D.UserLocationId                           
AND B.CustomerId = C.CustomerId                          
AND B.FacilityId =C.FacilityId                          
                          
INNER JOIN dbo.LLSCleanLinenIssueLinenItemTxnDet E                          
ON  A.CleanLinenIssueId =E.CleanLinenIssueId                          
AND A.LinenItemId =E.LinenitemId                          
                          
INNER JOIN dbo.LLSCentralCleanLinenStoreMstDet F         
ON A.LinenItemId =F.LinenItemId                           
                          
WHERE A.CleanLinenRequestId=@Id              
AND ISNULL(A.IsDeleted,'')=''          
AND ISNULL(D.IsDeleted,'')=''            
  
END        
ELSE        
BEGIN        
        
SELECT                       
C.LinenCode,                          
C.LinenDescription,                          
D.AgreedShelfLevel,                    
A.BalanceOnShelf,                          
A.RequestedQuantity,                          
0 AS DeliveryIssuedQty1st,                          
0 AS DeliveryIssuedQty2nd,                           
--COALESCE(A.RequestedQuantity,E.DeliveryIssuedQty1st,E.DeliveryIssuedQty2nd, 0)         
0 AS Shortfall,                          
0 AS StoreBalance, --F.StoreBalance           
A.CLRLinenItemId,              
A.LinenItemId                          
FROM dbo.LlsCleanLinenRequestLinenItemTxnDet A                          
                          
INNER JOIN dbo.LlsCleanLinenRequestTxn B                          
ON A.CleanLinenRequestId = B.CleanLinenRequestId                          
                          
INNER JOIN dbo.LLSLinenItemDetailsMst C                           
ON A.LinenItemId = C.LinenItemId                          
                          
INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet D                          
ON A.LinenItemId =D.LinenItemId                          
AND B.LLSUserAreaLocationId =D.UserLocationId                           
AND B.CustomerId = C.CustomerId                          
AND B.FacilityId =C.FacilityId                          
                          
--INNER JOIN dbo.LLSCleanLinenIssueLinenItemTxnDet E                          
--ON                          
--A.CleanLinenIssueId =E.CleanLinenIssueId                          
--AND A.LinenItemId =E.LinenitemId                          
                          
--INNER JOIN dbo.LLSCentralCleanLinenStoreMstDet F                          
--ON A.LinenItemId =F.LinenItemId                           
                          
WHERE A.CleanLinenRequestId=@Id              
AND ISNULL(A.IsDeleted,'')=''            
AND ISNULL(D.IsDeleted,'')=''            
        
END        
         
        
END TRY                              
BEGIN CATCH                              
                              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                              
                              
THROW                              
                              
END CATCH                              
SET NOCOUNT OFF                              
END  
  
  
  
  
--SELECT * FROM LLSUserAreaDetailsLinenItemMstDet WHERE LINENITEMID=98  
GO
