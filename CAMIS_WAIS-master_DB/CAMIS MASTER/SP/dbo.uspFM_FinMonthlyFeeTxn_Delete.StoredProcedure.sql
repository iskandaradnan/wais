USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FinMonthlyFeeTxn_Delete]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FinMonthlyFeeTxn_Delete
Description			: To Delete CategorySystem details from EngEODCategorySystemDet table.
Authors				: Dhilip V
Date				: 27-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_FinMonthlyFeeTxn_Delete  @MonthlyFeeId	=	'1,5,4'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FinMonthlyFeeTxn_Delete]                           
	@pMonthlyFeeId	NVARCHAR(100)		
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

	DELETE FROM  FinMonthlyFeeHistoryTxnDet WHERE MonthlyFeeId = @pMonthlyFeeId

	DELETE FROM  FinMonthlyFeeTxnDet WHERE MonthlyFeeId = @pMonthlyFeeId

	DELETE FROM  FinMonthlyFeeTxn WHERE MonthlyFeeId = @pMonthlyFeeId


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
