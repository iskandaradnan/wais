USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DedGenerationTxn_AdjustmentSave]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_DedGenerationTxn_AdjustmentSave] (
	@pYear INT,
	@pMonth INT,
	@pServiceId INT,
	@pFacilityId INT,
	@pRemarks nvarchar(1000) = NULL,
	@pUserId  INT

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
EXEC [uspFM_DedGenerationTxn_AdjustmentSave] @pYear=2018,@pMonth=5, @pServiceId=2,@pFacilityId=2,@pUserId=2

SELECT * FROM DedGenerationTxn
SELECT * FROM DedGenerationTxnDet
SELECT * FROM DeductionTransactionMappingMst
SELECT * FROM DeductionTransactionMappingMstDET

SELECT * FROM DedGenerationTxn

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


	DECLARE @Bemsmsf numeric(24,2)
	DECLARE @pCustomerId int
	DECLARE @pDocumentNo nvarchar(100)

	IF NOT EXISTS(SELECT 1 FROM DedGenerationTxn WHERE FacilityId = @pFacilityId AND ServiceId = @pServiceId AND Month = @pMonth AND Year = @pYear)
	BEGIN

	SELECT 'Deduction Not Generated for Year,Month and Service.' AS ErrorMessage,
	'' AS DocumentNo

	END

	IF EXISTS(SELECT 1 FROM DedGenerationTxn WHERE FacilityId = @pFacilityId AND ServiceId = @pServiceId AND Month = @pMonth AND Year = @pYear AND DeductionStatus = 'A' AND DocumentNo IS NOT NULL)
	BEGIN

	SELECT 'Adjustment Already Completed' AS ErrorMessage,
	'' AS DocumentNo

	END


	ELSE

	BEGIN
	--CREATE TABLE #DeductionAdjustment(IndicatorDetId int,IndicatorNo nvarchar(50),IndicatorName nvarchar(100),TotalDemeritPoints int,
	--DeductionValue numeric(24,2),DeductionPer numeric(24,2),PostDemeritPoints INT,PostDeductionValue numeric(24,2),PostDeductionPer numeric(24,2))


	--INSERT INTO #DeductionAdjustment(IndicatorDetId,IndicatorNo,IndicatorName,TotalDemeritPoints,DeductionValue,DeductionPer,PostDemeritPoints,PostDeductionValue,PostDeductionPer)

	--SELECT B.IndicatorDetId,c.IndicatorNo,c.IndicatorName,B.TransactionDemeritPoint,B.DeductionValue,B.DeductionPercentage,0,0,0 FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	--INNER JOIN MstDedIndicatorDet C ON C.IndicatorDetId = B.IndicatorDetId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear


	--SELECT * FROM #DeductionAdjustment
----B.1
	UPDATE B SET B.PostTransactionDemeritPoint = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=1 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear 


	UPDATE B SET B.PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1 AND B.FinalDemeritPoint>0) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=1 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.2
	UPDATE B SET B.PostTransactionDemeritPoint = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=2 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear 


	UPDATE B SET B.PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2 AND B.FinalDemeritPoint>0) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=2 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.3
	UPDATE B SET B.PostTransactionDemeritPoint = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=3 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear 


	UPDATE B SET B.PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3 AND B.FinalDemeritPoint>0) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=3 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.4
	UPDATE B SET B.PostTransactionDemeritPoint = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=4 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear 


	UPDATE B SET B.PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4 AND B.FinalDemeritPoint>0) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=4 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.5
	UPDATE B SET B.PostTransactionDemeritPoint = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=5 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear 


	UPDATE B SET B.PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5 AND B.FinalDemeritPoint>0) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=5 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.6
	UPDATE B SET B.PostTransactionDemeritPoint = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=6 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear 


	UPDATE B SET B.PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6 AND B.FinalDemeritPoint>0) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=6 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

	SET @pCustomerId = (SELECT CustomerId FROM MstLocationFacility WHERE FacilityId = @pFacilityId)
	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)
----B.1
	UPDATE B SET B.PostDeductionPercentage = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=1 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.2
	UPDATE B SET B.PostDeductionPercentage = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=2 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.3
	UPDATE B SET B.PostDeductionPercentage = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=3 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

----B.4
	UPDATE B SET B.PostDeductionPercentage = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=4 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear
----B.5
	UPDATE B SET B.PostDeductionPercentage = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=5 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear
----B.6
	UPDATE B SET B.PostDeductionPercentage = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6) FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE IndicatorDetId=6 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

	DECLARE @OutParam NVARCHAR(50)
	EXEC [uspFM_GenerateDocumentNumber] @pFlag='DedGenerationTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='DED',@pModuleName=NULL,@pService=NULL,@pMonth=@pMonth,@pYear=@pYear,@pOutParam=@OutParam output
	SELECT @pDocumentNo=@OutParam


	UPDATE A SET A.DeductionStatus = 'A',A.DocumentNo = @pDocumentNo,A.ModifiedBy=@pUserId,A.ModifiedDate=GETDATE(),A.ModifiedDateUTC=GETDATE(),A.Remarks =@pRemarks
	FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE B.IndicatorDetId=1 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear

	UPDATE DeductionTransactionMappingMst SET IsAdjustmentSaved =1 WHERE FacilityId = @pFacilityId AND ServiceId = @pServiceId AND Month = @pMonth AND Year = @pYear

	SELECT '' AS ErrorMessage,@pDocumentNo AS DocumentNo  FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	WHERE B.IndicatorDetId=1 AND A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear
	

--SELECT * FROM #DeductionAdjustment

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
