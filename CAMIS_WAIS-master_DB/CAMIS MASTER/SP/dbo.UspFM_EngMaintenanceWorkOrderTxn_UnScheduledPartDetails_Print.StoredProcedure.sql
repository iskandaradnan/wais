USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_UnScheduledPartDetails_Print]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMaintenanceWorkOrderTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMaintenanceWorkOrderTxn_ScheduledPartDetails_Print] @pWorkOrderId=5954

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_UnScheduledPartDetails_Print]   
                        

  @pWorkOrderId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

    SELECT	
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
			ISNULL(MwoPartReplacement.TotalCost,0)				AS TotalCost,
			SparePartRunningHours,
			StockUpdateRegister.EstimatedLifeSpan               AS EstimatedLifeSpanInHours,
			StockUpdateRegister.StockExpiryDate					AS StockExpiryDate,
			SpareParts.LifeSpanOptionId							AS LifeSpanOptionId,
			LifeSpanOptionId.LovId								AS LifeSpanOptionId1,
			LifeSpanOptionId.FieldValue							AS LifeSpanOptionIdValue,		
			SpareParts.EstimatedLifeSpanInHours,
			IsPartReplacedCost,
			LovIsPartReplace.FieldValue							AS IsPartReplacedCostValue,
			PartReplacementCost,
			MwoPartReplacement.EstimatedLifeSpan,
			MwoPartReplacement.LifeSpanExpiryDate,
			MwoPartReplacement.StockType
	FROM	EngMwoPartReplacementTxn					AS MwoPartReplacement
			INNER JOIN	EngMaintenanceWorkOrderTxn		AS MaintenanceWorkOrder		WITH(NOLOCK)	ON MwoPartReplacement.WorkOrderId				= MaintenanceWorkOrder.WorkOrderId
			LEFT  JOIN	EngStockUpdateRegisterTxnDet	AS StockUpdateRegister		WITH(NOLOCK)	ON MwoPartReplacement.StockUpdateDetId			= StockUpdateRegister.StockUpdateDetId
			INNER JOIN  MstService						AS ServiceKey				WITH(NOLOCK)	ON MwoPartReplacement.ServiceId					= ServiceKey.ServiceId
			LEFT JOIN  EngSpareParts					AS SpareParts				WITH(NOLOCK)	ON MwoPartReplacement.SparePartStockRegisterId	= SpareParts.SparePartsId
			LEFT JOIN  FMItemMaster						AS ItemMaster				WITH(NOLOCK)	ON SpareParts.ItemId							= ItemMaster.ItemId
			LEFT  JOIN  FMLovMst						AS StockType				WITH(NOLOCK)	ON StockUpdateRegister.SparePartType			= StockType.LovId
			LEFT   JOIN  FMLovMst						AS LifeSpanOptionId			WITH(NOLOCK)	ON SpareParts.LifeSpanOptionId					= LifeSpanOptionId.LovId
			LEFT   JOIN  FMLovMst						AS LovIsPartReplace			WITH(NOLOCK)	ON MwoPartReplacement.IsPartReplacedCost		= LovIsPartReplace.LovId
		
	WHERE	MwoPartReplacement.WorkOrderId = @pWorkOrderId 




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
