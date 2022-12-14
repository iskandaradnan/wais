USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_PeriodicWorkRecordSummaryReportFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     
CREATE PROC [dbo].[Sp_CLS_PeriodicWorkRecordSummaryReportFetch] 
--- EXEC Sp_CLS_PeriodicWorkRecordSummaryReportFetch  10390, 10373     
(      
 @Month INT,      
 @Year INT      
)      
       
AS       
BEGIN      
SET NOCOUNT ON      
BEGIN TRY      

 --SELECT * FROM FMLovMst WITH(NOLOCK)    
 --  WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'

 DECLARE @YearName VARCHAR(15), @MonthName VARCHAR(15) , @YearLovId INT, @MonthLovId INT

 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)    
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year 
    
 SELECT @MonthName = FieldValue  FROM FMLovMst WITH(NOLOCK)    
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month

    --  SELECT @YearName, @MonthName

	    SELECT @YearLovId = lovId   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1  AND LovKey='PeriodicYearValues' AND ModuleName='CLS' AND FieldValue = @YearName 
  
   SELECT @MonthLovId = LovId  FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1  AND LovKey='PeriodicMonthValues'  AND ModuleName='CLS'  AND FieldValue = @MonthName
   
  -- SELECT @YearLovId, @MonthLovId

   SELECT UserAreaCode, UserAreaName, SUM( CASE WHEN FieldValue = 'Done' then 1 else 0 end) as [Done] , 
   SUM(  CASE WHEN FieldValue = 'Not Done' then 1 else 0 end ) as [NotDone] , Count(FieldValue) as TotalCount
    FROM   
    ( SELECT  A.UserAreaCode,D.UserAreaName, C.FieldValue    
    From CLS_PeriodicWorkRecordTable A              
    INNER JOIN CLS_DeptAreaDetails D ON A.UserAreaCode= D.Userareacode      
    INNER JOIN CLS_PeriodicWorkRecord B ON A.PeriodicId=B.PeriodicId  
	LEFT JOIN FMLovMst C ON A.Status = C.LovId   
	WHERE B.Month=@MonthLovId AND B.Year= @YearLovId   ) A
	GROUP BY UserAreaCode, UserAreaName
	
	-- select * from CLS_PeriodicWorkRecordTable A where 
	   
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
