USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EODAsset_Fetch]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EODAsset_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 13-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EODAsset_Fetch]  @pAssetNo='',@pPageIndex=1,@pPageSize=50,@pFacilityId=1
select * from EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EODAsset_Fetch]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  --@pAssetTypeCodeId	NVARCHAR(100)	=	NULL,
  --@pRecordDate			DATETIME		=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT				=	NULL

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution


		SELECT		@TotalRecords	=	 COUNT(*)
		FROM		EngAsset										AS Asset			WITH(NOLOCK)
					--INNER JOIN	EngEODCategorySystemDet				AS EODSystemDet 	WITH(NOLOCK) ON Asset.AssetTypeCodeId			= EODSystemDet.AssetTypeCodeId					
					INNER JOIN	EngAssetTypeCode					AS TypeCode 		WITH(NOLOCK) ON Asset.AssetTypeCodeId	= TypeCode.AssetTypeCodeId
					INNER JOIN	MstLocationUserArea					AS UserArea 		WITH(NOLOCK) ON Asset.UserAreaId				= UserArea.UserAreaId
					INNER JOIN	MstLocationUserLocation				AS UserLocation		WITH(NOLOCK) ON Asset.UserLocationId			= UserLocation.UserLocationId
					WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					--AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND TypeCode.AssetTypeCodeId =   @pAssetTypeCodeId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId =   @pFacilityId ))
					--AND ((ISNULL(@pRecordDate,'')='' )		OR (ISNULL(@pRecordDate,'') <> '' AND (Asset.ServiceStartDate <= @pRecordDate --AND Asset.ServiceStartDate >= @pRecordDate
					--)  ))


		SELECT		Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetDescription,
					Asset.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					Asset.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					Asset.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset			WITH(NOLOCK)
					--INNER JOIN	EngEODCategorySystemDet				AS EODSystemDet 	WITH(NOLOCK) ON Asset.AssetTypeCodeId			= EODSystemDet.AssetTypeCodeId					
					INNER JOIN	EngAssetTypeCode					AS TypeCode 		WITH(NOLOCK) ON Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					INNER JOIN	MstLocationUserArea					AS UserArea 		WITH(NOLOCK) ON Asset.UserAreaId				= UserArea.UserAreaId
					INNER JOIN	MstLocationUserLocation				AS UserLocation		WITH(NOLOCK) ON Asset.UserLocationId			= UserLocation.UserLocationId
					WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					--AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND TypeCode.AssetTypeCodeId =   @pAssetTypeCodeId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId =   @pFacilityId ))
					--AND ((ISNULL(@pRecordDate,'')='' )		OR (ISNULL(@pRecordDate,'') <> '' AND (Asset.ServiceStartDate <= @pRecordDate --AND Asset.ServiceStartDate >= @pRecordDate
					--)  ))

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
