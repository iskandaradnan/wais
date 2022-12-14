USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- Exec [LLSCleanLinenIssueLinenItemTxnDet_Update]                 
                
--/*=====================================================================================================================                
--APPLICATION  : UETrack 1.5                
--NAME    : LLSCleanLinenIssueLinenItemTxnDet_Update               
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenIssueLinenItemTxnDet_Update] TABLE                 
--AUTHORS   : SIDDHANT                
--DATE    : 4-FEB-2020              
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT          : 4-FEB-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
              
                
              
              
                
CREATE PROCEDURE  [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Update]                                           
                
(                
 @LLSCleanLinenIssueLinenItemTxnDet_Update AS [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Update] READONLY   
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)                
              
UPDATE A            
SET            
 A.DeliveryIssuedQty1st = B.DeliveryIssuedQty1st,            
 A.DeliveryIssuedQty2nd = B.DeliveryIssuedQty2nd,            
 A.Remarks = B.Remarks,            
 A.ModifiedBy = B.ModifiedBy,            
 A.ModifiedDate = GETDATE(),            
 A.ModifiedDateUTC = GETUTCDATE()            
FROM LLSCleanLinenIssueLinenItemTxnDet as A Inner join @LLSCleanLinenIssueLinenItemTxnDet_Update as B on A.CLILinenItemId= B.CLILinenItemId      
WHERE A.CLILinenItemId= B.CLILinenItemId      
                        
SELECT CLILinenItemId              
      ,[Timestamp]              
   ,'' ErrorMsg              
      --,GuId               
FROM LLSCleanLinenIssueLinenItemTxnDet WHERE CLILinenItemId IN (SELECT ID FROM @Table)                
                
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END  
  
  
  
  
GO
