USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstQAPQualityCause_Search]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstQAPQualityCause_Search]
Description			: Failure Symptom Code fetch control
Authors				: Dhilip V
Date				: 19-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_MstQAPQualityCause_Search]  @pCauseCode='',@pPageIndex=1,@pPageSize=20

SELECT * FROM QAPCarTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstQAPQualityCause_Search]                           
                            
  @pCauseCode				NVARCHAR(100)	=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT


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
		FROM		MstQAPQualityCause					AS	Cause		WITH(NOLOCK)
		WHERE		Active	= 1 
					AND	((ISNULL(@pCauseCode,'')='' )		OR (ISNULL(@pCauseCode,'') <> '' AND Cause.CauseCode LIKE '%' + @pCauseCode + '%'))

		SELECT		QualityCauseId,
					CauseCode	AS [FailureSymptomCode],
					Description,
					@TotalRecords AS TotalRecords
		FROM		MstQAPQualityCause					AS	Cause		WITH(NOLOCK)
		WHERE		Active	= 1 
					AND	((ISNULL(@pCauseCode,'')='' )		OR (ISNULL(@pCauseCode,'') <> '' AND Cause.CauseCode LIKE '%' + @pCauseCode + '%'))
		ORDER BY	Cause.ModifiedDateUTC DESC
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
