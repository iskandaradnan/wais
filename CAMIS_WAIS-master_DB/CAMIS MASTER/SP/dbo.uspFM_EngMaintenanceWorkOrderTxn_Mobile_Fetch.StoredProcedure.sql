USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Mobile_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSpareParts_Fetch
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMaintenanceWorkOrderTxn_Mobile_Fetch]  @pMaintenanceWorkNo='WO/BEMS/000001',@pPageIndex=1,@pPageSize=50
EXEC uspFM_EngSpareParts_Fetch  @pSparePartNo=null,@pPageIndex=1,@pPageSize=5
select * from EngSpareParts
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Mobile_Fetch]                           
  @pMaintenanceWorkNo			NVARCHAR(100) =	NULL,
  @pAssetId					INT,
  @pPageIndex					INT,
  @pPageSize					INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngMaintenanceWorkOrderTxn						  WorkOrder WITH(NOLOCK)
		WHERE		((ISNULL(@pMaintenanceWorkNo,'') = '' )	OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND WorkOrder.MaintenanceWorkNo LIKE + '%' + @pMaintenanceWorkNo + '%' ))

		SELECT		WorkOrder.MaintenanceWorkNo,
					WorkOrder.WorkOrderId,
					WorkOrder.FacilityId
		FROM		EngMaintenanceWorkOrderTxn						  WorkOrder WITH(NOLOCK)
		WHERE		((ISNULL(@pMaintenanceWorkNo,'') = '' )	OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND WorkOrder.MaintenanceWorkNo LIKE + '%' + @pMaintenanceWorkNo + '%' )) and WorkOrder.AssetId=@pAssetId
		ORDER BY	WorkOrder.ModifiedDateUTC	 DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

		

END TRY

BEGIN CATCH

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
