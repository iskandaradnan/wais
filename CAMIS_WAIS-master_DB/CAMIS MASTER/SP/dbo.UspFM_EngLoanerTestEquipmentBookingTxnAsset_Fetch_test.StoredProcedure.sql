USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLoanerTestEquipmentBookingTxnAsset_Fetch_test]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_PorteringAsset_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 24-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngLoanerTestEquipmentBookingTxnAsset_Fetch]  @pAssetNo='',@pPageIndex=1,@pPageSize=500
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngLoanerTestEquipmentBookingTxnAsset_Fetch_test]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT
  --@pFacilityId			INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution

	--Checking assets in ppm

		SELECT DISTINCT AssetId INTO #TempPPMAsset FROM EngMaintenanceWorkOrderTxn 
		WHERE MaintenanceWorkCategory=187 AND TypeOfWorkOrder=34
		AND TargetDateTime >= DBO.udf_GetMalaysiaDateTime(GETDATE()) AND WorkOrderStatus NOT IN (192,193)

		SELECT ASSETID INTO #AssetIdFilter FROM
		(SELECT ASSETID FROM EngAsset WHERE Active =1 and IsLoaner=1
		EXCEPT
		SELECT DISTINCT AssetId  FROM EngMaintenanceWorkOrderTxn WHERE TypeOfWorkOrder = 34)Z

		--SELECT		@TotalRecords	=	COUNT(*)
		--FROM		EngAsset										AS Asset		WITH(NOLOCK)
		--		    INNER JOIN  EngAssetTypeCode					AS typecode     WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
		--		    LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book			WITH(NOLOCK) ON	Asset.AssetId		=  	book.AssetId					
		--			LEFT JOIN   #TempPPMAsset						AS PPMAsset		WITH(NOLOCK) ON	Asset.AssetId		=  	PPMAsset.AssetId					
		--			INNER JOIN	MstLocationFacility					AS	Facility	WITH(NOLOCK) ON	Asset.FacilityId	=	Facility.FacilityId					
		--WHERE		Asset.Active =1 and IsLoaner=1
		--			AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
		--			--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

					SELECT AssetId,AssetNo,AssetTypeCodeId,AssetTypeCode,AssetDescription,FacilityId,TypeOfAsset
					--,FacilityName,BookingStartFrom,BookingEnd
					,ModifiedDateUTC
					,Active,IsLoaner 
					into  #ResultSet FROM 

				   (SELECT	 distinct   Asset.AssetId,

	   				Asset.AssetNo,
					typecode.AssetTypeDescription,
					Asset.AssetTypeCodeId,
					typecode.AssetTypeCode,
					Asset.AssetDescription,
					Asset.FacilityId ,
					Asset.TypeOfAsset,
					Facility.FacilityName,
					Book.BookingStartFrom,
					--DATEDIFF(D,Book.BookingStartFrom, book.BookingEnd ) As DaysCount,
					book.BookingEnd,
					Asset.ModifiedDateUTC,
					Asset.Active,
					Asset.IsLoaner
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
		           INNER JOIN  EngAssetTypeCode					AS typecode             WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
				    LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId					
					--left JOIN   #TempPPMAsset						AS PPMAsset				WITH(NOLOCK) ON	Asset.AssetId				=  	PPMAsset.AssetId
					INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Asset.FacilityId			=	Facility.FacilityId					
		WHERE		Asset.Active =1 and IsLoaner=1 and Asset.AssetId  in (SELECT DISTINCT AssetId  FROM #AssetIdFilter )


		union 

			   SELECT	distinct    Asset.AssetId,

	   				Asset.AssetNo,
					typecode.AssetTypeDescription,
					Asset.AssetTypeCodeId,
					typecode.AssetTypeCode,
					Asset.AssetDescription,
					Asset.FacilityId ,
					Asset.TypeOfAsset,
					Facility.FacilityName,
					Book.BookingStartFrom,
					--DATEDIFF(D,Book.BookingStartFrom, book.BookingEnd ) As DaysCount,
					book.BookingEnd,
					Asset.ModifiedDateUTC,
					Asset.Active,
					Asset.IsLoaner
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
		           INNER JOIN  EngAssetTypeCode					AS typecode             WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
				    LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId					
					--left JOIN   #TempPPMAsset						AS PPMAsset				WITH(NOLOCK) ON	Asset.AssetId				=  	PPMAsset.AssetId
					INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Asset.FacilityId			=	Facility.FacilityId					
		WHERE		Asset.Active =1 and IsLoaner=1 and Asset.AssetId  in (SELECT DISTINCT AssetId  FROM #TempPPMAsset )) Z



		SELECT		@TotalRecords	=	COUNT(distinct a.AssetId)
		FROM		#ResultSet	A			
		WHERE		A.Active =1 and A.IsLoaner=1
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND A.AssetNo LIKE '%' + @pAssetNo + '%'))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

		 SELECT	    Asset.AssetId,
					Asset.AssetNo,
					typecode.AssetTypeDescription,
					typecode.AssetTypeCode,
					Asset.AssetDescription,
					Asset.FacilityId ,
					Asset.TypeOfAsset,
					'' as FacilityName,
					'' as BookingStartFrom,
					--'' as DaysCount,
					'' as BookingEnd,
					--Facility.FacilityName,
					--Book.BookingStartFrom,
					----DATEDIFF(D,Book.BookingStartFrom, book.BookingEnd ) As DaysCount,
					--book.BookingEnd,
							
					@TotalRecords AS TotalRecords
		FROM		#ResultSet										AS Asset				WITH(NOLOCK)
		           INNER JOIN  EngAssetTypeCode						AS typecode             WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
				    LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId					
					LEFT JOIN   #TempPPMAsset						AS PPMAsset				WITH(NOLOCK) ON	Asset.AssetId				=  	PPMAsset.AssetId
					INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Asset.FacilityId			=	Facility.FacilityId					
		WHERE		Asset.Active =1 and IsLoaner=1
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
				    --AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
		group by Asset.AssetId,
					Asset.AssetNo,
					typecode.AssetTypeDescription,
					typecode.AssetTypeCode,
					Asset.AssetDescription,
					Asset.FacilityId ,
					Asset.TypeOfAsset,
					Asset.ModifiedDateUTC 
		ORDER BY	Asset.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

	 --  SELECT	    Asset.AssetId,
		--			Asset.AssetNo,
		--			typecode.AssetTypeDescription,
		--			typecode.AssetTypeCode,
		--			Asset.AssetDescription,
		--			Asset.FacilityId ,
		--			Asset.TypeOfAsset,
		--			Facility.FacilityName,
		--			Book.BookingStartFrom,
		--			--DATEDIFF(D,Book.BookingStartFrom, book.BookingEnd ) As DaysCount,
		--			book.BookingEnd,
							
		--			@TotalRecords AS TotalRecords
		--FROM		EngAsset										AS Asset				WITH(NOLOCK)
		--            INNER JOIN  EngAssetTypeCode					AS typecode             WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
		--		    LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId					
		--			LEFT JOIN   #TempPPMAsset						AS PPMAsset				WITH(NOLOCK) ON	Asset.AssetId				= 	PPMAsset.AssetId
		--			INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Asset.FacilityId			=	Facility.FacilityId					
		--WHERE		Asset.Active =1 and IsLoaner=1
		--			AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
		--		    --AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
		--ORDER BY	Asset.ModifiedDateUTC DESC



		----SELECT		Asset.AssetId,
		----			Asset.AssetNo,
		----			Asset.AssetDescription,
		----			Asset.FacilityId,
		----			Facility.FacilityName,
		----			Block.BlockId,
		----			Block.BlockName,
		----			Level.LevelId,
		----			Level.LevelName,
		----			UserArea.UserAreaId,
		----			UserArea.UserAreaName,
		----			UserLocation.UserLocationId,
		----			UserLocation.UserLocationName,
		----			@TotalRecords AS TotalRecords
		----FROM		EngAsset										AS Asset				WITH(NOLOCK)
		----			INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification	= AssetClassification.AssetClassificationId
		----			INNER JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId		= UserLocation.UserLocationId
		----			INNER JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId			= UserArea.UserAreaId
		----			INNER JOIN	MstLocationLevel					AS	Level				WITH(NOLOCK) ON	UserArea.LevelId			= Level.LevelId
		----			INNER JOIN	MstLocationBlock					AS	Block				WITH(NOLOCK) ON	Level.BlockId				=	Block.BlockId
		----			INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Block.FacilityId			=	Facility.FacilityId					
		----WHERE		Asset.Active =1
		----			AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
		----			AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
		----ORDER BY	Asset.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
