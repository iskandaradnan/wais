USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_NotificationDeliveryDet_Delete]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockAdjustmentTxnDet_Delete
Description			: To Delete Stock Adjustment from EngStockAdjustmentTxnDet table.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_NotificationDeliveryDet_Delete]  @pNotificationDeliveryId='24'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_NotificationDeliveryDet_Delete]                           
	@pNotificationDeliveryId	NVARCHAR(250)	
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

	DELETE FROM  NotificationDeliveryDet 
	WHERE NotificationDeliveryId IN  (SELECT ITEM FROM dbo.[SplitString] (@pNotificationDeliveryId,','))

	
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
