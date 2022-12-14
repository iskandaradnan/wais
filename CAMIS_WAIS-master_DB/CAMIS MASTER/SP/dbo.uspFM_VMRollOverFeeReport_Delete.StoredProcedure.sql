USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMRollOverFeeReport_Delete]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VMRollOverFeeReport_Delete
Description			: To Delete Summary of Fee report in VM module.
Authors				: Dhilip V
Date				: 24-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_VMRollOverFeeReport_Delete  @pRollOverFeeId	= 21
SELECT * FROM VMRollOverFeeReport
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_VMRollOverFeeReport_Delete]
                         
	@pRollOverFeeId INT	

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Execution



	DELETE FROM VmRollOverFeeReportHistoryDet WHERE RollOverFeeId	= @pRollOverFeeId

	DELETE FROM VMRollOverFeeReport WHERE RollOverFeeId	= @pRollOverFeeId


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
