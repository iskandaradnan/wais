USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DedGenerationTxn_AdjustmentFetch_Report]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_DedGenerationTxn_AdjustmentFetch_Report] (
	@pYear INT,
	@pMonth INT,
	@pServiceId INT,
	@pFacilityId INT
	--@pErrorMessage		NVARCHAR(1000) OUTPUT

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
EXEC [uspFM_DedGenerationTxn_AdjustmentFetch] @pYear=2018,@pMonth=09, @pServiceId=2,@pFacilityId=1,@pErrorMessage=''
SELECT * FROM DedGenerationTxn
SELECT * FROM DeductionTransactionMappingMst
SELECT * FROM DeductionTransactionMappingMstDET



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
	DECLARE @pErrorMessage nvarchar(500)

	IF NOT EXISTS(SELECT 1 FROM DedGenerationTxn WHERE FacilityId = @pFacilityId AND ServiceId = @pServiceId AND Month = @pMonth AND Year = @pYear)
	BEGIN

	set  @pErrorMessage= 'Deduction Not Generated for Year,Month' 

	END

	ELSE IF NOT EXISTS(SELECT 1 FROM DeductionTransactionMappingMst   WHERE FacilityId = @pFacilityId AND ServiceId = @pServiceId AND Month = @pMonth AND Year = @pYear)
	BEGIN

	set  @pErrorMessage= 'Deduction Transaction Mapping not generated for the selected Year Month' 

	END

	ELSE

	BEGIN
	CREATE TABLE #DeductionAdjustment(IndicatorDetId int,IndicatorNo nvarchar(50),IndicatorName nvarchar(100),TotalDemeritPoints int,
	DeductionValue numeric(24,2),DeductionPer numeric(24,2),PostDemeritPoints INT,PostDeductionValue numeric(24,2),PostDeductionPer numeric(24,2),IsAdjustmentSaved int default(0),DocumentNo NVARCHAR(50),Remarks NVARCHAR(1000))


	INSERT INTO #DeductionAdjustment(IndicatorDetId,IndicatorNo,IndicatorName,TotalDemeritPoints,DeductionValue,DeductionPer,PostDemeritPoints,PostDeductionValue,PostDeductionPer)

	SELECT B.IndicatorDetId,c.IndicatorNo,c.IndicatorName,B.TransactionDemeritPoint,B.DeductionValue,B.DeductionPercentage,0,0,0 FROM DedGenerationTxn A INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	INNER JOIN MstDedIndicatorDet C ON C.IndicatorDetId = B.IndicatorDetId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear




---b.1
	UPDATE  #DeductionAdjustment SET PostDemeritPoints = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1 AND B.DocumentNo IS NOT NULL) WHERE IndicatorDetId=1
	
	UPDATE  #DeductionAdjustment SET PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1 AND B.FinalDemeritPoint>0)  WHERE IndicatorDetId=1


	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)

	--UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1)  WHERE IndicatorDetId=1
	UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull(SUM (DeductionValue)/100.00,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 1)  WHERE IndicatorDetId=1

--B.2
	UPDATE  #DeductionAdjustment SET PostDemeritPoints = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2 AND B.DocumentNo IS NOT NULL) WHERE IndicatorDetId=2
	
	UPDATE  #DeductionAdjustment SET PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2 AND B.FinalDemeritPoint>0)  WHERE IndicatorDetId=2


	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)

	--UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2)  WHERE IndicatorDetId=2
	
	UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull(SUM (DeductionValue)/100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 2)  WHERE IndicatorDetId=2

--B.3
	UPDATE  #DeductionAdjustment SET PostDemeritPoints = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3 AND B.DocumentNo IS NOT NULL) WHERE IndicatorDetId=3
	
	UPDATE  #DeductionAdjustment SET PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3 AND B.FinalDemeritPoint>0)  WHERE IndicatorDetId=3


	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)

	--UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3)  WHERE IndicatorDetId=3

	UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull(SUM (DeductionValue)/100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 3)  WHERE IndicatorDetId=3

