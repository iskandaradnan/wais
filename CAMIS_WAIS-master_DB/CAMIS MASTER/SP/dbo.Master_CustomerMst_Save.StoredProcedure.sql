USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_CustomerMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE  [dbo].[Master_CustomerMst_Save]                           

(
	@CustomerId  int
)	     

AS      

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
				
INSERT INTO MstCustomer_Mapping (CustomerId,BEMS_ID,FEMS_ID,CLS_ID,LLS_ID,HWMS_ID) Values (@CustomerId,0,0,0,0,0)  
	

	

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
