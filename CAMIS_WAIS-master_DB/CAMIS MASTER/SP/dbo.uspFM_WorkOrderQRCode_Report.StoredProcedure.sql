USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WorkOrderQRCode_Report]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMaintenanceWorkOrderTxn_Save
Description			: If Maintenance Work Order already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_WorkOrderQRCode_Report] @pFacilityId=2

select * from QRCodeAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WorkOrderQRCode_Report]
	@pFacilityId INT = NULL	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @mBatchId INT

	SELECT @mBatchId	=	MAX(cast(BatchGenerated as int))  FROM QRCodeWorkOrder WHERE FacilityId	=	@pFacilityId


	SELECT	B.MaintenanceWorkNo,
			B.QRCode,
			C.CustomerName 
	FROM	QRCodeWorkOrder A 
			INNER JOIN EngMaintenanceWorkOrderTxn B ON A.WorkOrderId = B.WorkOrderId
			INNER JOIN MstCustomer C ON C.CustomerId = b.CustomerId 
	WHERE	A.BatchGenerated	= @mBatchId
			AND  A.FacilityId	=	@pFacilityId




	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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
		   );
THROW;
END CATCH
GO
