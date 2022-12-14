USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionPostCarryForwardUpdate]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---EXEC DeductionPostCarryForwardUpdate

CREATE PROCEDURE [dbo].[DeductionPostCarryForwardUpdate]
AS
BEGIN


DECLARE @YEAR INT
DECLARE @MONTH INT

SET @YEAR=YEAR(GETDATE())
SET @MONTH=MONTH(GETDATE())


DECLARE @PREV_YEAR INT               
DECLARE @PREV_MONTH INT              


SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)              
SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)              
              


IF OBJECT_ID('tempdb.dbo.#TEMP1', 'U') IS NOT NULL                
DROP TABLE #TEMP1              

SELECT * INTO
#TEMP1
FROM DedTransactionMappingTxnDet
WHERE [Year]=@PREV_YEAR
AND [Month]=@PREV_MONTH-1 ---GO TWO MONTHS BACK FROM CURRENT MONTH
AND IndicatorDetId=2
AND Flag='Prev Month Open And Still Open In Current Month'


SELECT * FROM #TEMP1

---PLEASE UNCOMMENT WHN YOU NEED TO USE


--UPDATE A
--SET A.FinalDemeritPoint=A.DemeritPoint
--   ,A.IsValid=B.IsValid
--   ,A.Remarks=B.Remarks
--   ,A.RemarksJOHN=B.RemarksJOHN
--FROM DedTransactionMappingTxnDet A
--INNER JOIN #TEMP1 B
--ON A.DocumentNo=B.DocumentNo
--WHERE 
--A.[Year]=@PREV_YEAR
--AND A.[Month]=@PREV_MONTH
--AND A.IndicatorDetId=2
--AND B.IsValid=1

END

GO
