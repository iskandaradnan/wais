USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LlsLinenInventoryTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                
--APPLICATION  : UETrack 1.5                
--NAME    : LlsLinenInventoryTxnDet_Update               
--DESCRIPTION  : Update RECORD IN [LlsLinenInventoryTxnDet] TABLE                 
--AUTHORS   : SIDDHANT                
--DATE    : 3-FEB-2020              
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT          : 3-FEB-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
              
              
            
                
CREATE PROCEDURE  [dbo].[LlsLinenInventoryTxnDet_Update]                                           
                
(             
@LlsLinenInventoryTxnDet AS LlsLinenInventoryTxnDet READONLY     
--@ID  INT,      
--@LinenItemId INT,      
--@InUse NUMERIC(24,2),      
--@Shelf NUMERIC(24,2)      
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)                
              
UPDATE A      
SET      
A.LinenItemId = B.LinenItemId,      
A.InUse = B.InUse,      
A.Shelf = B.Shelf,      
a.CCLSInUse=b.CCLSInUse,    
a.CCLSShelf=b.CCLSShelf,    
ModifiedBy = B.ModifiedBy,      
ModifiedDate = GETDATE(),      
ModifiedDateUTC = GETUTCDATE()     
FROM LLSLinenInventoryTxnDet A        
 INNER JOIN @LlsLinenInventoryTxnDet B        
 ON A.LlsLinenInventoryTxnDetId=B.LlsLinenInventoryTxnDetId        
WHERE A.LlsLinenInventoryTxnDetId =B.LlsLinenInventoryTxnDetId    
    
    
    
              
              
SELECT LlsLinenInventoryTxnDetId              
      ,[Timestamp]              
   ,'' ErrorMsg              
      --,GuId               
FROM LLSLinenInventoryTxnDet WHERE LlsLinenInventoryTxnDetId IN (SELECT ID FROM @Table)                
                
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END


GO
