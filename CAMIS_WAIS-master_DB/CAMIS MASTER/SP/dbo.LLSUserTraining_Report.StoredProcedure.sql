USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserTraining_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--EXEC LLSUserTraining_Report 2020  
  
CREATE PROCEDURE [dbo].[LLSUserTraining_Report]  
(  
@FREQUENCY VARCHAR(30)
,@YEAR INT  
,@MONTH INT NULL
  )
AS  
  
BEGIN  
  
IF OBJECT_ID('tempdb.dbo.#TEMPBASEDATA', 'U') IS NOT NULL        
DROP TABLE #TEMPBASEDATA       
    

--DECLARE @FREQUENCY VARCHAR(30)
--SET @FREQUENCY='MONTHLY'

--DECLARE @YEAR INT 
--SET @YEAR=2020
  
--DECLARE @MONTH INT 
--SET @MONTH=10
  
IF(@FREQUENCY='Yearly')
BEGIN
  
SELECT PlannedDate   
,ActualDate  
,CAST(C.DAY AS VARCHAR(10))+'-'+LEFT(C.MonthName,3)+'-'+CAST(C.Year AS VARCHAR(10)) AS [PlannedDateDDMMMYY]  
,CAST(D.DAY AS VARCHAR(10))+'-'+LEFT(D.MonthName,3)+'-'+CAST(D.Year AS VARCHAR(10)) AS [ActualDateDDMMMYY]  
,TrainingDescription  
,ISNULL(TotalParticipants,0) AS TotalParticipants  
,TrainerUserName AS Presenter  
,Designation  
,'' AS TrainingType  
,ISNULL(B.FieldValue,'') AS TrainingStatus  
,'' AS TrainingModule  
,'' AS Effectiveness  
  
FROM EngTrainingScheduleTxn A  
LEFT OUTER JOIN FMLovMst B  
ON A.TrainingStatus=B.LovId  
LEFT OUTER JOIN LLSDate C  
ON CAST(A.PlannedDate AS DATE)=C.Date  
LEFT OUTER JOIN LLSDate D  
ON CAST(A.ActualDate AS DATE)=D.Date  
WHERE YEAR(A.CreatedDate)=@YEAR  
END 
IF(@FREQUENCY='Monthly')
BEGIN
  
SELECT PlannedDate   
,ActualDate  
,CAST(C.DAY AS VARCHAR(10))+'-'+LEFT(C.MonthName,3)+'-'+CAST(C.Year AS VARCHAR(10)) AS [PlannedDateDDMMMYY]  
,CAST(D.DAY AS VARCHAR(10))+'-'+LEFT(D.MonthName,3)+'-'+CAST(D.Year AS VARCHAR(10)) AS [ActualDateDDMMMYY]  
,TrainingDescription  
,ISNULL(TotalParticipants,0) AS TotalParticipants  
,TrainerUserName AS Presenter  
,Designation  
,'' AS TrainingType  
,ISNULL(B.FieldValue,'') AS TrainingStatus  
,'' AS TrainingModule  
,'' AS Effectiveness  
  
FROM EngTrainingScheduleTxn A  
LEFT OUTER JOIN FMLovMst B  
ON A.TrainingStatus=B.LovId  
LEFT OUTER JOIN LLSDate C  
ON CAST(A.PlannedDate AS DATE)=C.Date  
LEFT OUTER JOIN LLSDate D  
ON CAST(A.ActualDate AS DATE)=D.Date  
WHERE YEAR(A.CreatedDate)=@YEAR  
AND MONTH(A.CreatedDate)=@MONTH
END 

  
END  
  
  
  
  
GO
