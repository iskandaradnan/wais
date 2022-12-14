USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenItemTxnDetSingle_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--LLSCleanLinenRequestLinenItemTxnDetSingle_Delete          
-- Exec [LLSCleanLinenRequestLinenItemTxnDetSingle_Delete]             
            
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : LLSCleanLinenRequestLinenItemTxnDetSingle_Delete           
--DESCRIPTION  : DELETE RECORD SINGLE RECORD (UPDATE ISELDETED COLUMN) IN [LLSCleanLinenRequestLinenItemTxnDet] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 30-MAR-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 30-MAR-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
          
            
          
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenItemTxnDetSingle_Delete]                                       
(            
@ID NVARCHAR(250)           
,@ModifiedBy AS INT    
)                  
            
AS                  
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
            
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT            
            
 BEGIN TRANSACTION            
            
-- Paramter Validation             
            
 SET NOCOUNT ON;            
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;            
            
-- Declaration            
            
            
-- Default Values            
            
            
-- Execution            
            
 --DELETE FROM [dbo].LLSCleanLinenRequestLinenItemTxnDet             
 --WHERE CLRLinenItemId           
 --IN (SELECT ITEM FROM dbo.[SplitString] (@ID,','))            
   ---deepak added---  
   update LLSCleanLinenIssueLinenItemTxnDet set unqkey=(Concat(CleanLinenIssueId ,LinenItemId,RequestedQuantity))  
update LLSCleanLinenRequestLinenItemTxnDet set unqkey=(Concat(CleanLinenIssueId ,LinenItemId,RequestedQuantity))  
UPDATE A      
SET A.IsDeleted=1      
,A.ModifiedBy=@ModifiedBy    
FROM LLSCleanLinenRequestLinenItemTxnDet A       
WHERE A.CLRLinenItemId IN (SELECT ITEM FROM dbo.[SplitString] (@ID,','))            
      
UPDATE I      
SET I.IsDeleted=1      
,I.ModifiedBy=@ModifiedBy    
FROM LLSCleanLinenRequestLinenItemTxnDet A       
Inner join LLSCleanLinenIssueLinenItemTxnDet as I ON A.unqkey=I.unqkey  
WHERE A.CLRLinenItemId IN (SELECT ITEM FROM dbo.[SplitString] (@ID,','))   
      
------end deepak         
--UPDATE A      
--SET A.IsDeleted=1      
--,A.ModifiedBy=@ModifiedBy    
--FROM LLSCleanLinenRequestLinenItemTxnDet A       
--WHERE A.CLRLinenItemId IN (SELECT ITEM FROM dbo.[SplitString] (@ID,','))            
      
      
      
            
 IF @mTRANSCOUNT = 0            
        BEGIN            
            COMMIT TRANSACTION            
        END               
            
            
END TRY            
            
BEGIN CATCH            
            
 IF @mTRANSCOUNT = 0            
        BEGIN            
            ROLLBACK TRAN            
        END            
            
 SELECT 'This record can''t be deleted as it is referenced by another screen' AS ErrorMessage            
            
 INSERT INTO ErrorLog(            
    Spname,            
    ErrorMessage,            
    createddate)            
 VALUES(  OBJECT_NAME(@@PROCID),            
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),            
    getdate()            
     );            
     THROW;            
            
END CATCH          
END 
GO
