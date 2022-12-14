USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMstDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
---EXEC LLSCentralCleanLinenStoreMstDet_GetById     
    
    
CREATE PROCEDURE [dbo].[LLSCentralCleanLinenStoreMstDet_GetById]      
     
AS       
      
-- Exec [GetUserRole]       
      
--/*=====================================================================================================================      
--APPLICATION  : UETrack      
--NAME    : LLSCentralCleanLinenStoreMstDet_GetById      
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID      
--AUTHORS   : SIDDHANT      
--DATE    : 14-FEB-2020      
-------------------------------------------------------------------------------------------------------------------------      
--VERSION HISTORY       
--------------------:---------------:---------------------------------------------------------------------------------------      
--Init    : Date          : Details      
--------------------:---------------:---------------------------------------------------------------------------------------      
--BIJU NB           : 14-FEB-2020 :       
-------:------------:----------------------------------------------------------------------------------------------------*/      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
       
    
    
    
--SELECT A.LinenItemId    
--      ,B.LinenCode    
--   ,B.LinenDescription    
--   ,SUM(ISNULL(A.Par2,0)) AS StockLevel    
--   ,SUM(ISNULL(A.Par2,0)) AS Par2    
--      ,SUM(ISNULL(A.Par1,0)) AS Par1     
--   --,SUM(ISNULL(D.ReceivedQuantity,0)) AS TotalReceivedCLD    
--   --,SUM(ISNULL(E.TotalRejectedQuantity,0)) AS TotalRejected    
--   --,SUM(ISNULL(E.ReplacedQuantity,0)) AS TotalReplaced    
--   --,SUM(ISNULL(F.DeliveryIssuedQty1st,0) + ISNULL(F.DeliveryIssuedQty2nd, 0)) AS TotalIssued     
    
--   ,(SUM(ISNULL(D.ReceivedQuantity,0)) +SUM(ISNULL(E.TotalRejectedQuantity,0)))     
--    -    
--   (SUM(ISNULL(E.ReplacedQuantity,0)) + SUM(ISNULL(F.DeliveryIssuedQty1st,0) + ISNULL(F.DeliveryIssuedQty2nd, 0))) AS StoreBalance    
    
    
--   ,((SUM(ISNULL(A.Par2,0)))-    
--   (ABS((SUM(ISNULL(D.ReceivedQuantity,0)) +SUM(ISNULL(E.TotalRejectedQuantity,0)))     
--    -    
--   (SUM(ISNULL(E.ReplacedQuantity,0)) + SUM(ISNULL(F.DeliveryIssuedQty1st,0) + ISNULL(F.DeliveryIssuedQty2nd, 0)))))) AS ReorderQuantity    
    
       
      
    
       
    
    
--FROM dbo.LLSUserAreaDetailsLinenItemMstDet A    
--LEFT OUTER JOIN LLSLinenItemDetailsMst B    
--ON A.LinenItemId=B.LinenItemId    
    
  
-- LEFT OUTER JOIN LLSCleanLinenDespatchTxnDet D    
--ON A.LinenItemId=D.LinenItemId    
    
    
--LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet E    
--ON A.LinenItemId=E.LinenItemId    
    
--LEFT OUTER JOIN LLSCleanLinenIssueLinenItemTxnDet F    
--ON A.LinenitemId=F.LinenitemId    
    
----WHERE A.LinenItemId=@ID    
    
--GROUP BY A.LinenItemId    
--         ,B.LinenCode    
--   ,B.LinenDescription    
       

SELECT 
       A.LinenItemId    
      ,B.LinenCode    
      ,B.LinenDescription    
      ,ISNULL(A.StockLevel,0) AS StockLevel    
      ,ISNULL(A.Par2,0) AS Par2    
      ,ISNULL(A.Par1,0) AS Par1     
	  --,0 AS TotalReceivedCLD    
   --   ,0 AS TotalRejected    
   --   ,0 AS TotalReplaced    
   --   ,0 AS TotalIssued     
   
	  ,ISNULL(StoreBalance,0) AS StoreBalance
	  ,ISNULL(ReorderQuantity,0) AS ReorderQuantity
FROM LLSCentralCleanLinenStoreMstDet A
LEFT OUTER JOIN LLSLinenItemDetailsMst B    
ON A.LinenItemId=B.LinenItemId     
    
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
SET NOCOUNT OFF      
END
GO
