USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionEdgentaProHawk_Report]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--EXEC DeductionEdgentaProHawk_Report 2020,8    
CREATE PROCEDURE [dbo].[DeductionEdgentaProHawk_Report]    
(    
 @YEAR INT    
,@MONTH INT    
)    
    
AS    
BEGIN    

DECLARE @FinMonthlyFeeTxnDet NUMERIC(18,2)
SET @FinMonthlyFeeTxnDet=(SELECT BemsMSF FROM FinMonthlyFeeTxnDet where CustomerId=157 AND Year=@YEAR AND Month=@MONTH)



    
--DECLARE @YEAR INT    
--DECLARE @MONTH INT    
    
--SET @YEAR=2020    
--SET @MONTH=8    
    
SELECT IndicatorNo    
,CASE WHEN IndicatorDetId=1 THEN 'All service requests shall be responded by the Company trained technical personal within the timeframe as stipulated in the Agreement.'    
     WHEN IndicatorDetId=2 THEN 'All unscheduled maintenance works including relevant maintenance calibration, safety tests and functional checks shall be completed within seven (7) days.'    
  WHEN IndicatorDetId=3 THEN 'All biomedical equipment shall be functioning and maintained to ensure uptime target as specified in the TRPI are met.'    
  WHEN IndicatorDetId=4 THEN 'Scheduled maintenance shall be carried out as per schedule and accoring to the procedure as specified in the Agreement. Scheduled maintenance shall include complete safety and performance tests.'    
     WHEN IndicatorDetId=5 THEN 'Submission of report as agreed by the user shall be made within the agreed timeframe.'    
  END AS KeyDeductionIndicators    
,CASE WHEN IndicatorDetId=1 THEN 'Per Event'    
     WHEN IndicatorDetId=2 THEN 'Per Day'    
  WHEN IndicatorDetId=3 THEN 'Per Event'    
  WHEN IndicatorDetId=4 THEN 'Per Month'    
     WHEN IndicatorDetId=5 THEN 'Per Day'    
  END AS Frequency    
,PreTotalDeductionValue AS DeductionValue    
,@FinMonthlyFeeTxnDet AS MonthlyServiceFee    
    
FROM DeductionPrePostSummary    
WHERE Year=@YEAR    
AND Month=@MONTH    
    
END
GO
