USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_ToiletInspectionSummaryReportFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROC [dbo].[SP_CLS_ToiletInspectionSummaryReportFetch]      
--- EXEC SP_CLS_ToiletInspectionSummaryReportFetch  10376, 10373        
(        
 @Month INT,        
 @Year INT        
)        
         
AS         
BEGIN        
SET NOCOUNT ON        
BEGIN TRY        
                    
    
  DECLARE @YearName VARCHAR(15), @MonthName VARCHAR(15) , @YearLovId INT, @MonthLovId INT    
    
 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year     
        
 SELECT  @MonthName = FieldValue  FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month    
     
 IF(EXISTS( SELECT 1 FROM CLS_ToiletInspectionTxn WHERE Year([Date]) = @YearName AND DATENAME(MONTH, [Date]) = @MonthName AND CustomerId = CustomerId and FacilityId = FacilityId  ))  
 BEGIN  
   select SUM(TotalDone) as TotalDone, SUM(TotalNotDone) AS TotalNotDone , SUM(TotalDone + TotalNotDone )  AS TotalToiletLocations FROM CLS_ToiletInspectionTxn     
 WHERE Year([Date]) = @YearName AND DATENAME(MONTH, [Date]) = @MonthName AND CustomerId = CustomerId and FacilityId = FacilityId   
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
  Error_Procedure() as 'Sp_CLS_PeriodicWorkRecordSummaryReport_Get',          
  Error_Severity() as ErrorSeverity,          
  Error_State() as ErrorState,          
  GETDATE () as DateErrorRaised           
END CATCH        
END
GO
