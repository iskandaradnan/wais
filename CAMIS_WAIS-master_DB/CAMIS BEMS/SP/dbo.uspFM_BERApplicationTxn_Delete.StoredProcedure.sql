USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_Delete]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERApplicationTxn_Delete
Description			: To Delete BERApplicationTxn details
Authors				: Dhilip V
Date				: 12-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_BERApplicationTxn_Delete  @pApplicationId	= 21
SELECT * FROM BERApplicationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_BERApplicationTxn_Delete]                           
	@pApplicationId INT	
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

	INSERT INTO @Table (ID)
	SELECT DocumentId FROM BERApplicationAttachmentTxn WHERE ApplicationId	= @pApplicationId

	DELETE FROM BERApplicationAttachmentTxn WHERE ApplicationId	= @pApplicationId

	DELETE FROM FMDocument WHERE DocumentId IN (SELECT ID FROM @Table)

	DELETE FROM BERApplicationHistoryTxn WHERE ApplicationId	= @pApplicationId

	DELETE FROM BERApplicationRemarksHistoryTxn WHERE ApplicationId	= @pApplicationId

	DELETE FROM BerCurrentValueHistoryTxnDet WHERE ApplicationId	= @pApplicationId

	DELETE FROM BERApplicationTxn WHERE ApplicationId	= @pApplicationId


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
