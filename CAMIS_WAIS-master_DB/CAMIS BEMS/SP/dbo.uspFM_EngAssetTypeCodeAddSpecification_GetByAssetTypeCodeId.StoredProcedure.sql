USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCodeAddSpecification_GetByAssetTypeCodeId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCodeAddSpecification_GetByAssetTypeCodeId
Description			: To Get the AssetTypeCode using the AssetTypeCodeId
Authors				: Dhilip V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetTypeCodeAddSpecification_GetByAssetTypeCodeId]  @pAssetTypeCodeId=6

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCodeAddSpecification_GetByAssetTypeCodeId]                           

  @pAssetTypeCodeId				INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pAssetTypeCodeId,0) = 0) RETURN

	
		SELECT	AddSpec.AssetTypeCodeAddSpecId,
				AddSpec.AssetTypeCodeId,
				AddSpec.SpecificationType,
				LovSpecType.FieldValue AS SpecificationTypeName,
				AddSpec.SpecificationUnit,
				LovSpecUnit.FieldValue AS SpecificationUnitName,
				AddSpec.ModifiedDateUTC
		FROM	EngAssetTypeCode										AS TypeCode			WITH(NOLOCK)
				INNER JOIN			EngAssetTypeCodeAddSpecification	AS AddSpec			WITH(NOLOCK)		ON TypeCode.AssetTypeCodeId		= AddSpec.AssetTypeCodeId
				LEFT JOIN			FMLovMst							AS LovSpecType		WITH(NOLOCK)		ON AddSpec.SpecificationType	= LovSpecType.LovId
				LEFT JOIN			FMLovMst							AS LovSpecUnit		WITH(NOLOCK)		ON AddSpec.SpecificationUnit	= LovSpecUnit.LovId
		WHERE	TypeCode.AssetTypeCodeId  = @pAssetTypeCodeId 
		ORDER BY TypeCode.ModifiedDate ASC

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
