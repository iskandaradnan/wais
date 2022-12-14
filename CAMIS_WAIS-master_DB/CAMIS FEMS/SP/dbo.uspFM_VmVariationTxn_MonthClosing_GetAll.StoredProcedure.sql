USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxn_MonthClosing_GetAll]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxn_MonthClosing_GetAll
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 15-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_VmVariationTxn_MonthClosing_GetAll  @pFacilityId=1,@pYear=2018,@pMonth=4,@pServiceId=2,@pPageIndex=1,@pPageSize=5
,@pFlag=Authorised,@pVariationStatus='V2'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxn_MonthClosing_GetAll] 
		@pFacilityId		INT,                          
		@pYear				INT,
		@pMonth				INT,
		@pServiceId			INT,
		@pPageIndex			INT	=	NULL,
		@pPageSize			INT	=	NULL,
		@pFlag				NVARCHAR(100)	=NULL,
		@pVariationStatus	NVARCHAR(100)	=NULL
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE	@TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)
	DECLARE	@pTotalPageCalc	NUMERIC(24,2)

	CREATE TABLE #VMMonthClosing (	Id INT IDENTITY(1,1),
									VariationStatus NVARCHAR(100),
									Authorised INT,
									UnAuthorised INT,
								)
-- Default Values
	
	INSERT INTO #VMMonthClosing (VariationStatus,Authorised,UnAuthorised)
	SELECT 'V1 - Existing'		,0,0 UNION
	SELECT 'V2 - Addition'		,0,0 UNION
	SELECT 'V3 - Deletion'		,0,0 UNION
	SELECT 'V4 - BER'			,0,0 UNION
	SELECT 'V5 - Transfer From'	,0,0 UNION
	SELECT 'V6 - Transfer To'	,0,0 UNION
	SELECT 'V7 - Upgrade'		,0,0 UNION
	SELECT 'V8 - Donated by others',0,0 
-- Execution
	

