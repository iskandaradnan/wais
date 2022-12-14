USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_WeekCalendar]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_WeekCalendar](
        @WeekCalendarId INT,
		@CustomerId int,
		@FacilityId int,
		@Year int)
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
		IF(@WeekCalendarId = 0)
		BEGIN
		INSERT INTO CLS_WeekCalendar (CustomerId,FacilityId,Year) VALUES(@CustomerId,@FacilityId,@Year)
	
		SELECT MAX(WeekCalendarId) as WeekCalendarId FROM CLS_WeekCalendar
	
		END
		ELSE
		BEGIN
		--UPDATE
		UPDATE CLS_WeekCalendar SET Year = @Year
	    WHERE WeekCalendarId=@WeekCalendarId
		END
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
	Error_Procedure() as 'SP_CLS_WeekCalendar',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
