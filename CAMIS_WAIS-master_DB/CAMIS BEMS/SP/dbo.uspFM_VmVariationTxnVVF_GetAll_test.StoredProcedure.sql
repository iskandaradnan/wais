USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxnVVF_GetAll_test]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxnVVF_GetAll_test]                           
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

	IF(ISNULL(@pYear,0) = 0) RETURN

	SET @pVariationWFStatus =	(SELECT   CASE 
											--WHEN ISNULL(@pVariationWFStatus,0)	IN (0) THEN 0
											WHEN ISNULL(@pVariationWFStatus,0)	= 232 then 0
											WHEN ISNULL(@pVariationWFStatus,0)	=	233 THEN 232											
											WHEN ISNULL(@pVariationWFStatus,0)	in(230,231) THEN 233											
										END AS VariationWFStatus)



	CREATE TABLE #TotalAssetList(AssetId int,AssetTypeCodeId INT,TypeCodeParameterId INT,VariationRate NUMERIC(24,2),ContractType int)

	SELECT Asset.Assetid,Asset.AssetTypeCodeId,--TypeCodeVariation.TypeCodeParameterId,VariationRate,
	Asset.ContractType
	INTO #VmResult
		FROM	VmVariationTxn								AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId					=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId					=	Facility.FacilityId
			INNER JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON Variation.AssetId					=	Asset.AssetId
			--INNER JOIN EngAssetTypeCodeVariationRate		AS  TypeCodeVariation   WITH(NOLOCK)    ON Asset.AssetTypeCodeId				=   TypeCodeVariation.AssetTypeCodeId
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

	
	
	SELECT Assetid,a.AssetTypeCodeId,
	isnull(max(case when B.TypeCodeParameterId =1 then B.VariationRate else null end),0) as Parameter1,
	isnull(max(case when B.TypeCodeParameterId =2 then B.VariationRate else null end),0) as Parameter2,
	isnull(max(case when B.TypeCodeParameterId =3 then B.VariationRate else null end),0) as Parameter3,
	isnull(max(case when B.TypeCodeParameterId =4 then B.VariationRate else null end),0) as Parameter4,
	isnull(max(case when B.TypeCodeParameterId =5 then B.VariationRate else null end),0) as Parameter5,
	isnull(max(case when B.TypeCodeParameterId =6 then B.VariationRate else null end),0) as Parameter6,
	isnull(max(case when B.TypeCodeParameterId =7 then B.VariationRate else null end),0) as Parameter7,
	isnull(max(case when B.TypeCodeParameterId =8 then B.VariationRate else null end),0) as Parameter8,
	isnull(max(case when B.TypeCodeParameterId =9 then B.VariationRate else null end),0) as Parameter9,
	isnull(max(case when B.TypeCodeParameterId =10 then B.VariationRate else null end),0) as Parameter10,
	isnull(max(case when B.TypeCodeParameterId =11 then B.VariationRate else null end),0) as Parameter11,
	isnull(max(case when B.TypeCodeParameterId =12 then B.VariationRate else null end),0) as Parameter12,
	isnull(max(case when B.TypeCodeParameterId =13 then B.VariationRate else null end),0) as Parameter13	
	into #AssetTypeCodeVariationSep
	FROM #VmResult a join EngAssetTypeCodeVariationRate b
	on 	A.AssetTypeCodeId = B.AssetTypeCodeId and b.active=1
	group by Assetid,a.AssetTypeCodeId

	select * from #AssetTypeCodeVariationSep where Assetid = 160 --PANH00023

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
			Case when CAST(Asset.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)  Then Result.Parameter13				 
				 ELSE
				 0.00
				 END as [MaintenanceRateDW],

				Case when CAST(Asset.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)  Then 0.00
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=279 then Parameter1
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=279 then Parameter2
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=279 then Parameter3

				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=280 then Parameter4
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=280 then Parameter5
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=280 then Parameter6

				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=281 then Parameter7
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=281 then Parameter8
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=281 then Parameter9

				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=282 then Parameter10
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=282 then Parameter11
				 when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=284 then Parameter12
				 ELSE
				 0.00
				 END as [MaintenanceRatePW],
		
			Asset.PurchaseCostRM,
			50.00									AS CountingDays,
			Variation.VariationApprovedStatus		AS Action,
			Variation.Remarks						AS Remarks,
			LovWorkFlowStatus.FieldValue			AS WorkFlowStatus,
			Variation.VariationWFStatus,
			Variation.[Timestamp]					AS	[Timestamp],
			--@TotalRecords							AS	TotalRecords,
			--@pTotalPage								AS	TotalPageCalc,
			Variation.VariationRaisedDate--,
			--Variation.VariationWFStatus,
			--Variation.VariationStatus
	INTO	#VmVariationTxnResult
 	FROM	VmVariationTxn									AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId					=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId					=	Facility.FacilityId
			INNER JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON Variation.AssetId					=	Asset.AssetId
			--INNER JOIN EngAssetTypeCodeVariationRate		AS  TypeCodeVariation   WITH(NOLOCK)    ON Asset.AssetTypeCodeId				=   TypeCodeVariation.AssetTypeCodeId
			LEFT  JOIN MstLocationUserArea					AS	UserArea			WITH(NOLOCK)	ON Asset.UserAreaId						=	UserArea.UserAreaId
			LEFT  JOIN  FMLovMst							AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus			=	LovVariationStatus.LovId
			LEFT  JOIN  FMLovMst							AS	LovApproveStatus	WITH(NOLOCK)	ON Variation.VariationApprovedStatus	=	LovApproveStatus.LovId
			LEFT  JOIN  FMLovMst							AS	LovWorkFlowStatus	WITH(NOLOCK)	ON Variation.VariationApprovedStatus	=	LovWorkFlowStatus.LovId
			LEFT  JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK)	ON Asset.Manufacturer					=	Manufacturer.ManufacturerId
			LEFT  JOIN EngAssetStandardizationModel			AS	Model				WITH(NOLOCK)	ON Asset.Model							=	Model.ModelId
			LEFT  JOIN #AssetTypeCodeVariationSep			AS  Result				WITH(NOLOCK)	ON Asset.AssetId						=   Result.AssetId
			--LEFT  JOIN EngAsset								AS  Preventive			WITH(NOLOCK)	ON Result.AssetId						=   Preventive.AssetId AND Asset.ContractType = 279 AND CAST(Preventive.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)
			--LEFT  JOIN EngAsset								AS  NonComprehensive	WITH(NOLOCK)	ON Result.AssetId						=   NonComprehensive.AssetId AND Asset.ContractType = 280 AND CAST(NonComprehensive.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)
			--LEFT  JOIN EngAsset								AS  Comprehensive		WITH(NOLOCK)	ON Result.AssetId						=   Comprehensive.AssetId AND Asset.ContractType = 281 AND CAST(Comprehensive.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)
			--LEFT  JOIN EngAsset								AS  ComprehensivePlus	WITH(NOLOCK)	ON Result.AssetId						=   ComprehensivePlus.AssetId AND Asset.ContractType = 282 AND CAST(ComprehensivePlus.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)

			--LEFT  JOIN EngAsset								AS  PreventivePW		WITH(NOLOCK)	ON Result.AssetId						=   PreventivePW.AssetId AND Asset.ContractType = 279 AND CAST(PreventivePW.WarrantyEndDate AS DATE)<CAST(GETDATE() AS DATE)
			--LEFT  JOIN EngAsset								AS  NonComprehensivePW	WITH(NOLOCK)	ON Result.AssetId						=   NonComprehensivePW.AssetId AND Asset.ContractType = 280 AND CAST(NonComprehensivePW.WarrantyEndDate AS DATE)<CAST(GETDATE() AS DATE)
			--LEFT  JOIN EngAsset								AS  ComprehensivePW		WITH(NOLOCK)	ON Result.AssetId						=   ComprehensivePW.AssetId AND Asset.ContractType = 281 AND CAST(ComprehensivePW.WarrantyEndDate AS DATE)<CAST(GETDATE() AS DATE)
			--LEFT  JOIN EngAsset								AS  ComprehensivePlusPW	WITH(NOLOCK)	ON Result.AssetId						=   ComprehensivePlusPW.AssetId AND Asset.ContractType = 282 AND CAST(ComprehensivePlusPW.WarrantyEndDate AS DATE)<CAST(GETDATE() AS DATE)
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

	--ORDER BY Variation.ModifiedDate DESC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
	
	SELECT	@TotalRecords	=	COUNT(*)
 	FROM	#VmVariationTxnResult	

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)


	
	select VariationId,AssetId,UserAreaName,AssetNo,Manufacturer,Model,PurchaseCost,VariationStatus,CommissioningDate,StartServiceDate,WarrantyExpiryDate,StopServiceDate,
	MaintenanceRateDW, MaintenanceRatePW, (t.PurchaseCostRM * t.MaintenanceRateDW) / 100.00 as  [MonthlyProposedFeeDW],
	(t.PurchaseCostRM * t.MaintenanceRatePW) / 100.00 as [MonthlyProposedFeePW],
	
	CountingDays,Action,Remarks,WorkFlowStatus,VariationWFStatus,Timestamp,VariationRaisedDate , @TotalRecords	AS	TotalRecords,@pTotalPage AS	TotalPageCalc

	from #VmVariationTxnResult t
	order by Timestamp
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	--select VariationId,AssetId,UserAreaName,AssetNo,Manufacturer,Model,PurchaseCost,VariationStatus,CommissioningDate,StartServiceDate,WarrantyExpiryDate,StopServiceDate,
	--MaintenanceRateDW,(PreventiveMaintenanceMaintenanceRatePW+NonComprehensiveMaintenanceRatePW+ComprehensiveMaintenanceRatePW+ComprehensivePlusMaintenanceRatePW) as MaintenanceRatePW,
	--MonthlyProposedFeeDW,(PreventiveMaintenanceProposedFeeRatePW+NonComprehensiveProposedFeeRatePW+ComprehensiveProposedFeeRatePW+ComprehensivePlusProposedFeeRatePW) as MonthlyProposedFeePW,
	--CountingDays,Action,Remarks,WorkFlowStatus,VariationWFStatus,Timestamp,VariationRaisedDate , @TotalRecords	AS	TotalRecords,@pTotalPage AS	TotalPageCalc
	--from #VmVariationTxnResult
	--order by Timestamp
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
		   );
		THROW;

END CATCH
GO
