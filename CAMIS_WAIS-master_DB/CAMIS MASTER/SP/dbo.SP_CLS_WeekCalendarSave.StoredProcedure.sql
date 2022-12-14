USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_WeekCalendarSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_WeekCalendarSave](
		@Customerid INT,
		@Facilityid INT,
		@Year INT,
        @Month VARCHAR(50),
		@WeekNo INT,
		@StartDate DATE,
		@EndDate DATE
		)		
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
		IF(EXISTS(SELECT 1 FROM CLS_WeekCalendar WHERE CustomerId = @Customerid AND  FacilityId = @Facilityid AND [Year] = @Year AND WeekNo = @WeekNo))
		BEGIN
			UPDATE  CLS_WeekCalendar SET [Month] = @Month, StartDate = @StartDate, EndDate = @EndDate WHERE CustomerId = @Customerid AND  FacilityId = @Facilityid AND [Year] = @Year AND WeekNo = @WeekNo 
					
		END
		ELSE
		BEGIN
		--UPDATE
			INSERT CLS_WeekCalendar Values ( @Customerid, @Facilityid, @Year, @Month, @WeekNo, @StartDate , @EndDate )
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
