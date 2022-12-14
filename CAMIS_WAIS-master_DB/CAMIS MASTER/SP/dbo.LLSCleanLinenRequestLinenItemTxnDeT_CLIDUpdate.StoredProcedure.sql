USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenItemTxnDeT_CLIDUpdate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--SELECT * FROM LLSCleanLinenRequestTxn    
              
-- Exec [LLSCleanLinenRequestLinenItemTxnDeT_CLIDUpdate]               
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : SaveUserAreaDetailsLLS             
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenRequestLinenItemTxnDeT] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 3-mar-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 3-mar-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
            
              
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenItemTxnDeT_CLIDUpdate]                                         
              
(              
 @DocumentNo AS VARCHAR(100)          
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
    
UPDATE C SET C.CleanLinenIssueId=B.CleanLinenIssueId    
FROM LLSCleanLinenRequestTxn​ A INNER JOIN LLSCleanLinenIssueTxn B ON A.DocumentNo=B.CLRNo    
INNER JOIN LLSCleanLinenRequestLinenItemTxnDeT C    
ON A.CleanLinenRequestId=C.CleanLinenRequestId    
WHERE A.DocumentNo=@DocumentNo    
    
    
            
SELECT CLRLinenItemId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSCleanLinenRequestLinenItemTxnDeT WHERE CLRLinenItemId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END 
GO
