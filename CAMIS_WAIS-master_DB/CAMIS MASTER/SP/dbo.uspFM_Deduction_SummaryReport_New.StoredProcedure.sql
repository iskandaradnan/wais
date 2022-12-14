USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Deduction_SummaryReport_New]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: [usp_FM_Deduction_Summary] 
Author(s) Name(s)	: Balaji M S
Date				: 31/06/2018
Purpose				: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC [uspFM_Deduction_Summary]  '@pFacilityId','@pMonth','@pYear'
EXEC [uspFM_Deduction_SummaryReport] '2',2,5,2018

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/  
CREATE PROCEDURE [dbo].[uspFM_Deduction_SummaryReport_New]
(                                                
	@pFacilityId						INT,                                           
	@pFrommonth							INT,
	@pTomonth							INT,
	@pYear								INT


)             
AS                                                
BEGIN    



                              
SET NOCOUNT ON
SET FMTONLY OFF;

if object_id('tempdb..#Result') is not null
drop table #Result
if object_id('tempdb..#DeductionValue') is not null
DROP TABLE #DeductionValue

CREATE TABLE #Result(MonthId int,MonthValue nvarchar(100),Year int,FacilityId int,FacilityName nvarchar(100),MSFValue NUMERIC(24,2), CFValue numeric(24,2),DeductionValue NUMERIC(24,2),TOTAL NUMERIC(24,2))

CREATE TABLE #DeductionValue(MonthId int,Year int,FacilityId int,DeductionValue NUMERIC(24,2))


INSERT INTO #Result(MonthId,MonthValue,Year,FacilityId,FacilityName,MSFValue,CFValue,DeductionValue)
SELECT F.Month,G.Month,e.Year,e.FacilityId,L.FacilityName,F.BemsMSF,F.BemsCF,0
FROM  FinMonthlyFeeTxn E		
INNER JOIN FinMonthlyFeeTxnDet F   ON		E.MonthlyFeeId					= F.MonthlyFeeId
INNER JOIN FMTimeMonth         G   ON		F.Month							= G.MonthId
INNER JOIN MstLocationFacility L   ON       E.FacilityId                    = L.FacilityId
WHERE E.FacilityId=@pFacilityId AND F.Month BETWEEN @pFrommonth AND @pTomonth AND E.Year=@pYear



INSERT INTO #DeductionValue(MonthId,Year,FacilityId,DeductionValue)
SELECT B.Month , B.Year , B.FacilityId,
CASE WHEN B.DeductionStatus = 'G' THEN ISNULL(SUM(C.DeductionValue),0)
     WHEN B.DeductionStatus = 'A' THEN ISNULL(SUM(C.PostDeductionValue),0)
ELSE
0 
END AS DeductionValues
FROM DedGenerationTxn  B
INNER JOIN DedGenerationTxnDet C ON B.DedGenerationId = C.DedGenerationId
WHERE  b.Month BETWEEN @pFrommonth AND @pTomonth AND B.Year = @pYear and B.FacilityId = @pFacilityId
GROUP BY B.Month , B.Year , B.FacilityId ,B.DeductionStatus


UPDATE A SET A.DeductionValue = B.DeductionValue FROM #Result A INNER JOIN #DeductionValue B ON A.MonthId = B.MonthId AND A.Year = B.Year AND A.FacilityId = B.FacilityId

UPDATE #Result SET TOTAL = (MSFValue+CFValue)-DeductionValue

SELECT * FROM #Result


SET NOCOUNT OFF  
END
GO
