USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCLRIssueStatusUpdate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
--EXEC LLSCLRIssueStatusUpdate      
      
CREATE PROCEDURE [dbo].[LLSCLRIssueStatusUpdate]      
AS      
BEGIN                      
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY        
      
DECLARE @PREV_MONTHSTARTDATE DATE      
DECLARE @PREV_MONTHENDDATE DATE      
      
SET @PREV_MONTHSTARTDATE=(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0))      
SET @PREV_MONTHENDDATE=(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))      
      
SELECT @PREV_MONTHSTARTDATE,@PREV_MONTHENDDATE      
      
--ALTER TABLE LLSCleanLinenRequestTxn ADD TxnStatus INT DEFAULT 10103      
      
--UPDATE LLSCleanLinenRequestTxn      
--SET TxnStatus=10103      
      
      
--SELECT *       
UPDATE A      
SET A.TxnStatus=10104      
   ,A.ModifiedBy=19      
   ,A.ModifiedDate=GETDATE()      
FROM LLSCleanLinenRequestTxn A      
WHERE CAST(RequestDateTime AS DATE) >= @PREV_MONTHSTARTDATE AND CAST(RequestDateTime AS DATE) <=@PREV_MONTHENDDATE      
--AND DocumentNo='CLR/WAC/2020061/00024'---CHNAGE ONCED CONFIRMED      
      
END TRY                      
BEGIN CATCH                      
                      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                      
                      
THROW                      
                      
END CATCH                      
SET NOCOUNT OFF                      
END 
GO
