USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngWarrantyManagementTxnWO_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngWarrantyManagementTxnWO_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Asset Register id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngWarrantyManagementTxnWO_GetById] @pWarrantyMgmtId=12,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngWarrantyManagementTxnWO_GetById]                           
  @pUserId			INT	=	NULL,
  @pWarrantyMgmtId	INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pWarrantyMgmtId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngWarrantyManagementTxn							AS WarrantyManagement		WITH(NOLOCK)
			INNER JOIN	EngAsset								AS Asset					WITH(NOLOCK) on WarrantyManagement.AssetId				= Asset.AssetId
			INNER  JOIN  EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder		WITH(NOLOCK) on WarrantyManagement.AssetId				= MaintenanceWorkOrder.AssetId
			INNER  JOIN  EngMwoCompletionInfoTxn				AS CompletionInfo			WITH(NOLOCK) on MaintenanceWorkOrder.WorkOrderId		= CompletionInfo.WorkOrderId
			INNER  JOIN	FMLovMst								AS WorkOrderType			WITH(NOLOCK) on MaintenanceWorkOrder.TypeOfWorkOrder	= WorkOrderType.LovId
			INNER  JOIN	FMLovMst								AS WorkOrderStatus			WITH(NOLOCK) on MaintenanceWorkOrder.WorkOrderStatus	= WorkOrderStatus.LovId
			INNER  JOIN  EngMwoAssesmentTxn						AS Assesment				WITH(NOLOCK) on MaintenanceWorkOrder.WorkOrderId		= Assesment.WorkOrderId
	WHERE	WarrantyManagement.WarrantyMgmtId = @pWarrantyMgmtId  

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	WarrantyManagement.WarrantyMgmtId					AS WarrantyMgmtId,
			WarrantyManagement.WarrantyNo						AS WarrantyNo,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			WorkOrderType.FieldValue							AS WorkOrderType,
			Assesment.ResponseDateTime							AS ResponseDateTime,
			Assesment.ResponseDateTimeUTC						AS ResponseDateTimeUTC,		
			MaintenanceWorkOrder.TargetDateTime					AS TargetDateTime,
			CompletionInfo.EndDateTime							AS CompletionDatetime,
			CompletionInfo.EndDateTimeUTC						AS CompletionDatetimeUTC,
			WorkOrderStatus.FieldValue							AS WorkOrderStatus,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	EngWarrantyManagementTxn							AS WarrantyManagement		WITH(NOLOCK)
			INNER JOIN	EngAsset								AS Asset					WITH(NOLOCK) on WarrantyManagement.AssetId				= Asset.AssetId
			INNER  JOIN  EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder		WITH(NOLOCK) on WarrantyManagement.AssetId				= MaintenanceWorkOrder.AssetId
			INNER  JOIN  EngMwoCompletionInfoTxn				AS CompletionInfo			WITH(NOLOCK) on MaintenanceWorkOrder.WorkOrderId		= CompletionInfo.WorkOrderId
			INNER  JOIN	FMLovMst								AS WorkOrderType			WITH(NOLOCK) on MaintenanceWorkOrder.TypeOfWorkOrder	= WorkOrderType.LovId
			INNER  JOIN	FMLovMst								AS WorkOrderStatus			WITH(NOLOCK) on MaintenanceWorkOrder.WorkOrderStatus	= WorkOrderStatus.LovId
			INNER  JOIN  EngMwoAssesmentTxn						AS Assesment				WITH(NOLOCK) on MaintenanceWorkOrder.WorkOrderId		= Assesment.WorkOrderId
	WHERE	WarrantyManagement.WarrantyMgmtId = @pWarrantyMgmtId AND Asset.WarrantyEndDate>GETDATE()
	ORDER BY WarrantyManagement.ModifiedDate ASC
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
