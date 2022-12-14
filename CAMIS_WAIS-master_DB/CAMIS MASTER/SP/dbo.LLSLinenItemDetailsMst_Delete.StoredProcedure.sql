USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenItemDetailsMst_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================    
APPLICATION  : UETrack 1.5    
NAME    : LLSLinenItemDetailsMst_Delete   
DESCRIPTION  : DELETE RECORD  (UPDATE ISELDETED COLUMN) IN [LLSLinenItemDetailsMst] TABLE     
AUTHORS   : SIDDHANT    
DATE    : 8-JAN-2020  
-----------------------------------------------------------------------------------------------------------------------    
VERSION HISTORY     
------------------:---------------:---------------------------------------------------------------------------------------    
Init    : Date          : Details    
------------------:---------------:---------------------------------------------------------------------------------------    
SIDDHANT          : 8-JAN-2020 :     
-----:------------:----------------------------------------------------------------------------------------------------*/    
  
    
  
  
    
CREATE PROCEDURE  [dbo].[LLSLinenItemDetailsMst_Delete]                               
    
(    
@ID AS INT
,@ModifiedBy INT
)          
    
AS          
    
BEGIN    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
  
  
  
UPDATE LLSLinenItemDetailsMst  
SET IsDeleted = 1
   ,ModifiedBy=@ModifiedBy 
WHERE LinenItemId = @ID  
  
  
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
END

GO
