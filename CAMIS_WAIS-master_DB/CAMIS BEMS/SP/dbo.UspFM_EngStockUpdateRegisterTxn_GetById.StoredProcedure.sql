USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngStockUpdateRegisterTxn_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngStockUpdateRegisterTxn_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngStockUpdateRegisterTxn_GetById] @pStockUpdateId=40,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngStockUpdateRegisterTxn_GetById]                           
  @pUserId			INT	=	NULL,
  @pStockUpdateId   INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pStockUpdateId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngStockUpdateRegisterTxn							AS StockUpdate		WITH(NOLOCK)
			INNER JOIN  MstLocationFacility						AS Facility			WITH(NOLOCK)	ON StockUpdate.FacilityId		= Facility.FacilityId
			INNER JOIN  EngStockUpdateRegisterTxnDet			AS StockUpdateDet	WITH(NOLOCK)	ON StockUpdateDet.StockUpdateId = StockUpdate.StockUpdateId
			INNER JOIN	EngSpareParts							AS SpareParts       WITH(NOLOCK)	ON SpareParts.SparePartsId		= StockUpdateDet.SparePartsId
			LEFT JOIN	FMLovMst								AS SparePartType	WITH(NOLOCK)	ON StockUpdateDet.SparePartType		= SparePartType.LovId
			INNER JOIN	FMItemMaster							AS ItemMaster		WITH(NOLOCK)	ON SpareParts.ItemId			= ItemMaster.ItemId
			LEFT JOIN FMLovMst									AS LovPartSource	WITH(NOLOCK)	ON	SpareParts.PartSourceId	=	LovPartSource.LovId
			LEFT JOIN FMLovMst									AS LifeSpanOptionId	WITH(NOLOCK)	ON	SpareParts.LifeSpanOptionId	=	LifeSpanOptionId.LovId
			LEFT JOIN	FMLovMst								AS	LovLocation		WITH(NOLOCK)	ON StockUpdateDet.LocationId			=	LovLocation.LovId
			OUTER APPLY (	SELECT	CASE WHEN COUNT(AdjDet.SparePartsId)>0 THEN 1 
										ELSE 0 END AS IsReferenced 
							FROM
							EngStockAdjustmentTxnDet AS AdjDet WHERE StockUpdateDet.StockUpdateDetId=AdjDet.StockUpdateDetId) as AdjDet
	WHERE	StockUpdate.StockUpdateId = @pStockUpdateId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	StockUpdateDet.StockUpdateId						AS StockUpdateId,
			StockUpdateDet.StockUpdateDetId						AS StockUpdateDetId,
			StockUpdate.CustomerId								AS CustomerId,
			StockUpdate.FacilityId								AS FacilityId,
			Facility.FacilityCode								AS FacilityCode,
			Facility.FacilityName								AS FacilityName,
			StockUpdate.ServiceId								AS ServiceId,
			StockUpdate.StockUpdateNo							AS StockUpdateNo,
			StockUpdate.Date									AS Date,
			StockUpdate.DateUTC									AS DateUTC,
			StockUpdateDet.SparePartsId							AS SparePartsId,
			SpareParts.PartNo									AS PartNo,		
			SpareParts.PartDescription							AS PartDescription,
			StockUpdateDet.SparePartType						AS SparePartType,
			SparePartType.FieldValue							AS SparePartTypeName,
			ItemMaster.ItemNo									AS ItemNo,
			ItemMaster.ItemDescription							AS ItemDescription,
			StockUpdateDet.StockExpiryDate						AS StockExpiryDate,
			StockUpdateDet.StockExpiryDateUTC					AS StockExpiryDateUTC,
			StockUpdateDet.Quantity								AS Quantity,
			StockUpdateDet.Cost									AS Cost,
			StockUpdateDet.PurchaseCost							AS PurchaseCost,
			StockUpdateDet.InvoiceNo							AS InvoiceNo,
			StockUpdateDet.Remarks								AS Remarks,
			StockUpdateDet.Vendorname							AS Vendorname,				
			(SELECT cast(SUM(COST*Quantity)as numeric(24,2)) FROM EngStockUpdateRegisterTxnDet WHERE StockUpdateId =@pStockUpdateId
			GROUP BY StockUpdateId)								AS TotalCost, 
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc,
			--ISNULL(SpareParts.IsExpirydate,0)					AS	IsExpirydate,
			SpareParts.PartSourceId,
			LovPartSource.FieldValue AS PartSource,
			--SpareParts.EstimatedLifeSpanInHours as EstimatedLifeSpan,
			CAST(AdjDet.IsReferenced AS BIT) IsReferenced,
			StockUpdateDet.EstimatedLifeSpan,
			SpareParts.LifeSpanOptionId,
			LifeSpanOptionId.FieldValue as LifeSpanOptionValue,
			SpareParts.LifeSpanOptionId AS EstimatedLifeSpanId,
			StockUpdateDet.LocationId			AS LocationId,
			LovLocation.FieldValue				AS Location,
			StockUpdateDet.BinNo
	FROM	EngStockUpdateRegisterTxn							AS StockUpdate		WITH(NOLOCK)
			INNER JOIN  MstLocationFacility						AS Facility			WITH(NOLOCK)	ON StockUpdate.FacilityId		= Facility.FacilityId
			INNER JOIN  EngStockUpdateRegisterTxnDet			AS StockUpdateDet	WITH(NOLOCK)	ON StockUpdateDet.StockUpdateId = StockUpdate.StockUpdateId
			INNER JOIN	EngSpareParts							AS SpareParts       WITH(NOLOCK)	ON SpareParts.SparePartsId		= StockUpdateDet.SparePartsId
			LEFT JOIN	FMLovMst								AS SparePartType	WITH(NOLOCK)	ON StockUpdateDet.SparePartType		= SparePartType.LovId
			INNER JOIN	FMItemMaster							AS ItemMaster		WITH(NOLOCK)	ON SpareParts.ItemId			= ItemMaster.ItemId
			LEFT JOIN FMLovMst									AS LovPartSource	WITH(NOLOCK)	ON	SpareParts.PartSourceId	=	LovPartSource.LovId
			LEFT JOIN FMLovMst									AS LifeSpanOptionId	WITH(NOLOCK)	ON	SpareParts.LifeSpanOptionId	=	LifeSpanOptionId.LovId
			LEFT JOIN	FMLovMst								AS	LovLocation		WITH(NOLOCK)	ON StockUpdateDet.LocationId			=	LovLocation.LovId
			OUTER APPLY (	SELECT	CASE WHEN COUNT(AdjDet.SparePartsId)>0 THEN 1 
										ELSE 0 END AS IsReferenced 
							FROM
							EngStockAdjustmentTxnDet AS AdjDet WHERE StockUpdateDet.StockUpdateDetId=AdjDet.StockUpdateDetId) as AdjDet
	WHERE	StockUpdate.StockUpdateId = @pStockUpdateId 
	ORDER BY StockUpdate.ModifiedDate ASC
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
