USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenBagTxnDet_CLIDUpdate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--SELECT * FROM LLSCleanLinenRequestTxn  
            
-- Exec [LLSCleanLinenRequestLinenBagTxnDet_CLIDUpdate]             
            
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : SaveUserAreaDetailsLLS           
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenRequestLinenBagTxnDet] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 3-mar-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 3-mar-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
          
            
          
          
            
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenBagTxnDet_CLIDUpdate]                                       
            
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
INNER JOIN LLSCleanLinenRequestLinenBagTxnDet C  
ON A.CleanLinenRequestId=C.CleanLinenRequestId  
WHERE A.DocumentNo=@DocumentNo  
  
  
          
SELECT CLRLinenBagId          
      ,[Timestamp]          
   ,'' ErrorMsg          
      --,GuId           
FROM LLSCleanLinenRequestLinenBagTxnDet WHERE CLRLinenBagId IN (SELECT ID FROM @Table)            
            
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END  
GO
