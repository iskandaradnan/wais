USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestTxn_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================        
APPLICATION  : UETrack 1.5        
NAME    : LLSCleanLinenRequestLinenItemTxnDet_Delete       
DESCRIPTION  : DELETE RECORD  (UPDATE ISELDETED COLUMN) IN [LLSCleanLinenRequestLinenItemTxnDet] TABLE         
AUTHORS   : SIDDHANT        
DATE    : 23-JAN-2020      
-----------------------------------------------------------------------------------------------------------------------        
VERSION HISTORY         
------------------:---------------:---------------------------------------------------------------------------------------        
Init    : Date          : Details        
------------------:---------------:---------------------------------------------------------------------------------------        
SIDDHANT          : 23-JAN-2020 :         
-----:------------:----------------------------------------------------------------------------------------------------*/        
      
        
      
      
        
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestTxn_Delete]                                   
        
(        
@ID AS INT      
,@ModifiedBy AS INT
)              
        
AS              
        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
      
      
      
UPDATE LLSCleanLinenRequestTxn  
SET IsDeleted = 1      
,ModifiedBy=@ModifiedBy
WHERE CleanLinenRequestId = @ID      
      
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
END
GO
