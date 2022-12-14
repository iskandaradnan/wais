USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetSoftware_GetByAssetId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSoftware_GetByAssetId
Description			: Get the Asset Software details for given asset
Authors				: Dhilip V
Date				: 18-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetSoftware_GetByAssetId  @pAssetId=3
select * from EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetSoftware_GetByAssetId]      
                     
  @pAssetId		INT

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

	IF(ISNULL(@pAssetId,0) = 0) RETURN

    SELECT	Asset.AssetId,
			AssetSW.AssetSoftwareId,
			AssetSW.SoftwareVersion,
			AssetSW.Softwarekey AS SoftwareKey,
			AssetSW.ModifiedDate
 	FROM	EngAsset						AS	Asset		WITH(NOLOCK)	
			INNER JOIN EngAssetSoftware		AS	AssetSW		WITH(NOLOCK)	ON Asset.AssetId	=	AssetSW.AssetId
	WHERE	Asset.AssetId = @pAssetId 

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )

END CATCH
GO
