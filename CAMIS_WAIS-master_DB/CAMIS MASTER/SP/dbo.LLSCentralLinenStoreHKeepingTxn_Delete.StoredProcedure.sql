USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxn_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[LLSCentralLinenStoreHKeepingTxn_Delete]                                     
          
(          
@ID AS INT  
,@ModifiedBy AS INT
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
        
UPDATE LLSCentralLinenStoreHKeepingTxn        
SET IsDeleted = 1        
,ModifiedBy=@ModifiedBy
WHERE HouseKeepingId = @ID        
        
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END                                   
GO
