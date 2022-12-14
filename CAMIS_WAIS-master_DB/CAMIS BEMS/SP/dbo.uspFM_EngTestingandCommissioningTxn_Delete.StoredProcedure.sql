USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxn_Delete]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTestingandCommissioningTxn_Delete
Description			: Delete the assetno in asset screen
Authors				: Dhilip V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngTestingandCommissioningTxn_Delete  @pTestingandCommissioningId=17
SELECT * FROM EngTestingandCommissioningTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTestingandCommissioningTxn_Delete]                           
	@pTestingandCommissioningId	INT	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Execution


	DELETE FROM	EngTestingandCommissioningTxnDet	WHERE TestingandCommissioningId	= @pTestingandCommissioningId

	DELETE FROM  EngTestingandCommissioningTxn		WHERE TestingandCommissioningId	= @pTestingandCommissioningId


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
		   )

END CATCH
GO
