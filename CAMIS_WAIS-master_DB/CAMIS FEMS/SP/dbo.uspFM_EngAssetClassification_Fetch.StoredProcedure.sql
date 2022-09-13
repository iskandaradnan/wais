USE [UetrackFemsdbPreProd]
GO

/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetClassification_Fetch]    Script Date: 12-01-2022 16:38:35 ******/
DROP PROCEDURE [dbo].[uspFM_EngAssetClassification_Fetch]
GO

/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetClassification_Fetch]    Script Date: 12-01-2022 16:38:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetClassification_Fetch
Description			: Model search popup
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetClassification_Fetch  @pPageIndex=1,@pPageSize=5,@pAssetClassificationCode='L'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetClassification_Fetch]                           
  @pAssetClassificationCode		NVARCHAR(100)	=	NULL,
  @pPageIndex					INT,
  @pPageSize					INT,
  @pServiceId					INT = NULL
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		SET @pServiceId = 1;
-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAssetClassification						AS AssetClassification WITH(NOLOCK)
		WHERE		AssetClassification.Active =1
					AND ((ISNULL(@pAssetClassificationCode,'')='' )	OR ( ISNULL(@pAssetClassificationCode,'') <> ''  AND ( AssetClassificationCode LIKE '%' + @pAssetClassificationCode + '%' OR  AssetClassificationDescription LIKE '%' + @pAssetClassificationCode + '%' ) ))
					AND ServiceId=@pServiceId

		SELECT		AssetClassification.AssetClassificationId,
					AssetClassification.AssetClassificationCode,
					AssetClassification.AssetClassificationDescription,
					@TotalRecords AS TotalRecords
		FROM		EngAssetClassification						AS AssetClassification WITH(NOLOCK)
					INNER JOIN MstService WITH(NOLOCK)	ON	AssetClassification.ServiceId	=	MstService.ServiceId
		WHERE		AssetClassification.Active =1
					AND ((ISNULL(@pAssetClassificationCode,'')='' )	OR ( ISNULL(@pAssetClassificationCode,'') <> ''  AND ( AssetClassificationCode LIKE '%' + @pAssetClassificationCode + '%' OR  AssetClassificationDescription LIKE '%' + @pAssetClassificationCode + '%' ) ))
					AND AssetClassification.ServiceId=@pServiceId
		ORDER BY	AssetClassification.ModifiedDateUTC DESC
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


