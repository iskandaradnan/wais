USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WarrantyCoverage_GetById]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WarrantyCoverage_GetById
Description			: To Get the warranty details of asset
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_WarrantyCoverage_GetById] @pAssetId=1
SELECT * FROM EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_WarrantyCoverage_GetById] 
                          

  @pAssetId	INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	VmVar.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,	
			TypeCode.AssetTypeCode,
			Asset.WarrantyStartDate,
			Asset.WarrantyEndDate,
			Asset.WarrantyDuration,
			Asset.PurchaseCostRM,
			VmVar.MonthlyProposedFeeDW as  CalculatedFeeDW,
			VmVar.MonthlyProposedFeePW as  CalculatedFeePW,			
			WarDowntime.DowntimeHoursMin AS TotalWarrantyDownTime
	FROM	VmVariationTxn					AS VmVar		WITH(NOLOCK)
			INNER JOIN  EngAsset			AS Asset		WITH(NOLOCK)			ON VmVar.AssetId			= Asset.AssetId
			INNER JOIN  EngAssetTypeCode	AS TypeCode		WITH(NOLOCK)			ON Asset.AssetTypeCodeId	= TypeCode.AssetTypeCodeId
			OUTER APPLY (	SELECT SUM(DowntimeHoursMin) AS DowntimeHoursMin 
							FROM	EngMwoCompletionInfoTxn A INNER JOIN EngMaintenanceWorkOrderTxn B ON A.WorkOrderId=B.WorkOrderId
									INNER JOIN EngAsset C ON B.AssetId	 = C.AssetId
							WHERE	B.AssetId = @pAssetId AND C.WarrantyEndDate <= GETDATE()
							GROUP BY B.AssetId) WarDowntime
WHERE	Asset.AssetId = @pAssetId 
	ORDER BY VmVar.ModifiedDate ASC
	



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
