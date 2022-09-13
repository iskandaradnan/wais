USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_BlockTMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[Master_BlockTMst_Save]                           

(
	@BlockId  int
)	     

AS      

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
				
INSERT INTO MstServices_Mapping_block (Master_Block_ID,BEMS,FEMS,CLS,LLS,HWMS) Values (@BlockId,0,0,0,0,0)  
	

	

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
