USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxnDet_Search]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTestingandCommissioningTxnDet_Search
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngTestingandCommissioningTxnDet_Search  @pAssetPreRegistrationNo='',@pAssetClassificationId='',@pPageIndex=1,@pPageSize=5,@pFacilityId=1,@pIsLoaner=0
SELECT * FROM EngAssetTypeCode
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngTestingandCommissioningTxnDet_Search]
                           
  @pAssetPreRegistrationNo		NVARCHAR(100),
  @pAssetClassificationId		INT	=NULL,
  @pPageIndex					INT,
  @pPageSize					INT,
  @pFacilityId					INT,
  @pIsLoaner					INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

IF(@pIsLoaner  = 0)
	BEGIN
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngTestingandCommissioningTxn					AS TandC			WITH(NOLOCK)
					INNER JOIN EngTestingandCommissioningTxnDet		AS TandCDet			WITH(NOLOCK)	ON	TandC.TestingandCommissioningId = TandCDet.TestingandCommissioningId
					LEFT JOIN EngAssetTypeCode						AS TypeCode			WITH(NOLOCK)	ON	TandC.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN MstContractorandVendor				AS Contractor		WITH(NOLOCK)	ON	TandC.ContractorId				= Contractor.ContractorId
					LEFT JOIN EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON	TandC.ModelId					= Model.ModelId
					LEFT JOIN EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON	TandC.ManufacturerId			= Manufacturer.ManufacturerId
		WHERE		TandC.TandCStatus =71
					AND ( ISNULL( Status,0) IN (290))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND TandC.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetPreRegistrationNo,'') = '' )	OR (ISNULL(@pAssetPreRegistrationNo,'') <> '' AND TandCDet.AssetPreRegistrationNo LIKE + '%' + @pAssetPreRegistrationNo + '%' ))
					AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND ( ISNULL(TypeCode.AssetClassificationId,0) =  @pAssetClassificationId ) OR TypeCode.AssetClassificationId IS NULL))
					AND TandCDet.TestingandCommissioningDetId NOT IN (SELECT DISTINCT ISNULL(TestingandCommissioningDetId,'') FROM EngAsset WHERE FacilityId	=	@pFacilityId)
					AND TandC.AssetCategoryLovId IN (73)

		SELECT		TandCDet.TestingandCommissioningDetId,
					TandCDet.AssetPreRegistrationNo,
					CAST(TandC.TandCDate AS date)				AS	TandCDate,
					CAST(TandC.ServiceStartDate AS date)		AS	ServiceStartDate,
					CAST(TandC.PurchaseDate AS date)			AS	PurchaseDate,
					PurchaseCost,
					CAST(TandC.WarrantyStartDate AS date)		AS	WarrantyStartDate,				
					TandC.WarrantyDuration,					
					CAST(TandC.WarrantyEndDate AS date)			AS	WarrantyEndDate,
					Contractor.ContractorName	AS	MainSupplierName,
					CAST(CAST((DATEDIFF(m, TandC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' + 
						CASE	WHEN DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
								ELSE cast((abs(DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12)) 
						AS VARCHAR) END as NUMERIC(24,2))				AS AssetAge, 
					CAST(CAST((DATEDIFF(m, TandC.TandCDate, GETDATE())/12) AS VARCHAR) + '.' + 
						CASE	WHEN DATEDIFF(m, TandC.TandCDate, GETDATE())%12 = 0 THEN '1' 
								ELSE CAST((abs(DATEDIFF(m, TandC.TandCDate, GETDATE())%12)) 
						AS VARCHAR) END as NUMERIC(24,2))				AS YearsInService,
					TypeCode.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					TypeCode.AssetClassificationId,
					TandC.ServiceEndDate,
					TandC.PurchaseOrderNo,	
					TandC.ModelId,	
					Model.Model,
					TandC.ManufacturerId,	
					Manufacturer.Manufacturer,
					@TotalRecords AS TotalRecords
		FROM		EngTestingandCommissioningTxn					AS TandC			WITH(NOLOCK)
					INNER JOIN EngTestingandCommissioningTxnDet		AS TandCDet			WITH(NOLOCK)	ON	TandC.TestingandCommissioningId = TandCDet.TestingandCommissioningId
					LEFT JOIN EngAssetTypeCode						AS TypeCode			WITH(NOLOCK)	ON	TandC.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN MstContractorandVendor				AS Contractor		WITH(NOLOCK)	ON	TandC.ContractorId				= Contractor.ContractorId
					LEFT JOIN EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON	TandC.ModelId					= Model.ModelId
					LEFT JOIN EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON	TandC.ManufacturerId			= Manufacturer.ManufacturerId
		WHERE		TandC.TandCStatus =71
					AND ( ISNULL( Status,0) IN (290))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND TandC.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetPreRegistrationNo,'') = '' )	OR (ISNULL(@pAssetPreRegistrationNo,'') <> '' AND TandCDet.AssetPreRegistrationNo LIKE + '%' + @pAssetPreRegistrationNo + '%' ))
					AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND ( ISNULL(TypeCode.AssetClassificationId,0) =  @pAssetClassificationId ) OR TypeCode.AssetClassificationId IS NULL))
					AND TandCDet.TestingandCommissioningDetId NOT IN (SELECT DISTINCT ISNULL(TestingandCommissioningDetId,'') FROM EngAsset WHERE FacilityId	=	@pFacilityId)
					AND TandC.AssetCategoryLovId IN (73)

		ORDER BY	TandCDet.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
