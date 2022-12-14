USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenBagTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
              
-- Exec [LLSCleanLinenRequestLinenBagTxnDet_Save]               
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : LLSCleanLinenRequestLinenBagTxnDet_Save             
--DESCRIPTION  : SAVE RECORD IN [LLSCleanLinenRequestLinenBagTxnDet_Save] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 23-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 23-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
              
          
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenBagTxnDet_Save]                                         
              
(              
 @Block As [dbo].[LLSCleanLinenRequestLinenBagTxnDet] READONLY              
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
INSERT INTO LLSCleanLinenRequestLinenBagTxnDet (          
[CustomerId] ,        
 [FacilityId] ,        
 [CleanLinenRequestId] ,        
 [CleanLinenIssueId] ,        
 [LaundryBag] ,        
 [RequestedQuantity] ,        
 [Remarks],        
 CreatedBy,          
 CreatedDate,          
 CreatedDateUTC)           
            
 OUTPUT INSERTED.CLRLinenBagId INTO @Table              
           
 SELECT  [CustomerId] ,        
 [FacilityId] ,        
 [CleanLinenRequestId] ,        
 [CleanLinenIssueId] ,        
 [LaundryBag] ,        
 [RequestedQuantity] ,        
 [Remarks],        
CreatedBy,            
GETDATE(),            
GETUTCDATE()            
FROM @Block      
  
/*Update TotalRequest IN CLR table*/  
  
;WITH CTE AS  
(  
    SELECT A.CleanLinenRequestId,SUM(B.RequestedQuantity) AS RequestedQuantity    
    FROM LLSCleanLinenRequestTxn A  
    INNER JOIN LLSCleanLinenRequestLinenBagTxnDet B  
    ON A.CleanLinenRequestId=B.CleanLinenRequestId  
    --WHERE A.CleanLinenRequestId=100026  
    GROUP BY A.CleanLinenRequestId  
)  
--SELECT *   
UPDATE A   
SET A.TotalBagRequested=B.RequestedQuantity  
FROM LLSCleanLinenRequestTxn A  
INNER JOIN CTE B  
ON A.CleanLinenRequestId=B.CleanLinenRequestId  
  
  
  
              
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
        
--select * from LLSCleanLinenRequestLinenBagTxnDet  
  
  
  
  
GO
