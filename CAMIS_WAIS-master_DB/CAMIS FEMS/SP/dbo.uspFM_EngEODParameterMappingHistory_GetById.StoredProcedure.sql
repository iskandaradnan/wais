USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODParameterMappingHistory_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODParameterMappingHistory_GetById
Description			: To Get the data from table EngEODCategorySystem using the Primary Key id
Authors				: Dhilip V
Date				: 01-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngEODParameterMappingHistory_GetById] @pParameterMappingId=35
select * from EngEODParameterMapping
select * from EngEODParameterMappingdET
SELECT * FROM EngEODCaptureTxnDet
DELETE FROM EngEODCaptureTxnDet WHERE ParameterMappingDetId=19
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODParameterMappingHistory_GetById]                           

  @pParameterMappingId	INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)


--- Header table
    SELECT	EODParameter.ParameterMappingId,
			EODParameter.ServiceId,
			Service.ServiceKey	AS ServiceName,
			EODParameter.AssetClassificationId,
			--CategorySystem.CategorySystemName,
			Classification.AssetClassificationCode,
			Classification.AssetClassificationDescription,
			EODParameter.AssetTypeCodeId,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			EODParameter.ManufacturerId,
			Manufacturer.Manufacturer,
			EODParameter.ModelId,
			Model.Model,
			EODParameter.Timestamp,
			EODParameter.FrequencyLovId,
			LovFrequency.FieldValue			AS	FrequencyValue
	FROM	EngEODParameterMapping								AS EODParameter		WITH(NOLOCK)
			INNER JOIN EngAssetClassification					AS Classification	WITH(NOLOCK)	ON EODParameter.AssetClassificationId	= Classification.AssetClassificationId
			INNER JOIN EngAssetTypeCode							AS TypeCode			WITH(NOLOCK)	ON EODParameter.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
			INNER JOIN MstService								AS Service			WITH(NOLOCK)	ON EODParameter.ServiceId				= Service.ServiceId
			INNER JOIN EngAssetStandardizationManufacturer		AS Manufacturer		WITH(NOLOCK)	ON EODParameter.ManufacturerId			= Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel				AS Model			WITH(NOLOCK)	ON EODParameter.ModelId					= Model.ModelId
			LEFT JOIN FMLovMst									AS LovFrequency		WITH(NOLOCK)	ON EODParameter.FrequencyLovId			= LovFrequency.LovId
	WHERE	EODParameter.ParameterMappingId = @pParameterMappingId
	ORDER BY EODParameter.ModifiedDateUTC DESC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY	


--- Detail Grid



    SELECT	EODParameterDet.ParameterMappingDetId,
			EODParameterDet.ParameterMappingId,
			EODParameterDet.Parameter,
			EODParameterDet.Standard,
			EODParameterDet.UOMId,
			UOM.UnitOfMeasurement,
			EODParameterDet.DataTypeLovId,
			LovDataType.FieldValue			AS	DataType,
			EODParameterDet.DataValue,
			EODParameterDet.Minimum,
			EODParameterDet.Maximum,
			EODParameterDet.FrequencyLovId,
			LovFrequency.FieldValue			AS	FrequencyValue,
			EODParameterDet.EffectiveFrom,
			EODParameterDet.EffectiveTo,
			EODParameterDet.Remarks,
			Ref.IsReferenced,
			EffToCheck.IsEffectiveTo,
			EODParameterDet.StatusId,
			LovStauts.FieldValue								AS Status
	FROM	EngEODParameterMapping								AS EODParameter		WITH(NOLOCK)
			INNER JOIN EngEODParameterMappingDet				AS EODParameterDet	WITH(NOLOCK)	ON EODParameter.ParameterMappingId	= EODParameterDet.ParameterMappingId
			LEFT JOIN FMUOM										AS UOM				WITH(NOLOCK)	ON EODParameterDet.UOMId			= UOM.UOMId
			INNER JOIN FMLovMst									AS LovDataType		WITH(NOLOCK)	ON EODParameterDet.DataTypeLovId	= LovDataType.LovId
			LEFT JOIN FMLovMst									AS LovFrequency		WITH(NOLOCK)	ON EODParameterDet.FrequencyLovId	= LovFrequency.LovId
			LEFT JOIN FMLovMst									AS LovStauts		WITH(NOLOCK)	ON EODParameterDet.StatusId			= LovStauts.LovId
			--INNER JOIN EngEODCategorySystem						AS CategorySystem	WITH(NOLOCK)	ON EODParameter.CategorySystemId	= CategorySystem.CategorySystemId
			--INNER JOIN MstService								AS Service			WITH(NOLOCK)	ON EODParameter.ServiceId			= Service.ServiceId
			--INNER JOIN EngAssetStandardizationManufacturer		AS Manufacturer		WITH(NOLOCK)	ON EODParameter.ManufacturerId		= Manufacturer.ManufacturerId
			--INNER JOIN EngAssetStandardizationModel				AS Model			WITH(NOLOCK)	ON EODParameter.ModelId				= Model.ModelId
			OUTER APPLY
			(	SELECT CASE WHEN COUNT(1)>0 THEN 1 
					ELSE 0 END AS IsReferenced
				FROM	EngEODParameterMapping AS EODPara inner join 
						EngEODParameterMappingDet  AS EODParaDet on EODPara.ParameterMappingId=EODParaDet.ParameterMappingId
						INNER JOIN EngEODCaptureTxnDet  AS EODCaptureDet ON EODParaDet.ParameterMappingDetId=EODCaptureDet.ParameterMappingDetId
						WHERE	EODParaDet.ParameterMappingDetId=EODParameterDet.ParameterMappingDetId
								AND EODPara.AssetClassificationId	=		EODParameter.AssetClassificationId		
			) Ref
			OUTER APPLY
			(	SELECT CASE WHEN EODParaDet1.EffectiveTo	IS NULL THEN 1 
					ELSE 0 END AS IsEffectiveTo
				FROM	EngEODParameterMappingDet  AS EODParaDet1 
				WHERE EODParaDet1.ParameterMappingDetId=EODParameterDet.ParameterMappingDetId
			) EffToCheck

	WHERE	EODParameterDet.ParameterMappingId = @pParameterMappingId
			AND EODParameterDet.StatusId = 2
	ORDER BY EODParameter.ModifiedDateUTC DESC


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
