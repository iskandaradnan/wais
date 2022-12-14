USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_PeriodicWorkRecordSummaryReport_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec [dbo].[Sp_CLS_ChemicalInUse_Get] 35
CREATE PROC [dbo].[Sp_CLS_PeriodicWorkRecordSummaryReport_Get]
(
	@Month VARCHAR(50),
	@Year INT
)
	
AS 
BEGIN
SET NOCOUNT ON
BEGIN TRY
	         
			 SELECT A.UserAreaCode,D.UserAreaName,C.FieldValue AS [Status]
			 From CLS_PeriodicWorkRecordTable A
			 LEFT JOIN FMLovMst C ON A.Status = C.LovId 
			 INNER JOIN CLS_DeptAreaDetails D ON A.UserAreaCode= D.Userareacode
			 INNER JOIN CLS_PeriodicWorkRecord B ON A.PeriodicId=B.PeriodicId WHERE B.Month=@Month AND B.Year=@Year
END TRY
BEGIN CATCH

INSERT INTO ExceptionLog (  
		ErrorLine, ErrorMessage, ErrorNumber,  
		ErrorProcedure, ErrorSeverity, ErrorState,  
		DateErrorRaised  
		)  
		SELECT  
		ERROR_LINE () as ErrorLine,  
		Error_Message() as ErrorMessage,  
		Error_Number() as ErrorNumber,  
		Error_Procedure() as 'Sp_CLS_PeriodicWorkRecordSummaryReport_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END
GO
