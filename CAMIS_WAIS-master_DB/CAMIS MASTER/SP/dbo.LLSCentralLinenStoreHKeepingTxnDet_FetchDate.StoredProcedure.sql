USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxnDet_FetchDate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[LLSCentralLinenStoreHKeepingTxnDet_FetchDate]  
@pYear AS INT
,@pMonthName AS VARCHAR(20)
AS  
  
BEGIN  
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
  
  
SELECT Date FROM dbo.LLSDate
WHERE Year = @pYear 
AND DATENAME(month, Date) = @pMonthName
ORDER BY Date   
  
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
  

END
GO
