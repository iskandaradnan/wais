USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BEMSDARData_Rpt]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: UETRACK BEMS              
Version				:               
File Name			:              
Procedure Name		: uspFM_BEMSDAR_Rpt
Author(s) Name(s)	: Hari Haran N
Date				:  
Purpose				:  BEMS Dar Report
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC uspFM_BEMSDAR_Rpt  '@Hospital_Id','@Year','@Month','@Reference_No','@DedGenerationType'   
EXEC uspFM_BEMSDAR_Rpt   '1','2018','3','12','12'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   
 			          
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EXEC BEMS_DATA 85,2017,03,1
CREATE PROCEDURE [dbo].[uspFM_BEMSDARData_Rpt]
(
  @Hospital_Id		INT,
  @Year             INT,
  @Month			INT,
  @Reference_No		VARCHAR(50)
  ,@DedGenerationType int= null
)
AS              
BEGIN        
SET NOCOUNT ON
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF

CREATE TABLE #FINAL(Indicator_No VARCHAR(5),Indicator_Name VARCHAR(300),Frequency varchar(100),Weightage DECIMAL(12,2),Parameters INT,Key_Deduction_Indicators_Value FLOAT,Ringgit_Equivalent NUMERIC(24,2),
Gearing_Ratio_Of_Ringgit_Equivalent NUMERIC(24,2),Demerit_Points FLOAT,Deduction_Value_RM NUMERIC(24,2),Deduction_Percentage NUMERIC(24,2),Performance_Level FLOAT,FLAG VARCHAR(2),MSF FLOAT)


DECLARE @Ind_No VARCHAR(5),@COUNT INT,@INDEX INT=1,@WEIGHT DECIMAL(12,2),@KEY FLOAT,@PARAMETER INT,@RINGEQ NUMERIC(24,9),@GEAR_RATIO NUMERIC(24,9),@DemeritPoints INT,
@DED_VALUE NUMERIC(24,9),@DED_PERCENT NUMERIC(24,9),@MSF FLOAT,@NCR INT, @Frequency varchar(100)

INSERT INTO #FINAL (Indicator_No,Indicator_Name,FLAG)
SELECT IndicatorNo,IndicatorDesc,'N' FROM MstDedIndicatorDet WHERE IndicatorNo LIKE 'B%'

SELECT @COUNT = COUNT(*) FROM #FINAL

WHILE(@INDEX <= @COUNT)
BEGIN

SET ROWCOUNT 1

SELECT @Ind_No = Indicator_No FROM #FINAL
WHERE FLAG='N'

SET ROWCOUNT 0

SELECT @Frequency = dbo.[Fn_DisplayNameofLov](D.Frequency), @WEIGHT = D.Weightage,@KEY= keyIndicatorValue,@PARAMETER = B.TotalParameter,@MSF = F.BemsMSF ,
@GEAR_RATIO = GearingRatio, @RINGEQ = Ringittequivalent,
@DemeritPoints = CASE WHEN A.DeductionStatus='G' THEN ISNULL(B.TransactionDemeritPoint,0) ELSE ISNULL(B.PostTransactionDemeritPoint,0) END + isnull(NcrDemeritPoint,0),
@DED_VALUE = CASE WHEN A.DeductionStatus='G' THEN ISNULL(B.DeductionValue,0) ELSE ISNULL(B.PostDeductionValue,0) END, @DED_PERCENT = CASE WHEN A.DeductionStatus='G' THEN ISNULL(B.DeductionPercentage,0) ELSE ISNULL(B.PostDeductionPercentage,0) END
FROM DedGenerationTxn A,DedGenerationTxnDet B,MstDedIndicator C,MstDedIndicatorDet D,FinMonthlyFeeTxn E,FinMonthlyFeeTxnDet F
WHERE IndicatorNo = @Ind_No
AND B.IndicatorDetId=D.IndicatorDetId
AND D.IndicatorId=C.IndicatorId
AND C.ServiceId=2
AND B.SubParameterDetId IS NULL
AND A.Year=@Year
AND A.Month=@Month
AND A.ServiceId=C.ServiceId
AND A.DedGenerationId=B.DedGenerationId
AND E.Year=@Year
AND F.Month=@Month
AND E.MonthlyFeeId=F.MonthlyFeeId
AND A.FacilityId=@Hospital_Id


AND E.FacilityId=A.FacilityId

--SELECT @NCR = COUNT(*) FROM FmsNCREntryTxn A,DedIndicatorMstDet B--,AsisSysLovMst C
--WHERE B.IndicatorNo = @Ind_No
--AND A.IndicatorDetId=B.IndicatorDetId
--AND YEAR(A.NCRDateTime)=@Year
--AND MONTH(A.NCRDateTime)=@Month
----AND C.LovId=@Month
--AND A.HospitalId=@Hospital_Id
--AND A.IsDeleted=0
--AND B.IsDeleted=0

--SELECT @DemeritPoints = @DemeritPoints+@NCR
--SELECT @RINGEQ = @KEY/(CASE WHEN @PARAMETER = 0 or @PARAMETER IS null then 1 else @PARAMETER end)
--SELECT @GEAR_RATIO = @RINGEQ*2

--SELECT @DED_VALUE = @GEAR_RATIO*@DemeritPoints

--SELECT @DED_PERCENT = (@DED_VALUE/@MSF)*100

--SELECT @DED_VALUE=case when charindex('.',cast(@DED_VALUE as varchar(20)))>0 then substring(cast(@DED_VALUE as varchar(20)),1,charindex('.',cast(@DED_VALUE as varchar(20)))+2) else @DED_VALUE end
--SELECT @DED_PERCENT=case when charindex('.',cast(@DED_PERCENT as varchar(20)))>0 then substring(cast(@DED_PERCENT as varchar(20)),1,charindex('.',cast(@DED_PERCENT as varchar(20)))+2) else @DED_PERCENT end

UPDATE #FINAL
SET Frequency = @Frequency, Weightage = ISNULL(@WEIGHT,0),Key_Deduction_Indicators_Value = ISNULL(@KEY,0),Parameters = ISNULL(@PARAMETER,0),Ringgit_Equivalent = ISNULL(@RINGEQ,0),Gearing_Ratio_Of_Ringgit_Equivalent = ISNULL(@GEAR_RATIO,0),Demerit_Points =
 ISNULL(@DemeritPoints,0),
Deduction_Value_RM = ISNULL(@DED_VALUE,0),Deduction_Percentage = ISNULL(@DED_PERCENT,0),MSF = ISNULL(@MSF,0),Performance_Level=0,FLAG = 'Y'
WHERE Indicator_No = @Ind_No

SET @INDEX = @INDEX+1

END

SELECT Indicator_No as 'S_No',Indicator_Name as 'Key_Deduction_Indicators',Weightage,Parameters,Key_Deduction_Indicators_Value,Ringgit_Equivalent,Gearing_Ratio_Of_Ringgit_Equivalent,
Demerit_Points,Deduction_Value_RM,Deduction_Percentage,Performance_Level,Frequency FROM #FINAL

DROP TABLE #FINAL

SET NOCOUNT OFF
SET ARITHABORT ON
SET ANSI_WARNINGS ON
END
GO
