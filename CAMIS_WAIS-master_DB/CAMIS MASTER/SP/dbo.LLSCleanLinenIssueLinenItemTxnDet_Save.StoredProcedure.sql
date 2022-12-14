USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
-- Exec [LLSCleanLinenIssueLinenItemTxnDet_Save]           
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : LLSCleanLinenIssueLinenItemTxnDet_Save         
--DESCRIPTION  : SAVE RECORD IN [LLSCleanLinenIssueLinenItemTxnDet] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 4-FEB-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 4-FEB-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
       

      
CREATE PROCEDURE  [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Save]                                     
          
(          
 @Block As [dbo].[LLSCleanLinenIssueLinenItemTxnDet] READONLY          
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
INSERT INTO LLSCleanLinenIssueLinenItemTxnDet (      
 CleanLinenIssueId,      
 LinenitemId,      
 RequestedQuantity,      
 DeliveryIssuedQty1st,      
 DeliveryIssuedQty2nd,      
 Remarks,      
 CreatedBy,      
 CreatedDate,      
 CreatedDateUTC    
 )      
       
  OUTPUT INSERTED.CLILinenItemId INTO @Table          
 SELECT  CleanLinenIssueId,      
 LinenitemId,      
 RequestedQuantity,      
 DeliveryIssuedQty1st,      
 DeliveryIssuedQty2nd,      
 Remarks,      
CreatedBy,        
GETDATE(),        
GETUTCDATE()    
FROM @Block          
          
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
