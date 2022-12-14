USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetDefectDetails_GetByAssetId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetDefectDetails_GetByAssetId
Description			: Get the Defect details for given assets
Authors				: Dhilip V
Date				: 18-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetDefectDetails_GetByAssetId  @pAssetId=3
select * from EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetDefectDetails_GetByAssetId]      
                     
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
			DefectTxn.DefectId,
			DefectTxn.DefectNo,
			DefectTxn.DefectDate,
			DefectDet.StartDate	,
			DefectDet.CompletionDate,
			DefectDet.ActionTaken,
			Asset.ModifiedDate
 	FROM	EngAsset								AS Asset			WITH(NOLOCK)	
			INNER JOIN EngDefectDetailsTxn	AS	DefectTxn				WITH(NOLOCK)	ON Asset.AssetId					=	DefectTxn.AssetId
			LEFT JOIN EngDefectDetailsTxnDet			AS	DefectDet	WITH(NOLOCK)	ON DefectTxn.DefectId				=	DefectDet.DefectId
			--INNER JOIN FMLovMst						AS	LovRealStatus	WITH(NOLOCK)	ON MWOAssesment.AssetRealtimeStatus	=	LovRealStatus.LovId
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
