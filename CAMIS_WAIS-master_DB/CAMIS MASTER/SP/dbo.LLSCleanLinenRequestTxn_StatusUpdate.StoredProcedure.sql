USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestTxn_StatusUpdate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM LLSCleanLinenRequestLinenItemTxnDet            
--SELECT * FROM LLSCleanLinenIssueLinenItemTxnDet             
            
            
--SELECT * FROM LLSCleanLinenRequestLinenBagTxnDet            
--WHERE CleanLinenIssueId=58            
--SELECT * FROM LLSCleanLinenIssueLinenBagTxnDet            
--WHERE CleanLinenIssueId=58            
            
            
            
            
            
            
--SELECT * FROM LLSCleanLinenRequestTxn              
                        
-- Exec [LLSCleanLinenRequestTxn_StatusUpdate]                         
                        
--/*=====================================================================================================================                        
--APPLICATION  : UETrack 1.5                        
--NAME    : SaveUserAreaDetailsLLS                       
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenRequestTxn] TABLE                         
--AUTHORS   : SIDDHANT                        
--DATE    : 3-mar-2020                      
-------------------------------------------------------------------------------------------------------------------------                        
--VERSION HISTORY                         
--------------------:---------------:---------------------------------------------------------------------------------------                        
--Init    : Date          : Details                        
--------------------:---------------:---------------------------------------------------------------------------------------                        
--SIDDHANT          : 3-mar-2020 :                         
-------:------------:----------------------------------------------------------------------------------------------------*/                        
                      
                        
                      
                      
                        
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestTxn_StatusUpdate]                                                   
                        
(                        
 @DocumentNo AS VARCHAR(100)             
 ,@CLINO AS VARCHAR(100)            
)                              
                        
AS                              
                        
BEGIN                        
SET NOCOUNT ON                        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
BEGIN TRY                        
                      
DECLARE @Table TABLE (ID INT)                        
            
----CHECKING THE SHORT FALL TO CHANGE THE STATUS----            
DECLARE @SHORTFALL AS INT            
SET @SHORTFALL=(            
SELECT SUM(C.RequestedQuantity)-SUM(D.IssuedQuantity) AS SHORTFALL            
FROM LLSCleanLinenRequestTxn (NOLOCK) A            
INNER JOIN LLSCleanLinenIssueTxn (NOLOCK) B ON A.CleanLinenRequestId=B.CleanLinenRequestId            
INNER JOIN LLSCleanLinenRequestLinenBagTxnDet (NOLOCK) C            
ON A.CleanLinenRequestId=C.CleanLinenRequestId            
AND B.CleanLinenIssueId=C.CleanLinenIssueId            
INNER JOIN LLSCleanLinenIssueLinenBagTxnDet (NOLOCK) D            
ON B.CleanLinenIssueId=D.CleanLinenIssueId            
AND C.LaundryBag=D.LaundryBag            
WHERE B.CLINo=@CLINO            
)            
            
             
            
DECLARE @SHORTFALL1 AS INT            
SET @SHORTFALL1=(            
SELECT SUM(C.RequestedQuantity)-(SUM(D.DeliveryIssuedQty1st)+SUM(DeliveryIssuedQty2nd)) AS SHORTFALL            
FROM LLSCleanLinenRequestTxn (NOLOCK) A            
INNER JOIN LLSCleanLinenIssueTxn (NOLOCK) B ON A.CleanLinenRequestId=B.CleanLinenRequestId            
INNER JOIN LLSCleanLinenRequestLinenItemTxnDet (NOLOCK) C            
ON A.CleanLinenRequestId=C.CleanLinenRequestId            
AND B.CleanLinenIssueId=C.CleanLinenIssueId            
INNER JOIN LLSCleanLinenIssueLinenItemTxnDet (NOLOCK) D            
ON B.CleanLinenIssueId=D.CleanLinenIssueId            
AND C.LinenItemId=D.LinenitemId            
WHERE B.CLINo=@CLINO            
)      
            
            
--SELECT @SHORTFALL            
            
            
UPDATE A              
SET A.IssueStatus=10104              
FROM LLSCleanLinenRequestTxn (NOLOCK)​ A              
WHERE DocumentNo= @DocumentNo              
AND @SHORTFALL=0                      
AND @SHORTFALL1<=0            
            
SELECT CleanLinenRequestId            ,[Timestamp]                 
   ,'' ErrorMsg                      
      --,GuId                       
FROM LLSCleanLinenRequestTxn WHERE CleanLinenRequestId IN (SELECT ID FROM @Table)                        
                        
END TRY                        
BEGIN CATCH                        
                        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                        
                        
THROW                        
                        
END CATCH                        
SET NOCOUNT OFF                        
END 
GO
