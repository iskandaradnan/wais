USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxn_FetchYear]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[LLSCentralLinenStoreHKeepingTxn_FetchYear]      
AS      
      
BEGIN      
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
      
      
----DECLARE @YEAR INT    
----DECLARE @MONTHNAME VARCHAR(20)    
    
--SET @YEAR=2019    
----SET @MONTHNAME='January'    
    
SELECT DISTINCT [Year] FROM LLSDate    
--WHERE [Year]=@YEAR    
  
      
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
      
    
END
GO
