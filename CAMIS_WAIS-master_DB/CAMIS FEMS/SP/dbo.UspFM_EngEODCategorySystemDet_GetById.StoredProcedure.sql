USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngEODCategorySystemDet_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngEODCategorySystemDet_GetById
Description			: To Get the data from table EngEODCategorySystem using the Primary Key id
Authors				: Dhilip V
Date				: 27-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngEODCategorySystemDet_GetById] @pCategorySystemId=2,@pPageIndex=1,@pPageSize=5
select * from EngEODCategorySystemDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngEODCategorySystemDet_GetById]                           

  @pCategorySystemId	INT,
  @pPageIndex			INT,
  @pPageSize			INT	
AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngEODCategorySystemDet								AS CategorySystemDet	WITH(NOLOCK)
			INNER JOIN EngEODCategorySystem						AS CategorySystem		WITH(NOLOCK)		ON CategorySystem.CategorySystemId		= CategorySystemDet.CategorySystemId
			INNER JOIN MstService								AS ServiceKey			WITH(NOLOCK)		ON CategorySystem.ServiceId				= ServiceKey.ServiceId
			INNER JOIN EngAssetTypeCode							AS TypeCode				WITH(NOLOCK)		ON CategorySystemDet.AssetTypeCodeId	= TypeCode.AssetTypeCodeId
	WHERE	CategorySystemDet.CategorySystemId = @pCategorySystemId	

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)

    SELECT	CategorySystemDet.CategorySystemDetId				AS CategorySystemDetId,
			CategorySystem.CategorySystemId						AS CategorySystemId,
			CategorySystem.ServiceId							AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			CategorySystem.CategorySystemName					AS CategorySystemName,
			CategorySystemDet.AssetTypeCodeId					AS AssetTypeCodeId,
			TypeCode.AssetTypeCode								AS AssetTypeCode,
			TypeCode.AssetTypeDescription						AS AssetTypeDescription,
			CategorySystem.Remarks								AS Remarks,
			CategorySystem.Timestamp,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc,
			(SELECT CASE WHEN COUNT(1)>0 THEN 1 
					ELSE 0 END
			FROM	EngEODCategorySystem AS EODCategory inner join 
					EngEODCategorySystemDet  AS EODCategoryDet on EODCategory.CategorySystemId=EODCategoryDet.CategorySystemId
					INNER JOIN EngEODCaptureTxn  AS EODCapture ON  EODCategoryDet.AssetTypeCodeId  = EODCapture.AssetTypeCodeId
					WHERE EODCategoryDet.CategorySystemId=CategorySystemDet.CategorySystemId AND EODCategoryDet.AssetTypeCodeId = CategorySystemDet.AssetTypeCodeId) IsReferenced
	FROM	EngEODCategorySystemDet								AS CategorySystemDet	WITH(NOLOCK)
			INNER JOIN EngEODCategorySystem						AS CategorySystem		WITH(NOLOCK)		ON CategorySystem.CategorySystemId		= CategorySystemDet.CategorySystemId
			INNER JOIN MstService								AS ServiceKey			WITH(NOLOCK)		ON CategorySystem.ServiceId				= ServiceKey.ServiceId
			INNER JOIN EngAssetTypeCode							AS TypeCode				WITH(NOLOCK)		ON CategorySystemDet.AssetTypeCodeId	= TypeCode.AssetTypeCodeId
	WHERE	CategorySystemDet.CategorySystemId = @pCategorySystemId
	ORDER BY CategorySystemDet.CategorySystemDetId
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
