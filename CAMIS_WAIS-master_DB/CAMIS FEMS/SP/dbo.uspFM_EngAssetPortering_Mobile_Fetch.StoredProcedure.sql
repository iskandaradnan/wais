USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPortering_Mobile_Fetch]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAsset_Fetch]
Description			: Asset number fetch control
Authors				: Karthick R
Date				: 13-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetPortering_Fetch]  @pAssetNo='PAN101',@pPageIndex=1,@pPageSize=20
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPortering_Mobile_Fetch]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT

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
		LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId			AND BOOK.BookingEnd >= GETDATE()			
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					INNER JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId
					INNER JOIN	MstLocationBlock					AS LocationBlock		WITH(NOLOCK) ON	UserArea.BlockId				= LocationBlock.BlockId
					INNER JOIN	MstLocationLevel					AS LocationLevel		WITH(NOLOCK) ON	UserArea.LevelId				= LocationLevel.LevelId

		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

		SELECT		Asset.AssetId,
					Asset.AssetNo,					
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
		LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId	AND BOOK.BookingEnd >= GETDATE()				
					INNER JOIN	MstLocationFacility					AS LocationFacility 	WITH(NOLOCK) ON Asset.FacilityId				= LocationFacility.FacilityId
					INNER JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK) ON	UserLocation.UserAreaId			= UserArea.UserAreaId
					INNER JOIN	MstLocationBlock					AS LocationBlock		WITH(NOLOCK) ON	UserArea.BlockId				= LocationBlock.BlockId
					INNER JOIN	MstLocationLevel					AS LocationLevel		WITH(NOLOCK) ON	UserArea.LevelId				= LocationLevel.LevelId

		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
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
