USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstDedSubParameter_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstDedSubParameter_GetById
Description			: To Get the data from table MstDedPenalty using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_MstDedSubParameter_GetById] @pServiceId=2,@pIndicatorDetId=5,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_MstDedSubParameter_GetById]                           
  @pUserId			INT	=	NULL,
  @pServiceId		INT,
  @pIndicatorDetId	INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pServiceId,0) = 0) RETURN

	IF(@pIndicatorDetId=6)
		BEGIN
			SELECT	@TotalRecords	=	COUNT(*)
			FROM	MstDedSubParameter									AS SubParameter				WITH(NOLOCK)
					INNER JOIN  MstDedSubParameterDet					AS SubParameterDet			WITH(NOLOCK)			on SubParameter.SubParameterId	= SubParameterDet.SubParameterId
					INNER JOIN  MstDedIndicatorDet						AS DedIndicatorDet			WITH(NOLOCK)			on SubParameter.IndicatorDetId	= DedIndicatorDet.IndicatorDetId
					INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			on SubParameter.ServiceId		= ServiceKey.ServiceId
					INNER JOIN  FMLovMst								AS [Group]					WITH(NOLOCK)			on SubParameter.[Group]			= [Group].LovId
			WHERE	SubParameter.ServiceId = @pServiceId AND SubParameter.IndicatorDetId = @pIndicatorDetId
			

			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

			SET @pTotalPageCalc = CEILING(@pTotalPage)


			SELECT	SubParameter.SubParameterId							AS SubParameterId,
					SubParameter.ServiceId								AS ServiceId,
					ServiceKey.ServiceKey								AS ServiceKey,
					SubParameter.[Group]								AS [Group],
					[Group].FieldValue									AS [GroupName],
					SubParameter.IndicatorDetId							AS IndicatorDetId,
					DedIndicatorDet.IndicatorNo							AS IndicatorNo,
					DedIndicatorDet.IndicatorDesc						AS IndicatorDesc,
					SubParameterDet.SubParameterDetId					AS SubParameterDetId,
					SubParameterDet.SubParameterId						AS SubParameterId,
					SubParameterDet.SubParameter						AS SubParameter,
					SubParameterDet.TotalParameterValue					AS TotalParameterValue,
					@TotalRecords										AS TotalRecords,
					@pTotalPageCalc										AS TotalPageCalc
			FROM	MstDedSubParameter									AS SubParameter				WITH(NOLOCK)
					INNER JOIN  MstDedSubParameterDet					AS SubParameterDet			WITH(NOLOCK)			on SubParameter.SubParameterId	= SubParameterDet.SubParameterId
					INNER JOIN  MstDedIndicatorDet						AS DedIndicatorDet			WITH(NOLOCK)			on SubParameter.IndicatorDetId	= DedIndicatorDet.IndicatorDetId
					INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			on SubParameter.ServiceId		= ServiceKey.ServiceId
					INNER JOIN  FMLovMst								AS [Group]					WITH(NOLOCK)			on SubParameter.[Group]			= [Group].LovId
			WHERE	SubParameter.ServiceId = @pServiceId AND SubParameter.IndicatorDetId = @pIndicatorDetId
			ORDER BY SubParameter.ModifiedDate ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

	ELSE
		BEGIN
			SELECT	@TotalRecords	=	COUNT(*)
			FROM	MstDedIndicatorDet						AS DedIndicatorDet			WITH(NOLOCK)
			WHERE	DedIndicatorDet.IndicatorDetId = @pIndicatorDetId

			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

			SET @pTotalPageCalc = CEILING(@pTotalPage)

			SELECT	'' AS SubParameterId,
			''AS ServiceId,
			''AS ServiceKey,
			''AS [Group],
			''AS [GroupName],
			DedIndicatorDet.IndicatorDetId							AS IndicatorDetId,
			DedIndicatorDet.IndicatorNo							AS IndicatorNo,
			DedIndicatorDet.IndicatorDesc						AS IndicatorDesc,
			''AS SubParameterDetId,
			''AS SubParameterId,
			''AS SubParameter,
			''AS TotalParameterValue,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	MstDedIndicatorDet						AS DedIndicatorDet			WITH(NOLOCK)
	WHERE	DedIndicatorDet.IndicatorDetId = @pIndicatorDetId

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
