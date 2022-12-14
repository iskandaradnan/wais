USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetRealTimeStatus_GetByAssetId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetRealTimeStatus_GetByAssetId
Description			: Get the Service work order based on realtime status for assets
Authors				: Dhilip V
Date				: 18-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetRealTimeStatus_GetByAssetId  @pAssetId=3
select * from EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetRealTimeStatus_GetByAssetId]      
                     
  @pAssetId		INT

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

	IF(ISNULL(@pAssetId,0) = 0) RETURN

    SELECT	Asset.AssetId,
			MWO.WorkOrderId,
			MWO.MaintenanceWorkNo			AS	ServiceWorkNo,
			MWO.MaintenanceWorkDateTime		AS  ServiceWorkDateTime,
			LovRealStatus.FieldValue		AS	RealTimeStatus,
			Asset.ModifiedDate
 	FROM	EngAsset								AS	Asset			WITH(NOLOCK)	
			INNER JOIN EngMaintenanceWorkOrderTxn	AS	MWO				WITH(NOLOCK)	ON Asset.AssetId					=	MWO.AssetId
			INNER JOIN EngMwoAssesmentTxn			AS	MWOAssesment	WITH(NOLOCK)	ON MWO.WorkOrderId					=	MWOAssesment.WorkOrderId
			INNER JOIN FMLovMst						AS	LovRealStatus	WITH(NOLOCK)	ON MWOAssesment.AssetRealtimeStatus	=	LovRealStatus.LovId
WHERE	Asset.AssetId = @pAssetId 

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
