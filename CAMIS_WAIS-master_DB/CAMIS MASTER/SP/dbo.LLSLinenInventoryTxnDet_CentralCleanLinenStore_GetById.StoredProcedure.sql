USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxnDet_CentralCleanLinenStore_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LLSLinenInventoryTxnDet_CentralCleanLinenStore_GetById]                
(                
 @Id INT                
)                
                 
AS                 
                
-- Exec LLSLinenInventoryTxnDet_CentralCleanLinenStore_GetById 142               
                
--/*=====================================================================================================================                
--APPLICATION  : UETrack                
--NAME    : LLSLinenInventoryTxnDet_CentralCleanLinenStore_GetById                
--DESCRIPTION  : LLSLinenInventoryTxnDet_CentralCleanLinenStore_GetById                
--AUTHORS   : SIDDHANT                
--DATE    : 14-FEB-2020                
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT           : 14-FEB-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
                 
SELECT         
 A.LinenInventoryId,      
 A.LlsLinenInventoryTxnDetId ,   
 A.IsDeleted,  
 B.LinenItemId            
,B.LinenCode            
,B.LinenDescription       
--,A.CCLSInUse      
--,A.CCLSShelf      
,D.StoreType            
,SUM(ISNULL(A.CCLSInUse,0)) AS CCLSInUse            
,SUM(ISNULL(A.CCLSShelf,0)) AS CCLSShelf            
,SUM(ISNULL(A.InUse,0)) AS InUse            
,SUM(ISNULL(A.Shelf,0)) AS Shelf            
,SUM((ISNULL(A.CCLSInUse,0) + ISNULL(A.CCLSShelf,0))) AS [TotalPcs(A)]            
,SUM((ISNULL(A.InUse,0)+ISNULL(A.Shelf,0))) AS [TotalPcs(B)]            
,SUM((ISNULL(A.CCLSInUse,0) +ISNULL(A.CCLSShelf,0)+ISNULL(A.InUse,0)+ISNULL(A.Shelf,0))) AS [TotalPcs(A+B)]            
,SUM((ISNULL(A.CCLSInUse,0) +ISNULL(A.CCLSShelf,0)+ISNULL(A.InUse,0)+ISNULL(A.Shelf,0))-(ISNULL(C.StoreBalance,0))) AS Variance            
,SUM(C.StoreBalance) AS StoreBalance            
            
FROM dbo.LLSLinenInventoryTxnDet A            
INNER JOIN dbo.LLSLinenItemDetailsMst B            
ON A.LinenItemId = B.LinenItemId            
LEFT JOIN dbo.LLSCentralCleanLinenStoreMstDet C            
ON A.LinenItemId =C.LinenItemId            
INNER JOIN dbo.LLSLinenInventoryTxn D            
ON A.LinenInventoryId =D.LinenInventoryId            
---WHERE D.StoreType ='10171'            
WHERE D.LinenInventoryId=@Id     
AND ISNULL(A.IsDeleted,'')=''
AND ISNULL(B.IsDeleted,'')=''
AND ISNULL(D.IsDeleted,'')=''
      
GROUP BY      
 A.LinenInventoryId,      
 A.LlsLinenInventoryTxnDetId ,      
 A.IsDeleted,  
 B.LinenItemId            
,B.LinenCode            
,B.LinenDescription            
,D.StoreType            
              
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END    
    
    
GO
