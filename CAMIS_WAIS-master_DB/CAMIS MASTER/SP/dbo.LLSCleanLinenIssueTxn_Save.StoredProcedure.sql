USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                          
-- Exec [LLSCleanLinenIssueTxn_Save ]                                           
                                          
--/*=====================================================================================================================                                          
--APPLICATION  : UETrack 1.5                                          
--NAME    : LLSCleanLinenIssueTxn_Save                                         
--DESCRIPTION  : SAVE RECORD IN [LLSCleanLinenIssueTxn] TABLE                                           
--AUTHORS   : SIDDHANT                                          
--DATE    : 4-FEB-2020                                        
-------------------------------------------------------------------------------------------------------------------------                                          
--VERSION HISTORY                                           
--------------------:---------------:---------------------------------------------------------------------------------------                                          
--Init    : Date          : Details                                          
--------------------:---------------:---------------------------------------------------------------------------------------                                          
--SIDDHANT          : 4-FEB-2020 :                                           
-------:------------:----------------------------------------------------------------------------------------------------*/                                          
                  
                                     
CREATE PROCEDURE  [dbo].[LLSCleanLinenIssueTxn_Save]                                                                     
                                          
(                                          
 @LLSCleanLinenIssueTxn As [dbo].[LLSCleanLinenIssueTxn] READONLY                                          
)                                                
                                          
AS                                                
                                          
BEGIN                                          
SET NOCOUNT ON                                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                          
BEGIN TRY                                          
                                        
DECLARE @Table TABLE (ID INT)                        
/*CHANGE IN THE LOGIC AS SUGGESTED BY SYAHID ON 16-8-2020*/

--DECLARE @pCustomerId INT                      
--DECLARE @pFacilityId INT                      
--DECLARE @mDefaultkey VARCHAR(100)                      
--DECLARE @mMonth VARCHAR(50)                      
--DECLARE @mYear INT                      
--DECLARE @mDay VARCHAR(50)                   
--DECLARE @YYMM VARCHAR(50)                  
--DECLARE @YYMMDD VARCHAR(50)                  
--DECLARE @pOutParam VARCHAR(100)                      
--DECLARE @pDocumentNo VARCHAR(100)                      
                      
--SET @pCustomerId=(SELECT CustomerId FROM @LLSCleanLinenIssueTxn )                      
--SET @pFacilityId=(SELECT FacilityId FROM @LLSCleanLinenIssueTxn )                      
--SET @mDefaultkey='CLI'                      
--SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH,DeliveryDate1st)),2) FROM @LLSCleanLinenIssueTxn)                  
--SET @mYear=(SELECT YEAR(DeliveryDate1st) FROM @LLSCleanLinenIssueTxn)                  
--SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,DeliveryDate1st)),2) FROM @LLSCleanLinenIssueTxn)                      
--SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)            
--SET @YYMM=CONCAT(@mYear,@mMonth)   
----SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM                      
                      
                      
                      
--EXEC [uspFM_GenerateDocumentNumber] @pFlag='Clean Linen Issue',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                      
--SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)                        
                  
                  
                  
                  
                  
                  
                  
 INSERT INTO LLSCleanLinenIssueTxn (                                   
 [CustomerId]                    
 ,[FacilityId]                    
 ,[CleanLinenRequestId]                    
 ,[CLRNo]                    
 ,[CLINo]                    
 ,[ReceivedBy1st]                    
 ,[ReceivedBy2nd]                    
 ,[Verifier]                    
 ,[DeliveredBy]                
 ,[DeliveryDate1st]                  
 --,[DeliveryDate2nd]                  
 ,[DeliveryWeight1st]                    
 ,[DeliveryWeight2nd]                    
 ,[IssuedOnTime]           ,[DeliverySchedule]                    
 ,[QCTimeliness]                    
 ,[ShortfallQC]                    
 ,[CLIOption]                     
 ,[TotalItemIssued]                    
 ,[TotalBagIssued]                     
 ,[TotalItemShortfall]                     
 ,[Remarks]                     
    ,CreatedBy                                      
    ,CreatedDate                                      
    ,CreatedDateUTC              
 ,ModifiedBy              
 ,ModifiedDate              
 ,ModifiedDateUTC              
 )                  
OUTPUT INSERTED.CleanLinenIssueId INTO @Table                                          
SELECT                        
    [CustomerId]                    
 ,[FacilityId]                    
 ,[CleanLinenRequestId]                    
 ,[CLRNo]                    
 ,NULL as [CLINo]                    
 ,[ReceivedBy1st]                    
 ,[ReceivedBy2nd]                    
 ,[Verifier]                    
 ,[DeliveredBy]                    
 ,[DeliveryDate1st]                  
 --,[DeliveryDate2nd]                  
 ,[DeliveryWeight1st]                    
 ,[DeliveryWeight2nd]                    
 ,[IssuedOnTime]                    
 ,[DeliverySchedule]                    
 ,[QCTimeliness]                    
 ,[ShortfallQC]                    
 ,[CLIOption]                     
 ,[TotalItemIssued]                    
 ,[TotalBagIssued]                     
 ,[TotalItemShortfall]                     
 ,[Remarks]                     
 ,CreatedBy                                        
 ,GETDATE()                                        
 ,GETUTCDATE()              
 ,ModifiedBy                                        
 ,GETDATE()                                        
 ,GETUTCDATE()                
FROM @LLSCleanLinenIssueTxn                                          
                                          
SELECT CleanLinenIssueId                                        
      ,[Timestamp]                                        
   ,'' ErrorMsg                                        
      --,GuId                                         
FROM LLSCleanLinenIssueTxn WHERE CleanLinenIssueId IN (SELECT ID FROM @Table)                                          


-----UPDATE DOC NO FOR CLI


UPDATE B
SET B.CLINo=CONCAT('CLI/WAC/',RIGHT(A.DocumentNo,15))
FROM LLSCleanLinenRequestTxn  A
INNER JOIN LLSCleanLinenIssueTxn B
ON A.CleanLinenRequestId=B.CleanLinenRequestId
WHERE ISNULL(B.CLINo,'')=''
AND CAST(B.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)
--WHERE A.CleanLinenRequestId='100481'






                                          
END TRY                                          
BEGIN CATCH                                          
                                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                          
                                          
THROW                                          
                                    
END CATCH                                          
SET NOCOUNT OFF                                          
END      
GO
