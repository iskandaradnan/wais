USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxn_BulkAuthorization_GetAll]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxn_BulkAuthorization_GetAll
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 26-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_VmVariationTxn_BulkAuthorization_GetAll  @pYear=2018,@pMonth=4,@pServiceId=2,@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxn_BulkAuthorization_GetAll]                           
		@pYear			INT,
		@pMonth			INT,
		@pServiceId		INT,
		@pPageIndex		INT,
		@pPageSize		INT,
		@pFacilityId	INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE	@TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)
	DECLARE	@pTotalPageCalc	NUMERIC(24,2)

-- Default Values


-- Execution


	IF(ISNULL(@pYear,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
 	FROM	VmVariationTxn							AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
			LEFT JOIN MstLocationUserLocation		AS	UserLocation		WITH(NOLOCK)	ON Asset.UserLocationId			=	UserLocation.UserLocationId
			INNER JOIN  FMLovMst					AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
	WHERE	ISNULL(AuthorizedStatus,0) = 0 
			AND	YEAR(Variation.VariationRaisedDate)			=	@pYear 
			AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
			AND Variation.ServiceId							=	@pServiceId
			AND Variation.FacilityId						=	@pFacilityId

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)

    SELECT	Variation.VariationId,
			Variation.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			UserLocation.UserLocationName,
			Variation.SNFDocumentNo,
			LovVariationStatus.FieldValue			AS	VariationStatus,
			isnull(Variation.PurchaseProjectCost,0) as PurchaseProjectCost,
			Variation.CommissioningDate,
			Variation.StartServiceDate,
			Variation.WarrantyEndDate,
			Variation.VariationDate,
			Variation.ServiceStopDate,
			Variation.AuthorizedStatus ,
			Variation.[Timestamp]					AS	[Timestamp],
			@TotalRecords							AS	TotalRecords,
			@pTotalPageCalc							AS	TotalPageCalc
 	FROM	VmVariationTxn							AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
			LEFT JOIN MstLocationUserLocation		AS	UserLocation		WITH(NOLOCK)	ON Asset.UserLocationId			=	UserLocation.UserLocationId
			INNER JOIN  FMLovMst					AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
	WHERE	ISNULL(AuthorizedStatus,0) = 0 
			AND	YEAR(Variation.VariationRaisedDate)			=	@pYear 
			AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
			AND Variation.ServiceId							=	@pServiceId
			AND Variation.FacilityId						=	@pFacilityId
	ORDER BY Variation.ModifiedDate DESC
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
