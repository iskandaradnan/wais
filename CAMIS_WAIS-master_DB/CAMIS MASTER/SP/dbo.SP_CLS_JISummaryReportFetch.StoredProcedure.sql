USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_JISummaryReportFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_JISummaryReportFetch]          
  -- EXEC SP_CLS_JISummaryReportFetch  10389, 10373      
@Month int,          
@Year int          
        
as          
begin          
SET NOCOUNT ON;          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY         
          
 --select          
 --        Userareacode, UserAreaName,GrandTotalElementsInspected,Satisfactory,UnSatisfactory,NoofUserLocation          
 --        from CLS_JiDetails          
      
 DECLARE @YearName VARCHAR(15), @MonthName VARCHAR(15)      
      
 -- SELECT  *, FieldValue FROM FMLovMst WITH(NOLOCK)          
 --  WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'       
      
 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)          
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year        
      
 SELECT @MonthName = FieldValue  FROM FMLovMst WITH(NOLOCK)          
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month        
      
  -- SELECT @YearName, @MonthName      
      
   SELECT 1 AS [No], [UserAreaCode] , [UserAreaName],  Count([UserAreaCode]) as InspectionScheduled, SUM([Satisfactory]) AS Compliance,       
   SUM([UnSatisfactory]) AS NonCompliance,  SUM([GrandTotalElementsInspected]) AS TotalRatings , MAX([NoofUserLocation]) AS NoOfUserLocationsInspected      
   FROM       
 ( SELECT [DetailsId], [CustomerId], [FacilityId], [DocumentNo],   [DateTime],   [UserAreaCode], [UserAreaName], [HospitalRepresentative], [HospitalRepresentativeDesignation], [CompanyRepresentative], [CompanyRepresentativeDesignation], [Remarks], [ReferenceNo],   [Satisfactory], [NoofUserLocation], [UnSatisfactory], [GrandTotalElementsInspected], [NotApplicable], ISNULL([IsSubmitted],0) AS [IsSubmitted]        
 FROM CLS_JiDetails  WHERE [CustomerId] = [CustomerId] AND [FacilityId] = [FacilityId]      
  AND Year([DateTime]) = @YearName AND DATENAME(MONTH, [DateTime]) = @MonthName ) A      
  GROUP BY [UserAreaCode], [UserAreaName]       
        
      
 -- select convert(varchar(20), DateTime),* from CLS_JiDetails where     
  --Year([DateTime]) = '2020' AND DATENAME(MONTH, [DateTime]) = 'October'     
 --select 1 as No, 'ME11CP11' as UserAreaCode , 'M&amp;E Plant Room Level 1' UserAreaName, 6 as InspectionScheduled, 11 as Compliance, 2 as NonCompliance, 34 as TotalRatings, 44 as NoOfUserLocationsInspected        
                
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
 Error_Procedure() as 'SP_CLS_JISummaryReportFetch',          
 Error_Severity() as ErrorSeverity,          
 Error_State() as ErrorState,          
 GETDATE () as DateErrorRaised          
END CATCH          
END
GO
