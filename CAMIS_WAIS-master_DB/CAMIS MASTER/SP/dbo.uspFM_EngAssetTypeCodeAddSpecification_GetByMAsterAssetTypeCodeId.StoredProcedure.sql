USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCodeAddSpecification_GetByMAsterAssetTypeCodeId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCodeAddSpecification_MasterGetByAssetTypeCodeId
Description			: To Get the Master_AssetTypeCode using the AssetTypeCodeId
Authors				:  V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetTypeCodeAddSpecification_GetByMAsterAssetTypeCodeId]  @pAssetTypeCodeId=82

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCodeAddSpecification_GetByMAsterAssetTypeCodeId]                           

  @pAssetTypeCodeId				INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pAssetTypeCodeId,0) = 0) RETURN

	
		SELECT
				TypeCode.AssetClassification_mappingTo_SeviceDB
		FROM	[EngAssetClassification]										AS TypeCode			WITH(NOLOCK)
				
		WHERE	TypeCode.AssetClassificationId  = @pAssetTypeCodeId 
		

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
