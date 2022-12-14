USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_TransportationReportFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[SP_HWMS_TransportationReportFetch]    
   
 @Month INT,    
 @Year INT  
   
     
AS     
BEGIN    
SET NOCOUNT ON    
BEGIN TRY    
  
                   DECLARE @YearName VARCHAR(15), @MonthName VARCHAR(15) , @YearLovId INT, @MonthLovId INT

 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)    
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year 
    
 SELECT @MonthName = FieldValue  FROM FMLovMst WITH(NOLOCK)    
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month
              
   -- SELECT 'sdfsdfsd' as ConsignmentNote, '4-5-2020' as Date, 6 as QCValue, '' as VehicleNumber, 'dfsdfgdfgs' as DriverName , 'Yes' as ONSchedule 
	
	  SELECT ConsignmentNoteNo as ConsignmentNote, CONVERT(varchar,[DateTime],109)  as [Date], B.FieldValue as QCValue, 
	  VehicleNo as VehicleNumber, DriverName , C.FieldValue as ONSchedule
		FROM HWMS_ConsignmentNoteCWCN A
	  LEFT JOIN FmLovMst B ON A.QC = B.LovId
	  LEFT JOIN FmLovMst C ON A.ONSchedule = C.LovId
	  WHERE  Year(A.[DATETIME]) = @YearName AND DATENAME(MONTH, A.[DATETIME]) = @MonthName -- AND B.CustomerId = B.CustomerId and B.FacilityId = B.FacilityId
  
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
