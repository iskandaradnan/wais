USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERDocNo_Rejected_Search]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_BERDocNo_Rejected_Search]
Description			: BERDocNo number fetch control
Authors				: Dhilip V
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_BERDocNo_Rejected_Search]  @pBERNo='',@pPageIndex=1,@pPageSize=20,@pBERStage=2,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BERDocNo_Rejected_Search]                           
                            
  @pBERNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pBERStage			INT,
  @pFacilityId			INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution


	IF(@pBERStage=1)
		BEGIN

			SELECT		@TotalRecords	=	COUNT(*)
			FROM		BERApplicationTxn										AS BER				WITH(NOLOCK)
						LEFT JOIN	FMLovMst	AS	LovBERStatus		WITH(NOLOCK) ON	BER.BERStatus				= LovBERStatus.LovId
			WHERE		BER.BERStatus = 210 and BERStage = 1 
						AND	((ISNULL(@pBERNo,'')='' )		OR (ISNULL(@pBERNo,'') <> '' AND BER.BERno LIKE '%' + @pBERNo + '%'))
						AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND BER.FacilityId = @pFacilityId))
						AND not exists (select 1 from BERApplicationTxn br where  br.RejectedBERReferenceId = BER.ApplicationId)
			SELECT		BER.ApplicationId,
						BER.BERno,
						BER.BERStatus	as BERStatusLovId,
						LovBERStatus.FieldValue		BERStatusName,
						@TotalRecords AS TotalRecords
			FROM		BERApplicationTxn										AS BER				WITH(NOLOCK)
						LEFT JOIN	FMLovMst	AS	LovBERStatus		WITH(NOLOCK) ON	BER.BERStatus				= LovBERStatus.LovId
			WHERE		BER.BERStatus = 210  and BERStage = 1 
						AND	((ISNULL(@pBERNo,'')='' )		OR (ISNULL(@pBERNo,'') <> '' AND BER.BERno LIKE '%' + @pBERNo + '%'))
						AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND BER.FacilityId = @pFacilityId))
						AND not exists (select 1 from BERApplicationTxn br where  br.RejectedBERReferenceId = BER.ApplicationId)
			ORDER BY	BER.ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

		END


	IF(@pBERStage=2)
		BEGIN

			SELECT		@TotalRecords	=	COUNT(*)
			FROM		BERApplicationTxn										AS BER				WITH(NOLOCK)
						LEFT JOIN	FMLovMst	AS	LovBERStatus		WITH(NOLOCK) ON	BER.BERStatus				= LovBERStatus.LovId
			WHERE		BER.BERStatus = 206 and BERStage = 1 
						AND	((ISNULL(@pBERNo,'')='' )		OR (ISNULL(@pBERNo,'') <> '' AND BER.BERno LIKE '%' + @pBERNo + '%'))
						AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND BER.FacilityId = @pFacilityId))
	

			SELECT		BER.ApplicationId,
						BER.BERno,
						BER.BERStatus	as BERStatusLovId,
						LovBERStatus.FieldValue		BERStatusName,
						@TotalRecords AS TotalRecords
			FROM		BERApplicationTxn										AS BER				WITH(NOLOCK)
						LEFT JOIN	FMLovMst	AS	LovBERStatus		WITH(NOLOCK) ON	BER.BERStatus				= LovBERStatus.LovId
			WHERE		BER.BERStatus = 206 and BERStage = 1 
						AND	((ISNULL(@pBERNo,'')='' )		OR (ISNULL(@pBERNo,'') <> '' AND BER.BERno LIKE '%' + @pBERNo + '%'))
						AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND BER.FacilityId = @pFacilityId))
			ORDER BY	BER.ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

	IF(@pBERStage=3)
		BEGIN

			SELECT		@TotalRecords	=	COUNT(*)
			FROM		BERApplicationTxn										AS BER				WITH(NOLOCK)
						LEFT JOIN	FMLovMst	AS	LovBERStatus		WITH(NOLOCK) ON	BER.BERStatus				= LovBERStatus.LovId
			WHERE		BER.BERStatus = 210 and BERStage = 2 
						AND	((ISNULL(@pBERNo,'')='' )		OR (ISNULL(@pBERNo,'') <> '' AND BER.BERno LIKE '%' + @pBERNo + '%'))
						AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND BER.FacilityId = @pFacilityId))
	

			SELECT		BER.ApplicationId,
						BER.BERno,
						BER.BERStatus	as BERStatusLovId,
						LovBERStatus.FieldValue		BERStatusName,
						@TotalRecords AS TotalRecords
			FROM		BERApplicationTxn										AS BER				WITH(NOLOCK)
						LEFT JOIN	FMLovMst	AS	LovBERStatus		WITH(NOLOCK) ON	BER.BERStatus				= LovBERStatus.LovId
			WHERE		BER.BERStatus = 210 and BERStage=2 -- reocrds Rejected in ber2 screen
						AND	((ISNULL(@pBERNo,'')='' )		OR (ISNULL(@pBERNo,'') <> '' AND BER.BERno LIKE '%' + @pBERNo + '%'))
						AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND BER.FacilityId = @pFacilityId))
			ORDER BY	BER.ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END


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
