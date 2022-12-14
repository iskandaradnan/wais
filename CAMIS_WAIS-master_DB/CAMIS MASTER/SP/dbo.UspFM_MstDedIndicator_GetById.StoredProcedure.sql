USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstDedIndicator_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstDedIndicator_GetById
Description			: To Get the data from table MstDedIndicator using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_MstDedIndicator_GetById] @pServiceId=2,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_MstDedIndicator_GetById]                           
  @pUserId			INT	=	NULL,
  @pServiceId		INT,
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
	FROM	MstDedIndicator										AS DedIndicator				WITH(NOLOCK)
			INNER JOIN  MstDedIndicatorDet						AS DedIndicatorDet			WITH(NOLOCK)			on DedIndicator.IndicatorId		= DedIndicatorDet.IndicatorId
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			on DedIndicator.ServiceId		= ServiceKey.ServiceId
			INNER JOIN  FMLovMst								AS GroupKey					WITH(NOLOCK)			on DedIndicator.[Group]			= GroupKey.LovId
			INNER JOIN  FMLovMst								AS Frequency				WITH(NOLOCK)			on DedIndicatorDet.Frequency	= Frequency.LovId
	WHERE	DedIndicator.ServiceId = @pServiceId 
	

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	DedIndicator.IndicatorId							AS IndicatorId,
			DedIndicatorDet.IndicatorDetId						AS IndicatorDetId,
			DedIndicator.ServiceId								AS ServiceId,
			Servicekey.ServiceKey								AS ServiceKey,
			DedIndicator.[Group]								AS [Group],
			GroupKey.FieldValue									AS GroupName,
			DedIndicatorDet.IndicatorNo							AS IndicatorNo,
			DedIndicatorDet.IndicatorName						AS IndicatorName,
			DedIndicatorDet.IndicatorDesc						AS IndicatorDesc,
			DedIndicatorDet.Weightage							AS Weightage,
			DedIndicatorDet.Frequency							AS Frequency,
			Frequency.FieldValue								AS FrequencyName,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	MstDedIndicator										AS DedIndicator				WITH(NOLOCK)
			INNER JOIN  MstDedIndicatorDet						AS DedIndicatorDet			WITH(NOLOCK)			on DedIndicator.IndicatorId		= DedIndicatorDet.IndicatorId
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			on DedIndicator.ServiceId		= ServiceKey.ServiceId
			INNER JOIN  FMLovMst								AS GroupKey					WITH(NOLOCK)			on DedIndicator.[Group]			= GroupKey.LovId
			INNER JOIN  FMLovMst								AS Frequency				WITH(NOLOCK)			on DedIndicatorDet.Frequency	= Frequency.LovId
	WHERE	DedIndicator.ServiceId =  @pServiceId 
	ORDER BY DedIndicator.ModifiedDate ASC
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
