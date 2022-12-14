USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetRegisterEngAssetTypeCode_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetRegisterEngAssetTypeCode_Fetch
Description			: Asset Type Code Fetch popup
Authors				: Balaji M S
Date				: 07-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetRegisterEngAssetTypeCode_Fetch  @pTypeCode=null,@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/ 
CREATE PROCEDURE  [dbo].[uspFM_EngAssetRegisterEngAssetTypeCode_Fetch]                           
  @pTypeCode			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT
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
		FROM		EngAssetTypeCode				AS AssetTypeCode WITH(NOLOCK)
		WHERE		AssetTypeCode.Active =1
					AND ((ISNULL(@pTypeCode,'') = '' )	OR (ISNULL(@pTypeCode,'') <> '' AND (AssetTypeCode LIKE + '%' + @pTypeCode + '%' or AssetTypeDescription LIKE  + '%' + @pTypeCode + '%') ))

		SELECT		AssetTypeCode.AssetTypeCode,
					AssetTypeCode.AssetTypeDescription,										
					@TotalRecords AS TotalRecords
		FROM		EngAssetTypeCode				AS AssetTypeCode WITH(NOLOCK)					
		WHERE		AssetTypeCode.Active =1
					AND ((ISNULL(@pTypeCode,'') = '' )	OR (ISNULL(@pTypeCode,'') <> '' AND (AssetTypeCode LIKE  + '%' + @pTypeCode + '%' or AssetTypeDescription LIKE  + '%' + @pTypeCode + '%') ))
		ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
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