IF (ISNULL(@pFlag,'') ='')
	BEGIN

	SELECT Sub.VariationStatus,SUM(Authorised)	AS	Authorised,SUM(UnAuthorised)	AS	UnAuthorised
	INTO #TempRest
	FROM
	(
	SELECT	Variation.VariationStatus	VariationStatusId,
			LovVariationStatus.FieldValue  AS VariationStatus,
			CASE 
				WHEN Variation.AuthorizedStatus=1	THEN 1 ELSE NULL
			END										AS	Authorised,
			CASE
				WHEN Variation.AuthorizedStatus=0	THEN 0 ELSE NULL
			END										AS	UnAuthorised
 	FROM	VmVariationTxn							AS	Variation			WITH(NOLOCK)	
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
			INNER JOIN  FMLovMst					AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
	WHERE	YEAR(Variation.VariationRaisedDate)				=	@pYear 
			AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
			AND Variation.ServiceId							=	@pServiceId
			AND Variation.FacilityId						=	@pFacilityId
	GROUP BY	Variation.VariationStatus,LovVariationStatus.FieldValue,Variation.AuthorizedStatus
	) Sub
	GROUP BY Sub.VariationStatus ORDER BY Sub.VariationStatus
	
	UPDATE A SET	A.Authorised	=	B.Authorised,
					A.UnAuthorised	=	B.UnAuthorised
	 FROM #VMMonthClosing A INNER JOIN #TempRest B ON A.VariationStatus	=	B.VariationStatus


	 SELECT VariationStatus,ISNULL(Authorised,0)	AS	Authorised,ISNULL(UnAuthorised,0)	AS	UnAuthorised FROM #VMMonthClosing

	 END

	ELSE IF(@pFlag = 'Authorised')

	BEGIN

		SELECT	@TotalRecords	=	COUNT(*)
 		FROM	VmVariationTxn								AS	Variation			WITH(NOLOCK)	
				INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
				INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
				INNER JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
				INNER JOIN  FMLovMst						AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
				INNER JOIN  EngTestingandCommissioningTxn	AS	TandC				WITH(NOLOCK)	ON Variation.AssetId			=	TandC.AssetId
		WHERE	YEAR(Variation.VariationRaisedDate)				=	@pYear 
				AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
				AND Variation.ServiceId							=	@pServiceId
				AND Variation.FacilityId						=	@pFacilityId
				AND Variation.AuthorizedStatus					=	1
		SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

		SET @pTotalPageCalc = CEILING(@pTotalPage)

		SELECT	Variation.VariationId,
				Asset.AssetNo,
				Asset.AssetDescription,
				TandC.TandCDocumentNo						AS SNFDocumentNo,
				TandC.TestingandCommissioningId				AS SNFDocumentId,
				Variation.[Timestamp]						AS	[Timestamp],
				@TotalRecords								AS	TotalRecords,
				@pTotalPageCalc								AS	TotalPageCalc
 		FROM	VmVariationTxn								AS	Variation			WITH(NOLOCK)	
				INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
				INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
				INNER JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
				INNER JOIN  FMLovMst						AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
				INNER JOIN  EngTestingandCommissioningTxn	AS	TandC				WITH(NOLOCK)	ON Variation.AssetId			=	TandC.AssetId
		WHERE	YEAR(Variation.VariationRaisedDate)				=	@pYear 
				AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
				AND Variation.ServiceId							=	@pServiceId
				AND Variation.FacilityId						=	@pFacilityId
				AND Variation.AuthorizedStatus					=	1
				AND CASE 
						WHEN  LovVariationStatus.FieldValue	='V1 - Existing' THEN	'V1'
						WHEN  LovVariationStatus.FieldValue	='V2 - Addition' THEN	'V2'
						WHEN  LovVariationStatus.FieldValue	='V3 - Deletion' THEN	'V3'
						WHEN  LovVariationStatus.FieldValue	='V4 - BER' THEN	'V4'
						WHEN  LovVariationStatus.FieldValue	='V5 - Transfer From' THEN	'V5'
						WHEN  LovVariationStatus.FieldValue	='V6 - Transfer To' THEN	'V6'
						WHEN  LovVariationStatus.FieldValue	='V7 - Upgrade' THEN	'V7'
						WHEN  LovVariationStatus.FieldValue	='V8 - Donated by others' THEN	'V8'
					END		=	@pVariationStatus
		ORDER BY Variation.ModifiedDate DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
	END

	ELSE IF(@pFlag = 'UnAuthorised')

	BEGIN

		SELECT	@TotalRecords	=	COUNT(*)
 		FROM	VmVariationTxn								AS	Variation			WITH(NOLOCK)	
				INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
				INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
				INNER JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
				INNER JOIN  FMLovMst						AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
				INNER JOIN  EngTestingandCommissioningTxn	AS	TandC				WITH(NOLOCK)	ON Variation.AssetId			=	TandC.AssetId
		WHERE	YEAR(Variation.VariationRaisedDate)				<=	@pYear 
				AND	 MONTH(Variation.VariationRaisedDate)		<=	@pMonth
				AND Variation.ServiceId							=	@pServiceId
				AND Variation.FacilityId						=	@pFacilityId
				AND Variation.AuthorizedStatus					=	0
		SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

		SET @pTotalPageCalc = CEILING(@pTotalPage)

		SELECT	Variation.VariationId,
				Asset.AssetNo,
				Asset.AssetDescription,
				TandC.TandCDocumentNo						AS SNFDocumentNo,
				TandC.TestingandCommissioningId				AS SNFDocumentId,
				Variation.[Timestamp]						AS	[Timestamp],
				@TotalRecords								AS	TotalRecords,
				@pTotalPageCalc								AS	TotalPageCalc
 		FROM	VmVariationTxn								AS	Variation			WITH(NOLOCK)	
				INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
				INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
				INNER JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
				INNER JOIN  FMLovMst						AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
				INNER JOIN  EngTestingandCommissioningTxn	AS	TandC				WITH(NOLOCK)	ON Variation.AssetId			=	TandC.AssetId
		WHERE	YEAR(Variation.VariationRaisedDate)				<=	@pYear 
				AND	 MONTH(Variation.VariationRaisedDate)		<=	@pMonth
				AND Variation.ServiceId							=	@pServiceId
				AND Variation.FacilityId						=	@pFacilityId
				AND Variation.AuthorizedStatus					=	0
				AND CASE 
						WHEN  LovVariationStatus.FieldValue	='V1 - Existing' THEN	'V1'
						WHEN  LovVariationStatus.FieldValue	='V2 - Addition' THEN	'V2'
						WHEN  LovVariationStatus.FieldValue	='V3 - Deletion' THEN	'V3'
						WHEN  LovVariationStatus.FieldValue	='V4 - BER' THEN	'V4'
						WHEN  LovVariationStatus.FieldValue	='V5 - Transfer From' THEN	'V5'
						WHEN  LovVariationStatus.FieldValue	='V6 - Transfer To' THEN	'V6'
						WHEN  LovVariationStatus.FieldValue	='V7 - Upgrade' THEN	'V7'
						WHEN  LovVariationStatus.FieldValue	='V8 - Donated by others' THEN	'V8'
					END		=	@pVariationStatus
		ORDER BY Variation.ModifiedDate DESC
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
