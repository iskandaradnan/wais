USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DailyCleaningActivitySummaryReport_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec [dbo].[Sp_CLS_ChemicalInUse_Get] 35
CREATE PROC [dbo].[Sp_CLS_DailyCleaningActivitySummaryReport_Get]
(
	--@Month VARCHAR(50),
	--@Year INT
	@Date DATETIME
)
	
AS 
BEGIN
SET NOCOUNT ON
BEGIN TRY
	         
			 SELECT A.UserAreaCode,D.UserAreaName,A.A1,A.A2,A.A3,A.A4,A.B1,A.C1,A.D1,A.D2,A.D3,A.E1
			 From CLS_DailyCleaningActivityGridviewfields A
			 INNER JOIN CLS_DeptAreaDetails D ON A.UserAreaCode= D.Userareacode
			 INNER JOIN CLS_DailyCleaningActivity B ON A.DailyActivityId=B.DailyActivityId WHERE B.Date=@Date
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
		Error_Procedure() as 'Sp_CLS_DailyCleaningActivitySummaryReport_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END
GO
