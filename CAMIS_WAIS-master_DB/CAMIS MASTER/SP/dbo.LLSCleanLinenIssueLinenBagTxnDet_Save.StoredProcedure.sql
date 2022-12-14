USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
          
-- Exec [LLSCleanLinenIssueLinenBagTxnDet_Save ]           
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : LLSCleanLinenIssueLinenBagTxnDet_Save         
--DESCRIPTION  : SAVE RECORD IN [LLSCleanLinenIssueLinenBagTxnDet] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 04-FEB-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 04-FEB-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
          
       
CREATE PROCEDURE  [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Save]                                     
          
(          
 @Block As [dbo].[LLSCleanLinenIssueLinenBagTxnDet] READONLY          
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
 INSERT INTO LLSCleanLinenIssueLinenBagTxnDet (      
 CleanLinenIssueId,      
 LaundryBag,      
 IssuedQuantity,      
 Remarks,      
 CreatedBy,      
 CreatedDate,      
 CreatedDateUTC,    
 IsDeleted)          
        
OUTPUT INSERTED.CLILinenBagId INTO @Table          
SELECT   CleanLinenIssueId,      
 LaundryBag,      
 IssuedQuantity,      
 Remarks,      
CreatedBy,        
GETDATE(),        
GETUTCDATE(),    
0    
FROM @Block          
          
SELECT CLILinenBagId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSCleanLinenIssueLinenBagTxnDet WHERE CLILinenBagId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END    
    
GO
