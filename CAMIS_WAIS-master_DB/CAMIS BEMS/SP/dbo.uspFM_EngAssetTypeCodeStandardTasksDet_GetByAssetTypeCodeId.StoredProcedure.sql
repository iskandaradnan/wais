USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCodeStandardTasksDet_GetByAssetTypeCodeId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCodeStandardTasksDet_GetByAssetTypeCodeId
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetTypeCodeStandardTasksDet_GetByAssetTypeCodeId @pPageIndex=1,@pPageSize=5, @pAssetTypeCodeId=4
EXEC uspFM_EngAssetTypeCodeStandardTasksDet_GetByAssetTypeCodeId  @pAssetTypeCodeId=4

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCodeStandardTasksDet_GetByAssetTypeCodeId]                           
  @pAssetTypeCodeId		INT	=	NULL
  --@pPageIndex			INT	=	NULL,
  --@pPageSize			INT	=	NULL
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution


		SELECT		PPMRegisterMst.PPMId,
					PPMRegisterMst.BemsTaskCode,
					PPMRegisterMst.ModelId,
					Model.Model,
					PPMRegisterMst.PPMChecklistNo,
					PpmHistory.DocumentId,
					PpmHistory.FileName,
					PpmHistory.DocumentTitle,
					PPMRegisterMst.ModifiedDateUTC
		FROM		EngPPMRegisterMst					AS	PPMRegisterMst		WITH(NOLOCK) 
					INNER JOIN EngAssetStandardizationModel			AS	Model				WITH(NOLOCK) ON PPMRegisterMst.ModelId				=	Model.ModelId
					INNER JOIN EngAssetTypeCode  AS	TypeCode WITH(NOLOCK) ON PPMRegisterMst.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
					OUTER APPLY (SELECT	TOP 1 His.DocumentId,FMDoc.FileName,FMDoc.DocumentTitle
					FROM	EngPPMRegisterHistoryMst AS His 
							INNER JOIN FMDocument AS FMDoc ON His.DocumentId=FMDoc.DocumentId
					WHERE PPMId	=	PPMRegisterMst.PPMId 
					ORDER BY His.ModifiedDate DESC) PpmHistory
		WHERE		PPMRegisterMst.Active =1
					AND	PPMRegisterMst.AssetTypeCodeId	= @pAssetTypeCodeId
		ORDER BY	PPMRegisterMst.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 


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
