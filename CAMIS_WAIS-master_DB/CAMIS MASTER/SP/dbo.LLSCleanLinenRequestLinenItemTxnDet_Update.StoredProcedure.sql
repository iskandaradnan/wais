USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenItemTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
                  
-- EXEC [LLSCleanLinenRequestLinenItemTxnDet_Update]                   
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack 1.5                  
--NAME    : LLSCleanLinenRequestLinenItemTxnDet                 
--DESCRIPTION  : UPDATE RECORD IN [LLSCleanLinenRequestLinenItemTxnDet] TABLE                   
--AUTHORS   : SIDDHANT                  
--DATE    : 23-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT          : 23-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                
                  
                
         
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenItemTxnDet_Update]                                             
                  
(                  
@LLSCleanLinenRequestLinenItemTxnDet_Update AS LLSCleanLinenRequestLinenItemTxnDet_Update READONLY        
              
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
 ModifiedBy = B.ModifiedBy,              
 ModifiedDate = GETDATE(),              
 ModifiedDateUTC = GETUTCDATE()              
FROM LLSCleanLinenRequestLinenItemTxnDet as A Inner join @LLSCleanLinenRequestLinenItemTxnDet_Update as B on A.CLRLinenItemId= B.CLRLinenItemId      
WHERE A.CLRLinenItemId= B.CLRLinenItemId      
              
                
SELECT CLRLinenItemId                
      ,[Timestamp]                
   ,'' ErrorMsg                
      --,GuId                 
FROM LLSCleanLinenRequestLinenItemTxnDet WHERE CLRLinenItemId IN (SELECT ID FROM @Table)                  
                  
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END
GO
