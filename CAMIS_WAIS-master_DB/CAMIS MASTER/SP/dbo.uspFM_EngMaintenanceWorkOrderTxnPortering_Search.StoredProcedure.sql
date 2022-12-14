USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxnPortering_Search]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngMaintenanceWorkOrderTxnPortering_Search]
Description			: MaintenanceWorkOrder Search popup
Authors				: Dhilip V
Date				: 30-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMaintenanceWorkOrderTxnPortering_Search]  @pMaintenanceWorkNo='PAN101',@pPageIndex=1,@pPageSize=20,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxnPortering_Search]                           
                            
  @pMaintenanceWorkNo	NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pAssetId				INT

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
		            LEFT JOIN   EngLoanerTestEquipmentBookingTxn	AS Book				    WITH(NOLOCK) ON	Asset.AssetId					= book.AssetId	AND BOOK.BookingEnd >= GETDATE()						
					INNER JOIN	EngMaintenanceWorkOrderTxn			AS MaintenanceWorkOrder	WITH(NOLOCK) ON Asset.AssetId					= MaintenanceWorkOrder.AssetId
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					INNER JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId
					INNER JOIN	MstLocationBlock					AS LocationBlock		WITH(NOLOCK) ON	UserArea.BlockId				= LocationBlock.BlockId
					INNER JOIN	MstLocationLevel					AS LocationLevel		WITH(NOLOCK) ON	UserArea.LevelId				= LocationLevel.LevelId
		WHERE		Asset.Active =1
					AND ((ISNULL(@pMaintenanceWorkNo,'')='' )		OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND MaintenanceWorkOrder.MaintenanceWorkNo LIKE '%' + @pMaintenanceWorkNo + '%'))
					AND ((ISNULL(@pAssetId,'')='' )		OR (ISNULL(@pAssetId,'') <> '' AND Asset.AssetId = @pAssetId))
					AND MaintenanceWorkOrder.WorkOrderId NOT IN (SELECT ISNULL(WorkOrderId,'') FROM EngLoanerTestEquipmentBookingTxn WHERE BookingEnd >= GETDATE())
					AND MaintenanceWorkOrder.TypeOfWorkOrder IN (34,270,271,272,273,274,275)

		SELECT		MaintenanceWorkOrder.WorkOrderId,
					MaintenanceWorkOrder.MaintenanceWorkNo,
					Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetNoOld,
					Asset.CustomerId,
					Asset.AssetDescription,
					Asset.CustomerId,
					Asset.IsLoaner,
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
					BOOK.BookingStartFrom,
					BOOK.BookingEnd,
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)

					LEFT JOIN   EngLoanerTestEquipmentBookingTxn	AS Book				    WITH(NOLOCK) ON	Asset.AssetId					= book.AssetId		AND BOOK.BookingEnd >= GETDATE()					
					INNER JOIN	EngMaintenanceWorkOrderTxn			AS MaintenanceWorkOrder	WITH(NOLOCK) ON Asset.AssetId					= MaintenanceWorkOrder.AssetId
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					INNER JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId
					INNER JOIN	MstLocationBlock					AS LocationBlock		WITH(NOLOCK) ON	UserArea.BlockId				= LocationBlock.BlockId
					INNER JOIN	MstLocationLevel					AS LocationLevel		WITH(NOLOCK) ON	UserArea.LevelId				= LocationLevel.LevelId
		WHERE		Asset.Active =1
					AND ((ISNULL(@pMaintenanceWorkNo,'')='' )		OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND MaintenanceWorkOrder.MaintenanceWorkNo LIKE '%' + @pMaintenanceWorkNo + '%'))
					AND ((ISNULL(@pAssetId,'')='' )		OR (ISNULL(@pAssetId,'') <> '' AND Asset.AssetId = @pAssetId))
					AND MaintenanceWorkOrder.WorkOrderId NOT IN (SELECT ISNULL(WorkOrderId,'') FROM EngLoanerTestEquipmentBookingTxn WHERE BookingEnd >= GETDATE())
					AND MaintenanceWorkOrder.TypeOfWorkOrder IN (34,270,271,272,273,274,275)
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
		   );
		THROW;

END CATCH
GO
