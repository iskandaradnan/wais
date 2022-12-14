USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_WeighingSummaryReportFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROC [dbo].[SP_HWMS_WeighingSummaryReportFetch]        
(        
 @Month INT,        
 @Year INT,      
 @WasteCategory VARCHAR(100)        
)        
         
AS         
BEGIN        
SET NOCOUNT ON        
BEGIN TRY        
      
                               
               DECLARE @YearName VARCHAR(15), @MonthName VARCHAR(15) , @YearLovId INT, @MonthLovId INT    
    
 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year     
        
 SELECT @MonthName = FieldValue  FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month    
        
    
   SELECT C.WasteCategory,  ISNULL( B.ConsignmentNoteNo, '' ) as [ConsignmentNo], A.[TotalWeight],     
   A.[TotalNoofBins] as NoofBins , FORMAT([Date], 'dd-MMM-yyyy') AS [Date]        
  FROM HWMS_DailyWeighingRecord A        
  JOIN HWMS_ConsignmentNoteOsWCN B ON A.ConsignmentNo = B.ConsignmentOSWCNId     
  JOIN HWMS_WasteType C ON B.WasteType = C.WasteType  
  WHERE Year(A.[Date]) = @YearName AND DATENAME(MONTH, A.[Date]) = @MonthName -- AND B.CustomerId = B.CustomerId and B.FacilityId = B.FacilityId    
  and C.WasteCategory = @WasteCategory  
  
   --select * from HWMS_DailyWeighingRecord  
   --select * from HWMS_ConsignmentNoteOsWCN  
   --select * from FMLovMst where FieldName = 'WasteCategory' and ScreenName = 'Waste Type' LovId = 10565  
   --select * from HWMS_WasteType  
    
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