END


ELSE IF(@pIsLoaner  = 1)
	BEGIN
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngTestingandCommissioningTxn					AS TandC			WITH(NOLOCK)
					INNER JOIN EngTestingandCommissioningTxnDet		AS TandCDet			WITH(NOLOCK)	ON	TandC.TestingandCommissioningId = TandCDet.TestingandCommissioningId
					LEFT JOIN EngAssetTypeCode						AS TypeCode			WITH(NOLOCK)	ON	TandC.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN MstContractorandVendor				AS Contractor		WITH(NOLOCK)	ON	TandC.ContractorId				= Contractor.ContractorId
					LEFT JOIN EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON	TandC.ModelId					= Model.ModelId
					LEFT JOIN EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON	TandC.ManufacturerId			= Manufacturer.ManufacturerId
		WHERE		TandC.TandCStatus =71
					AND ( ISNULL( Status,0) IN (290))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND TandC.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetPreRegistrationNo,'') = '' )	OR (ISNULL(@pAssetPreRegistrationNo,'') <> '' AND TandCDet.AssetPreRegistrationNo LIKE + '%' + @pAssetPreRegistrationNo + '%' ))
					AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND ( ISNULL(TypeCode.AssetClassificationId,0) =  @pAssetClassificationId ) OR TypeCode.AssetClassificationId IS NULL))
					AND TandCDet.TestingandCommissioningDetId NOT IN (SELECT DISTINCT ISNULL(TestingandCommissioningDetId,'') FROM EngAsset WHERE FacilityId	=	@pFacilityId)
					AND TandC.AssetCategoryLovId IN (283,284)

		SELECT		TandCDet.TestingandCommissioningDetId,
					TandCDet.AssetPreRegistrationNo,
					CAST(TandC.TandCDate AS date)				AS	TandCDate,
					CAST(TandC.ServiceStartDate AS date)		AS	ServiceStartDate,
					CAST(TandC.PurchaseDate AS date)			AS	PurchaseDate,
					PurchaseCost,
					CAST(TandC.WarrantyStartDate AS date)		AS	WarrantyStartDate,				
					TandC.WarrantyDuration,					
					CAST(TandC.WarrantyEndDate AS date)			AS	WarrantyEndDate,
					Contractor.ContractorName	AS	MainSupplierName,
					CAST(CAST((DATEDIFF(m, TandC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' + 
						CASE	WHEN DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
								ELSE cast((abs(DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12)) 
						AS VARCHAR) END as NUMERIC(24,2))				AS AssetAge, 
					CAST(CAST((DATEDIFF(m, TandC.TandCDate, GETDATE())/12) AS VARCHAR) + '.' + 
						CASE	WHEN DATEDIFF(m, TandC.TandCDate, GETDATE())%12 = 0 THEN '1' 
								ELSE CAST((abs(DATEDIFF(m, TandC.TandCDate, GETDATE())%12)) 
						AS VARCHAR) END as NUMERIC(24,2))				AS YearsInService,
					TypeCode.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					TypeCode.AssetClassificationId,
					TandC.ServiceEndDate,
					TandC.PurchaseOrderNo,	
					TandC.ModelId,	
					Model.Model,
					TandC.ManufacturerId,	
					Manufacturer.Manufacturer,
					@TotalRecords AS TotalRecords
		FROM		EngTestingandCommissioningTxn					AS TandC			WITH(NOLOCK)
					INNER JOIN EngTestingandCommissioningTxnDet		AS TandCDet			WITH(NOLOCK)	ON	TandC.TestingandCommissioningId = TandCDet.TestingandCommissioningId
					LEFT JOIN EngAssetTypeCode						AS TypeCode			WITH(NOLOCK)	ON	TandC.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN MstContractorandVendor				AS Contractor		WITH(NOLOCK)	ON	TandC.ContractorId				= Contractor.ContractorId
					LEFT JOIN EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON	TandC.ModelId					= Model.ModelId
					LEFT JOIN EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON	TandC.ManufacturerId			= Manufacturer.ManufacturerId
		WHERE		TandC.TandCStatus =71
					AND ( ISNULL( Status,0) IN (290))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND TandC.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetPreRegistrationNo,'') = '' )	OR (ISNULL(@pAssetPreRegistrationNo,'') <> '' AND TandCDet.AssetPreRegistrationNo LIKE + '%' + @pAssetPreRegistrationNo + '%' ))
					AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND ( ISNULL(TypeCode.AssetClassificationId,0) =  @pAssetClassificationId ) OR TypeCode.AssetClassificationId IS NULL))
					AND TandCDet.TestingandCommissioningDetId NOT IN (SELECT DISTINCT ISNULL(TestingandCommissioningDetId,'') FROM EngAsset WHERE FacilityId	=	@pFacilityId)
					AND TandC.AssetCategoryLovId IN (283,284)

		ORDER BY	TandCDet.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
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
		   );
		   THROW;

END CATCH
GO
