USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenBagTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec [LLSCleanLinenRequestLinenBagTxnDet_Update]                   
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack 1.5                  
--NAME    : LLSCleanLinenRequestLinenBagTxnDet_Update                 
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenRequestLinenBagTxnDet] TABLE                   
--AUTHORS   : SIDDHANT                  
--DATE    : 23-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT          : 23-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                
          
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenBagTxnDet_Update]                                             
                  
(                  
@LLSCleanLinenRequestLinenBagTxnDet_Update  AS LLSCleanLinenRequestLinenBagTxnDet_Update READONLY            
)                        
                  
AS                        
                  
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                
DECLARE @Table TABLE (ID INT)                  
                
UPDATE A              
SET              
 A.RequestedQuantity = B.RequestedQuantity,    
 A.Remarks =B.Remarks,    
 ModifiedBy =B.ModifiedBy ,              
 ModifiedDate = GETDATE(),              
 ModifiedDateUTC = GETUTCDATE()              
FROM LLSCleanLinenRequestLinenBagTxnDet as A Inner join @LLSCleanLinenRequestLinenBagTxnDet_Update as B on A.CLRLinenBagId= B.CLRLinenBagId        
WHERE A.CLRLinenBagId= B.CLRLinenBagId        
                          
              
              
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