--B.4
	UPDATE  #DeductionAdjustment SET PostDemeritPoints = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4 AND B.DocumentNo IS NOT NULL) WHERE IndicatorDetId=4
	
	UPDATE  #DeductionAdjustment SET PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4 AND B.FinalDemeritPoint>0)  WHERE IndicatorDetId=4


	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)

	--UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4)  WHERE IndicatorDetId=4
	
	UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull(SUM (DeductionValue)/100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 4)  WHERE IndicatorDetId=4

--B.5
	UPDATE  #DeductionAdjustment SET PostDemeritPoints = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5 AND B.DocumentNo IS NOT NULL) WHERE IndicatorDetId=5
	
	UPDATE  #DeductionAdjustment SET PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5 AND B.FinalDemeritPoint>0)  WHERE IndicatorDetId=5


	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)

	--UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5)  WHERE IndicatorDetId=5
	UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull(SUM (DeductionValue)/100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 5)  WHERE IndicatorDetId=5

--B.6
	UPDATE  #DeductionAdjustment SET PostDemeritPoints = (SELECT isnull(SUM (FinalDemeritPoint),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6 AND B.DocumentNo IS NOT NULL) WHERE IndicatorDetId=6
	
	UPDATE  #DeductionAdjustment SET PostDeductionValue = (SELECT isnull(SUM (DeductionValue),0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6 AND B.FinalDemeritPoint>0)  WHERE IndicatorDetId=6


	set @Bemsmsf = (SELECT BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE Month =@pMonth AND Year =@pYear AND A.FacilityId = @pFacilityId)

	--UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull((SUM (DeductionValue)/@Bemsmsf)*100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	--WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6)  WHERE IndicatorDetId=6
	UPDATE  #DeductionAdjustment SET PostDeductionPer = (SELECT isnull(SUM (DeductionValue)/100,0) FROM DeductionTransactionMappingMst A INNER JOIN DeductionTransactionMappingMstDet B on A.DedTxnMappingId = B.DedTxnMappingId
	WHERE A.FacilityId = @pFacilityId AND A.ServiceId = @pServiceId AND A.Month = @pMonth AND A.Year = @pYear AND A.IndicatorDetId = 6)  WHERE IndicatorDetId=6
	--------

	UPDATE A SET A.IsAdjustmentSaved =1,A.DocumentNo=B.DocumentNo,A.Remarks = isnull(B.Remarks,'') FROM #DeductionAdjustment A , DedGenerationTxn B WHERE B.FacilityId = @pFacilityId AND B.ServiceId = @pServiceId AND B.Month = @pMonth AND B.Year = @pYear
	AND B.DeductionStatus='A' AND B.DocumentNo IS NOT NULL

	UPDATE A SET A.IsAdjustmentSaved =0,A.DocumentNo = '',A.Remarks='' FROM #DeductionAdjustment A , DedGenerationTxn B WHERE B.FacilityId = @pFacilityId AND B.ServiceId = @pServiceId AND B.Month = @pMonth AND B.Year = @pYear
	AND B.DeductionStatus='G' AND B.DocumentNo IS NULL


	SELECT IndicatorDetId ,IndicatorNo ,IndicatorName ,TotalDemeritPoints ,
	DeductionValue ,DeductionPer ,PostDemeritPoints, 
	case when TotalDemeritPoints =0 then 0 else (DeductionValue/TotalDemeritPoints)* PostDemeritPoints  end as  PostDeductionValue ,case when TotalDemeritPoints = 0 then 0 else ((DeductionPer/TotalDemeritPoints)* PostDemeritPoints) end 
	as PostDeductionPer ,IsAdjustmentSaved ,DocumentNo ,Remarks
	FROM #DeductionAdjustment
	
	
		

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
