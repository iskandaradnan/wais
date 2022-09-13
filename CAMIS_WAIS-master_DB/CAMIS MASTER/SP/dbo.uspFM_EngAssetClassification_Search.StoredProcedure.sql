USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetClassification_Search]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetClassification_Search
Description			: Model search popup
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetClassification_Search  @pPageIndex=1,@pPageSize=5,@pAssetClassificationCode='L'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetClassification_Search]                           
  @pAssetClassificationCode		       NVARCHAR(100)	=	NULL,
  @pAssetClassificationDescription     NVARCHAR(200)	=	NULL,
  @pPageIndex					       INT,
  @pPageSize						int,
  @pServicesID				       INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAssetClassification						AS AssetClassification WITH(NOLOCK)
		WHERE		AssetClassification.Active =1
					AND ((ISNULL(@pAssetClassificationCode,'')='' )	OR ( ISNULL(@pAssetClassificationCode,'') <> ''  AND AssetClassificationCode LIKE '%' + @pAssetClassificationCode + '%'))
					AND ((ISNULL(@pAssetClassificationDescription,'')='' )	OR ( ISNULL(@pAssetClassificationDescription,'') <> ''  AND AssetClassificationDescription LIKE '%' + @pAssetClassificationDescription + '%'))
		SELECT		AssetClassification.AssetClassificationId,
					AssetClassification.AssetClassificationCode,
					AssetClassification.AssetClassificationDescription,
					@TotalRecords AS TotalRecords
		FROM		EngAssetClassification						AS AssetClassification WITH(NOLOCK)
					INNER JOIN MstService WITH(NOLOCK)	ON	AssetClassification.ServiceId	=	MstService.ServiceId
		WHERE		AssetClassification.Active =1 and MstService.ServiceId=@pServicesID
					AND ((ISNULL(@pAssetClassificationCode,'')='' )	OR ( ISNULL(@pAssetClassificationCode,'') <> ''  AND AssetClassificationCode LIKE '%' + @pAssetClassificationCode + '%'))
					AND ((ISNULL(@pAssetClassificationDescription,'')='' )	OR ( ISNULL(@pAssetClassificationDescription,'') <> ''  AND AssetClassificationDescription LIKE '%' + @pAssetClassificationDescription + '%'))
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
