USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_WeekCalendar_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec SP_CLS_WeekCalendarGet 25, 25, 2019
CREATE procedure [dbo].[SP_CLS_WeekCalendar_Get](
		@CustomerId INT,
		@FacilityId INT,
		@Year INT  )		
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
		
		SELECT [Month], WeekNo,  StartDate,  EndDate
		 FROM CLS_WeekCalendar WHERE CustomerId = @CustomerId AND FacilityId = @FacilityId AND [Year] = @Year

		 
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
	Error_Procedure() as 'SP_CLS_WeekCalendarGet',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END

GO
