USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestWorkOrderTxn_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestWorkOrderTxn_Delete
Description			: To Delete CRM Work order details
Authors				: Dhilip V
Date				: 24-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_CRMRequestWorkOrderTxn_Delete  @pCRMRequestWOId	= 21
SELECT * FROM CRMRequestWorkOrderTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestWorkOrderTxn_Delete]
                         
	@pCRMRequestWOId	INT,
	@pUserId			INT		= NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @Table TABLE (ID INT)
-- Execution

	UPDATE CRMRequestWorkOrderTxn	SET	Status	=	143,
							ModifiedBy		=	@pUserId,
							ModifiedDate	=	GETDATE(),
							ModifiedDateUTC	=	GETUTCDATE()
	WHERE	CRMRequestWOId	=	@pCRMRequestWOId

	declare @reqId int
	set @reqId = (select CRMRequestId from CRMRequestWorkOrderTxn where CRMRequestWOId = @pCRMRequestWOId)

	UPDATE CRMRequest	SET	RequestStatus	=	143,
							ModifiedBy		=	@pUserId,
							ModifiedDate	=	GETDATE(),
							ModifiedDateUTC	=	GETUTCDATE()
	WHERE	CRMRequestId	=	@reqId



/*
	INSERT INTO @Table (ID)
	SELECT DocumentId FROM [CRMRequestWorkOrderAttachmentTxn] WHERE CRMRequestWOId	= @pCRMRequestWOId

	DELETE FROM [CRMRequestWorkOrderAttachmentTxn] WHERE CRMRequestWOId	= @pCRMRequestWOId

	DELETE FROM FMDocument WHERE DocumentId IN (SELECT ID FROM @Table)

	DELETE FROM CRMRequestCompletionInfo WHERE CRMRequestWOId	= @pCRMRequestWOId

	DELETE FROM CRMRequestAssessment WHERE CRMRequestWOId	= @pCRMRequestWOId

	DELETE FROM CRMRequestWorkOrderTxn WHERE CRMRequestWOId	= @pCRMRequestWOId
*/


	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH
GO
