USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetPPMChecklistUsingWorkOrderId_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSpareParts_GetById
Description			: Get the SpareParts details by passing the SparePartsId.
Authors				: Dhilip V
Date				: 26-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_GetPPMChecklistUsingWorkOrderId_GetById]  @pWorkOrderId=1
SELECT * FROM EngSpareParts
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_GetPPMChecklistUsingWorkOrderId_GetById]                           
  @pWorkOrderId		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

    SELECT	PPMCheckList.PPMCheckListId							AS LovId,
			PPMCheckList.PPMChecklistNo							AS FieldValue,
			0													AS IsDefault
 	FROM	EngMaintenanceWorkOrderTxn							AS  MaintenanceWorkOrder		WITH(NOLOCK)	
			INNER JOIN	EngAsset								AS	Asset					WITH(NOLOCK)	ON MaintenanceWorkOrder.AssetId			=	Asset.AssetId
			INNER JOIN	EngAssetTypeCode						AS	AssetTypeCode			WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId		=	Asset.AssetTypeCodeId
			INNER JOIN	EngAssetPPMCheckList					AS	PPMCheckList			WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId		=	PPMCheckList.AssetTypeCodeId

	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId 

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
