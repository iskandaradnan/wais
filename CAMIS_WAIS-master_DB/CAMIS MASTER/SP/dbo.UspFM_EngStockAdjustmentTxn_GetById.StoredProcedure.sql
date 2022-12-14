USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngStockAdjustmentTxn_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngStockAdjustmentTxn_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngStockAdjustmentTxn_GetById] @pStockAdjustmentId=228,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngStockAdjustmentTxn_GetById]                           
  @pUserId				INT	=	NULL,
  @pStockAdjustmentId   INT,
  @pPageIndex			INT,
  @pPageSize			INT	
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pStockAdjustmentId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngStockAdjustmentTxn									AS StockAdjustment			WITH(NOLOCK)
			INNER JOIN  MstLocationFacility							AS Facility					WITH(NOLOCK)	ON StockAdjustment.FacilityId			= Facility.FacilityId
			INNER JOIN  MstService									AS ServiceKey				WITH(NOLOCK)	ON StockAdjustment.ServiceId			= ServiceKey.ServiceId
			INNER JOIN  EngStockAdjustmentTxnDet					AS StockAdjustmentDet		WITH(NOLOCK)	ON StockAdjustment.StockAdjustmentId	= StockAdjustmentDet.StockAdjustmentId
			INNER JOIN	EngSpareParts								AS SpareParts				WITH(NOLOCK)	ON SpareParts.SparePartsId				= StockAdjustmentDet.SparePartsId
			INNER JOIN	FMItemMaster								AS ItemMaster				WITH(NOLOCK)	ON SpareParts.ItemId					= ItemMaster.ItemId
			INNER JOIN	EngStockUpdateRegisterTxnDet				AS StockUpdateRegisterDet	WITH(NOLOCK)	ON StockAdjustmentDet.StockUpdateDetId	= StockUpdateRegisterDet.StockUpdateDetId
	WHERE	StockAdjustment.StockAdjustmentId = @pStockAdjustmentId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

    SELECT	StockAdjustment.StockAdjustmentId						AS StockAdjustmentId,
			StockAdjustment.CustomerId								AS CustomerId,
			StockAdjustment.FacilityId								AS FacilityId,
			Facility.FacilityCode									AS FacilityCode,
			Facility.FacilityName									AS FacilityName,
			StockAdjustment.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey									AS ServiceKey,
			StockAdjustment.StockAdjustmentNo						AS StockAdjustmentNo,
			StockAdjustment.AdjustmentDate							AS AdjustmentDate,
			StockAdjustment.AdjustmentDateUTC						AS AdjustmentDateUTC,
			StockAdjustment.ApprovalStatus							AS ApprovalStatus,
			ApprovalStatus.FieldValue								AS ApprovalStatusValue,
			StockAdjustment.ApprovedBy								AS ApprovedBy,
			StockAdjustment.ApprovedDate							AS ApprovedDate,
			StockAdjustment.ApprovedDateUTC							AS ApprovedDateUTC,
			StockAdjustment.Timestamp								AS TimestampValue,
			StockAdjustmentDet.StockAdjustmentDetId					AS StockAdjustmentDetId,
			StockAdjustmentDet.StockUpdateDetId						AS StockUpdateDetId,
			StockAdjustmentDet.SparePartsId							AS SparePartsId,
			SpareParts.PartNo										AS PartNo,
			SpareParts.PartDescription								AS PartDescription,
			ItemMaster.ItemNo										AS ItemNo,
			ItemMaster.ItemDescription								AS ItemDescription,
			StockUpdateRegisterDet.Quantity							AS QuantityInFacility,
			StockAdjustmentDet.PhysicalQuantity						AS PhysicalQuantity,
			StockAdjustmentDet.Variance								AS Variance,
			StockAdjustmentDet.AdjustedQuantity						AS AdjustedQuantity,
			StockAdjustmentDet.Cost									AS Cost,
			StockAdjustmentDet.PurchaseCost							AS PurchaseCost,
			StockAdjustmentDet.InvoiceNo							AS InvoiceNo,
			StockAdjustmentDet.Remarks								AS Remarks,
			StockAdjustmentDet.VendorName							AS VendorName,			
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc,
			StockUpdateRegisterDet.BinNo
	FROM	EngStockAdjustmentTxn									AS StockAdjustment			WITH(NOLOCK)
			INNER JOIN  MstLocationFacility							AS Facility					WITH(NOLOCK)	ON StockAdjustment.FacilityId			= Facility.FacilityId
			INNER JOIN  MstService									AS ServiceKey				WITH(NOLOCK)	ON StockAdjustment.ServiceId			= ServiceKey.ServiceId
			INNER JOIN  EngStockAdjustmentTxnDet					AS StockAdjustmentDet		WITH(NOLOCK)	ON StockAdjustment.StockAdjustmentId	= StockAdjustmentDet.StockAdjustmentId
			INNER JOIN	EngSpareParts								AS SpareParts				WITH(NOLOCK)	ON SpareParts.SparePartsId				= StockAdjustmentDet.SparePartsId
			INNER JOIN	FMItemMaster								AS ItemMaster				WITH(NOLOCK)	ON SpareParts.ItemId					= ItemMaster.ItemId
			INNER JOIN	EngStockUpdateRegisterTxnDet				AS StockUpdateRegisterDet	WITH(NOLOCK)	ON StockAdjustmentDet.StockUpdateDetId	= StockUpdateRegisterDet.StockUpdateDetId
			INNER JOIN	FMLovMst									AS ApprovalStatus			WITH(NOLOCK)	ON StockAdjustment.ApprovalStatus		= ApprovalStatus.LovId
	WHERE	StockAdjustment.StockAdjustmentId = @pStockAdjustmentId 
	ORDER BY StockAdjustment.ModifiedDate ASC
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
