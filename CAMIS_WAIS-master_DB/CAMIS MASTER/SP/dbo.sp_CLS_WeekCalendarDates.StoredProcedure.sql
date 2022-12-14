USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_WeekCalendarDates]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_WeekCalendarDates]
 -- EXEC [dbo].[sp_CLS_WeekCalendarDates] 25, '2020'
@FacilityId INT,
@YEAR VARCHAR(50)
            

as
begin
SET NOCOUNT ON; 
BEGIN TRY

	DECLARE @tblHolidays TABLE (
    Lovid int,
	WeekDay varchar(50)
	)
	DECLARE @weeklyholdy varchar(max) = (select WeeklyHoliday from MstLocationFacility where FacilityId = @FacilityId )

	IF(@weeklyholdy is null  )
		BEGIN
			INSERT INTO @tblHolidays SELECT 1 Lovid, 'Sunday' WeekDay 			
			INSERT INTO @tblHolidays SELECT 3 Lovid, 'Saturday' WeekDay 
		END 
	ELSE 
		BEGIN 
			INSERT INTO @tblHolidays select b.WeekDayId as Lovid, b.WeekDay from SplitString(@weeklyholdy, ',') a
			INNER JOIN FMTimeWeekDay b on a.Item = b.WeekDayId
		END 
	
	IF OBJECT_ID(N'tempdb..##WeekDateDay') IS NOT NULL
		BEGIN
			DROP TABLE #WeekDateDay
		END
			

	CREATE table #WeekDateDay(WeekNumber int, [Month] varchar(30), FirstDay Date, LastDay Date )
	DECLARE @Output table(id int, CurrentWeekdays date, DateType varchar(50))
	 
	-- DELETE #WeekDateDay
	 DECLARE @StartDayOfYear date
	 SET  @StartDayOfYear = CONVERT(DATE, '01/01/' +  @YEAR, 101)   
	 Declare @FirstDay date, @LastDayOfFirstWeek Date, @NoOfWeekEnds int = 0, @WeekNo int = 1
	 SELECT @NoOfWeekEnds = COUNT(1) FROM @tblHolidays

	 IF(@NoOfWeekEnds != 0)
	 BEGIN

		 IF(EXISTS(SELECT 1 FROM @tblHolidays WHERE WeekDay = DATENAME(dw, @StartDayOfYear)))
		 BEGIN		
			IF(NOT EXISTS(SELECT 1 FROM @tblHolidays WHERE WeekDay = DATENAME(dw,DATEADD(DAY, 1, @StartDayOfYear))))
			BEGIN
				SET @FirstDay = DATEADD(DAY, 1, @StartDayOfYear)
			END
			ELSE
			BEGIN
				SET @FirstDay = DATEADD(DAY, 2, @StartDayOfYear)
			END	
		 END
		 ELSE
		 BEGIN
			SET @FirstDay = @StartDayOfYear
		 END

		 SET @LastDayOfFirstWeek = @FirstDay

		 WHILE(NOT EXISTS(SELECT 1 FROM @tblHolidays WHERE WeekDay = DATENAME(dw, @LastDayOfFirstWeek))) 
		 BEGIN
			SET @LastDayOfFirstWeek = DATEADD(DAY, 1, @LastDayOfFirstWeek)
			PRINT @LastDayOfFirstWeek
		 END

		 SET @LastDayOfFirstWeek = DATEADD(DAY, -1, @LastDayOfFirstWeek)

	 END
	 ELSE
	 BEGIN
		SET @FirstDay = @StartDayOfYear
		SET @LastDayOfFirstWeek = DATEADD(DAY, 7, @FirstDay)
	 END

	 

	  WHILE(@WeekNo <= 53)
	  BEGIN
		IF(@WeekNo = 1)
		BEGIN
			INSERT INTO #WeekDateDay VALUES ( @WeekNo, DATENAME(mm, @FirstDay), @FirstDay, @LastDayOfFirstWeek )
		END
		ELSE
		BEGIN
			SET @FirstDay = DATEADD(DAY, @NoOfWeekEnds + 1, @LastDayOfFirstWeek )
			SET @LastDayOfFirstWeek = DATEADD(DAY, 7 - @NoOfWeekEnds - 1, @FirstDay )

			INSERT INTO #WeekDateDay VALUES ( @WeekNo, DATENAME(mm, @FirstDay), @FirstDay, @LastDayOfFirstWeek )
		END		
		SET @WeekNo = @WeekNo + 1;
	  END

	  SELECT * FROM #WeekDateDay
	
	  DROP TABLE #WeekDateDay

END TRY 
BEGIN CATCH  
    insert into ExceptionLog (  
	ErrorLine, ErrorMessage, ErrorNumber,  
	ErrorProcedure, ErrorSeverity, ErrorState,  
	DateErrorRaised  
	)
SELECT  
	ERROR_LINE () as ErrorLine,  
	Error_Message() as ErrorMessage,  
	Error_Number() as ErrorNumber,  
	Error_Procedure() as 'sp_CLS_WeekCalendar',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH
end
GO
