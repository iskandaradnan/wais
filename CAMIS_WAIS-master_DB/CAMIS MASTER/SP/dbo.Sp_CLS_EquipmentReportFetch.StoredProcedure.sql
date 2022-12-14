USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_EquipmentReportFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROC [dbo].[Sp_CLS_EquipmentReportFetch]        
      
 @Month INT, @Year INT        
  -- EXEC Sp_CLS_EquipmentReportFetch 10390, 10373  
         
AS         
BEGIN        
SET NOCOUNT ON        
BEGIN TRY        
                  
        
      
  DECLARE @YearName VARCHAR(15), @MonthValue VARCHAR(15), @Date Date   
 SELECT @YearName = FieldValue FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  AND LovId = @Year      
 SELECT @MonthValue = FieldCode  FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS' AND LovId = @Month     
  
    -- SELECT *  FROM FMLovMst WITH(NOLOCK)    
   -- WHERE Active = 1  AND LovKey='FacilityStatusLovs' AND ScreenName = 'FETC' and ModuleName = 'CLS'    
  
   SET @Date = Convert(dateTIME, @MonthValue + '/01/' + @YearName)  
  
    
  
 SELECT ItemCode as EquipmentCode , ItemDescription as EquipmentDescription,  Quantity , EffectiveFrom , EffectiveTo, B.FieldValue   FROM CLS_FETC A  
 JOIN FMLovMst B ON A.Status = B.LovId  
 WHERE  EffectiveFrom >  @Date  --and  EffectiveTo <= CASE When EffectiveTo is not null then @Date else EffectiveTo end  
 and B.Active = 1  AND B.LovKey='FacilityStatusLovs' AND B.ScreenName = 'FETC' and B.ModuleName = 'CLS' --AND B.FieldValue = 'Active'   
 Order by FETCId  
  
  -- SELECT @DATE  
 --select * from CLS_FETC  
  
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
