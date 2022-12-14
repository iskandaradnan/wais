USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DailyCleaningActivitySummaryReportFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- EXEC Sp_CLS_DailyCleaningActivitySummaryReportFetch  10390, 10373    
CREATE PROC [dbo].[Sp_CLS_DailyCleaningActivitySummaryReportFetch]        
       
 @Month INT,        
 @Year INT        
          
AS         
BEGIN        
SET NOCOUNT ON        
BEGIN TRY        
                  
    
 DECLARE @YearName VARCHAR(15), @MonthName VARCHAR(15)    
 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year      
 SELECT @MonthName = FieldValue  FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month      
           
      
     
 SELECT 1 as [No], A.UserAreaCode,B.UserAreaName, SUM(A.A1) AS A1, SUM(A.A2) AS A2, SUM(A.A3) AS A3, SUM(A.A4) AS A4, SUM(A.A5) AS A5, SUM(A.B1) AS B1, SUM(A.C1) AS C1, SUM(A.D1) AS D1, SUM(A.D2) AS D2, SUM(A.D3) AS D3, SUM(A.E1) AS E1     
  FROM CLS_DailyCleaningActivityGridviewfields  A     
 INNER JOIN CLS_DeptAreaDetails B ON A.UserAreaCode= B.Userareacode      
 JOIN FMLOVMST C ON A.Status = C.LovId  
 where A.DailyActivityId in      
 ( SELECT DailyActivityId FROM CLS_DailyCleaningActivity WHERE Year([Date]) = @YearName AND DATENAME(MONTH, [Date]) = @MonthName )    
 and C.ModuleName = 'CLS' and C.ScreenName = 'DailyCleaningActivity' and C.LovKey = 'DCAStatusValues' and C.FieldValue = 'Done'  
 GROUP BY A.UserAreaCode,B.UserAreaName     
    
  
  -- SELECT * FROM CLS_DailyCleaningActivityGridviewfields  
  -- SELECT * FROM FMLOVMST WHERE ModuleName = 'CLS' and ScreenName = 'DailyCleaningActivity' and LovKey = 'DCAStatusValues' and FieldValue = 'Done' LovId = 10739  
    
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
