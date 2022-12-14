USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAssetClassification_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngAssetTypeCodeStandardTasks_GetById
Description			: To Get the data from table EngAssetTypeCodeStandardTasks using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngAssetClassification_GetById]  @pUserId='',@pAssetClassificationId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngAssetClassification_GetById]                           
  @pUserId		 INT,
  @pAssetClassificationId   INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pAssetClassificationId,0) = 0) RETURN

    SELECT	AssetClassification.AssetClassificationId			AS AssetClassificationId,
			AssetClassification.ServiceId						AS ServiceId,
			AssetService.ServiceKey								AS ServiceKey,
			AssetClassification.AssetClassificationCode			AS AssetClassificationCode,
			AssetClassification.AssetClassificationDescription  AS AssetClassificationDescription,
   CASE
   WHEN		AssetClassification.Active=0 THEN	'InActive'
   WHEN		AssetClassification.Active=1 THEN	'Active'
   END															as Active,													 

			AssetClassification.Remarks
	FROM	EngAssetClassification								AS AssetClassification WITH(NOLOCK)
			INNER JOIN  MstService								AS AssetService		   WITH(NOLOCK)			on AssetClassification.ServiceId	= AssetService.ServiceId
	WHERE	AssetClassification.AssetClassificationId = @pAssetClassificationId 
	ORDER BY AssetClassification.ModifiedDate ASC
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
