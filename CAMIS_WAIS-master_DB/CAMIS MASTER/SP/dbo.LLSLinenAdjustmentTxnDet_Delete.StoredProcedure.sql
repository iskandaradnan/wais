USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxnDet_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- Exec [LLSLinenAdjustmentTxnDet_Delete]     
    
--/*=====================================================================================================================    
--APPLICATION  : UETrack 1.5    
--NAME    : LLSLinenAdjustmentTxnDet_Delete   
--DESCRIPTION  : DELETE RECORD  (UPDATE ISELDETED COLUMN) IN [LLSLinenAdjustmentTxnDet] TABLE     
--AUTHORS   : SIDDHANT    
--DATE    : 16-JAN-2020  
-------------------------------------------------------------------------------------------------------------------------    
--VERSION HISTORY     
--------------------:---------------:---------------------------------------------------------------------------------------    
--Init    : Date          : Details    
--------------------:---------------:---------------------------------------------------------------------------------------    
--SIDDHANT          : 16-JAN-2020 :     
-------:------------:----------------------------------------------------------------------------------------------------*/    
  
    
  
  
    
CREATE PROCEDURE  [dbo].[LLSLinenAdjustmentTxnDet_Delete]                               
    
(    
@ID AS INT  
)          
    
AS          
    
BEGIN    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
  
  
UPDATE LLSLinenAdjustmentTxnDet  
SET IsDeleted = 1  
WHERE LinenAdjustmentDetId = @ID   
  
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
END
GO
