USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLoanerTestEquipmentBookingTxn_WorkOderNo_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngMaintenanceWorkOrderTxnPortering_Fetch]
Description			: Maintenance Work Order fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMaintenanceWorkOrderTxnPortering_Fetch]  @pMaintenanceWorkNo='',@pPageIndex=1,@pPageSize=200,@pFacilityId=2
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngLoanerTestEquipmentBookingTxn_WorkOderNo_Fetch]                           
                            
  @pMaintenanceWorkNo	NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pAssetId			INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
/*
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngMaintenanceWorkOrderTxn			AS MaintenanceWorkOrder	WITH(NOLOCK) ON Asset.AssetId					= MaintenanceWorkOrder.AssetId
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					LEFT JOIN   EngLoanerTestEquipmentBookingTxn	AS Book				    WITH(NOLOCK) ON	Asset.AssetId					= book.AssetId					
		WHERE		Asset.Active =1  and asset.IsLoaner=1
					AND ((ISNULL(@pMaintenanceWorkNo,'')='' )		OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND MaintenanceWorkOrder.MaintenanceWorkNo LIKE '%' + @pMaintenanceWorkNo + '%'))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
*/
SELECT DISTINCT * INTO	#TempWO	 FROM( 
		SELECT		DISTINCT MaintenanceWorkOrder.WorkOrderId,
					MaintenanceWorkOrder.MaintenanceWorkNo,
					Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetDescription,
					Asset.CustomerId,
					Asset.TypeOfAsset,
					LocationFacility.FacilityId,
					LocationFacility.FacilityName--,
					--Book.BookingStartFrom,
					--book.BookingEnd
		
					--@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					LEFT JOIN   EngLoanerTestEquipmentBookingTxn	AS Book				    WITH(NOLOCK) ON	Asset.AssetId					= book.AssetId					
					INNER JOIN	EngMaintenanceWorkOrderTxn			AS MaintenanceWorkOrder	WITH(NOLOCK) ON Asset.AssetId					= MaintenanceWorkOrder.AssetId
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId					
		WHERE		Asset.Active =1 and asset.IsLoaner=1
					AND ((ISNULL(@pMaintenanceWorkNo,'')='' )		OR (ISNULL(@pMaintenanceWorkNo,'') <> '' AND MaintenanceWorkOrder.MaintenanceWorkNo LIKE '%' + @pMaintenanceWorkNo + '%'))
					--AND ((ISNULL(@pAssetId,'')='' )		OR (ISNULL(@pAssetId,'') <> '' AND Asset.AssetId LIKE '%' + @pMaintenanceWorkNo + '%'))
					--AND ( TypeOfWorkOrder != 273 OR MaintenanceWorkType != 273 )
					AND ((ISNULL(@pAssetId,'')='' )		OR (ISNULL(@pAssetId,'') <> '' AND Asset.AssetId = @pAssetId))
		--ORDER BY	MaintenanceWorkOrder.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
		) A

		SELECT		@TotalRecords	=	COUNT(Distinct WorkOrderId)
		FROM #TempWO	

		SELECT		Distinct WorkOrderId,
					MaintenanceWorkNo,
					AssetId,
					AssetNo,
					AssetDescription,
					CustomerId,
					TypeOfAsset,
					FacilityId,
					FacilityName,
					cast(null as date) as BookingStartFrom,
					cast(null as date) as BookingEnd,
					--BookingStartFrom,
					--BookingEnd,
					@TotalRecords AS TotalRecords
		FROM	#TempWO	
		ORDER BY	WorkOrderId DESC
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
