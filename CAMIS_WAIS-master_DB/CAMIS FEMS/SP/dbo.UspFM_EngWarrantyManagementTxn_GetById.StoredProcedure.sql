USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngWarrantyManagementTxn_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngWarrantyManagementTxn_GetById
Description			: To Get the data from table EngPPMRegisterMst using the Primary Key id
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngWarrantyManagementTxn_GetById] @pWarrantyMgmtId=1,@pUserId=1
SELECT * FROM EngWarrantyManagementTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngWarrantyManagementTxn_GetById] 
                          
  @pUserId			INT	=	NULL,
  @pWarrantyMgmtId	INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	
			WarrantyManagement.WarrantyMgmtId					AS WarrantyMgmtId,
			WarrantyManagement.CustomerId						AS CustomerId,
			WarrantyManagement.FacilityId						AS FacilityId,
			WarrantyManagement.ServiceId						AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			WarrantyManagement.WarrantyNo						AS WarrantyNo,
			WarrantyManagement.WarrantyDate						AS WarrantyDate,
			WarrantyManagement.WarrantyDateUTC					AS WarrantyDateUTC,
			WarrantyManagement.AssetId							AS AssetId,
			TandC.TandCDocumentNo								AS TandCDocumentNo,
			Asset.AssetNo										AS AssetNo,
			AssetClassification.AssetClassificationCode			AS AssetClassificationCode,
			AssetClassification.AssetClassificationDescription	AS AssetClassificationDescription,
			Asset.AssetDescription								AS AssetDescription,
			AssetTypeCode.AssetTypeCode							AS AssetTypeCode,
			Asset.WarrantyDuration								AS WarrantyDuration,
			Asset.WarrantyStartDate								AS WarrantyStartDate,
			Asset.WarrantyStartDateUTC							AS WarrantyStartDateUTC,
			Asset.WarrantyEndDate								AS WarrantyEndDate,
			Asset.WarrantyEndDateUTC							AS WarrantyEndDateUTC,
			ISNULL(Asset.PurchaseCostRM,0)						AS PurchaseCostRM,
			ISNULL(MwoCompletionInfo.DowntimeHoursMin,0)		AS DowntimeHoursMin,
			ISNULL(Variation.MonthlyProposedFeeDW,0)			AS MonthlyProposedFeeDW,
			ISNULL(Variation.MonthlyProposedFeePW,0)			AS MonthlyProposedFeePW,
			WarrantyManagement.Remarks							AS Remarks,
			WarrantyManagement.Timestamp
	FROM	EngWarrantyManagementTxn							AS WarrantyManagement		WITH(NOLOCK)
			INNER JOIN  EngAsset								AS Asset					WITH(NOLOCK)			ON WarrantyManagement.AssetId			= Asset.AssetId
			INNER JOIN  EngAssetClassification					AS AssetClassification		WITH(NOLOCK)			ON Asset.AssetClassification			= AssetClassification.AssetClassificationId
			LEFT JOIN  EngTestingandCommissioningTxnDet			AS TandCDet					WITH(NOLOCK)			ON Asset.TestingandCommissioningDetId	= TandCDet.TestingandCommissioningDetId
			LEFT JOIN	 EngTestingandCommissioningTxn			AS TandC					WITH(NOLOCK)			ON TandCDet.TestingandCommissioningId	= TandC.TestingandCommissioningId
			INNER JOIN  EngAssetTypeCode						AS AssetTypeCode			WITH(NOLOCK)			on Asset.AssetTypeCodeId				= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			ON WarrantyManagement.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder		WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId			= Asset.AssetId
			LEFT  JOIN	EngMwoCompletionInfoTxn					AS MwoCompletionInfo		WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderId		= MwoCompletionInfo.WorkOrderId
			LEFT  JOIN	VmVariationTxn							AS Variation				WITH(NOLOCK)			on WarrantyManagement.AssetId			= Variation.AssetId
	WHERE	WarrantyManagement.WarrantyMgmtId = @pWarrantyMgmtId 
	ORDER BY WarrantyManagement.ModifiedDate ASC
	



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
