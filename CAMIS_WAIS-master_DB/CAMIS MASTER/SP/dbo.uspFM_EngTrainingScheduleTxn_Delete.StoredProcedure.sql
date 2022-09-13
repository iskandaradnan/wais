USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleTxn_Delete]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTrainingScheduleTxn_Delete
Description			: To Delete the user Training details
Authors				: Dhilip V
Date				: 09-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngTrainingScheduleTxn_Delete  @pTrainingScheduleId	= 21
SELECT * FROM EngTrainingScheduleTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTrainingScheduleTxn_Delete]                           
	@pTrainingScheduleId INT	
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

	--INSERT INTO @Table (ID)
	--SELECT DocumentId FROM EngTrainingScheduleTxnAttachment WHERE TrainingScheduleId	= @pTrainingScheduleId

	--DELETE FROM EngTrainingScheduleTxnAttachment WHERE TrainingScheduleId	= @pTrainingScheduleId

	--DELETE FROM FMDocument WHERE DocumentId IN (SELECT ID FROM @Table)	

	--DELETE FROM EngTrainingScheduleFeedbackTxn WHERE TrainingScheduleId	= @pTrainingScheduleId

	--DELETE FROM EngTrainingScheduleTxnDet WHERE TrainingScheduleId	= @pTrainingScheduleId

	--DELETE FROM EngTrainingScheduleTxn WHERE TrainingScheduleId	= @pTrainingScheduleId

	UPDATE EngTrainingScheduleTxn set TrainingStatus	=	263 WHERE TrainingScheduleId	= @pTrainingScheduleId

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
