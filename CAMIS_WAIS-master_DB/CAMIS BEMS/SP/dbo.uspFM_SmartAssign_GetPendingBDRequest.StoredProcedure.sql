USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SmartAssign_GetPendingBDRequest]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_SmartAssign_GetPendingBDRequest
Description			: Assign the staff for work order
Authors				: Dhilip V
Date				: 06-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_SmartAssign_GetPendingBDRequest] 

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_SmartAssign_GetPendingBDRequest]


AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	SELECT	WorkOrderId,
			Facility.FacilityId,
			Facility.Latitude,
			Facility.Longitude,
			MaintenanceWorkNo
	FROM	EngMaintenanceWorkOrderTxn AS WorkOrder
			INNER JOIN	[dbo].[MstLocationFacility] Facility ON	WorkOrder.FacilityId = Facility.FacilityId
	WHERE	MaintenanceWorkCategory	=	188 AND (AssigneeLovId = 330 OR AssigneeLovId IS NULL)

END TRY


BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   );
		   THROW;

END CATCH
GO
