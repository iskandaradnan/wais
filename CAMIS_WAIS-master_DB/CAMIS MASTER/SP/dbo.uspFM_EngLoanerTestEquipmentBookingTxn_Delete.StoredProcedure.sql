USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngLoanerTestEquipmentBookingTxn_Delete
Description			: To Delete Portering Transaction details
Authors				: Dhilip V
Date				: 01-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngLoanerTestEquipmentBookingTxn_Delete  @pLoanerTestEquipmentBookingId	=	9
SELECT * FROM PorteringTransaction
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Delete]  
                        
	@pLoanerTestEquipmentBookingId	INT	

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	DELETE FROM  EngLoanerTestEquipmentBookingTxn WHERE LoanerTestEquipmentBookingId= @pLoanerTestEquipmentBookingId



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
