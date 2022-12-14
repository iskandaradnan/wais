USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_GetLocationInfo]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngMaintenanceWorkOrderTxnPortering_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMaintenanceWorkOrderTxnPortering_Fetch]  @pMaintenanceWorkNo='PAN101',@pPageIndex=1,@pPageSize=20
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
create PROCEDURE  [dbo].[uspFM_EngAsset_GetLocationInfo]                           
                            
  @pMaintenanceWorkNo	NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT

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
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngMaintenanceWorkOrderTxn			AS MaintenanceWorkOrder	WITH(NOLOCK) ON Asset.AssetId					= MaintenanceWorkOrder.AssetId
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					INNER JOIN	MstLocationBlock					AS LocationBlock		WITH(NOLOCK) ON	Asset.FacilityId				= LocationBlock.FacilityId
					INNER JOIN	MstLocationLevel					AS LocationLevel		WITH(NOLOCK) ON	Asset.FacilityId				= LocationLevel.FacilityId
					INNER JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId

		WHERE		Asset.Active =1
					AND ((ISNULL(@pMaintenanceWorkNo,'')='' )		OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND MaintenanceWorkOrder.MaintenanceWorkNo LIKE '%' + @pMaintenanceWorkNo + '%'))
	

		SELECT		MaintenanceWorkOrder.WorkOrderId,
					MaintenanceWorkOrder.MaintenanceWorkNo,
					Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetNoOld,
					Asset.AssetDescription,
					Asset.CustomerId,
					LocationFacility.FacilityId,
					LocationFacility.FacilityCode,
					LocationFacility.FacilityName,
					LocationBlock.BlockId,
					LocationBlock.BlockCode,
					LocationBlock.BlockName,
					LocationLevel.LevelId,
					LocationLevel.LevelCode,
					LocationLevel.LevelName,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngMaintenanceWorkOrderTxn			AS MaintenanceWorkOrder	WITH(NOLOCK) ON Asset.AssetId					= MaintenanceWorkOrder.AssetId
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					INNER JOIN	MstLocationBlock					AS LocationBlock		WITH(NOLOCK) ON	Asset.FacilityId				= LocationBlock.FacilityId
					INNER JOIN	MstLocationLevel					AS LocationLevel		WITH(NOLOCK) ON	Asset.FacilityId				= LocationLevel.FacilityId
					INNER JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId

		WHERE		Asset.Active =1
					AND ((ISNULL(@pMaintenanceWorkNo,'')='' )		OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND MaintenanceWorkOrder.MaintenanceWorkNo LIKE '%' + @pMaintenanceWorkNo + '%'))
		ORDER BY	MaintenanceWorkOrder.ModifiedDateUTC DESC
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
