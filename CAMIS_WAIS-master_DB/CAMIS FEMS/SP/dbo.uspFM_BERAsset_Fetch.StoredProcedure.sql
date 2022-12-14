USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERAsset_Fetch]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*===========================================-=============================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_BERAsset_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 09-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_BERAsset_Fetch]  @pAssetNo='PANH00035',@pPageIndex=1,@pPageSize=20,@pFacilityId=2
EXEC [uspFM_BERAsset_Fetch]  @pAssetNo=NULL,@pPageIndex=1,@pPageSize=20,@pFacilityId=1
select BERStatus,* from BerApplicationTxn
select * from eNGaSSET
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BERAsset_Fetch]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT =	NULL,
  @pPageSize			INT =	NULL,
  @pFacilityId			INT =	NULL

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
		--SELECT		@TotalRecords	=	COUNT(*)
		--FROM (
		--SELECT Asset.AssetId,Asset.AssetNo,ISNULL(BERStatus,0)	AS BERStatus
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
	            	INNER JOIN EngAssetTypeCode                     AS  TYPECODE			WITH(NOLOCK) ON	Asset.AssetTypeCodeId		    = TYPECODE.AssetTypeCodeId        
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	BERApplicationTxn					AS	BERApp				WITH(NOLOCK) ON	Asset.AssetId					= BERApp.AssetId	
					 inner join EngTestingandCommissioningTxnDet     AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId		    = Test.TestingandCommissioningDetId           
					 inner join		EngTestingandCommissioningTxn								as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
					 left join  MstContractorandVendor				as Contractor           WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId

			WHERE		Asset.Active =1 and asset.IsLoaner=0
			  AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
	         	AND ( ISNULL( BERStatus,0) NOT IN (206,210))
	    				--AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					--AND ( ISNULL( BERStatus,0) NOT IN (206,210))
		--) SUB WHERE BERStatus NOT IN (206,210)
						
	
--SELECT * FROM (
		SELECT		Asset.AssetId,
					Asset.AssetNo,
					TYPECODE.AssetTypeDescription        AssetDescription,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					Manufacturer.Manufacturer,
					Model.Model,
					Contractor.ContractorName  MainSupplier,
					Asset.PurchaseCostRM,
					Asset.PurchaseDate,
					CAST(CAST((DATEDIFF(m, Asset.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' + 
					CASE	WHEN DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
							ELSE CAST((ABS(DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12)) 
					AS VARCHAR) END as NUMERIC(24,2))				AS AssetAge,
					CASE WHEN ((CAST(CONVERT(char(8), GETDATE(), 112) AS INT) - CAST(CONVERT(char(8), COALESCE(Asset.PurchaseDate,CommissioningDate), 112) AS int)) / 10000 < Asset.ExpectedLifespan) THEN 99
					ELSE 100 END	AS StillWithInLifeSpan,


				   CASE WHEN Asset.ExpectedLifespan <> 0 THEN 
					((1-CAST(CAST((DATEDIFF(m, Asset.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' + 
					CASE	WHEN DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
							ELSE CAST((ABS(DATEDIFF(m, Asset.PurchaseDate, GETDATE())%12)) 
					AS VARCHAR) END as NUMERIC(24,2)) )	/  Asset.ExpectedLifespan	) * PurchaseCostRM	
					ELSE 
					0.00 END AS CurrentValue ,
					BERStatus,
					Asset.ModifiedDateUTC,
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)

		            INNER JOIN EngAssetTypeCode                     AS  TYPECODE			WITH(NOLOCK) ON	Asset.AssetTypeCodeId		    = TYPECODE.AssetTypeCodeId        
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	BERApplicationTxn					AS	BERApp				WITH(NOLOCK) ON	Asset.AssetId					= BERApp.AssetId
					inner join EngTestingandCommissioningTxnDet     AS  Test			    WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId		    = Test.TestingandCommissioningDetId           
					inner join EngTestingandCommissioningTxn	as te						WITH(NOLOCK) ON te.TestingandCommissioningId=test.TestingandCommissioningId
					left join  MstContractorandVendor				as Contractor           WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
	
		WHERE		Asset.Active =1 and asset.IsLoaner=0
		            AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ( ISNULL( BERStatus,0) NOT IN (206,210))
						
		ORDER BY	ModifiedDateUTC DESC
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
