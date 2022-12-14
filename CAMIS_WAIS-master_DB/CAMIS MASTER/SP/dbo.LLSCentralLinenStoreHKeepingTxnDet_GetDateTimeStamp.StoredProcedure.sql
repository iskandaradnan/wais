USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxnDet_GetDateTimeStamp]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[LLSCentralLinenStoreHKeepingTxnDet_GetDateTimeStamp]  
@pHouseKeepingDetId INT 
AS  
  
BEGIN  
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
  
  
UPDATE
dbo.LLSCentralLinenStoreHKeepingTxnDet
SET DateTimeStamp = FORMAT(GETDATE(),
'DD-MMM-YYYY HH:MM:SS') 
WHERE HouseKeepingDetId = @pHouseKeepingDetId  
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
  

END
GO
