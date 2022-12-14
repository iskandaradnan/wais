USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_WeekCalendarTable]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_WeekCalendarTable](
            @Month varchar(100),
			@WeekNo int,
			@StartDate datetime,
			@EndDate datetime,	
		    @WeekCalendarId INT)
		
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
	
		BEGIN
		
		INSERT INTO CLS_WeekCalendarTable VALUES(@Month,@WeekNo,@StartDate,@EndDate,@WeekCalendarId)
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
		Error_Procedure() as 'SP_CLS_WeekCalendarTable',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
end
select * from CLS_WeekCalendar
GO
