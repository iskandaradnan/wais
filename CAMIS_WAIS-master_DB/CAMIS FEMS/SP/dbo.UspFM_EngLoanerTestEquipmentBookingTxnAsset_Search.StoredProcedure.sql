USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLoanerTestEquipmentBookingTxnAsset_Search]    Script Date: 20-09-2021 16:56:53 ******/
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
EXEC [UspFM_EngLoanerTestEquipmentBookingTxnAsset_Search]  @pAssetNo='',@pAssetTypeCode='',@pAssetTypeDescription='',@pPageIndex=1,@pPageSize=20
,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngLoanerTestEquipmentBookingTxnAsset_Search]                           
                            
  @pAssetNo						NVARCHAR(1000)	=	NULL,
  @pAssetTypeCode			    NVARCHAR(1000)	=	NULL,
  @pAssetTypeDescription		NVARCHAR(1000)	=	NULL,
  @pPageIndex					INT,
  @pPageSize					INT
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
			SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN  EngAssetTypeCode					AS typecode             WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
					 LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId					
					INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Asset.FacilityId			=	Facility.FacilityId				
		WHERE		Asset.Active =1 and IsLoaner=1
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCode,'')='' )		 OR (ISNULL(@pAssetTypeCode,'') <> '' AND typecode.AssetTypeCode LIKE '%' + @pAssetTypeCode + '%'))
					AND ((ISNULL(@pAssetTypeDescription,'')='' ) OR (ISNULL(@pAssetTypeDescription,'') <> '' AND typecode.AssetTypeDescription LIKE '%' + @pAssetTypeDescription + '%'))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					and			( book.BookingEnd   is null or cast(book.BookingEnd as date) >= getdate() ) 

		SELECT		Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetDescription,
					Asset.FacilityId ,
					typecode.AssetTypeDescription,
					typecode.AssetTypeCode,
					Facility.FacilityName,
					Book.BookingStartFrom,
					book.BookingEnd,	
					Asset.TypeOfAsset,	
					DATEDIFF(D,Book.BookingStartFrom, book.BookingEnd ) As DaysCount,
					@TotalRecords AS TotalRecords,
					m.Model,
					ma.Manufacturer,
					Cal.calibrationduedate
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN  EngAssetTypeCode					AS typecode             WITH(NOLOCK) ON	Asset.AssetTypeCodeId	    =  	typecode.AssetTypeCodeId	
					LEFT JOIN   EngLoanerTestEquipmentBookingTxn    AS Book				    WITH(NOLOCK) ON	Asset.AssetId			    =  	book.AssetId					
					INNER JOIN	MstLocationFacility					AS	Facility			WITH(NOLOCK) ON	Asset.FacilityId			=	Facility.FacilityId				
					left join EngAssetStandardizationModel			 m on Asset.Model  = m.ModelId
					left join EngAssetStandardizationManufacturer	 ma on Asset.Manufacturer  = ma.ManufacturerId
					outer apply (select top 1 b.calibrationduedate from EngFacilitiesWorkshopTxn a join  EngFacilitiesWorkshopTxnDet  b
						on a.FacilitiesWorkshopId=b.FacilitiesWorkshopId  and a.Category=109 and year(getdate())=a.year
						where b.AssetId  = Asset.AssetId ) Cal

		WHERE		Asset.Active =1 and IsLoaner=1
					AND ((ISNULL(@pAssetNo,'')='' )				 OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCode,'')='' )		 OR (ISNULL(@pAssetTypeCode,'') <> '' AND typecode.AssetTypeCode LIKE '%' + @pAssetTypeCode + '%'))
					AND ((ISNULL(@pAssetTypeDescription,'')='' ) OR (ISNULL(@pAssetTypeDescription,'') <> '' AND typecode.AssetTypeDescription LIKE '%' + @pAssetTypeDescription + '%'))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					and			( book.BookingEnd   is null or cast(book.BookingEnd as date) >= getdate() ) 
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
