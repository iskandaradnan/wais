USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetQR_GetAll]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAssetQR_GetAll]
Description			: QR Code Asset number fetch control
Authors				: Dhilip V
Date				: 24-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetQR_GetAll]  @pContainsAssetNo='1',@pBeginWithAssetNo='',@pEqualAssetNo='',@pNotEqulAssetNo='',@pContainsUserArea=NULL,@pBeginWithUserArea='',
@pEqualUserArea='',@pNotEqulUserArea='',@pContainsUserLocation=NULL,@pBeginWithUserLocation=NULL,@pEqualUserLocation=NULL,@pNotEqulUserLocation=NULL,@pContainsAssetDescription=NULL,@pBeginWithAssetDescription=NULL,@pEqualAssetDescription=NULL,@pNotEqulAssetDescription=NULL,@pContainsAssetTypeCode=NULL,@pBeginWithAssetTypeCode=NULL,@pEqualAssetTypeCode=NULL,@pNotEqulAssetTypeCode=NULL,@pContainsManufacturer=NULL,@pBeginWithManufacturer=NULL,@pEqualManufacturer=NULL,@pNotEqulManufacturer=NULL,@pContainsModel=NULL,@pBeginWithModel=NULL,@pEqualModel=NULL,@pNotEqulModel=NULL,
@pPageIndex=1,@pPageSize=20
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetQR_GetAll]                           
                            
  @pContainsAssetNo					NVARCHAR(100)	=	NULL,
  @pBeginWithAssetNo				NVARCHAR(100)	=	NULL,
  @pEqualAssetNo					NVARCHAR(100)	=	NULL,
  @pNotEqulAssetNo					NVARCHAR(100)	=	NULL,

  @pContainsUserArea				NVARCHAR(100)	=	NULL,
  @pBeginWithUserArea				NVARCHAR(100)	=	NULL,
  @pEqualUserArea					NVARCHAR(100)	=	NULL,
  @pNotEqulUserArea					NVARCHAR(100)	=	NULL,

  @pContainsUserLocation			NVARCHAR(100)	=	NULL,
  @pBeginWithUserLocation			NVARCHAR(100)	=	NULL,
  @pEqualUserLocation				NVARCHAR(100)	=	NULL,
  @pNotEqulUserLocation				NVARCHAR(100)	=	NULL,

  @pContainsAssetDescription		NVARCHAR(100)	=	NULL,
  @pBeginWithAssetDescription		NVARCHAR(100)	=	NULL,
  @pEqualAssetDescription			NVARCHAR(100)	=	NULL,
  @pNotEqulAssetDescription			NVARCHAR(100)	=	NULL,

  @pContainsAssetTypeCode			NVARCHAR(100)	=	NULL,
  @pBeginWithAssetTypeCode			NVARCHAR(100)	=	NULL,
  @pEqualAssetTypeCode				NVARCHAR(100)	=	NULL,
  @pNotEqulAssetTypeCode			NVARCHAR(100)	=	NULL,


  @pContainsManufacturer			NVARCHAR(100)	=	NULL,
  @pBeginWithManufacturer			NVARCHAR(100)	=	NULL,
  @pEqualManufacturer				NVARCHAR(100)	=	NULL,
  @pNotEqulManufacturer				NVARCHAR(100)	=	NULL,
  
  
  @pContainsModel					NVARCHAR(100)	=	NULL,
  @pBeginWithModel					NVARCHAR(100)	=	NULL,
  @pEqualModel						NVARCHAR(100)	=	NULL,
  @pNotEqulModel					NVARCHAR(100)	=	NULL,
    

  
  @pPageIndex			INT,
  @pPageSize			INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId
		WHERE		Asset.Active =1
					AND ((ISNULL(@pContainsAssetNo,'')='' )		OR (ISNULL(@pContainsAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pContainsAssetNo + '%'))
					AND ((ISNULL(@pBeginWithAssetNo,'')='' )		OR (ISNULL(@pBeginWithAssetNo,'') <> '' AND Asset.AssetNo LIKE '' + @pBeginWithAssetNo + '%'))
					AND ((ISNULL(@pEqualAssetNo,'')='' )		OR (ISNULL(@pEqualAssetNo,'') <> '' AND Asset.AssetNo = '' + @pEqualAssetNo + ''))
					AND ((ISNULL(@pNotEqulAssetNo,'')='' )		OR (ISNULL(@pNotEqulAssetNo,'') <> '' AND Asset.AssetNo <> '' + @pNotEqulAssetNo + ''))

					AND ((ISNULL(@pContainsUserArea,'')='' )		OR (ISNULL(@pContainsUserArea,'') <> '' AND UserArea.UserAreaName LIKE '%' + @pContainsUserArea + '%'))
					AND ((ISNULL(@pBeginWithUserArea,'')='' )		OR (ISNULL(@pBeginWithUserArea,'') <> '' AND UserArea.UserAreaName LIKE '' + @pBeginWithUserArea + '%'))
					AND ((ISNULL(@pEqualUserArea,'')='' )		OR (ISNULL(@pEqualUserArea,'') <> '' AND UserArea.UserAreaName = '' + @pEqualUserArea + ''))
					AND ((ISNULL(@pNotEqulUserArea,'')='' )		OR (ISNULL(@pNotEqulUserArea,'') <> '' AND UserArea.UserAreaName <> '' + @pNotEqulUserArea + ''))

					AND ((ISNULL(@pContainsUserLocation,'')='' )		OR (ISNULL(@pContainsUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '%' + @pContainsUserLocation + '%'))
					AND ((ISNULL(@pBeginWithUserLocation,'')='' )		OR (ISNULL(@pBeginWithUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '' + @pBeginWithUserLocation + '%'))
					AND ((ISNULL(@pEqualUserLocation,'')='' )		OR (ISNULL(@pEqualUserLocation,'') <> '' AND UserLocation.UserLocationName = '' + @pEqualUserLocation + ''))
					AND ((ISNULL(@pNotEqulUserLocation,'')='' )		OR (ISNULL(@pNotEqulUserLocation,'') <> '' AND UserLocation.UserLocationName <> '' + @pNotEqulUserLocation + ''))

					AND ((ISNULL(@pContainsManufacturer,'')='' )		OR (ISNULL(@pContainsManufacturer,'') <> '' AND Manufacturer.Manufacturer LIKE '%' + @pContainsManufacturer + '%'))
					AND ((ISNULL(@pBeginWithManufacturer,'')='' )		OR (ISNULL(@pBeginWithManufacturer,'') <> '' AND Manufacturer.Manufacturer LIKE '' + @pBeginWithManufacturer + '%'))
					AND ((ISNULL(@pEqualManufacturer,'')='' )		OR (ISNULL(@pEqualManufacturer,'') <> '' AND Manufacturer.Manufacturer = '' + @pEqualManufacturer + ''))
					AND ((ISNULL(@pNotEqulManufacturer,'')='' )		OR (ISNULL(@pNotEqulManufacturer,'') <> '' AND Manufacturer.Manufacturer <> '' + @pNotEqulManufacturer + ''))

					AND ((ISNULL(@pContainsModel,'')='' )		OR (ISNULL(@pContainsModel,'') <> '' AND Model.Model LIKE '%' + @pContainsModel + '%'))
					AND ((ISNULL(@pBeginWithModel,'')='' )		OR (ISNULL(@pBeginWithModel,'') <> '' AND Model.Model LIKE '' + @pBeginWithModel + '%'))
					AND ((ISNULL(@pEqualModel,'')='' )		OR (ISNULL(@pEqualModel,'') <> '' AND Model.Model = '' + @pEqualModel + ''))
					AND ((ISNULL(@pNotEqulModel,'')='' )		OR (ISNULL(@pNotEqulModel,'') <> '' AND Model.Model <> '' + @pNotEqulModel + ''))

					AND ((ISNULL(@pContainsAssetTypeCode,'')='' )		OR (ISNULL(@pContainsAssetTypeCode,'') <> '' AND Asset.AssetNo LIKE '%' + @pContainsAssetTypeCode + '%'))
					AND ((ISNULL(@pBeginWithAssetTypeCode,'')='' )		OR (ISNULL(@pBeginWithAssetTypeCode,'') <> '' AND Asset.AssetNo LIKE '' + @pBeginWithAssetTypeCode + '%'))
					AND ((ISNULL(@pEqualAssetTypeCode,'')='' )		OR (ISNULL(@pEqualAssetTypeCode,'') <> '' AND Asset.AssetNo = '' + @pEqualAssetTypeCode + ''))
					AND ((ISNULL(@pNotEqulAssetTypeCode,'')='' )		OR (ISNULL(@pNotEqulAssetTypeCode,'') <> '' AND Asset.AssetNo <> '' + @pNotEqulAssetTypeCode + ''))

					AND ((ISNULL(@pContainsAssetDescription,'')='' )		OR (ISNULL(@pContainsAssetDescription,'') <> '' AND Asset.AssetDescription LIKE '%' + @pContainsAssetDescription + '%'))
					AND ((ISNULL(@pBeginWithAssetDescription,'')='' )		OR (ISNULL(@pBeginWithAssetDescription,'') <> '' AND Asset.AssetDescription LIKE '' + @pBeginWithAssetDescription + '%'))
					AND ((ISNULL(@pEqualAssetDescription,'')='' )		OR (ISNULL(@pEqualAssetDescription,'') <> '' AND Asset.AssetDescription = '' + @pEqualAssetDescription + ''))
					AND ((ISNULL(@pNotEqulAssetDescription,'')='' )		OR (ISNULL(@pNotEqulAssetDescription,'') <> '' AND Asset.AssetDescription <> '' + @pNotEqulAssetDescription + ''))
	

		SELECT		Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetDescription,
					AssetClassification.AssetClassificationCode,
					TypeCode.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					Manufacturer.Manufacturer,
					Model.Model,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId
		WHERE		Asset.Active =1
					AND ((ISNULL(@pContainsAssetNo,'')='' )		OR (ISNULL(@pContainsAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pContainsAssetNo + '%'))
					AND ((ISNULL(@pBeginWithAssetNo,'')='' )		OR (ISNULL(@pBeginWithAssetNo,'') <> '' AND Asset.AssetNo LIKE '' + @pBeginWithAssetNo + '%'))
					AND ((ISNULL(@pEqualAssetNo,'')='' )		OR (ISNULL(@pEqualAssetNo,'') <> '' AND Asset.AssetNo = '' + @pEqualAssetNo + ''))
					AND ((ISNULL(@pNotEqulAssetNo,'')='' )		OR (ISNULL(@pNotEqulAssetNo,'') <> '' AND Asset.AssetNo <> '' + @pNotEqulAssetNo + ''))

					AND ((ISNULL(@pContainsUserArea,'')='' )		OR (ISNULL(@pContainsUserArea,'') <> '' AND UserArea.UserAreaName LIKE '%' + @pContainsUserArea + '%'))
					AND ((ISNULL(@pBeginWithUserArea,'')='' )		OR (ISNULL(@pBeginWithUserArea,'') <> '' AND UserArea.UserAreaName LIKE '' + @pBeginWithUserArea + '%'))
					AND ((ISNULL(@pEqualUserArea,'')='' )		OR (ISNULL(@pEqualUserArea,'') <> '' AND UserArea.UserAreaName = '' + @pEqualUserArea + ''))
					AND ((ISNULL(@pNotEqulUserArea,'')='' )		OR (ISNULL(@pNotEqulUserArea,'') <> '' AND UserArea.UserAreaName <> '' + @pNotEqulUserArea + ''))

					AND ((ISNULL(@pContainsUserLocation,'')='' )		OR (ISNULL(@pContainsUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '%' + @pContainsUserLocation + '%'))
					AND ((ISNULL(@pBeginWithUserLocation,'')='' )		OR (ISNULL(@pBeginWithUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '' + @pBeginWithUserLocation + '%'))
					AND ((ISNULL(@pEqualUserLocation,'')='' )		OR (ISNULL(@pEqualUserLocation,'') <> '' AND UserLocation.UserLocationName = '' + @pEqualUserLocation + ''))
					AND ((ISNULL(@pNotEqulUserLocation,'')='' )		OR (ISNULL(@pNotEqulUserLocation,'') <> '' AND UserLocation.UserLocationName <> '' + @pNotEqulUserLocation + ''))

					AND ((ISNULL(@pContainsManufacturer,'')='' )		OR (ISNULL(@pContainsManufacturer,'') <> '' AND Manufacturer.Manufacturer LIKE '%' + @pContainsManufacturer + '%'))
					AND ((ISNULL(@pBeginWithManufacturer,'')='' )		OR (ISNULL(@pBeginWithManufacturer,'') <> '' AND Manufacturer.Manufacturer LIKE '' + @pBeginWithManufacturer + '%'))
					AND ((ISNULL(@pEqualManufacturer,'')='' )		OR (ISNULL(@pEqualManufacturer,'') <> '' AND Manufacturer.Manufacturer = '' + @pEqualManufacturer + ''))
					AND ((ISNULL(@pNotEqulManufacturer,'')='' )		OR (ISNULL(@pNotEqulManufacturer,'') <> '' AND Manufacturer.Manufacturer <> '' + @pNotEqulManufacturer + ''))

					AND ((ISNULL(@pContainsModel,'')='' )		OR (ISNULL(@pContainsModel,'') <> '' AND Model.Model LIKE '%' + @pContainsModel + '%'))
					AND ((ISNULL(@pBeginWithModel,'')='' )		OR (ISNULL(@pBeginWithModel,'') <> '' AND Model.Model LIKE '' + @pBeginWithModel + '%'))
					AND ((ISNULL(@pEqualModel,'')='' )		OR (ISNULL(@pEqualModel,'') <> '' AND Model.Model = '' + @pEqualModel + ''))
					AND ((ISNULL(@pNotEqulModel,'')='' )		OR (ISNULL(@pNotEqulModel,'') <> '' AND Model.Model <> '' + @pNotEqulModel + ''))

					AND ((ISNULL(@pContainsAssetTypeCode,'')='' )		OR (ISNULL(@pContainsAssetTypeCode,'') <> '' AND Asset.AssetNo LIKE '%' + @pContainsAssetTypeCode + '%'))
					AND ((ISNULL(@pBeginWithAssetTypeCode,'')='' )		OR (ISNULL(@pBeginWithAssetTypeCode,'') <> '' AND Asset.AssetNo LIKE '' + @pBeginWithAssetTypeCode + '%'))
					AND ((ISNULL(@pEqualAssetTypeCode,'')='' )		OR (ISNULL(@pEqualAssetTypeCode,'') <> '' AND Asset.AssetNo = '' + @pEqualAssetTypeCode + ''))
					AND ((ISNULL(@pNotEqulAssetTypeCode,'')='' )		OR (ISNULL(@pNotEqulAssetTypeCode,'') <> '' AND Asset.AssetNo <> '' + @pNotEqulAssetTypeCode + ''))

					AND ((ISNULL(@pContainsAssetDescription,'')='' )		OR (ISNULL(@pContainsAssetDescription,'') <> '' AND Asset.AssetDescription LIKE '%' + @pContainsAssetDescription + '%'))
					AND ((ISNULL(@pBeginWithAssetDescription,'')='' )		OR (ISNULL(@pBeginWithAssetDescription,'') <> '' AND Asset.AssetDescription LIKE '' + @pBeginWithAssetDescription + '%'))
					AND ((ISNULL(@pEqualAssetDescription,'')='' )		OR (ISNULL(@pEqualAssetDescription,'') <> '' AND Asset.AssetDescription = '' + @pEqualAssetDescription + ''))
					AND ((ISNULL(@pNotEqulAssetDescription,'')='' )		OR (ISNULL(@pNotEqulAssetDescription,'') <> '' AND Asset.AssetDescription <> '' + @pNotEqulAssetDescription + ''))
		ORDER BY	Asset.ModifiedDateUTC DESC
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
