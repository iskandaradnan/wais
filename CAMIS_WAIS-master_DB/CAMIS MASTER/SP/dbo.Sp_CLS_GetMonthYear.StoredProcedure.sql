USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_GetMonthYear]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_GetMonthYear]
(
@Year int
)
AS
BEGIN
SET NOCOUNT ON;


BEGIN TRY

SELECT LovId, FieldValue, IsDefault FROM 
(
SELECT DISTINCT * FROM (
 SELECT  DENSE_RANK() OVER(ORDER BY MONTH([StartDate])) AS LovId, [Month] as FieldValue, 0 as IsDefault from CLS_WeekCalendar
  where Year = @Year 
 ) A  ) B

 

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
	Error_Procedure() as 'Sp_CLS_YearNameData',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
