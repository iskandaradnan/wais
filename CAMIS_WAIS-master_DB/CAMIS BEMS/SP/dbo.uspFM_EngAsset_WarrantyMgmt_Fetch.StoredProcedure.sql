USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_WarrantyMgmt_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAsset_WarrantyMgmt_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAsset_WarrantyMgmt_Fetch] @pPageIndex=1,@pPageSize=30, @pAssetNo='asset1111',@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAsset_WarrantyMgmt_Fetch]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
		--SELECT		@TotalRecords	=	COUNT(*)
		--FROM		EngAsset									AS Asset WITH(NOLOCK)
		--			INNER JOIN	EngAssetClassification			AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification			= AssetClassification.AssetClassificationId
		--			INNER JOIN	EngAssetTypeCode				AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId				= TypeCode.AssetTypeCodeId
		--			LEFT JOIN EngTestingandCommissioningTxnDet	AS TandCDet				WITH(NOLOCK) ON ASSET.TestingandCommissioningDetId	= TandCDet.TestingandCommissioningDetId
		--			LEFT JOIN EngTestingandCommissioningTxn		AS TandC				WITH(NOLOCK) ON TandCDet.TestingandCommissioningId	= TandCDet.TestingandCommissioningId
		--			LEFT JOIN VmVariationTxn					AS Variation			WITH(NOLOCK) ON Asset.AssetId						=	Variation.AssetId
		--WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
		--			AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
		--			AND	Asset.WarrantyEndDate >= GETDATE()
		--			AND	Asset.AssetId NOT IN (SELECT AssetId FROM EngWarrantyManagementTxn)
	

		SELECT		DISTINCT Asset.AssetId,
					Asset.AssetNo,
					AssetClassification.AssetClassificationCode,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					TandC.TandCDocumentNo,
					ISNULL(Asset.WarrantyStartDate,'')			AS WarrantyStartDate,
					ISNULL(Asset.WarrantyEndDate,'')			AS WarrantyEndDate,
					ISNULL(Asset.WarrantyDuration,0)			AS WarrantyDuration ,
					ISNULL(Asset.PurchaseCostRM,0)				AS PurchaseCostRM,
					ISNULL(Variation.MonthlyProposedFeeDW,0)	AS MonthlyProposedFeeDW,
					ISNULL(Variation.MonthlyProposedFeePW,0)	AS MonthlyProposedFeePW,
					isnull((SELECT	SUM(DowntimeHoursMin) 
							FROM	EngMaintenanceWorkOrderTxn	AS WO 
									INNER JOIN EngMwoCompletionInfoTxn MWOCompletion on WO.WorkOrderId=MWOCompletion.WorkOrderId 
							WHERE	WO.AssetId=Asset.AssetId 
							GROUP BY WO.AssetId),0)				AS	DowntimeHoursMin
					--@TotalRecords AS TotalRecords
		INTO		#ResWarrantyMgmtAsset
		FROM		EngAsset									AS Asset WITH(NOLOCK)
					INNER JOIN	EngAssetClassification			AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification			= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode				AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId				= TypeCode.AssetTypeCodeId
					LEFT JOIN EngTestingandCommissioningTxnDet	AS TandCDet				WITH(NOLOCK) ON ASSET.TestingandCommissioningDetId	= TandCDet.TestingandCommissioningDetId
					LEFT JOIN EngTestingandCommissioningTxn		AS TandC				WITH(NOLOCK) ON TandCDet.TestingandCommissioningId	= TandC.TestingandCommissioningId
					LEFT JOIN VmVariationTxn					AS Variation			WITH(NOLOCK) ON Asset.AssetId						=	Variation.AssetId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND	Asset.WarrantyEndDate >= GETDATE()
					AND	Asset.AssetId NOT IN (SELECT AssetId FROM EngWarrantyManagementTxn)

		--ORDER BY	Asset.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 


		SELECT		@TotalRecords	=	COUNT(*)
		FROM		#ResWarrantyMgmtAsset


		SELECT		*,@TotalRecords AS TotalRecords
		FROM		#ResWarrantyMgmtAsset
		ORDER BY	AssetId DESC
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
