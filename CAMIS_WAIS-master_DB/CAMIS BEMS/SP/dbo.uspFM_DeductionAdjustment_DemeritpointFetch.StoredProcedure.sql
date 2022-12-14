USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DeductionAdjustment_DemeritpointFetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspFM_DeductionAdjustment_DemeritpointFetch] (
	@pYear INT,
	@pMonth INT,
	@pServiceId INT,
	@pFacilityId INT,
	@pIndicatorNo  NVARCHAR(50),
	@pPageIndex			INT,
	@pPageSize			INT
	)AS

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_DedGenerationTxn]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 08-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_DeductionAdjustment_DemeritpointFetch] @pYear=2018,@pMonth=05, @pServiceId=2,@pFacilityId=2,@pIndicatorNo='B.1',@pPageIndex=1,@pPageSize=5
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================
------------------:------------:-------------------------------------------------------------------
Raguraman J		  : 07/09/2016 : B1 - Responsetime emergency:15 mins / normal:120 mins
								 B2 - Working days greater than 7 days
								 B3 - PPM,SCM & RI
								 B4 - Uptime & Downtime Calculation
								 B5 - From NCR 
-----:------------:------------------------------------------------------------------------------*/


BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE @Bemsmsf numeric(24,2)


	IF NOT EXISTS(SELECT 1 FROM DedGenerationTxn WHERE FacilityId = @pFacilityId AND ServiceId = @pServiceId AND Month = @pMonth AND Year = @pYear)
	BEGIN

	SELECT 'Deduction Not Generated for Year,Month and Service.' AS ErrorMessage

	END

	ELSE IF(@pIndicatorNo='B.1')

	BEGIN

	SELECT		@TotalRecords	=	COUNT(*)
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =1 AND B.FinalDemeritPoint >0
	AND B.DocumentNo IS NOT NULL


	SELECT	B.DocumentNo,
			B.FinalDemeritPoint ,
			@TotalRecords	AS	TotalRecords
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
			INNER JOIN MstDedIndicatorDet C ON A.IndicatorDetId	=	C.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =1 AND B.FinalDemeritPoint >0
			AND C.IndicatorNo	=	@pIndicatorNo AND B.DocumentNo IS NOT NULL
	ORDER BY B.ModifiedDateUTC DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	END

	ELSE IF(@pIndicatorNo='B.2')

	BEGIN

	SELECT		@TotalRecords	=	COUNT(*)
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =2 AND B.FinalDemeritPoint >0
	AND B.DocumentNo IS NOT NULL


	SELECT	B.DocumentNo,
			B.FinalDemeritPoint ,
			@TotalRecords	AS	TotalRecords
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
			INNER JOIN MstDedIndicatorDet C ON A.IndicatorDetId	=	C.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =2 AND B.FinalDemeritPoint >0
			AND C.IndicatorNo	=	@pIndicatorNo AND B.DocumentNo IS NOT NULL
	ORDER BY B.ModifiedDateUTC DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	END

	ELSE IF(@pIndicatorNo='B.3')

	BEGIN

	SELECT		@TotalRecords	=	COUNT(*)
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =3 AND B.FinalDemeritPoint >0
	AND B.DocumentNo IS NOT NULL


	SELECT	B.DocumentNo,
			B.FinalDemeritPoint ,
			@TotalRecords	AS	TotalRecords
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
			INNER JOIN MstDedIndicatorDet C ON A.IndicatorDetId	=	C.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =3 AND B.FinalDemeritPoint >0
			AND C.IndicatorNo	=	@pIndicatorNo AND B.DocumentNo IS NOT NULL
	ORDER BY B.ModifiedDateUTC DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	END

	ELSE IF(@pIndicatorNo='B.4')

	BEGIN

	SELECT		@TotalRecords	=	COUNT(*)
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =4 AND B.FinalDemeritPoint >0
	AND B.DocumentNo IS NOT NULL


	SELECT	B.DocumentNo,
			B.FinalDemeritPoint ,
			@TotalRecords	AS	TotalRecords
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
			INNER JOIN MstDedIndicatorDet C ON A.IndicatorDetId	=	C.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =4 AND B.FinalDemeritPoint >0
			AND C.IndicatorNo	=	@pIndicatorNo AND B.DocumentNo IS NOT NULL
	ORDER BY B.ModifiedDateUTC DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	END

	ELSE IF(@pIndicatorNo='B.5')

	BEGIN

	SELECT		@TotalRecords	=	COUNT(*)
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =5 AND B.FinalDemeritPoint >0
	AND B.DocumentNo IS NOT NULL


	SELECT	B.DocumentNo,
			B.FinalDemeritPoint ,
			@TotalRecords	AS	TotalRecords
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
			INNER JOIN MstDedIndicatorDet C ON A.IndicatorDetId	=	C.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =5 AND B.FinalDemeritPoint >0
			AND C.IndicatorNo	=	@pIndicatorNo AND B.DocumentNo IS NOT NULL
	ORDER BY B.ModifiedDateUTC DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	END

	ELSE IF(@pIndicatorNo='B.6')

	BEGIN

	SELECT		@TotalRecords	=	COUNT(*)
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =6 AND B.FinalDemeritPoint >0
	AND B.DocumentNo IS NOT NULL


	SELECT	B.DocumentNo,
			B.FinalDemeritPoint ,
			@TotalRecords	AS	TotalRecords
	FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B ON A.DedTxnMappingId = B.DedTxnMappingId
			INNER JOIN MstDedIndicatorDet C ON A.IndicatorDetId	=	C.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId =6 AND B.FinalDemeritPoint >0
			AND C.IndicatorNo	=	@pIndicatorNo AND B.DocumentNo IS NOT NULL
	ORDER BY B.ModifiedDateUTC DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	
	END

	ELSE
	BEGIN
	SELECT 'No Record to Display' AS ErrorMessage
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
