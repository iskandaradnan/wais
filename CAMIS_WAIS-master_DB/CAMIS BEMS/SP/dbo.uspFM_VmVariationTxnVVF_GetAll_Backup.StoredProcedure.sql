USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxnVVF_GetAll_Backup]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxnVVF_GetAll
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 06-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_VmVariationTxnVVF_GetAll  @pYear=2018,@pMonth=7,@pVariationStatus=NULL,@pVariationWFStatus=232,@pVariationApprovedStatus=NULL,@pPageIndex=1,@pPageSize=5

SELECT VariationWFStatus,* FROM VmVariationTxn WHERE 
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
create PROCEDURE  [dbo].[uspFM_VmVariationTxnVVF_GetAll_Backup]                           
		@pYear							INT,
		@pMonth							INT,
		@pVariationStatus				INT	=	NULL,
		@pVariationWFStatus				INT	=	NULL,
		@pVariationApprovedStatus		INT	=	NULL,
		@pPageIndex						INT,
		@pPageSize						INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE	@TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

-- Default Values
	
	--DECLARE @mVariationWFStatus TABLE (WFStatusId int)
	--select * from FMLovMst where LovKey='WorkFlowStatusValue'

	--INSERT INTO @mVariationWFStatus
	SET @pVariationWFStatus =	(SELECT   CASE 
											--WHEN ISNULL(@pVariationWFStatus,0)	IN (0) THEN 0
											WHEN ISNULL(@pVariationWFStatus,0)	= 232 then 0
											WHEN ISNULL(@pVariationWFStatus,0)	=	233 THEN 232											
											WHEN ISNULL(@pVariationWFStatus,0)	in(230,231) THEN 233											
										END AS VariationWFStatus)


