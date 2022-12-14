USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleTxnDet_Delete]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTrainingScheduleTxnDet_Delete
Description			: To Delete QAPIndicator details from MstQAPIndicatorDet table.
Authors				: Dhilip V
Date				: 09-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngTrainingScheduleTxnDet_Delete  @pTrainingScheduleDetId	=	'41'
SELECT * FROM EngTrainingScheduleTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTrainingScheduleTxnDet_Delete]  
                        
	@pTrainingScheduleDetId	NVARCHAR(250)	

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


	DELETE FROM  EngTrainingScheduleTxnDet	
	WHERE TrainingScheduleDetId IN  (SELECT ITEM FROM dbo.[SplitString] (@pTrainingScheduleDetId,','))
	


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
