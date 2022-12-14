USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionBEMSPostVCM_Master]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC DeductionBEMSPreVCM_Master
--EXEC DeductionBEMSPostVCM_Master
CREATE PROCEDURE [dbo].[DeductionBEMSPostVCM_Master]
AS
BEGIN



DECLARE @DAY INT
SET @DAY=(SELECT DAY(GETDATE()))

--SELECT @DAY

IF (@DAY >=10)
BEGIN

INSERT INTO DeductionLog   
(  
 ProcessStartDate  
,Process  
)  
  
  
  
SELECT GETDATE(),'Post VCM Data Inserted'  


DECLARE @YEAR INT
DECLARE @MONTH INT

SET @YEAR=(CASE WHEN MONTH(GETDATE())=1 THEN YEAR(GETDATE())-1 ELSE YEAR(GETDATE()) END)
SET @MONTH=(CASE WHEN MONTH(GETDATE())=1 THEN 12 ELSE MONTH(GETDATE())-1 END)        


EXEC [DeductionPostValueUpdate] @YEAR,@MONTH
EXEC [DeductionPrePostSummary_Base] @YEAR,@MONTH --and post data once

UPDATE A  
SET A.ProcessEndDate=GETDATE()  
FROM DeductionLog A   
--WHERE ProcessStartDate=GETDATE()  
WHERE ProcessID=(SELECT MAX(ProcessID) FROM DeductionLog)  



END
ELSE
BEGIN 

SELECT 'Cannot Run as the day is Less'

END


END
GO