--SELECT @pVariationWFStatus
--RETURN
-- Execution


	IF(ISNULL(@pYear,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
 	FROM	VmVariationTxn									AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId					=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId					=	Facility.FacilityId
			INNER JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON Variation.AssetId					=	Asset.AssetId
			INNER JOIN EngAssetTypeCodeVariationRate		AS  TypeCodeVariation   WITH(NOLOCK)    ON Asset.AssetTypeCodeId				=   TypeCodeVariation.AssetTypeCodeId
			LEFT JOIN MstLocationUserArea					AS	UserArea			WITH(NOLOCK)	ON Asset.UserAreaId						=	UserArea.UserAreaId
			LEFT JOIN  FMLovMst								AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus			=	LovVariationStatus.LovId
			LEFT JOIN  FMLovMst								AS	LovApproveStatus	WITH(NOLOCK)	ON Variation.VariationApprovedStatus	=	LovApproveStatus.LovId
			LEFT JOIN  FMLovMst								AS	LovWorkFlowStatus	WITH(NOLOCK)	ON Variation.VariationApprovedStatus	=	LovWorkFlowStatus.LovId
			LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK)	ON Asset.Manufacturer					=	Manufacturer.ManufacturerId
			LEFT JOIN EngAssetStandardizationModel			AS	Model		WITH(NOLOCK)		ON Asset.Model			=	Model.ModelId
	WHERE	--AuthorizedStatus = 0 			AND	
			YEAR(Variation.VariationRaisedDate)			=	@pYear 
			AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
			--AND( ( @pVariationWFStatus = 232 and ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus  and ISNULL(Variation.VariationApprovedStatus,0)= 99)
			--	or 	( @pVariationWFStatus = 0 and  ISNULL(Variation.VariationWFStatus,0) in (0, 232)  and   ISNULL(Variation.VariationApprovedStatus,0) in (0,100,229))
			--	or (@pVariationWFStatus not in (0, 233)  and ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus  )
			--	)
			AND ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus
			--AND (ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus OR ISNULL(Variation.VariationApprovedStatus,0) = 229)
			--AND ISNULL(Variation.VariationApprovedStatus,0) = 229
			AND ((ISNULL(@pVariationStatus,'') = '' )	OR (ISNULL(@pVariationStatus,'') <> '' AND Variation.VariationStatus = @pVariationStatus ))
			--AND ((ISNULL(@pVariationWFStatus,'') = '' )	OR (ISNULL(@pVariationWFStatus,'') <> '' AND Variation.VariationWFStatus = @pVariationWFStatus ))
			AND Variation.IsMonthClosed	=	1
				

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

    SELECT	Variation.VariationId,
			Variation.AssetId,
			UserArea.UserAreaName					AS	UserAreaName,
			Asset.AssetNo,			
			--Variation.SNFDocumentNo,
			--Asset.Manufacturer						AS	ManufacturerId,
			Manufacturer.Manufacturer,
			--Asset.Model								AS	ModelId,
			Model.Model,
			Asset.PurchaseCostRM					AS	PurchaseCost,
			LovVariationStatus.FieldValue			AS	VariationStatus,
			Variation.CommissioningDate,
			Variation.StartServiceDate				AS	StartServiceDate,
			Variation.WarrantyEndDate				AS	WarrantyExpiryDate,
			Variation.ServiceStopDate				AS	StopServiceDate,
			CASE WHEN Asset.PurchaseCostRM < 2000000 THEN (SELECT TOP 1 TypeCodeVariation.VariationRate FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId= 9) 
			ELSE CASE WHEN Asset.PurchaseCostRM > 2000000 THEN (SELECT TOP 1 TypeCodeVariation.VariationRate FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId= 10) 
			END END AS	MaintenanceRateDW,

			CASE WHEN Asset.PurchaseCostRM < 2000000 THEN (SELECT TOP 1 TypeCodeVariation.VariationRate FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId IN (1,3,5,7)) 
			ELSE CASE WHEN Asset.PurchaseCostRM > 2000000 THEN (SELECT TOP 1 TypeCodeVariation.VariationRate FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId IN(2,4,6,8)) 
			END END 								AS	MaintenanceRatePW,

			CASE WHEN Asset.PurchaseCostRM < 2000000 THEN (SELECT TOP 1 (Asset.PurchaseCostRM * TypeCodeVariation.VariationRate)/1200 FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId= 9) 
			ELSE CASE WHEN Asset.PurchaseCostRM > 2000000 THEN (SELECT TOP 1 (Asset.PurchaseCostRM * TypeCodeVariation.VariationRate)/1200 FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId= 10) 
			END END AS	MonthlyProposedFeeDW,
			CASE WHEN Asset.PurchaseCostRM < 2000000 THEN (SELECT TOP 1 (Asset.PurchaseCostRM * TypeCodeVariation.VariationRate)/1200 FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId IN (1,3,5,7)) 
			ELSE CASE WHEN Asset.PurchaseCostRM > 2000000 THEN (SELECT TOP 1 (Asset.PurchaseCostRM * TypeCodeVariation.VariationRate)/1200 FROM EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId = ASSET.AssetTypeCodeId AND TypeCodeParameterId IN(2,4,6,8)) 
			END END 								AS	MonthlyProposedFeePW,
			50.00									AS CountingDays,
			Variation.VariationApprovedStatus		AS Action,
			Variation.Remarks						AS Remarks,
			LovWorkFlowStatus.FieldValue			AS WorkFlowStatus,
			Variation.VariationWFStatus,
			Variation.[Timestamp]					AS	[Timestamp],
			@TotalRecords							AS	TotalRecords,
			@pTotalPage								AS	TotalPageCalc,
			Variation.VariationRaisedDate,
			Variation.VariationWFStatus,
			Variation.VariationStatus
	--INTO	#ResVmVariationTxn
 	FROM	VmVariationTxn									AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId					=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId					=	Facility.FacilityId
			INNER JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON Variation.AssetId					=	Asset.AssetId
			INNER JOIN EngAssetTypeCodeVariationRate		AS  TypeCodeVariation   WITH(NOLOCK)    ON Asset.AssetTypeCodeId				=   TypeCodeVariation.AssetTypeCodeId
			LEFT JOIN MstLocationUserArea					AS	UserArea			WITH(NOLOCK)	ON Asset.UserAreaId						=	UserArea.UserAreaId
			LEFT JOIN  FMLovMst								AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus			=	LovVariationStatus.LovId
			LEFT JOIN  FMLovMst								AS	LovApproveStatus	WITH(NOLOCK)	ON Variation.VariationApprovedStatus	=	LovApproveStatus.LovId
			LEFT JOIN  FMLovMst								AS	LovWorkFlowStatus	WITH(NOLOCK)	ON Variation.VariationApprovedStatus	=	LovWorkFlowStatus.LovId
			LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK)	ON Asset.Manufacturer					=	Manufacturer.ManufacturerId
			LEFT JOIN EngAssetStandardizationModel			AS	Model		WITH(NOLOCK)		ON Asset.Model			=	Model.ModelId
	WHERE	--AuthorizedStatus = 0 			AND	
			YEAR(Variation.VariationRaisedDate)			=	@pYear 
			AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
			--AND( ( @pVariationWFStatus = 232 and ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus  and ISNULL(Variation.VariationApprovedStatus,0)= 99)
			--	or 	( @pVariationWFStatus = 0 and  ISNULL(Variation.VariationWFStatus,0) in (0, 232)  and   ISNULL(Variation.VariationApprovedStatus,0) in (0,100,229))
			--	or (@pVariationWFStatus not in (0, 233)  and ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus  )
			--	)
			AND ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus
			--AND (ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus OR ISNULL(Variation.VariationApprovedStatus,0) = 229)
			--AND ISNULL(Variation.VariationApprovedStatus,0) = 229
			AND ((ISNULL(@pVariationStatus,'') = '' )	OR (ISNULL(@pVariationStatus,'') <> '' AND Variation.VariationStatus = @pVariationStatus ))
			--AND ((ISNULL(@pVariationWFStatus,'') = '' )	OR (ISNULL(@pVariationWFStatus,'') <> '' AND Variation.VariationWFStatus = @pVariationWFStatus ))
			AND Variation.IsMonthClosed	=	1

	ORDER BY Variation.ModifiedDate DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY


	--SELECT * FROM #ResVmVariationTxn

	--UPDATE VM	SET VM.VariationApprovedStatus=	@pVariationApprovedStatus
	--FROM	#ResVmVariationTxn AS ResVM 
	--		INNER JOIN	VmVariationTxn AS VM  ON ResVM.VariationId=VM.VariationId
		
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
GO
