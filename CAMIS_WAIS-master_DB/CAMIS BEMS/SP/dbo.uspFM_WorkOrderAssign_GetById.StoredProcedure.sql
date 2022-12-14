USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WorkOrderAssign_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstCustomer_GetById
Description			: To Get the data from table MstCustomer using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_WorkOrderAssign_GetById]  @pCRMRequestWOId= 331

select * from CRMRequestWorkOrderTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_WorkOrderAssign_GetById]                           

  @pCRMRequestWOId   INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pCRMRequestWOId,0) = 0) RETURN

    SELECT	CRW.CRMRequestWOId,
			CRW.TypeOfRequest,
			TypeOfRequest.FieldValue AS TypeOfRequestValue
	FROM	CRMRequestWorkOrderTxn		AS CRW WITH(NOLOCK)
	INNER JOIN FMLovMst		AS		TypeOfRequest				ON CRW.TypeOfRequest = TypeOfRequest.LovId
	WHERE	CRW.CRMRequestWOId = @pCRMRequestWOId 
	ORDER BY CRW.ModifiedDate ASC

	SELECT	CRW.CRMRequestWOId,
			CRW.CRMWorkOrderNo,
			CRW.CRMWorkOrderDateTime
	FROM	CRMRequestWorkOrderTxn		AS CRW WITH(NOLOCK)
	
	WHERE	CRW.CRMRequestWOId = @pCRMRequestWOId 
	ORDER BY CRW.ModifiedDate ASC
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
