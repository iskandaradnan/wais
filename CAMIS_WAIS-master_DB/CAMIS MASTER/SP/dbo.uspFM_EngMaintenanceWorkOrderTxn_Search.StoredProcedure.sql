USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Search]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMaintenanceWorkOrderTxn_Search
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngMaintenanceWorkOrderTxn_Search  @pWorkOrderNo='b',@pPageIndex=1,@pPageSize=5,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Search]                           
  @pWorkOrderNo				NVARCHAR(100)	=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pFacilityId				INT
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
		FROM		EngMaintenanceWorkOrderTxn EngMaintenanceWoTxn WITH(NOLOCK)
					INNER JOIN EngAsset EngAsset WITH(NOLOCK) ON EngMaintenanceWoTxn.AssetId = EngAsset.AssetId
					INNER JOIN FMLovMst LovTypeOfPlanner WITH(NOLOCK) ON EngMaintenanceWoTxn.TypeOfWorkOrder = LovTypeOfPlanner.LovId
		WHERE		EngAsset.Active =1
					AND ((ISNULL(@pWorkOrderNo,'') = '' )	OR (ISNULL(@pWorkOrderNo,'') <> '' AND EngMaintenanceWoTxn.MaintenanceWorkNo LIKE + '%' + @pWorkOrderNo + '%' ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND EngMaintenanceWoTxn.FacilityId = @pFacilityId))


		SELECT		EngMaintenanceWoTxn.WorkOrderId,
					EngMaintenanceWoTxn.MaintenanceWorkNo,
					EngMaintenanceWoTxn.MaintenanceWorkDateTime,
					EngMaintenanceWoTxn.AssetId,
					EngAsset.AssetNo,
					EngAsset.AssetDescription,
					EngMaintenanceWoTxn.TypeOfWorkOrder,
					LovTypeOfPlanner.FieldValue AS TypeOfWorkOrderName,
					EngMaintenanceWoTxn.MaintenanceDetails,
					EngMaintenanceWoTxn.TargetDateTime,
					EngMaintenanceWoTxn.TargetDateTime + (31) AS NextScheduleDateTime,
					@TotalRecords AS TotalRecords
		FROM		EngMaintenanceWorkOrderTxn EngMaintenanceWoTxn WITH(NOLOCK)
					INNER JOIN EngAsset EngAsset WITH(NOLOCK) ON EngMaintenanceWoTxn.AssetId = EngAsset.AssetId
					INNER JOIN FMLovMst LovTypeOfPlanner WITH(NOLOCK) ON EngMaintenanceWoTxn.TypeOfWorkOrder = LovTypeOfPlanner.LovId
		WHERE		EngAsset.Active =1
					AND ((ISNULL(@pWorkOrderNo,'') = '' )	OR (ISNULL(@pWorkOrderNo,'') <> '' AND EngMaintenanceWoTxn.MaintenanceWorkNo LIKE + '%' + @pWorkOrderNo + '%' ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND EngMaintenanceWoTxn.FacilityId = @pFacilityId))
		ORDER BY	EngMaintenanceWoTxn.ModifiedDateUTC DESC
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
