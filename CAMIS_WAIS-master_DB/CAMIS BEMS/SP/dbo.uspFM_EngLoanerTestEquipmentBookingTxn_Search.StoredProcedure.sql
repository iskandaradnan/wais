USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Search]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_PorteringAsset_Search]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 30-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_PorteringAsset_Search]  @pAssetNo='PAN101',@pPageIndex=1,@pPageSize=20,@pFacilityId=NULL
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Search]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT NULL

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
		FROM		EngLoanerTestEquipmentBookingTxn				AS  LoanerTestEquipmentBooking  WITH(NOLOCK) 
					INNER  JOIN  EngAsset							AS  Asset						WITH(NOLOCK) ON LoanerTestEquipmentBooking.AssetId = Asset.AssetId
					--INNER JOIN	EngAssetClassification				AS  AssetClassification 		WITH(NOLOCK) ON Asset.AssetClassification	= AssetClassification.AssetClassificationId
					--INNER JOIN	MstLocationUserLocation				AS	UserLocation				WITH(NOLOCK) ON	Asset.UserLocationId		= UserLocation.UserLocationId
					--INNER JOIN	MstLocationUserArea					AS	UserArea					WITH(NOLOCK) ON	Asset.UserAreaId			= UserArea.UserAreaId
					--INNER JOIN	MstLocationLevel					AS	Level						WITH(NOLOCK) ON	UserArea.LevelId			= Level.LevelId
					--INNER JOIN	MstLocationBlock					AS	Block						WITH(NOLOCK) ON	Level.BlockId				=	Block.BlockId
					--INNER JOIN	MstLocationFacility					AS	Facility					WITH(NOLOCK) ON	Block.FacilityId			=	Facility.FacilityId					
					LEFT  JOIN  MstLocationFacility					AS  BookingFacility				WITH(NOLOCK) ON LoanerTestEquipmentBooking.FacilityId = BookingFacility.FacilityId
		WHERE		Asset.Active =1
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

	

		SELECT		Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetDescription,
					Asset.FacilityId,
					--Facility.FacilityName,
					--Block.BlockId,
					--Block.BlockName,
					--Level.LevelId,
					--Level.LevelName,
					--UserArea.UserAreaId,
					--UserArea.UserAreaName,
					--UserLocation.UserLocationId,
					--UserLocation.UserLocationName,
					LoanerTestEquipmentBooking.BookingStartFrom,
					LoanerTestEquipmentBooking.BookingEnd,
					BookingFacility.FacilityName AS FacilityName,
					@TotalRecords AS TotalRecords
		FROM		EngAsset							AS  Asset
				 
					INNER  JOIN  	EngLoanerTestEquipmentBookingTxn				AS  LoanerTestEquipmentBooking  WITH(NOLOCK) ON LoanerTestEquipmentBooking.AssetId = Asset.AssetId
					--INNER JOIN	EngAssetClassification				AS  AssetClassification 		WITH(NOLOCK) ON Asset.AssetClassification	= AssetClassification.AssetClassificationId
					--INNER JOIN	MstLocationUserLocation				AS	UserLocation				WITH(NOLOCK) ON	Asset.UserLocationId		= UserLocation.UserLocationId
					--INNER JOIN	MstLocationUserArea					AS	UserArea					WITH(NOLOCK) ON	Asset.UserAreaId			= UserArea.UserAreaId
					--INNER JOIN	MstLocationLevel					AS	Level						WITH(NOLOCK) ON	UserArea.LevelId			= Level.LevelId
					--INNER JOIN	MstLocationBlock					AS	Block						WITH(NOLOCK) ON	Level.BlockId				=	Block.BlockId
					--INNER JOIN	MstLocationFacility					AS	Facility					WITH(NOLOCK) ON	Block.FacilityId			=	Facility.FacilityId					
					LEFT  JOIN  MstLocationFacility					AS  BookingFacility				WITH(NOLOCK) ON LoanerTestEquipmentBooking.FacilityId = BookingFacility.FacilityId
		WHERE		Asset.Active =1
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
