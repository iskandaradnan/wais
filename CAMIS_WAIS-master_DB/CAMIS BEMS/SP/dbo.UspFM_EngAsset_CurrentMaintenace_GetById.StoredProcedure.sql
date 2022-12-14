USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAsset_CurrentMaintenace_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoPartReplacementTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngAsset_CurrentMaintenace_GetById] @pAssetId=1,@pPageIndex=1,@pPageSize=5,@pUserId=1

SELECT * FROM EngSpareParts
SELECT * FROM EngStockUpdateRegisterTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngAsset_CurrentMaintenace_GetById]                           
  --@pUserId			INT	=	NULL,
  @pAssetId			INT--,
  --@pPageIndex		INT,
  --@pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @TotalRecords INT
	--DECLARE	@pTotalPage		NUMERIC(24,2)

	--IF(ISNULL(@pAssetId,0) = 0) RETURN

	--SELECT	@TotalRecords	=	COUNT(*)
	--FROM	EngAsset											AS Asset
	--		INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on Asset.AssetId									= MaintenanceWorkOrder.AssetId
	--		INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
	--		INNER JOIN  FMLovMst								AS TypeofWO							WITH(NOLOCK)			on MaintenanceWorkOrder.TypeOfWorkOrder 			= TypeofWO.LovId
	--		INNER JOIN  FMLovMst								AS WorkCategory						WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory 	= WorkCategory.LovId
			
			
	--WHERE	MaintenanceWorkOrder.AssetId = @pAssetId AND MaintenanceWorkOrder.MaintenanceWorkCategory = 187 AND MaintenanceWorkOrder.TypeOfWorkOrder = 34  

	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPage = CEILING(@pTotalPage)

	

	SELECT	Asset.AssetId										AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			AssetTypeCode.AssetTypeCodeId						AS AssetTypeCodeId,
			AssetTypeCode.AssetTypeCode							AS AssetTypeCode,
			MaintenanceWorkOrder.WorkOrderId					AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenaceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS WorkOrderDate,
			MaintenanceWorkOrder.TypeOfWorkOrder				AS WorkCategoryId,
			TypeofWO.FieldValue									AS WorkCategory,
			MaintenanceWorkOrder.MaintenanceWorkCategory		AS TypeId,
			WorkCategory.FieldValue								AS Type--,
			--@TotalRecords										AS TotalRecords,
			--@pTotalPage											AS TotalPageCalc
	FROM	EngAsset											AS Asset
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on Asset.AssetId									= MaintenanceWorkOrder.AssetId
			INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  FMLovMst								AS TypeofWO							WITH(NOLOCK)			on MaintenanceWorkOrder.TypeOfWorkOrder 			= TypeofWO.LovId
			INNER JOIN  FMLovMst								AS WorkCategory						WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory 	= WorkCategory.LovId
			
			
	WHERE	MaintenanceWorkOrder.AssetId = @pAssetId AND MaintenanceWorkOrder.MaintenanceWorkCategory = 187 AND MaintenanceWorkOrder.TypeOfWorkOrder = 34
	ORDER BY (MaintenanceWorkOrder.MaintenanceWorkDateTime) DESC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	--DECLARE @TotalRecordsus INT
	--DECLARE	@pTotalPageus		NUMERIC(24,2)

	--IF(ISNULL(@pAssetId,0) = 0) RETURN

	--SELECT	@TotalRecordsus	=	COUNT(*)
	--FROM	EngAsset											AS Asset
	--		INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on Asset.AssetId									= MaintenanceWorkOrder.AssetId
	--		INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
	--		INNER JOIN  FMLovMst								AS TypeofWO							WITH(NOLOCK)			on MaintenanceWorkOrder.TypeOfWorkOrder 			= TypeofWO.LovId
	--		INNER JOIN  FMLovMst								AS WorkCategory						WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory 	= WorkCategory.LovId
			
			
	--WHERE	MaintenanceWorkOrder.AssetId = @pAssetId AND MaintenanceWorkOrder.MaintenanceWorkCategory = 188 

	--SET @pTotalPageus = CAST(@TotalRecordsus AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPageus = CEILING(@pTotalPageus)

		SELECT	Asset.AssetId									AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			AssetTypeCode.AssetTypeCodeId						AS AssetTypeCodeId,
			AssetTypeCode.AssetTypeCode							AS AssetTypeCode,
			MaintenanceWorkOrder.WorkOrderId					AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenaceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS WorkOrderDate,
			MaintenanceWorkOrder.TypeOfWorkOrder				AS WorkCategoryId,
			TypeofWO.FieldValue									AS WorkCategory,
			MaintenanceWorkOrder.MaintenanceWorkCategory		AS TypeId,
			WorkCategory.FieldValue								AS Type--,
			--@TotalRecordsus										AS TotalRecords,
			--@pTotalPageus										AS TotalPageCalc
	FROM	EngAsset											AS Asset
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on Asset.AssetId									= MaintenanceWorkOrder.AssetId
			INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  FMLovMst								AS TypeofWO							WITH(NOLOCK)			on MaintenanceWorkOrder.TypeOfWorkOrder 			= TypeofWO.LovId
			INNER JOIN  FMLovMst								AS WorkCategory						WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory 	= WorkCategory.LovId
			
			
	WHERE	MaintenanceWorkOrder.AssetId = @pAssetId AND MaintenanceWorkOrder.MaintenanceWorkCategory = 188
	ORDER BY (MaintenanceWorkOrder.MaintenanceWorkDateTime) DESC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



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
