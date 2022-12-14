USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CRMReportFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
CREATE PROC [dbo].[Sp_CLS_CRMReportFetch]             
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
      
 SELECT RequestNo, CONVERT(VARCHAR, RequestDateTime, 120) as RequestDate, RequestDescription as RequestDetails, ISNULL(C.UserAreaName, '') as UserArea, ISNULL(D.StaffName,'') as Requester, B.FieldValue as TypeOfRequest, ISNULL(CONVERT(VARCHAR,TargetDate,120),'') as Completion, ISNULL(DATEDIFF(DAY, RequestDateTime, TargetDate), 0) as Ageing, CASE WHEN A.StatusValue = 'Approve' then 'Closed' else A.StatusValue end  as [Status]   
  FROM CRMRequest A      
  LEFT JOIN MstLocationUserArea C ON A.UserAreaId = C.UserAreaId      
  LEFT JOIN UMUserRegistration D ON A.Requester = D.UserRegistrationId      
  LEFT JOIN FMLovMst B ON A.TypeOfRequest = B.LovId       
 WHERE B.Active = 1  AND B.ScreenName = 'CRM' and B.FieldName = 'CRMRequestType'  AND A.ServiceId = 3      
 AND Year(A.[RequestDateTime]) = @YearName AND DATENAME(MONTH, A.[RequestDateTime]) = @MonthName AND A.CustomerId = A.CustomerId and A.FacilityId = A.FacilityId       
      
    
      
      
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
