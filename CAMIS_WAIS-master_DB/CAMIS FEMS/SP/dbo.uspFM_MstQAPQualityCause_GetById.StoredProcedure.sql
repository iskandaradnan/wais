USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstQAPQualityCause_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstQAPQualityCause_GetById
Description			: To Get the data from table MstQAPQualityCause using the Primary Key id
Authors				: Dhilip V
Date				: 01-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstQAPQualityCause_GetById] @pQualityCauseId=1,@pPageIndex=1,@pPageSize=5
select * from MstQAPQualityCause
select * from MstQAPQualityCauseDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_MstQAPQualityCause_GetById]                           

  @pQualityCauseId		INT,
  @pPageIndex			INT,
  @pPageSize			INT	
AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)

    SELECT	QAPQuality.QualityCauseId,
			QAPQuality.ServiceId,
			Service.ServiceKey			AS ServiceName,
			QAPQuality.CauseCode,
			QAPQuality.Description,
			QAPQuality.Timestamp
	FROM	MstQAPQualityCause			AS QAPQuality		WITH(NOLOCK)
			INNER JOIN MstService		AS Service			WITH(NOLOCK)	ON QAPQuality.ServiceId			= Service.ServiceId
	WHERE	QAPQuality.QualityCauseId = @pQualityCauseId
	ORDER BY QAPQuality.ModifiedDateUTC DESC

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	MstQAPQualityCause								AS QAPQuality		WITH(NOLOCK)
			INNER JOIN MstQAPQualityCauseDet				AS QAPQualityDet	WITH(NOLOCK)	ON QAPQuality.QualityCauseId	= QAPQualityDet.QualityCauseId
			INNER JOIN FMLovMst								AS LovProbCode		WITH(NOLOCK)	ON QAPQualityDet.ProblemCode	= LovProbCode.LovId
			LEFT JOIN FMLovMst								AS LovStatus		WITH(NOLOCK)	ON QAPQualityDet.Status			= LovStatus.LovId
	WHERE	QAPQualityDet.QualityCauseId	=	@pQualityCauseId

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))
	SET @pTotalPage = CEILING(@pTotalPage)


    SELECT	QAPQualityDet.QualityCauseDetId,
			QAPQualityDet.QualityCauseId,
			QAPQualityDet.ProblemCode,
			LovProbCode.FieldValue				AS	ProblemCodeValue,
			QAPQualityDet.QcCode,
			QAPQualityDet.Details,
			QAPQualityDet.Status,
			LovStatus.FieldValue				AS	StatusValue,
			@TotalRecords						AS TotalRecords,
			@pTotalPage							AS TotalPageCalc
	FROM	MstQAPQualityCause					AS QAPQuality		WITH(NOLOCK)
			INNER JOIN MstQAPQualityCauseDet	AS QAPQualityDet	WITH(NOLOCK)	ON QAPQuality.QualityCauseId	= QAPQualityDet.QualityCauseId
			INNER JOIN FMLovMst					AS LovProbCode		WITH(NOLOCK)	ON QAPQualityDet.ProblemCode	= LovProbCode.LovId
			LEFT JOIN FMLovMst					AS LovStatus		WITH(NOLOCK)	ON QAPQualityDet.Status			= LovStatus.LovId
	WHERE	QAPQualityDet.QualityCauseId	=	@pQualityCauseId
	ORDER BY QAPQualityDet.ModifiedDateUTC DESC
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
