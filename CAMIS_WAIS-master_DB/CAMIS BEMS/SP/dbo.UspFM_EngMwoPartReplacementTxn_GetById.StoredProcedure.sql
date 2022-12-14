USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoPartReplacementTxn_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoPartReplacementTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMwoPartReplacementTxn_GetById] @pWorkOrderId=6149,@pPageIndex=1,@pPageSize=5,@pUserId=1

SELECT * FROM EngSpareParts
SELECT * FROM EngStockUpdateRegisterTxnDet
SELECT * FROM EngMwoPartReplacementTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoPartReplacementTxn_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngMwoPartReplacementTxn							AS MwoPartReplacement
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoPartReplacement.WorkOrderId					= MaintenanceWorkOrder.WorkOrderId
			LEFT  JOIN	EngStockUpdateRegisterTxnDet			AS StockUpdateRegister				WITH(NOLOCK)			on MwoPartReplacement.StockUpdateDetId				= StockUpdateRegister.StockUpdateDetId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoPartReplacement.ServiceId						= ServiceKey.ServiceId
			LEFT JOIN  EngSpareParts							AS SpareParts						WITH(NOLOCK)			on MwoPartReplacement.SparePartStockRegisterId		= SpareParts.SparePartsId
			LEFT JOIN  FMItemMaster								AS ItemMaster						WITH(NOLOCK)			on SpareParts.ItemId								= ItemMaster.ItemId
			LEFT  JOIN  FMLovMst								AS StockType						WITH(NOLOCK)			on StockUpdateRegister.SparePartType							= StockType.LovId
			LEFT   JOIN  FMLovMst								AS LifeSpanOptionId					WITH(NOLOCK)			on SpareParts.LifeSpanOptionId						= LifeSpanOptionId.LovId
			--OUTER APPLY (	SELECT	ComDet.CompletionInfoId, SUM(ComDet.LabourCost) AS LabourCost
			--	FROM	EngMwoCompletionInfoTxnDet AS ComDet
			--			INNER JOIN EngMwoCompletionInfoTxn AS Com ON Com.CompletionInfoId	=	ComDet.CompletionInfoId
			--	WHERE	Com.WorkOrderId	=	MaintenanceWorkOrder.WorkOrderId
			--	GROUP BY ComDet.CompletionInfoId
			--			) AS LabourCostInfo
	WHERE	MwoPartReplacement.WorkOrderId = @pWorkOrderId   

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	

	SELECT	MwoPartReplacement.PartReplacementId				AS PartReplacementId,
			MwoPartReplacement.CustomerId						AS CustomerId,
			MwoPartReplacement.FacilityId						AS FacilityId,
			MwoPartReplacement.ServiceId						AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoPartReplacement.WorkOrderId						AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			(SELECT ISNULL(SUM(a.TotalPartsCost),0) from EngMwoPartReplacementTxn a  WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalCostSum,
			(SELECT ISNULL(SUM(a.LabourCost),0) from EngMwoPartReplacementTxn a WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalLabourCostSum,
			(SELECT ISNULL(SUM(a.Cost),0) from EngMwoPartReplacementTxn a WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalSparepartsCostSum,
			ISNULL(LabourCostInfo.VendorCost,0)  AS TotalVendorCostSum,
			ISNULL(LabourCostInfo.LabourCost,0) AS TotalLabourCostCompinfo,
			(ISNULL(LabourCostInfo.VendorCost,0)+ISNULL(LabourCostInfo.LabourCost,0)+ISNULL(PartReplacementCost,0)) AS ScheduleTotalCost,
			--(SELECT ISNULL(SUM(TotalCost),0) from EngMwoPartReplacementTxn WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalCost,
			MwoPartReplacement.TotalPartsCost					AS TotalCost,
			MwoPartReplacement.SparePartStockRegisterId			AS SparePartStockRegisterId,
			SpareParts.PartNo									AS PartNo,	
			SpareParts.PartDescription							AS PartDescription,
			ItemMaster.ItemNo									AS ItemNo,
			ItemMaster.ItemDescription							AS ItemDescription,
			StockType.FieldValue								AS StockTypeValue,
			MwoPartReplacement.Quantity							AS Quantity,
			ISNULL(MwoPartReplacement.Cost,0)					AS Cost,
			MwoPartReplacement.StockUpdateDetId					AS StockUpdateDetId,
			StockUpdateRegister.InVoiceNo						AS InVoiceNo,
			StockUpdateRegister.VendorName						AS VendorName,
			ISNULL(MwoPartReplacement.LabourCost,0)				AS LabourCost,
			--ISNULL(MwoPartReplacement.TotalCost,0)				AS TotalCost,
			SparePartRunningHours,
			StockUpdateRegister.EstimatedLifeSpan               AS EstimatedLifeSpanInHours,
			StockUpdateRegister.StockExpiryDate					AS StockExpiryDate,
			SpareParts.LifeSpanOptionId							AS LifeSpanOptionId,
			LifeSpanOptionId.LovId								AS LifeSpanOptionId1,
			LifeSpanOptionId.FieldValue							AS LifeSpanOptionIdValue,
			@TotalRecords										AS TotalRecords,
			@pTotalPage											AS TotalPageCalc,
			SpareParts.EstimatedLifeSpanInHours,
			ISNULL(IsPartReplacedCost,0)						AS IsPartReplacedCost,
			LovIsPartReplace.FieldValue							AS IsPartReplacedCostValue,
			PartReplacementCost,
			MwoPartReplacement.EstimatedLifeSpan,
			MwoPartReplacement.LifeSpanExpiryDate,
			MwoPartReplacement.StockType						AS  StockType,
			MaintenanceWorkOrder.WorkOrderStatus				AS WorkOrderStatus,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue			
			
	FROM	EngMwoPartReplacementTxn					AS MwoPartReplacement
			INNER JOIN	EngMaintenanceWorkOrderTxn		AS MaintenanceWorkOrder		WITH(NOLOCK)	ON MwoPartReplacement.WorkOrderId				= MaintenanceWorkOrder.WorkOrderId
			LEFT  JOIN	EngStockUpdateRegisterTxnDet	AS StockUpdateRegister		WITH(NOLOCK)	ON MwoPartReplacement.StockUpdateDetId			= StockUpdateRegister.StockUpdateDetId
			INNER JOIN  MstService						AS ServiceKey				WITH(NOLOCK)	ON MwoPartReplacement.ServiceId					= ServiceKey.ServiceId
			LEFT JOIN  EngSpareParts					AS SpareParts				WITH(NOLOCK)	ON MwoPartReplacement.SparePartStockRegisterId	= SpareParts.SparePartsId
			LEFT JOIN  FMItemMaster						AS ItemMaster				WITH(NOLOCK)	ON SpareParts.ItemId							= ItemMaster.ItemId
			LEFT  JOIN  FMLovMst						AS StockType				WITH(NOLOCK)	ON StockUpdateRegister.SparePartType			= StockType.LovId
			LEFT   JOIN  FMLovMst						AS LifeSpanOptionId			WITH(NOLOCK)	ON SpareParts.LifeSpanOptionId					= LifeSpanOptionId.LovId
			LEFT   JOIN  FMLovMst						AS LovIsPartReplace			WITH(NOLOCK)	ON MwoPartReplacement.IsPartReplacedCost		= LovIsPartReplace.LovId
			LEFT  JOIN  FMLovMst						AS WorkOrderStatus			WITH(NOLOCK)	ON MaintenanceWorkOrder.WorkOrderStatus	= WorkOrderStatus.LovId
			OUTER APPLY (	SELECT	ComDet.CompletionInfoId,VendorCost, SUM(ComDet.LabourCost) AS LabourCost
				FROM	EngMwoCompletionInfoTxnDet AS ComDet
						INNER JOIN EngMwoCompletionInfoTxn AS Com ON Com.CompletionInfoId	=	ComDet.CompletionInfoId
				WHERE	Com.WorkOrderId	=	MaintenanceWorkOrder.WorkOrderId
				GROUP BY ComDet.CompletionInfoId,VendorCost
						) AS LabourCostInfo
	WHERE	MwoPartReplacement.WorkOrderId = @pWorkOrderId 
	ORDER BY (SpareParts.PartNo) ASC
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
