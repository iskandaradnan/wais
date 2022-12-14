USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Image_GetByAssetId]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAsset_Image_GetByAssetId
Description			: To Get the Attachment fro given Asset
Authors				: Dhilip V
Date				: 21-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAsset_Image_GetByAssetId] @pAssetId=1,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAsset_Image_GetByAssetId]                           
  @pUserId			INT	=	NULL,
  @pAssetId	INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	Asset.AssetId						AS AssetId,
			FMDoc.FilePath						AS FilePath,
			FileType.FileType					AS FileTypeValue,
			FMDoc.DocumentTitle					AS DocumentTitle,
			Asset.AssetNo						AS AssetNo,
			Asset.Image1FMDocumentId			AS Image1FMDocumentId,			
			FMDoc.DocumentExtension, 
			FMDoc.GuId                          AS [GuId]
 	FROM	FMDocument			AS	FMDoc			WITH(NOLOCK)  
			LEFT JOIN	EngAsset			AS	Asset			WITH(NOLOCK)	ON FMDoc.DocumentId			=	Asset.Image1FMDocumentId
			LEFT JOIN	FMDocumentFileType	AS	FileType		WITH(NOLOCK)	ON FMDoc.FileType			=	FileType.FileTypeId
	WHERE	Asset.AssetId = @pAssetId 




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
