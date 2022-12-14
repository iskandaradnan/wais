USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetMaintenanceHistory_GetByAssetId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetMaintenanceHistory_GetByAssetId
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetMaintenanceHistory_GetByAssetId  @pAssetId=139

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetMaintenanceHistory_GetByAssetId]   
                       
  @pAssetId			INT

AS                                                     

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pAssetId,0) = 0) RETURN

    SELECT	MaintenanceWO.WorkOrderId,
			MaintenanceWO.MaintenanceWorkNo						AS	MaintenaceWorkNo,
			CASE WHEN MaintenanceWO.MaintenanceWorkCategory = 187 THEN
			CAST(MWOCompletionInfo.StartDateTime AS DATE)
			ELSE
			CAST(MaintenanceWO.MaintenanceWorkDateTime AS DATE) 
			END													AS	WorkOrderDate,
			MaintenanceWO.MaintenanceWorkCategory				AS MaintenanceWorkCategory,
			LovMWOCategory.FieldValue							AS	WorkCategory ,
			LovMWOType.FieldValue								AS	Type,
			ISNULL(MAX(DownTimeHours),0.00)	AS	TotalDownTime,
			SUM(ISNULL(MwoPartRep.TotalPartsCost,0.00))			AS	SparepartsCost,
			SUM(ISNULL(MwoPartRep.LabourCost,0.00))				AS	LabourCost,
			SUM(ISNULL(MwoPartRep.TotalCost,0.00))				AS	TotalCost
	
 	FROM	EngMaintenanceWorkOrderTxn				AS	MaintenanceWO		WITH(NOLOCK)
			INNER JOIN	EngAsset					AS	Asset				WITH(NOLOCK)	ON Asset.AssetId							=	MaintenanceWO.AssetId
			LEFT JOIN	EngMwoCompletionInfoTxn		AS	MWOCompletionInfo	WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MWOCompletionInfo.WorkOrderId
			LEFT JOIN	EngMwoPartReplacementTxn	AS	MwoPartRep			WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MwoPartRep.WorkOrderId
			INNER JOIN	FMLovMst					AS	LovMWOCategory		WITH(NOLOCK)	ON MaintenanceWO.MaintenanceWorkCategory	=	LovMWOCategory.LovId
			INNER JOIN	FMLovMst					AS	LovMWOType			WITH(NOLOCK)	ON MaintenanceWO.TypeOfWorkOrder			=	LovMWOType.LovId
	WHERE	MaintenanceWO.AssetId	=	@pAssetId
	GROUP BY MaintenanceWO.WorkOrderId, 
			MaintenanceWO.MaintenanceWorkNo,
			MaintenanceWO.MaintenanceWorkDateTime,
			MWOCompletionInfo.StartDateTime,
			MaintenanceWO.MaintenanceWorkCategory,
			LovMWOCategory.FieldValue,
			MaintenanceWO.TypeOfWorkOrder,
			LovMWOType.FieldValue				
	ORDER BY	MaintenanceWO.MaintenanceWorkDateTime ASC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 


	SELECT	DISTINCT MaintenanceWO.WorkOrderId ,
			SpareParts.PartNo ,
			SpareParts.PartDescription ,
			ItemMst.ItemNo ,
			ItemMst.ItemDescription ,
			SpareParts.MinPrice		AS	MinCost ,
			SpareParts.MaxPrice		AS	MaxCost ,
			MwoPartRep.Quantity ,
			MwoPartRep.Cost			AS	CostPerUnit ,
			ISNULL(StockType.FieldValue, '')	AS	StockType 
 	FROM	EngMaintenanceWorkOrderTxn					AS	MaintenanceWO		WITH(NOLOCK)
			INNER JOIN	EngAsset						AS	Asset				WITH(NOLOCK)	ON Asset.AssetId							=	MaintenanceWO.AssetId
			--INNER JOIN	EngMwoCompletionInfoTxn			AS	MWOCompletionInfo	WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MWOCompletionInfo.WorkOrderId
			left JOIN	EngMwoPartReplacementTxn		AS	MwoPartRep			WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MwoPartRep.WorkOrderId
			left JOIN	EngSpareParts					AS	SpareParts			WITH(NOLOCK)	ON MwoPartRep.SparePartStockRegisterId		=	SpareParts.SparePartsId
			left  JOIN	EngStockUpdateRegisterTxnDet	AS	StockUpdateReg		WITH(NOLOCK)	ON MwoPartRep.StockUpdateDetId				=	StockUpdateReg.StockUpdateDetId
			left JOIN	FMItemMaster					AS	ItemMst				WITH(NOLOCK)	ON SpareParts.ItemId						=	ItemMst.ItemId
			--left JOIN	FMLovMst						AS	SparePartsType		WITH(NOLOCK)	ON SpareParts.SparePartType					=	SparePartsType.LovId
			left JOIN	FMLovMst						AS	StockType			WITH(NOLOCK)	ON MwoPartRep.StockType					=	StockType.LovId
	WHERE	MaintenanceWO.AssetId	=	@pAssetId
	and     SpareParts.SparePartsId  is not null
	ORDER BY MaintenanceWO.WorkOrderId




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
