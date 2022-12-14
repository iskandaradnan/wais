USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_DeductionTransactionMappingMst_GetbyId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [UspFM_DeductionTransactionMappingMst_GetbyId]
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_DeductionTransactionMappingMst_GetbyId] @pDedTxnMappingId=10,@pPageIndex=1,@pPageSize=5,@pUserId=1
select * from DeductionTransactionMappingMst
select * from DeductionTransactionMappingMstDet

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_DeductionTransactionMappingMst_GetbyId]                           
	@pUserId			INT	=	NULL,
	@pDedTxnMappingId	INT,
	@pPageIndex			INT = null,
	@pPageSize			INT = null
	
	AS 
	BEGIN TRY	

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pDedTxnMappingId,0) = 0) RETURN



	SELECT	@TotalRecords	=	COUNT(*)
	FROM	DeductionTransactionMappingMst						AS DeductionTransactionMst
			INNER JOIN  DeductionTransactionMappingMstDet		AS DeductionTransactionMstDet		WITH(NOLOCK)			on DeductionTransactionMstDet.DedTxnMappingId	= DeductionTransactionMst.DedTxnMappingId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on DeductionTransactionMst.ServiceId			= ServiceKey.ServiceId
			INNER JOIN  FMTimeMonth								AS TimeMonth						WITH(NOLOCK)			on DeductionTransactionMst.Month				= TimeMonth.MonthId
			INNER JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DeductionTransactionMst.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			--INNER JOIN  FMLovMst								AS GroupValue						WITH(NOLOCK)			on DeductionTransactionMst.[Group]				= GroupValue.LovId
	WHERE	DeductionTransactionMst.DedTxnMappingId = @pDedTxnMappingId

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	

    SELECT	CAST(ROW_NUMBER() OVER (ORDER BY DeductionTransactionMst.ModifiedDate) AS INT) AS SerialNo,
			DeductionTransactionMst.DedTxnMappingId				AS DedTxnMappingId,
			DeductionTransactionMst.CustomerId					AS CustomerId,
			DeductionTransactionMst.FacilityId					AS FacilityId,
			DeductionTransactionMst.ServiceId					AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			DeductionTransactionMst.Month						AS Month,
			TimeMonth.Month										AS MonthValue,
			DeductionTransactionMst.Year						AS Year,
			DeductionTransactionMst.DedGenerationId				AS DedGenerationId,
			DeductionTransactionMst.IndicatorDetId				AS IndicatorDetId,
			DedIndicatorDet.IndicatorNo							AS IndicatorNo,
			DeductionTransactionMst.[Group]						AS [Group],
			--GroupValue.FieldValue								AS GroupValue,
			DeductionTransactionMstDet.DedTxnMappingDetId		AS DedTxnMappingDetId,
			DeductionTransactionMstDet.CustomerId				AS CustomerId,
			DeductionTransactionMstDet.FacilityId				AS FacilityId,
			DeductionTransactionMstDet.DedTxnMappingId			AS DedTxnMappingId,
			DeductionTransactionMstDet.Date						AS ServiceWorkDateTime,
			DeductionTransactionMstDet.DocumentNo				AS ServiceWorkNo,
			DeductionTransactionMstDet.Details					AS ScreenName,
			DeductionTransactionMstDet.DemeritPoint				AS DemeritPoint,
			CAST(DeductionTransactionMstDet.IsValid AS INT)		AS IsValid,
			ISNULL(DeductionTransactionMstDet.Remarks,'')		AS Remarks,
			DeductionTransactionMstDet.DeductionValue			AS DeductionValue,
			DeductionTransactionMstDet.FinalDemeritPoint		AS FinalDemerit,
			DeductionTransactionMstDet.AssetNo					 AS AssetNo,
			DeductionTransactionMstDet.AssetDescription			 AS AssetDescription,
			DeductionTransactionMstDet.DisputedPendingResolution AS DisputedPendingResolution,
			cast(isnull(DeductionTransactionMst.IsAdjustmentSaved,0) as bit ) as IsAdjustmentSaved,
			@TotalRecords										AS TotalRecords
	FROM	DeductionTransactionMappingMst						AS DeductionTransactionMst
			INNER JOIN  DeductionTransactionMappingMstDet		AS DeductionTransactionMstDet		WITH(NOLOCK)			on DeductionTransactionMstDet.DedTxnMappingId	= DeductionTransactionMst.DedTxnMappingId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on DeductionTransactionMst.ServiceId			= ServiceKey.ServiceId
			INNER JOIN  FMTimeMonth								AS TimeMonth						WITH(NOLOCK)			on DeductionTransactionMst.Month				= TimeMonth.MonthId
			INNER JOIN  MstDedIndicatorDet						AS DedIndicatorDet					WITH(NOLOCK)			on DeductionTransactionMst.IndicatorDetId		= DedIndicatorDet.IndicatorDetId
			--INNER JOIN  FMLovMst								AS GroupValue						WITH(NOLOCK)			on DeductionTransactionMst.[Group]				= GroupValue.LovId
	WHERE	DeductionTransactionMst.DedTxnMappingId = @pDedTxnMappingId
	ORDER BY DeductionTransactionMst.ModifiedDate
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
