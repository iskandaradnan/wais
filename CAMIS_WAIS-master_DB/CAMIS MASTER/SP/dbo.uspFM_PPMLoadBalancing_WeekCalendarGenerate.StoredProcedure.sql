USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPMLoadBalancing_WeekCalendarGenerate]    Script Date: 18-01-2022 13:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-Master              
Version				: 1.0
Procedure Name		: uspFM_PPMLoadBalancing_WeekCalendarGenerate
Description			: To generate week no and Start, End Date of week for PPMLoadBalancing. It should be executed in every year 1st day
Authors				: Balaganesh
Date				: 17-January-2022
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_PPMLoadBalancing_WeekCalendarGenerate 

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_PPMLoadBalancing_WeekCalendarGenerate]                           
		

AS                                               

BEGIN TRY

declare @Yearcount int;
set @Yearcount=(select count(Autoid) from PPMLoadBalanceWeekCalendar where year=datepart(year, getdate()))
SET DATEFIRST 1; -- This command set "Monday" as First Day of week
If @Yearcount =0
BEGIN

declare @dt date = {fn current_date()};
declare @start_of_year date = datefromparts(year(@dt), 1, 1);

with digits(d) as (
    select 0 union all select 1 union all select 2 union all select 3 union all
    select 4 union all select 5 union all select 6 union all select 7
), wks as (
    select
        dateadd(week, d1.d * 8 + d0.d, dateadd(day, 1-datepart(weekday, @start_of_year), @start_of_year)) as week_start,
        d1.d * 8 + d0.d as wk
    from digits as d0 cross join digits as d1
)
select

    case when year(week_start) < year(@dt)
        then @start_of_year else week_start end as week_start,
    case when year(dateadd(day, 6, week_start)) > year(@dt)
        then datefromparts(year(@dt), 12, 31) else dateadd(day, 6, week_start) end as week_end,
		Datepart(year,@dt) as year
		--drop table #DTTEMP
		INTO #DTTEMP
from wks
where wk between 0 and 53 and year(week_start) = year(@dt)
order by week_start;

insert into PPMLoadBalanceWeekCalendar (Year,Month,Week,Week_start,Week_end,CreatedDatetime)
Select 
Year,LEFT(DATENAME(MONTH , DATEADD( MONTH , MONTH(week_start) , 0 ) - 1 ),3)  Month,
ROW_Number() over( partition by DATENAME(MONTH , DATEADD( MONTH , MONTH(week_start) , 0 ) - 1 ) order by week_start) as Week,
Week_start, 
case when datediff(dd,Week_start,Week_end)=6 then Week_end else dateadd(D,6,Week_start) end as
Week_end,getdate() from #DTTEMP order by week_start

END

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
