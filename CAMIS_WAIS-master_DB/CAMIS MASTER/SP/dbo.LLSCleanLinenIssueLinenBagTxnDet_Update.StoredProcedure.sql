USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
          
          
                          
-- Exec [LLSCleanLinenIssueLinenBagTxnDet_Update]                           
                          
--/*=====================================================================================================================                          
--APPLICATION  : UETrack 1.5                          
--NAME    : LLSCleanLinenIssueLinenBagTxnDet_Update                         
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenIssueLinenBagTxnDet] TABLE                           
--AUTHORS   : SIDDHANT                          
--DATE    : 4-FEB-2020                        
-------------------------------------------------------------------------------------------------------------------------                          
--VERSION HISTORY                           
--------------------:---------------:---------------------------------------------------------------------------------------                          
--Init    : Date          : Details                          
--------------------:---------------:---------------------------------------------------------------------------------------                          
--SIDDHANT          : 4-FEB-2020 :                           
-------:------------:----------------------------------------------------------------------------------------------------*/                          
                        
                      
CREATE PROCEDURE  [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Update]                                                     
(                
           
 @LLSIssue As [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Update] READONLY         
         
)                                
                          
AS                                
                          
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                          
                        
DECLARE @Table TABLE (ID INT)                          
                       
UPDATE  A                      
SET                      
 A.IssuedQuantity = B.IssuedQuantity,                      
 A.Remarks= B.Remarks,                      
 A.ModifiedBy = B.ModifiedBy,                       
 A.ModifiedDate = GETDATE(),                      
 A.ModifiedDateUTC = GETUTCDATE()            
 from LLSCleanLinenIssueLinenBagTxnDet as A Inner join @LLSIssue as B on A.CLILinenBagId=B.CLILinenBagId        
 Where A.CLILinenBagId=B.CLILinenBagId        
        
SELECT CLILinenBagId                        
      ,[Timestamp]                        
   ,'' ErrorMsg                        
      --,GuId                         
FROM  LLSCleanLinenIssueLinenBagTxnDet WHERE CLILinenBagId IN (SELECT ID FROM @Table)                          
                          
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                          
SET NOCOUNT OFF                          
END            
            
  
  
  
  
GO
