USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_RecordSheetWithoutCN]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROC [dbo].[SP_HWMS_RecordSheetWithoutCN]      
     
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
                
    
 SELECT  FORMAT( [DATETIME] , 'dd-MMM-yyyy') as DateOfConsignmentNote, ConsignmentNoteNo as ConsignmentNo,    
 ISNULL(TotalWeight,0) AS TotalWeight  , ChargeRM as RM FROM HWMS_ConsignmentNoteOSWCN      
  WHERE  Year([DATETIME]) = @YearName AND DATENAME(MONTH, [DATETIME]) = @MonthName -- AND B.CustomerId = B.CustomerId and B.FacilityId = B.FacilityId   
  
                
    --SELECT  '4-5-2020' as DateOfConsignmentNote, 6 as ConsignmentNo, 454 as TotalWeight, 'dfsdfgdfgs' as RM     
    
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
