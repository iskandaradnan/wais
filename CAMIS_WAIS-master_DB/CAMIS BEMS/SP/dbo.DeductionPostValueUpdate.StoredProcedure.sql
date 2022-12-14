USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionPostValueUpdate]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC DeductionPostValueUpdate




----IMPORTANT TO GET THE POST VALUE PLEASE CHECK THE YEAR AND MONTH IS PASSED CORRECTLY OR NOT.

CREATE PROCEDURE [dbo].[DeductionPostValueUpdate]
(
 @YEAR INT
,@MONTH INT
)

AS


BEGIN


--DECLARE @YEAR INT
--DECLARE @MONTH INT

--SET @YEAR=2020 --YEAR(GETDATE())
--SET @MONTH=8 --MONTH(GETDATE())-1

---UPDATE POST VALUE B1

--SELECT  
UPDATE A
SET 
 A.DemeritPoint_B1Post= ISNULL(B.FinalDemeritPoint,0) 
,A.Validate_Estatus_B1Post=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
--,A.DemeritPoint_B2Post=B.FinalDemeritPoint 
--,A.Validate_Estatus_B2Post=B.IsValid=1  THEN 'Y' ELSE 'N' END)
,A.DeductionProHawkRM_B1Post= ISNULL((B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset),0)
,A.DeductionEdgentaRM_B1Post=ISNULL((B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset),0)
--,A.DeductionProHawkRM_B2Post=((CASE WHEN IndicatorDetId=2 THEN B.FinalDemeritPoint ELSE 0 END)*A.B2_DeductionFigurePerAsset)
--,A.DeductionEdgentaRM_B2Post=((CASE WHEN IndicatorDetId=2 THEN B.FinalDemeritPoint ELSE 0 END)*A.B2_DeductionFigurePerAsset)
,A.RemarksB1=B.Remarks


FROM DeductionDemeritPointB1B2_Base A
INNER JOIN DedTransactionMappingTxnDet B
ON A.WONo=B.DocumentNo
WHERE B.IndicatorDetId IN (1)
AND B.Year=@YEAR
AND B.Month=@MONTH


---UPDATE POST VALUE DedTransactionMappingTxnDet TO SHOW IN SCREEEN

UPDATE B
SET 
-- A.DemeritPoint_B1Post= B.FinalDemeritPoint 
--,A.Validate_Estatus_B1Post=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
--,A.DemeritPoint_B2Post=B.FinalDemeritPoint 
--,A.Validate_Estatus_B2Post=B.IsValid=1  THEN 'Y' ELSE 'N' END)
--,A.DeductionProHawkRM_B1Post= (B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset)
 B.PostDeductionValue=ISNULL((B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset),0)
--,A.DeductionProHawkRM_B2Post=((CASE WHEN IndicatorDetId=2 THEN B.FinalDemeritPoint ELSE 0 END)*A.B2_DeductionFigurePerAsset)
--,A.DeductionEdgentaRM_B2Post=((CASE WHEN IndicatorDetId=2 THEN B.FinalDemeritPoint ELSE 0 END)*A.B2_DeductionFigurePerAsset)
--,A.Remarks=B.Remarks


FROM DeductionDemeritPointB1B2_Base A
INNER JOIN DedTransactionMappingTxnDet B
ON A.WONo=B.DocumentNo
WHERE B.IndicatorDetId IN (1)
AND B.Year=@YEAR
AND B.Month=@MONTH


---UPDATE POST VALUE B2

UPDATE A
SET 
-- A.DemeritPoint_B1Post= B.FinalDemeritPoint 
--,A.Validate_Estatus_B1Post=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
 A.DemeritPoint_B2Post=ISNULL(B.FinalDemeritPoint,0) 
,A.Validate_Estatus_B2Post=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
--,A.DeductionProHawkRM_B1Post= (B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset)
--,A.DeductionEdgentaRM_B1Post=(B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset)
,A.DeductionProHawkRM_B2Post=ISNULL((B.FinalDemeritPoint *A.B2_DeductionFigurePerAsset),0)
,A.DeductionEdgentaRM_B2Post=ISNULL((B.FinalDemeritPoint *A.B2_DeductionFigurePerAsset),0)
,A.RemarksB2=B.Remarks


FROM DeductionDemeritPointB1B2_Base A
INNER JOIN DedTransactionMappingTxnDet B
ON A.WONo=B.DocumentNo
WHERE B.IndicatorDetId IN (2)
AND B.Year=@YEAR
AND B.Month=@MONTH


---UPDATE POST VALUE DedTransactionMappingTxnDet TO SHOW IN SCREEEN

UPDATE B
SET 
-- A.DemeritPoint_B1Post= B.FinalDemeritPoint 
--,A.Validate_Estatus_B1Post=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
-- A.DemeritPoint_B2Post=B.FinalDemeritPoint 
--,A.Validate_Estatus_B2Post=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
--,A.DeductionProHawkRM_B1Post= (B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset)
--,A.DeductionEdgentaRM_B1Post=(B.FinalDemeritPoint *A.B1_DeductionFigurePerAsset)
B.PostDeductionValue=ISNULL((B.FinalDemeritPoint *A.B2_DeductionFigurePerAsset),0)
--,A.DeductionEdgentaRM_B2Post=(B.FinalDemeritPoint *A.B2_DeductionFigurePerAsset)
--,A.Remarks=B.Remarks



FROM DeductionDemeritPointB1B2_Base A
INNER JOIN DedTransactionMappingTxnDet B
ON A.WONo=B.DocumentNo
WHERE B.IndicatorDetId IN (2)
AND B.Year=@YEAR
AND B.Month=@MONTH



---UPDATE POST VALUE B4


UPDATE A
SET 
 A.DemeritPointPost= ISNULL(B.FinalDemeritPoint,0) 
,A.ValidateStatusPost=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
,A.DeductionRMPost= ISNULL((B.FinalDemeritPoint *A.DeductionFigurePerAsset),0)
,A.Remarks=B.Remarks
FROM DeductionDemeritPointB4_Base A
INNER JOIN DedTransactionMappingTxnDet B
ON A.MaintenanceWorkNo=B.DocumentNo
WHERE B.IndicatorDetId IN (4)
AND B.Year=@YEAR
AND B.Month=@MONTH



---UPDATE POST VALUE B5

UPDATE A
SET 
 A.DemeritPointPost= ISNULL(B.FinalDemeritPoint,0) 
,A.ValidateStatusPost=(CASE WHEN B.IsValid=1  THEN 'Y' ELSE 'N' END)
,A.DeductionFigureProHawkPost= ISNULL((B.FinalDemeritPoint *A.DeductionFigurePerReport),0)
,A.Remarks=B.Remarks
FROM DeductionReportB5_Base A
INNER JOIN DedTransactionMappingTxnDet B
ON A.ReportID=B.ReportID
WHERE B.IndicatorDetId IN (5)
AND B.Year=@YEAR
AND B.Month=@MONTH

END
GO
