USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngFacilitiesWorkshopTxn_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngFacilitiesWorkshopTxn_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngFacilitiesWorkshopTxn_GetById] @pFacilitiesWorkshopId=8,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngFacilitiesWorkshopTxn_GetById]                           
  @pUserId						INT	=	NULL,
  @pFacilitiesWorkshopId		INT,
  @pPageIndex					INT,
  @pPageSize					INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pFacilitiesWorkshopId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngFacilitiesWorkshopTxn							AS FacilitiesWorkshop		WITH(NOLOCK)
			INNER JOIN  EngFacilitiesWorkshopTxnDet				AS FacilitiesWorkshopDet	WITH(NOLOCK)			on FacilitiesWorkshop.FacilitiesWorkshopId		= FacilitiesWorkshopDet.FacilitiesWorkshopId
			INNER JOIN	MstService								AS ServiceKey				WITH(NOLOCK)			on FacilitiesWorkshop.ServiceId					= ServiceKey.ServiceId
			INNER JOIN	FMLovMst								AS FacilityType				WITH(NOLOCK)			on FacilitiesWorkshop.FacilityType				= FacilityType.LovId
			LEFT OUTER JOIN	FMLovMst								AS Category					WITH(NOLOCK)			on FacilitiesWorkshop.Category					= Category.LovId
			LEFT OUTER JOIN	EngAsset								AS Asset					WITH(NOLOCK)			on FacilitiesWorkshopDet.AssetId				= Asset.AssetId
			LEFT JOIN	FMLovMst								AS Location					WITH(NOLOCK)			on FacilitiesWorkshopDet.Location				= Location.LovId

	WHERE	FacilitiesWorkshop.FacilitiesWorkshopId = @pFacilitiesWorkshopId  

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


	SELECT	FacilitiesWorkshop.FacilitiesWorkshopId				AS FacilitiesWorkshopId,
			FacilitiesWorkshop.CustomerId						AS CustomerId,
			FacilitiesWorkshop.FacilityId						AS FacilityId,
			FacilitiesWorkshop.ServiceId						AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			FacilitiesWorkshop.Year								AS Year,
			FacilitiesWorkshop.FacilityType						AS FacilityType,
			FacilityType.FieldValue								AS FacilityTypeName,
			FacilitiesWorkshop.Category							AS Category,
			Category.FieldValue									AS CategoryName,
			FacilitiesWorkshopDet.FacilitiesWorkshopDetId		AS FacilitiesWorkshopDetId,
			FacilitiesWorkshopDet.AssetId						AS AssetId,
			Asset.AssetNo										AS AssetNo,
			FacilitiesWorkshopDet.[Description]					AS [Description],
			FacilitiesWorkshopDet.Manufacturer					AS Manufacturer,
			FacilitiesWorkshopDet.Model							AS Model,
			FacilitiesWorkshopDet.SerialNo						AS SerialNo,
			FacilitiesWorkshopDet.CalibrationDueDate			AS CalibrationDueDate,
			FacilitiesWorkshopDet.CalibrationDueDateUTC			AS CalibrationDueDateUTC,
			FacilitiesWorkshopDet.Location						AS Location,
			Location.FieldValue									AS LocationName,
			FacilitiesWorkshopDet.Quantity						AS Quantity,
			FacilitiesWorkshopDet.SizeArea						AS SizeArea,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	EngFacilitiesWorkshopTxn							AS FacilitiesWorkshop		WITH(NOLOCK)
			INNER JOIN  EngFacilitiesWorkshopTxnDet				AS FacilitiesWorkshopDet	WITH(NOLOCK)			on FacilitiesWorkshop.FacilitiesWorkshopId		= FacilitiesWorkshopDet.FacilitiesWorkshopId
			INNER JOIN	MstService								AS ServiceKey				WITH(NOLOCK)			on FacilitiesWorkshop.ServiceId					= ServiceKey.ServiceId
			INNER JOIN	FMLovMst								AS FacilityType				WITH(NOLOCK)			on FacilitiesWorkshop.FacilityType				= FacilityType.LovId
			LEFT OUTER JOIN	FMLovMst								AS Category					WITH(NOLOCK)			on FacilitiesWorkshop.Category					= Category.LovId
			LEFT OUTER JOIN	EngAsset								AS Asset					WITH(NOLOCK)			on FacilitiesWorkshopDet.AssetId				= Asset.AssetId
			LEFT OUTER JOIN	FMLovMst								AS Location					WITH(NOLOCK)			on FacilitiesWorkshopDet.Location				= Location.LovId

	WHERE	FacilitiesWorkshop.FacilitiesWorkshopId = @pFacilitiesWorkshopId
	ORDER BY FacilitiesWorkshop.ModifiedDate ASC
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
