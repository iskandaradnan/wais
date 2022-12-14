USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestTxn_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestTxn_Update]                                                 
                      
(                      
 @Remarks  AS NVARCHAR(1000) NULL=NULL              
,@CleanLinenRequestId AS INT                  
,@ModifiedBy INT       
                  
)                            
                      
AS                            
                      
BEGIN                      
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY                      
                    
DECLARE @Table TABLE (ID INT)                      
                    
UPDATE                  
 LLSCleanLinenRequestTxn                  
SET                  
 TotalItemRequested = (SELECT SUM(LLSCleanLinenRequestLinenItemTxnDet.RequestedQuantity ) FROM                  
LLSCleanLinenRequestLinenItemTxnDet where LLSCleanLinenRequestLinenItemTxnDet.CleanLinenRequestId=@CleanLinenRequestId),                  
 TotalBagRequested = (SELECT                  
SUM(LLSCleanLinenRequestLinenBagTxnDet.RequestedQuantity) FROM                  
LLSCleanLinenRequestLinenBagTxnDet where LLSCleanLinenRequestLinenBagTxnDet.CleanLinenRequestId=@CleanLinenRequestId),                  
 Remarks = @Remarks,                  
 ModifiedBy = @ModifiedBy,                  
 ModifiedDate = GETDATE(),                  
 ModifiedDateUTC = GETUTCDATE()                  
WHERE                  
 CleanLinenRequestId = @CleanLinenRequestId                   
                    
SELECT CleanLinenRequestId                    
      ,[Timestamp]                    
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
