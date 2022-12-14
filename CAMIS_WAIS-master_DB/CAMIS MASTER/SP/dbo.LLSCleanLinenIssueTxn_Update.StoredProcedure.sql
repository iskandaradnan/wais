USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec [LLSCleanLinenIssueTxn_Update]                           
                          
--/*=====================================================================================================================                          
--APPLICATION  : UETrack 1.5                          
--NAME    : SaveUserAreaDetailsLLS                         
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenIssueTxn] TABLE                           
--AUTHORS   : SIDDHANT                          
--DATE    : 4-FEB-2020                        
-------------------------------------------------------------------------------------------------------------------------                          
--VERSION HISTORY                           
--------------------:---------------:---------------------------------------------------------------------------------------                          
--Init    : Date          : Details                          
--------------------:---------------:---------------------------------------------------------------------------------------                          
--SIDDHANT          : 4-FEB-2020 :                           
-------:------------:----------------------------------------------------------------------------------------------------*/                          
                        
                          
                        
                        
                          
CREATE PROCEDURE  [dbo].[LLSCleanLinenIssueTxn_Update]                                                     
                          
(                          
 @Remarks AS NVARCHAR(1000)     NULL=NULL                 
,@ModifiedBy AS INT                      
--,@ModifiedDate AS DATETIME                      
--,@ModifiedDateUTC AS DATETIME                      
,@CleanLinenIssueId     AS INT    
,@DeliveryDate1st       DATETIME      
--,@DeliveryDate2nd       DATETIME   
,@ReceivedBy1st        INT   
--,@ReceivedBy2nd         INT        
--,@DeliveryWeight2nd     NUMERIC(18,2)    
,@DeliveryWeight1st     NUMERIC(18,2)    
,@DeliverySchedule      INT ,@QCTimeliness          INT        
,@ShortfallQC           INT         
        
                      
)                                
                          
AS                                
                          
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                          
                        
DECLARE @Table TABLE (ID INT)                          
DECLARE @TotalItemIssued INT      
SET @TotalItemIssued=(SELECT                      
SUM(LLSCleanLinenIssueLinenItemTxnDet.DeliveryIssuedQty1st) +                      
SUM(LLSCleanLinenIssueLinenItemTxnDet.DeliveryIssuedQty2nd) FROM LLSCleanLinenIssueLinenItemTxnDet      
WHERE CleanLinenIssueId=@CleanLinenIssueId      
)      
      
DECLARE @TotalBagIssued INT      
SET @TotalBagIssued=(SELECT                      
SUM(LLSCleanLinenIssueLinenBagTxnDet.IssuedQuantity) FROM                      
LLSCleanLinenIssueLinenBagTxnDet WHERE CleanLinenIssueId=@CleanLinenIssueId)      
      
DECLARE @TotalItemRequested INT      
SET @TotalItemRequested =      
(SELECT SUM(TotalItemRequested) FROM  LLSCleanLinenRequestTxn A       
INNER JOIN LLSCleanLinenIssueTxn B      
ON A.CleanLinenRequestId=B.CleanLinenRequestId      
WHERE B.CleanLinenIssueId=@CleanLinenIssueId)      
      
      
DECLARE @TotalBagRequested INT      
SET @TotalBagRequested =      
(SELECT SUM(TotalBagRequested) FROM  LLSCleanLinenRequestTxn A       
INNER JOIN LLSCleanLinenIssueTxn B      
ON A.CleanLinenRequestId=B.CleanLinenRequestId      
WHERE B.CleanLinenIssueId=@CleanLinenIssueId)      
      
      
DECLARE @TotalItemShortfall INT      
SET @TotalItemShortfall=(@TotalItemRequested-@TotalItemIssued)      
      
      
DECLARE @TotalBagShortfall INT      
SET @TotalBagShortfall=(@TotalBagRequested-@TotalBagIssued)      
      
      
                        
UPDATE                      
 LLSCleanLinenIssueTxn                      
SET                      
 TotalItemIssued = @TotalItemIssued,                      
 TotalBagIssued = @TotalBagIssued,                      
 TotalItemShortfall =@TotalItemShortfall ,                      
 TotalBagShortfall = @TotalBagShortfall,                      
 Remarks = @Remarks,                      
 ModifiedBy = @ModifiedBy ,                      
 ModifiedDate = GETDATE(),                      
 ModifiedDateUTC = GETUTCDATE(),    
 DeliveryDate1st  =@DeliveryDate1st,  
 --DeliveryDate2nd  =@DeliveryDate2nd  ,   
 ReceivedBy1st   =@ReceivedBy1st  ,  
 --ReceivedBy2nd    =@ReceivedBy2nd    ,        
 --DeliveryWeight2nd=@DeliveryWeight2nd,  
 DeliveryWeight1st =@DeliveryWeight1st,  
 DeliverySchedule =@DeliverySchedule ,        
 QCTimeliness     =@QCTimeliness     ,        
 ShortfallQC      =@ShortfallQC              
        
WHERE                      
 CleanLinenIssueId = @CleanLinenIssueId                      
        
        
        
SELECT CleanLinenIssueId                        
      ,[Timestamp]                        
   ,'' ErrorMsg                        
      --,GuId                         
FROM LLSCleanLinenIssueTxn WHERE CleanLinenIssueId IN (SELECT ID FROM @Table)                          
                          
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                          
SET NOCOUNT OFF                          
END 
GO
