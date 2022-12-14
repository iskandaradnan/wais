USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FinMonthlyFeeTxn_GetById_Krishna]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UspFM_FinMonthlyFeeTxn_GetById_Krishna](  
             @pYear  INT,    
             @pFacilityId INT    
             )  
AS     
  
/*  
  
EXEC UspFM_FinMonthlyFeeTxn_GetById_Krishna 2018, 12  
*/  
  
                                               
BEGIN TRY    
  
CREATE TABLE #TEMP_FinMonthlyFeeTxn_GetById(  
MonthlyFeeId	INT,  
MonthlyFeeDetId	INT,  
CustomerId		INT,  
FacilityId		INT,  
FacilityName	NVARCHAR(200),   
FacilityCode	NVARCHAR(200),  
Year			INT,  
Month			INT,  
MonthlyFeeMonth	NVARCHAR(100),  
VersionNo		INT,  
BemsMSF			NUMERIC(18,2),  
BemsCF			NUMERIC(18,2),  
BemsKPIF		NUMERIC(18,2),  
BemsPercent		NUMERIC(18,2),  
TotalFee		NUMERIC(18,2),  
--Timestamp1		TIMESTAMP   DEFAULT Timestamp
)  
   
   
 INSERT INTO #TEMP_FinMonthlyFeeTxn_GetById( MonthlyFeeId, MonthlyFeeDetId, CustomerId, FacilityId, FacilityCode, FacilityName, Year, Month,   
 MonthlyFeeMonth, VersionNo, BemsMSF, BemsCF, BemsKPIF, BemsPercent, TotalFee)	--, Timestamp1)  
  
 SELECT MFT.MonthlyFeeId AS MonthlyFeeId, MFTD.MonthlyFeeDetId AS MonthlyFeeDetId, MFT.CustomerId AS CustomerId, MFT.FacilityId AS FacilityId,   
 Facility.FacilityCode AS FacilityCode, Facility.FacilityName AS FacilityName, MFT.Year AS Year, MFTD.Month AS Month, MFM.Month AS MonthlyFeeMonth,    
 MFTD.VersionNo AS VersionNo, ISNULL(MFTD.BemsMSF ,0) AS BemsMSF, ISNULL(MFTD.BemsCF,0) AS BemsCF, ISNULL(MFTD.BemsKPIF,0) AS BemsKPIF,    
 ISNULL(MFTD.BemsPercent,0) AS BemsPercent, ISNULL(MFTD.TotalFee,0) AS TotalFee	--, MFT.Timestamp AS Timestamp    
 FROM FinMonthlyFeeTxn AS MFT WITH(NOLOCK)    
 INNER JOIN  FinMonthlyFeeTxnDet AS MFTD WITH(NOLOCK) ON MFT.MonthlyFeeId = MFTD.MonthlyFeeId    
 INNER JOIN FMTimeMonth        AS MFM WITH(NOLOCK) ON MFTD.Month  = MFM.MonthId    
 INNER JOIN MstLocationFacility      AS Facility   WITH(NOLOCK) ON MFT.FacilityId  = Facility.FacilityId    
 WHERE MFT.Year = 2018    
 AND MFT.FacilityId = 1    
 ORDER BY MFTD.Month ASC    
 
 
  
 SELECT * FROM #TEMP_FinMonthlyFeeTxn_GetById   
  
DROP TABLE #TEMP_FinMonthlyFeeTxn_GetById  
  
  
  
 -- DROP TABLE #ResultTempT 
 ----DROP TABLE 
 --DECLARE @mDedGenerationId INT, @pYear INT, @pMonth INT, @pServiceId INT, @pFacilityId INT
 
 --select @pYear = 2018, @pMonth = 10, @pServiceId = 2, @pFacilityId = 1
 --SELECT DedGenerationId FROM DedGenerationTxn WHERE Year = @pYear AND Month= @pMonth AND ServiceId = @pServiceId AND FacilityId = @pFacilityId
 --SET @mDedGenerationId = (SELECT DedGenerationId FROM DedGenerationTxn WHERE Year = @pYear AND Month= @pMonth AND ServiceId = @pServiceId AND FacilityId = @pFacilityId)    

 --CREATE TABLE #ResultTempT(IndicatorDetId int, IndicatorNo NVARCHAR(100),IndicatorName NVARCHAR(100), SubParameter INT,SubParameterDetId INT,
 --TransDemeritPoints INT,TotalDemeritPoints INT,DeductionValue NUMERIC(24,2), DeductionPer NUMERIC(24,2))    
    
 --INSERT INTO #ResultTempT(IndicatorDetId,IndicatorNo,IndicatorName,SubParameter,SubParameterDetId,TransDemeritPoints,TotalDemeritPoints,
 --DeductionValue,DeductionPer)
 
 --SELECT A.IndicatorDetId,B.IndicatorNo,B.IndicatorName,0 AS SubParameter,SubParameterDetId,TransactionDemeritPoint AS TransDemeritPoints,
 --TransactionDemeritPoint as TotalDemeritPoints    
 --, A.DeductionValue,A.DeductionPercentage AS DeductionPer    
 --FROM DedGenerationTxnDet A 
 --INNER JOIN MstDedIndicatorDet B ON A.IndicatorDetId = B.IndicatorDetId    
 --WHERE A.DedGenerationId = @mDedGenerationId    
 
 -- SELECT  A.DeductionValue,A.DeductionPercentage AS DeductionPer, A.FACILITYID, A.CustomerId, 
 --DGT.MONTH, DGT.YEAR
 ----B.IndicatorNo,B.IndicatorName,   
 --FROM DedGenerationTxnDet A 
 --INNER JOIN DedGenerationTxn AS DGT ON A.DedGenerationId = DGT.DedGenerationId
 ----INNER JOIN MstDedIndicatorDet B ON A.IndicatorDetId = B.IndicatorDetId    
 --WHERE A.DedGenerationId = @mDedGenerationId   
  
 --INSERT INTO #ResultTempT(IndicatorDetId,IndicatorNo,IndicatorName,SubParameter,SubParameterDetId,TransDemeritPoints,
 --TotalDemeritPoints,DeductionValue,DeductionPer)    
 --SELECT max(IndicatorDetId)+1,'Total',null,0,0,sum(TransDemeritPoints),sum(TotalDemeritPoints),sum(DeductionValue),
 --sum(DeductionPer) FROM #ResultTempT    
  
 --select IndicatorDetId,IndicatorNo,IndicatorName,SubParameter,ISNULL(SubParameterDetId,0) AS SubParameterDetId,cast(ISNULL(TransDemeritPoints,0) as int) AS TransDemeritPoints,    
 -- cast(ISNULL(TotalDemeritPoints,0) as int) AS TotalDemeritPoints, cast(ISNULL(DeductionValue,0.0)as decimal(24,2)) AS DeductionValue,cast(ISNULL(DeductionPer,0.0)as decimal(24,2)) AS DeductionPer from #ResultTempT    

END TRY    
    
BEGIN CATCH    
    
 INSERT INTO ErrorLog(    
    Spname,    
    ErrorMessage,    
    createddate)    
 VALUES(  OBJECT_NAME(@@PROCID),    
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),    
    getdate()    
     )    
    
END CATCH
GO
