USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_Reports_Load]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
CREATE proc [dbo].[Sp_CLS_Reports_Load]       
       
@pScreenName nvarchar(400)       
       
AS        
        
BEGIN TRY        
        
        
SET NOCOUNT ON;       
        
   SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='YearValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'  ORDER BY SortNo    
          
      
    SELECT LovId, FieldValue, IsDefault, SortNo FROM FMLovMst WITH(NOLOCK)        
   WHERE Active = 1  AND LovKey='MonthValue' AND ScreenName = 'WeekCalendar' and ModuleName = 'CLS'       
      
  select LovId, FieldValue, IsDefault  from FMLovMst     
  where Active = 1  AND ScreenName = 'CRM' and FieldName = 'CRMRequestType'    
    
  select LovId, FieldValue, IsDefault from FMLovMst     
  where Active = 1  AND LovKey = 'WasteTypeValues' and ScreenName = 'Waste Type'    
        
END TRY        
        
BEGIN CATCH        
        
INSERT INTO ErrorLog(        
Spname,        
ErrorMessage,        
createddate)        
VALUES( OBJECT_NAME(@@PROCID),        
'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),        
getdate()        
)        
        
END CATCH
GO
