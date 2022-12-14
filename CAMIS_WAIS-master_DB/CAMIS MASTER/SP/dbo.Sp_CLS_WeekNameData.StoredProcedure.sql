USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_WeekNameData]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[Sp_CLS_WeekNameData] '2019_February'    
CREATE procedure [dbo].[Sp_CLS_WeekNameData]    
(    
@YearMonth VARCHAR(50)    
)    
AS    
BEGIN    
SET NOCOUNT ON;    
    
BEGIN TRY    
    
    
    
DECLARE @YEAR VARCHAR(10);    
DECLARE @Month VARCHAR(20);    
    
SELECT  TOP 1 @YEAR = value  FROM  STRING_SPLIT(@YearMonth, '_');    
SELECT  TOP 2 @Month = value  FROM  STRING_SPLIT(@YearMonth, '_');    
    
    
--SELECT  WeekNo as LovId, WeekNo as FieldValue, 0 as IsDefault from CLS_WeekCalendar where Month = @Month and Year = @YEAR   
  
 if(@Month = 'February')  
  select 1 as LovId, 1 as FieldValue, 0 as IsDefault   
  union  
  select 2 as LovId, 2 as FieldValue, 0 as IsDefault   
  union  
  select 3 as LovId, 3 as FieldValue, 0 as IsDefault   
  union  
  select 4 as LovId, 4 as FieldValue, 0 as IsDefault     
 else  
  select 1 as LovId, 1 as FieldValue, 0 as IsDefault   
  union  
  select 2 as LovId, 2 as FieldValue, 0 as IsDefault   
  union  
  select 3 as LovId, 3 as FieldValue, 0 as IsDefault   
  union  
  select 4 as LovId, 4 as FieldValue, 0 as IsDefault    
  union  
  select 5 as LovId, 5 as FieldValue, 0 as IsDefault  
  
    
    
    
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
 Error_Procedure() as 'Sp_CLS_WeekNameData',      
 Error_Severity() as ErrorSeverity,      
 Error_State() as ErrorState,      
 GETDATE () as DateErrorRaised      
END CATCH    
end
GO
