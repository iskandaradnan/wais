USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstDedPenalty_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstDedPenalty_GetById
Description			: To Get the data from table MstDedPenalty using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_MstDedPenalty_GetById] @pServiceId=2,@pCriteriaId=1,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_MstDedPenalty_GetById]                           
  @pUserId			INT	=	NULL,
  @pServiceId		INT,
  @pCriteriaId		INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pServiceId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	MstDedPenalty										AS DedPenalty				WITH(NOLOCK)
			INNER JOIN  MstDedPenaltyDet						AS DedPenaltyDet			WITH(NOLOCK)			on DedPenalty.PenaltyId			= DedPenaltyDet.PenaltyId
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			on DedPenaltyDet.ServiceId		= ServiceKey.ServiceId
			INNER JOIN  MstDedCriteria							AS DedCriteria				WITH(NOLOCK)			on DedPenaltyDet.CriteriaId		= DedCriteria.CriteriaId
			INNER JOIN  FMLovMst								AS PenaltyStatus			WITH(NOLOCK)			on DedPenaltyDet.Status			= PenaltyStatus.LovId
	WHERE	DedPenaltyDet.ServiceId = @pServiceId AND DedPenaltyDet.CriteriaId = @pCriteriaId 
	

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	DedPenalty.PenaltyId								AS PenaltyId,
			DedPenaltyDet.PenaltyDetId							AS PenaltyDetId,
			DedPenalty.PenaltyDescription						AS PenaltyDescription,
			DedPenaltyDet.ServiceId								AS ServiceId,
			Servicekey.ServiceKey								AS ServiceKey,
			DedCriteria.CriteriaId								AS CriteriaId,
			DedCriteria.Criteria								AS Criteria,
			DedPenaltyDet.Status								AS Status,
			PenaltyStatus.FieldValue							AS StatusValue,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	MstDedPenalty										AS DedPenalty				WITH(NOLOCK)
			INNER JOIN  MstDedPenaltyDet						AS DedPenaltyDet			WITH(NOLOCK)			on DedPenalty.PenaltyId			= DedPenaltyDet.PenaltyId
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			on DedPenaltyDet.ServiceId		= ServiceKey.ServiceId
			INNER JOIN  MstDedCriteria							AS DedCriteria				WITH(NOLOCK)			on DedPenaltyDet.CriteriaId		= DedCriteria.CriteriaId
			INNER JOIN  FMLovMst								AS PenaltyStatus			WITH(NOLOCK)			on DedPenaltyDet.Status			= PenaltyStatus.LovId
	WHERE	DedPenaltyDet.ServiceId = @pServiceId AND DedPenaltyDet.CriteriaId = @pCriteriaId
	ORDER BY DedPenalty.ModifiedDate ASC
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
