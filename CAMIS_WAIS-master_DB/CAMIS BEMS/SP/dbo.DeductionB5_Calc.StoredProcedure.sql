USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB5_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC DeductionB5_Calc 2020,9
CREATE PROCEDURE [dbo].[DeductionB5_Calc]
(
 @Year INT
,@Month INT
)
AS 
BEGIN
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY             

DELETE FROM DeductionReportB5_Base WHERE Year=@Year AND Month=@Month




;WITH CTE AS
(
SELECT A.ReportsandRecordTxnId
,A.CustomerReportId
,CASE WHEN ISNULL(B.ReportName,'')='' THEN C.ReportType ELSE CONCAT(CONCAT(C.ReportType,' - '),B.ReportName) END AS ReportName
,B.SubmissionDate
,ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) AS SubmissionDueDate
,B.RequestDateTime 
,D.FieldValue AS Frequency
,CASE WHEN (B.SubmissionDate > B.SubmissionDueDate AND D.FieldValue IN ('Yearly','Monthly','Quaterly','Half Yearly'))
           OR (ISNULL(B.SubmissionDate,'')='' AND D.FieldValue IN ('Yearly','Monthly','Quaterly','Half Yearly'))
     THEN 'Y' 
	 WHEN B.SubmissionDate>DATEADD(DAY,14,RequestDateTime) AND D.FieldValue NOT IN ('Yearly','Monthly','Quaterly','Half Yearly')
	 THEN 'Y'
	 ELSE 'N' END AS ValidateStatus
,CASE WHEN (B.SubmissionDate > B.SubmissionDueDate AND D.FieldValue IN ('Yearly','Monthly','Quaterly','Half Yearly'))
           OR (ISNULL(B.SubmissionDate,'')='' AND D.FieldValue IN ('Yearly','Monthly','Quaterly','Half Yearly'))
     THEN ( CASE WHEN ISNULL(B.SubmissionDate,'')='' 
	            THEN DATEDIFF(DAY,CONVERT(DATETIME,CAST(ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) AS DATE)),CONVERT(DATETIME,CAST(GETDATE() AS DATE)))+1
	            ELSE DATEDIFF(DAY,CONVERT(DATETIME,CAST(ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) AS DATE)),B.SubmissionDate)+1       
				END
	      ) 
	 WHEN B.SubmissionDate>DATEADD(DAY,14,RequestDateTime) AND D.FieldValue NOT IN ('Yearly','Monthly','Quaterly','Half Yearly')
	 THEN ( CASE WHEN ISNULL(B.SubmissionDate,'')='' 
	            THEN DATEDIFF(DAY,(CONVERT(DATETIME,CAST(GETDATE() AS DATE))),DATEADD(DAY,14,RequestDateTime))+1
	            ELSE DATEDIFF(DAY,B.SubmissionDate,DATEADD(DAY,14,RequestDateTime))+1       
				END
	      )

	 ELSE 0 END AS DemeritPoint

----DAYS

,ISNULL(CASE WHEN (B.SubmissionDate > B.SubmissionDueDate AND D.FieldValue IN ('Yearly','Monthly','Quaterly','Half Yearly'))
           OR (ISNULL(B.SubmissionDate,'')='' AND D.FieldValue IN ('Yearly','Monthly','Quaterly','Half Yearly'))
     THEN 
	( CASE WHEN ISNULL(B.SubmissionDate,'')='' 
	            THEN DATEDIFF(DAY,CONVERT(DATETIME,CAST(ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) AS DATE)),CONVERT(DATETIME,CAST(GETDATE() AS DATE)))+1
	            ELSE DATEDIFF(DAY,CONVERT(DATETIME,CAST(ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) AS DATE)),B.SubmissionDate)+1       
				END
	      )
	 WHEN B.SubmissionDate>DATEADD(DAY,14,RequestDateTime) AND D.FieldValue NOT IN ('Yearly','Monthly','Quaterly','Half Yearly')
	 THEN 
	 ( CASE WHEN ISNULL(B.SubmissionDate,'')='' 
	            THEN DATEDIFF(DAY,(CONVERT(DATETIME,CAST(GETDATE() AS DATE))),DATEADD(DAY,14,RequestDateTime))+1
	            ELSE DATEDIFF(DAY,B.SubmissionDate,DATEADD(DAY,14,RequestDateTime))+1       
				END
	      )
	 ELSE 0 END,0) AS NoDays
	 
	 --,CASE WHEN ISNULL(B.SubmissionDate,'')='' 
	 --           THEN DATEDIFF(DAY,CONVERT(DATETIME,CAST(ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) AS DATE)),CONVERT(DATETIME,CAST(GETDATE() AS DATE)))
	 --           ELSE 0--DATEDIFF(DAY,B.SubmissionDate,B.SubmissionDueDate)       
		--		END
  --,CONVERT(DATETIME,CAST(GETDATE() AS DATE))
  --,ISNULL(B.SubmissionDueDate,A.SubmissionDueDate) 
  ,50 AS DeductionFigurePerReport
  ,CASE WHEN C.Frequency<>10245 THEN 'Main Reports' ELSE 'Other Reports' END AS ReportTag
  ,IsApplicable
FROM KPIReportsandRecordTxnDet A WITH (NOLOCK)
LEFT OUTER JOIN KPIReportsandRecordTxnAttachment B WITH (NOLOCK)
ON A.ReportsandRecordTxnDetId=B.ReportsandRecordTxnDetId
AND A.CustomerReportId=B.CustomerReportId
AND A.Year=ISNULL(B.YEAR,@Year)
AND A.Month=ISNULL(B.MONTH,@Month)
LEFT OUTER JOIN KPIReportsandRecordMst C WITH (NOLOCK)
ON A.CustomerReportId=C.CustomerReportId
LEFT OUTER JOIN FMLovMst D
ON C.Frequency=D.LovId
WHERE A.Year=@Year
AND A.Month=@Month
---AND A.IsApplicable=1--CHNAGES DONE 12082020
)



INSERT INTO DeductionReportB5_Base
(
 ReportName
,SubmissionDate
,SubmissionDueDate
,Frequency
,ValidateStatus
,DemeritPoint
,DeductionFigurePerReport
,DeductionFigureProHawk
,Year
,Month
,ReportID
,ReportTag
,IsApplicable
)

SELECT ReportName
,SubmissionDate
,SubmissionDueDate
,Frequency
--,RequestDateTime
--,FieldValue
,ValidateStatus
,DemeritPoint
--,NoDays
,DeductionFigurePerReport
,CASE WHEN DemeritPoint > 0 THEN DemeritPoint*DeductionFigurePerReport ELSE 0 END AS DeductionFigureProHawk 
,@Year AS Year
,@Month AS Month
,ROW_NUMBER()OVER(ORDER BY reportname )
,ReportTag
,IsApplicable
--INTO DeductionReportB5_Base
FROM CTE

END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    


END

--KPIReportsandRecordTxnDet

--DELETE FROM DeductionReportB5_Base

--ALTER TABLE DeductionReportB5_Base ADD Year INT
--ALTER TABLE DeductionReportB5_Base ADD Month INT




--SELECT * FROM DeductionReportB5_Base
GO
