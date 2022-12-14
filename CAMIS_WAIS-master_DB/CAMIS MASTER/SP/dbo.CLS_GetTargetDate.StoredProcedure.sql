USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[CLS_GetTargetDate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Author:      VENU GOPAL KADIYALA          
-- Create Date: <Create Date, , >          
-- Description: <Description, , >          
-- =============================================          
CREATE PROCEDURE [dbo].[CLS_GetTargetDate]          
(          
    -- Add the parameters for the stored procedure here          
     @Year INT,  @Month int,  @WeekNo INT , @TargetDate DATE OUTPUT        
)          
         
  -- DECLARE @TargetDate1 DATE; EXEC CLS_GetTargetDate 2021, 5 , 5 , @TargetDate1 OUTPUT; select @TargetDate1        
AS          
BEGIN          
    -- SET NOCOUNT ON added to prevent extra result sets from          
             
          
  --DECLARE @TargetDate DATE      
  DECLARE @CurrentDate DATE = getdate()        
  DECLARE @StartDate Date             
  DECLARE @EndDate Date          
  Declare @MonthName VARCHAR(12)          
  DECLARE @FirstDay DATE           
  DECLARE @LastDay DATE          
  DECLARE @YEAR1 INT     
  DECLARE @Month1 INT = 8      
   DECLARE @Day1 int    
   -- insert first week          
   -- First Day of Month          
   SET @FirstDay = CONVERT(DATE, CONVERT(VARCHAR(10), @Month) + '/' + CONVERT(VARCHAR(2), 1)  + '/' + CONVERT(VARCHAR(10), @Year ))          
   SET @LastDay  = CAST(eomonth(@FirstDay) AS date)          
 SET @MonthName = DATENAME(MM,@FirstDay)          
           
         
  set @Day1 = 15      
  SET @YEAR1 = YEAR(getdate())    
          
  IF(@CurrentDate > CONVERT(DATE, CONVERT(VARCHAR(10), @Month1) + '/' + CONVERT(VARCHAR(2), @Day1)  + '/' + CONVERT(VARCHAR(10), @Year1 )) )      
  BEGIN      
  SET @WeekNo = 6      
  END      
 --select @FirstDay, @LastDay, @MonthName          
          
            
  DECLARE  @tblWeekDays TABLE([Year] int, [Month] varchar(12), [StartDate] date, [EndDate] Date, WeekNum int)          
  DECLARE  @tblMISWeekDays TABLE([WeekDates] date, [WeekDay] varchar(12))          
          
  INSERT INTO @tblWeekDays          
   SELECT  [Year], [Month], [StartDate], [EndDate], ROW_NUMBER() OVER (ORDER BY WeekNo ASC) AS rowNum           
   FROM CLS_WeekCalendar where Year = @Year and Month = @MonthName          
               
    --SELECT  * FROM @tblWeekDays           
   SELECT top 1  @StartDate = StartDate  FROM @tblWeekDays order by WeekNum           
   SELECT top 1  @EndDate = EndDate  FROM @tblWeekDays order by WeekNum desc          
          
   --select @StartDate, @EndDate          
            
          
   While( @FirstDay < @StartDate)          
   BEGIN          
  INSERT INTO @tblMISWeekDays select @FirstDay , DATENAME(WEEKDAY, @FirstDay )          
  SET @FirstDay = DATEADD(DAY, 1,  @FirstDay)          
   END          
          
   --SELECT * FROM @tblMISWeekDays          
          
   IF(EXists(select 1 from @tblMISWeekDays where [WeekDay] not in ('Saturday' , 'Sunday')))          
   BEGIN          
 UPDATE @tblWeekDays set WeekNum = WeekNum + 1          
 INSERT INTO @tblWeekDays values( @Year, @MonthName,           
 (Select top 1  [WeekDates]  from @tblMISWeekDays where [WeekDay] not in ('Sunday')  order by [WeekDates]),           
 (Select top 1  [WeekDates]  from @tblMISWeekDays where [WeekDay] not in ('Sunday') order by [WeekDates] desc), 1)          
   END          
          
          
  -- update last week date          
  if(@LastDay < @EndDate)          
  begin          
 update @tblWeekDays set EndDate = @LastDay where WeekNum = ( select max(WeekNum) from @tblWeekDays )          
  end          
          
  -- insert last week          
  if( @LastDay > @EndDate)          
  begin          
  delete @tblMISWeekDays          
  While( @EndDate < @LastDay)          
  BEGIN          
   INSERT INTO @tblMISWeekDays select @EndDate , DATENAME(WEEKDAY, @EndDate )          
   SET @EndDate = DATEADD(DAY, 1,  @EndDate)          
  END          
          
  end          
          
            
          
   if(EXists(select 1 from @tblMISWeekDays where [WeekDay] not in ('Saturday' , 'Sunday')))          
   begin          
            
  INSERT INTO @tblWeekDays values( @Year, @MonthName , ( Select top 1  [WeekDates]  from @tblMISWeekDays order by [WeekDates] ),           
  ( Select top 1  [WeekDates]  from @tblMISWeekDays order by [WeekDates] desc ), (select max(WeekNum)+ 1 from @tblWeekDays) )          
          
   end          
          
    select @TargetDate =  DATEADD(DAY, 1,  EndDate)  from @tblWeekDays where WeekNum = @WeekNo          
          
  IF(@TargetDate > @LastDay)          
   SET @TargetDate = @LastDay          
          
         
 --PRINT @TargetDate        
 -- SELECT @TargetDate          
            
END
GO
