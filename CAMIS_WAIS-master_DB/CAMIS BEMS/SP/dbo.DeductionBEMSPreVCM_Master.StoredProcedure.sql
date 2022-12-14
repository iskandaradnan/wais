USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionBEMSPreVCM_Master]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec  DeductionBEMSPreVCM_Master  
CREATE PROCEDURE [dbo].[DeductionBEMSPreVCM_Master]  
AS  
BEGIN  
  
DECLARE @DAY INT  
SET @DAY=(SELECT DAY(GETDATE()))  
  
--SELECT @DAY  
IF (@DAY >=1 AND @DAY <=5)  
BEGIN  
  
  
INSERT INTO DeductionLog     
(    
 ProcessStartDate    
,Process    
)    
    
    
    
SELECT GETDATE(),'Pre VCM Data Inserted'    
  
  
DECLARE @YEAR INT  
DECLARE @MONTH INT  
  
SET @YEAR=(CASE WHEN MONTH(GETDATE())=1 THEN YEAR(GETDATE())-1 ELSE YEAR(GETDATE()) END)  
SET @MONTH=(CASE WHEN MONTH(GETDATE())=1 THEN 12 ELSE MONTH(GETDATE())-1 END)          
  
  
---- TO CALCUALTE PREVIOUS MONTH DATA AND STORE THE SAME  
EXEC [DeductionDemeritPointB1B2PrevMonth_Calc] @YEAR,@MONTH  
EXEC [DeductionDemeritPointB4PrevMonth_Calc] @YEAR,@MONTH  
EXEC DeductionDemeritPointB5PrevMonth_Calc @YEAR,@MONTH   
-------  
  
EXEC [DeductionDemeritPointB1B2_Calc] @YEAR,@MONTH  
EXEC [DeductionB3_Calc] @YEAR,@MONTH  
EXEC [DeductionB3Base_Calc]   
EXEC [DeductionDemeritPointB4_Calc] @YEAR,@MONTH  
EXEC [DeductionB5_Calc] @YEAR,@MONTH  
EXEC DeductionDemeritPointB5CRM_Calc @YEAR,@MONTH  
EXEC DedNCRValidationTxn_Save  @YEAR,@MONTH   
EXEC DedNCRValidationTxnDet_Save @YEAR,@MONTH  
  
  
---SAVE PROCEDURE   
EXEC [DeductionB1B2_Save] @YEAR,@MONTH  
EXEC [DeductionB3_Save] @YEAR,@MONTH  
EXEC [DeductionB4_Save] @YEAR,@MONTH  
EXEC [DeductionB5_Save] @YEAR,@MONTH  
EXEC [DeductionPrePostSummary_Base]  @YEAR,@MONTH --for pre data  
EXEC [DeductionPreValueUpdateRemarks] @YEAR,@MONTH ----FORREMARKS--ADDED ON 17122020 AS TO REFLECT REMARKS IN BOTH PREVCM AND POST VCM SSRS REPORTS  
  
UPDATE A    
SET A.ProcessEndDate=GETDATE()    
FROM DeductionLog A     
--WHERE ProcessStartDate=GETDATE()    
WHERE ProcessID=(SELECT MAX(ProcessID) FROM DeductionLog)    
  
END  
  
ELSE   
BEGIN   
  
SELECT 'Pre VCM Generated'  
  
END  
  
  
END
GO
