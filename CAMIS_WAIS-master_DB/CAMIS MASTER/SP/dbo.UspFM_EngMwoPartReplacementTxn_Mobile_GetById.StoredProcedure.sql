USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoPartReplacementTxn_Mobile_GetById]    Script Date: 20-09-2021 16:43:01 ******/
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
EXEC [UspFM_EngMwoPartReplacementTxn_mOBILE_GetById] @pWorkOrderId='5767,5768'

SELECT * FROM EngSpareParts
SELECT * FROM EngStockUpdateRegisterTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoPartReplacementTxn_Mobile_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		NVARCHAR(200)

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pWorkOrderId,'') = '') RETURN



	

	SELECT	MwoPartReplacement.PartReplacementId				AS PartReplacementId,
			MwoPartReplacement.CustomerId						AS CustomerId,
			MwoPartReplacement.FacilityId						AS FacilityId,
			MwoPartReplacement.ServiceId						AS ServiceId,
			MwoPartReplacement.ActualQuantityinStockUpdate						AS ActualQuantityinStockUpdate,
			MwoPartReplacement.SparePartRunningHours						AS SparePartRunningHours,
			MwoPartReplacement.IsPartReplacedCost						AS IsPartReplacedCost,
			MwoPartReplacement.PartReplacementCost						AS PartReplacementCost,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoPartReplacement.WorkOrderId						AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MwoPartReplacement.TotalPartsCost					 AS TotalSparePartCost,
			MwoPartReplacement.LabourCost						AS TotalLabourCost,
			MwoPartReplacement.TotalCost						AS TotalCost,
			--(SELECT ISNULL(SUM(TotalPartsCost),0) from EngMwoPartReplacementTxn WHERE WorkOrderId IN  (SELECT ITEM FROM dbo.[SplitString] (@pWorkOrderId,',')) GROUP BY WorkOrderId) AS TotalSparePartCost,
			--(SELECT ISNULL(SUM(LabourCost),0) from EngMwoPartReplacementTxn WHERE WorkOrderId IN  (SELECT ITEM FROM dbo.[SplitString] (@pWorkOrderId,',')) GROUP BY WorkOrderId) AS TotalLabourCost,
			--(SELECT ISNULL(SUM(TotalCost),0) from EngMwoPartReplacementTxn WHERE WorkOrderId IN  (SELECT ITEM FROM dbo.[SplitString] (@pWorkOrderId,',')) GROUP BY WorkOrderId) AS TotalCost,
			MwoPartReplacement.SparePartStockRegisterId			AS SparePartStockRegisterId,
			SpareParts.PartNo									AS PartNo,
			SpareParts.PartDescription							AS PartDescription,
			--ItemMaster.ItemNo									AS ItemNo,
			--ItemMaster.ItemDescription							AS ItemDescription,
			--StockType.FieldValue								AS StockTypeValue,
			MwoPartReplacement.Quantity							AS Quantity,
			ISNULL(MwoPartReplacement.Cost,0)					AS Cost,
			MwoPartReplacement.StockUpdateDetId					AS StockUpdateDetId,
			StockUpdateRegister.InVoiceNo						AS InVoiceNo,
			StockUpdateRegister.VendorName						AS VendorName,
			ISNULL(MwoPartReplacement.LabourCost,0)				AS LabourCost,
			ISNULL(MwoPartReplacement.TotalCost,0)				AS TotalCost
	FROM	EngMwoPartReplacementTxn							AS MwoPartReplacement
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoPartReplacement.WorkOrderId					= MaintenanceWorkOrder.WorkOrderId
			LEFT JOIN	EngStockUpdateRegisterTxnDet			AS StockUpdateRegister				WITH(NOLOCK)			on MwoPartReplacement.StockUpdateDetId				= StockUpdateRegister.StockUpdateDetId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoPartReplacement.ServiceId						= ServiceKey.ServiceId
			INNER JOIN  EngSpareParts							AS SpareParts						WITH(NOLOCK)			on MwoPartReplacement.SparePartStockRegisterId		= SpareParts.SparePartsId
			--INNER JOIN  FMItemMaster							AS ItemMaster						WITH(NOLOCK)			on SpareParts.ItemId								= ItemMaster.ItemId
			--INNER  JOIN  FMLovMst								AS StockType						WITH(NOLOCK)			on SpareParts.SparePartType							= StockType.LovId
	WHERE	MaintenanceWorkOrder.WorkOrderId IN  (SELECT ITEM FROM dbo.[SplitString] (@pWorkOrderId,','))
	ORDER BY (SpareParts.PartNo) ASC




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
