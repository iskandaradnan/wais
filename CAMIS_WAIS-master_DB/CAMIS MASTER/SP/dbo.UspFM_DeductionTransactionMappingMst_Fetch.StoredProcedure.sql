USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_DeductionTransactionMappingMst_Fetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [UspFM_DeductionTransactionMappingMst_Fetch]
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pErrorMessage nvarchar(1000)
EXEC [UspFM_DeductionTransactionMappingMst_Fetch] @pYear=2018,@pMonth=07,@pServiceId=2,@pFacilityId=2,@pIndicatorNo='B.3',@pErrorMessage=@pErrorMessage output
print @pErrorMessage

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_DeductionTransactionMappingMst_Fetch]                           
	@pUserId			INT	=	NULL,
	@pYear				INT,
	@pMonth				INT,
	@pServiceId			INT,                                             
	@pFacilityId		INT,
	@pIndicatorNo		nvarchar(10),
	@pErrorMessage		NVARCHAR(1000) OUTPUT
	--@pPageIndex			INT = null,
	--@pPageSize			INT = null
	
	AS 
	BEGIN TRY	

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pYear,0) = 0) RETURN

	IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn WHERE Month = @pMonth AND Year = @pYear AND FacilityId = @pFacilityId AND ServiceId = @pServiceId)
	BEGIN

	set  @pErrorMessage= 'Deduction not generated for this month' 

	END
	ELSE IF  EXISTS(SELECT 1 FROM DeductionTransactionMappingMst A 
					INNER JOIN MstDedIndicatorDet B ON A.IndicatorDetId = B.IndicatorDetId 
					WHERE Month = @pMonth AND Year = @pYear AND FacilityId = @pFacilityId AND ServiceId = @pServiceId and B.IndicatorNo = @pIndicatorNo)

	BEGIN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	DeductionTransactionMappingMst						AS DedGeneration
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on DedGeneration.ServiceId				= ServiceKey.ServiceId
			INNER  JOIN  DeductionTransactionMappingMstdet		AS DedGenerationDet					WITH(NOLOCK)			on DedGeneration.DedTxnMappingId		= DedGenerationDet.DedTxnMappingId
			INNER  JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DedGeneration.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			--INNER  JOIN  DedGenerationBemsPopupTxn				AS DedGenerationBemsPopup			WITH(NOLOCK)			on DedGeneration.DedGenerationId		= DedGenerationBemsPopup.DedGenerationId
	WHERE	DedGeneration.Year = @pYear AND  DedGeneration.Month = @pMonth AND DedGeneration.FacilityId = @pFacilityId 
	AND DedIndicatorDet.IndicatorNo = @pIndicatorNo
	and DedGenerationDet.DocumentNo IS NOT NULL


	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPage = CEILING(@pTotalPage)


	set  @pErrorMessage= ''

	IF (ISNULL(@TotalRecords,0)=0 )
	BEGIN
		SELECT  @pErrorMessage= 'No Records to display' ;
	END

	ELSE

	BEGIN

    SELECT	CAST(ROW_NUMBER() OVER(ORDER BY WorkOrder.MaintenanceWorkNo) AS INT) AS SerialNo,
			DedGeneration.DedTxnMappingId												AS DedTxnMappingId,
			DedGenerationBemsPopup.DedTxnMappingDetId											AS DedTxnMappingDetId,
			DedGeneration.DedGenerationId						AS DedGenerationId,
			DedGeneration.Month									AS Month,
			DedGeneration.Year									AS Year,
			DedGeneration.ServiceId								AS ServiceId,
			@TotalRecords										AS TotalRecords,
			ISNULL(ServiceKey.ServiceKey,'')					AS ServiceKey,
			'BEMS'												AS GroupValue,
			ISNULL(DedIndicatorDet.IndicatorNo,'')		AS IndicatorNo,
			--DedGenerationDet.TotalParameter						AS TotalParameter,
			WorkOrder.MaintenanceWorkDateTime			AS ServiceWorkDateTime,
			ISNULL(WorkOrder.MaintenanceWorkNo,'')		AS ServiceWorkNo,
			ISNULL(DedGenerationBemsPopup.AssetNo,'')			AS AssetNo,
			ISNULL(DedGenerationBemsPopup.AssetDescription,'')	AS AssetDescription,
			CASE WHEN WorkOrder.MaintenanceWorkCategory = 187 THEN 'Scheduled Work Order' ELSE CASE WHEN WorkOrder.MaintenanceWorkCategory = 188 THEN 'Unscheduled Work Order' 
			ELSE 'Unscheduled Work Order'	END END	AS ScreenName,
			ISNULL(DedGenerationBemsPopup.DemeritPoint,0)		AS DemeritPoint,
			ISNULL(DedGenerationBemsPopup.DemeritPoint,0)		AS FinalDemerit,
			1													AS IsValid,
			0													AS DisputedPendingResolution,
			''													AS Remarks,
			ISNULL(DedGenerationBemsPopup.DeductionValue,0)	AS DeductionValue,
			cast ( isnull(IsAdjustmentSaved,0) as bit ) as IsAdjustmentSaved
			--@pTotalPage											AS TotalPageCalc
	FROM	DeductionTransactionMappingMst									AS DedGeneration
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on DedGeneration.ServiceId				= ServiceKey.ServiceId
			--INNER  JOIN  DedGenerationTxnDet					AS DedGenerationDet					WITH(NOLOCK)			on DedGeneration.DedGenerationId		= DedGenerationDet.DedGenerationId
			--INNER  JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DedGenerationDet.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			INNER  JOIN  DeductionTransactionMappingMstdet				AS DedGenerationBemsPopup			WITH(NOLOCK)			on DedGeneration.DedTxnMappingId		= DedGenerationBemsPopup.DedTxnMappingId
			INNER  JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DedGeneration.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			LEFT  JOIN  EngMaintenanceWorkOrderTxn				AS WorkOrder						WITH(NOLOCK)			on DedGenerationBemsPopup.DocumentNo = WorkOrder.MaintenanceWorkNo
	WHERE	DedGeneration.Year = @pYear AND  DedGeneration.Month = @pMonth AND DedGeneration.FacilityId = @pFacilityId 
	AND DedIndicatorDet.IndicatorNo = @pIndicatorNo
	and DedGenerationBemsPopup.DocumentNo IS NOT NULL
	--ORDER BY DedGenerationBemsPopup.AssetNo
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	END
	END

	ELSE
	BEGIN
	SELECT	@TotalRecords	=	COUNT(*)
	FROM	DedGenerationTxn									AS DedGeneration
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on DedGeneration.ServiceId				= ServiceKey.ServiceId
			INNER  JOIN  DedGenerationTxnDet					AS DedGenerationDet					WITH(NOLOCK)			on DedGeneration.DedGenerationId		= DedGenerationDet.DedGenerationId
			INNER  JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DedGenerationDet.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			INNER  JOIN  DedGenerationBemsPopupTxn				AS DedGenerationBemsPopup			WITH(NOLOCK)			on DedGeneration.DedGenerationId		= DedGenerationBemsPopup.DedGenerationId
	WHERE	DedGeneration.Year = @pYear AND  DedGeneration.Month = @pMonth AND DedGeneration.FacilityId = @pFacilityId AND DedIndicatorDet.IndicatorNo = @pIndicatorNo
	--and DedGenerationBemsPopup.ServiceWorkNo IS NOT NULL
	and IsDemerit=0


	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPage = CEILING(@pTotalPage)


	set  @pErrorMessage= ''

	IF (ISNULL(@TotalRecords,0)=0 )
	BEGIN
		SELECT  @pErrorMessage= 'No Records to display' ;
	END

	ELSE

	BEGIN

    SELECT	CAST(ROW_NUMBER() OVER(ORDER BY DedGenerationBemsPopup.ServiceWorkNo) AS INT) AS SerialNo,
			0													AS DedTxnMappingId,
			0													AS DedTxnMappingDetId,
			DedGeneration.DedGenerationId						AS DedGenerationId,
			DedGeneration.Month									AS Month,
			DedGeneration.Year									AS Year,
			DedGeneration.ServiceId								AS ServiceId,
			@TotalRecords										AS TotalRecords,
			ISNULL(ServiceKey.ServiceKey,'')					AS ServiceKey,
			'BEMS'												AS GroupValue,
			ISNULL(DedGenerationBemsPopup.IndicatorNo,'')		AS IndicatorNo,
			--DedGenerationDet.TotalParameter						AS TotalParameter,
			case when IndicatorNo = 'b.5'  then TCDate 
				 when IndicatorNo = 'b.6'  then DATEFROMPARTS(@pYear,@pMonth,1)
				 else  DedGenerationBemsPopup.ServiceWorkDateTime	 end		AS ServiceWorkDateTime,
					--DedGenerationDet.TotalParameter						AS TotalParameter,
			case when IndicatorNo = 'b.5'  then TCDocumentNo 
				 ELSe
			ISNULL(DedGenerationBemsPopup.ServiceWorkNo,'')	end	AS ServiceWorkNo,
			ISNULL(DedGenerationBemsPopup.AssetNo,'')			AS AssetNo,
			ISNULL(DedGenerationBemsPopup.AssetDescription,'')	AS AssetDescription,
			CASE WHEN WorkOrder.MaintenanceWorkCategory = 187 THEN 'Scheduled Work Order' ELSE CASE WHEN WorkOrder.MaintenanceWorkCategory = 188 THEN 'Unscheduled Work Order' 
			ELSE 'Unscheduled Work Order'	END END	AS ScreenName,
			ISNULL(DedGenerationBemsPopup.DemeritPoint,0)		AS DemeritPoint,
			ISNULL(DedGenerationBemsPopup.DemeritPoint,0)		AS FinalDemerit,
			1													AS IsValid,
			0													AS DisputedPendingResolution,
			''													AS Remarks,
			ISNULL(DedGenerationBemsPopup.DeductionValueperasset,0)	AS DeductionValue,
			cast ( case when DeductionStatus='A' then 1 else 0 end as bit ) as IsAdjustmentSaved
			--@pTotalPage											AS TotalPageCalc
	FROM	DedGenerationTxn									AS DedGeneration
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on DedGeneration.ServiceId				= ServiceKey.ServiceId
			--INNER  JOIN  DedGenerationTxnDet					AS DedGenerationDet					WITH(NOLOCK)			on DedGeneration.DedGenerationId		= DedGenerationDet.DedGenerationId
			--INNER  JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DedGenerationDet.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			INNER  JOIN  DedGenerationBemsPopupTxn				AS DedGenerationBemsPopup			WITH(NOLOCK)			on DedGeneration.DedGenerationId		= DedGenerationBemsPopup.DedGenerationId
			LEFT  JOIN  EngMaintenanceWorkOrderTxn				AS WorkOrder						WITH(NOLOCK)			on DedGenerationBemsPopup.ServiceWorkNo = WorkOrder.MaintenanceWorkNo
	WHERE	DedGeneration.Year = @pYear AND  DedGeneration.Month = @pMonth AND DedGeneration.FacilityId = @pFacilityId AND DedGenerationBemsPopup.IndicatorNo = @pIndicatorNo
	--and DedGenerationBemsPopup.ServiceWorkNo IS NOT NULL
	and IsDemerit=0
	--ORDER BY DedGenerationBemsPopup.AssetNo
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



END


	END



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
