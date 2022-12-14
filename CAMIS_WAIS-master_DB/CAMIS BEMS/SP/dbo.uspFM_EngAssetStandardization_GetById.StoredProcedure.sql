USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStandardization_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetStandardization_GetById
Description			: To Get the AssetStandardization details using the Primary Key id
Authors				: Dhilip V
Date				: 16-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetStandardization_GetById] @pAssetStandardizationId=9
select * from EngAssetStandardization
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetStandardization_GetById]                           

  @pAssetStandardizationId	INT
AS                                              

BEGIN TRY


	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT	AssetStd.AssetStandardizationId,
			AssetStd.ServiceId,
			Service.ServiceKey				AS	Service,
			AssetStd.AssetTypeCodeId,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			AssetStd.ManufacturerId,
			Manufacturer.Manufacturer,
			AssetStd.ModelId,
			Model.Model,
			AssetStd.Status,
			LovStatus.FieldValue			AS	Status,
			AssetStd.Timestamp
	FROM	EngAssetStandardization							AS	AssetStd		WITH(NOLOCK)
			INNER JOIN EngAssetTypeCode						AS TypeCode			WITH(NOLOCK)	ON	AssetStd.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
			INNER JOIN EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON	AssetStd.ManufacturerId		=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON	AssetStd.ModelId			=	Model.ModelId
			INNER JOIN MstService							AS Service			WITH(NOLOCK)	ON	AssetStd.ServiceId			=	Service.ServiceId
			INNER JOIN FMLovMst								AS LovStatus		WITH(NOLOCK)	ON	AssetStd.Status				=	LovStatus.LovId
	WHERE	AssetStd.AssetStandardizationId	=	@pAssetStandardizationId


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
