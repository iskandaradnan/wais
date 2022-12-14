USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStandardization_DuplicateCheck]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetStandardization_DuplicateCheck
Description			: Asset Standardization Duplicate check
Authors				: Dhilip V
Date				: 16-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsDuplicate BIT 
Exec [uspFM_EngAssetStandardization_DuplicateCheck] @pAssetStandardizationId=0, @pAssetTypeCodeId=1,@pManufacturerId=1,@pModelId=1,@IsDuplicate=@IsDuplicate OUT
SELECT @IsDuplicate

SELECT * FROM EngAssetStandardization
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_EngAssetStandardization_DuplicateCheck]

	@pAssetStandardizationId	INT,
	@pAssetTypeCodeId			INT,
	@pManufacturerId			INT,
	@pModelId					INT,
	@IsDuplicate BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	IF (@pAssetStandardizationId = 0)
	SELECT @Cnt = COUNT(1) FROM EngAssetStandardization 
		WHERE	AssetTypeCodeId		= @pAssetTypeCodeId 
				AND ManufacturerId	= @pManufacturerId
				AND ModelId			= @pModelId
	ELSE
	SELECT @Cnt = COUNT(1) FROM EngAssetStandardization 
		WHERE	AssetTypeCodeId		= @pAssetTypeCodeId 
				AND ManufacturerId	= @pManufacturerId
				AND ModelId			= @pModelId
				AND AssetStandardizationId <> @pAssetStandardizationId

	IF (@Cnt = 0) SET @IsDuplicate = 0;
	ELSE SET @IsDuplicate = 1;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
