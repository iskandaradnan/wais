USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_JIScheduleGenerationFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[SP_CLS_JIScheduleGenerationFetch] 2021, 5, 1          
CREATE procedure [dbo].[SP_CLS_JIScheduleGenerationFetch]              
            -- SELECT * FROM CLS_JIScheduleGeneration WHERE [YEAR] = 2021 AND [MONTH] = 5 AND [Week] = 1  
@Year INT,              
@Month int,              
@WeekNo INT              
              
AS              
BEGIN              
SET NOCOUNT ON;              
              
BEGIN TRY              
              
 IF(EXISTS(SELECT * FROM CLS_JIScheduleGeneration WHERE [YEAR] = @Year AND [MONTH] = @Month AND [Week] = @WeekNo))              
 BEGIN              
                  
  SELECT UserAreaCode, UserAreaName, [Day] as [JISchedule], TargetDate, [STATUS],       
   REPLACE( ISNULL((        
  SELECT * FROM (SELECT B.LocationCode as UserLocationCode, D.UserLocationName as UserLocationName,      
  CASE WHEN B.[Floor] = 'True' then '' else 'NA' end as [F],       
  CASE WHEN B.[Walls] = 'True' then '' else 'NA' end as [W],       
  CASE WHEN B.[Celling] = 'True' then '' else 'NA' end as [C],       
  CASE WHEN B.[WindowsDoors] = 'True' then '' else 'NA' end as [WD],       
  CASE WHEN B.[ReceptaclesContainers] = 'True' then '' else 'NA' end as [R],       
  CASE WHEN B.[FurnitureFixtureEquipments] = 'True' then '' else 'NA' end as [FF]      
   from CLS_DeptAreaDetailsLocation B      
  join CLS_DeptAreaDetails C ON C.DeptAreaId = B.DeptAreaId      
  JOIN MstLocationUserLocation D ON B.LocationCode = D.UserLocationCode           
   where  A.UserAreaCode = C.UserAreaCode AND       
   B.Status = 1 ) K FOR JSON AUTO ), '') , '''', '')  as UserAreaLocations       
 FROM CLS_JIScheduleDocument A where         
   JIId = ( SELECT TOP 1 JIID FROM CLS_JIScheduleGeneration WHERE [YEAR] = @Year AND [MONTH] = @Month AND [Week] = @WeekNo )             
           
  --SELECT * FROM CLS_DeptAreaDetails      
    -- select * from CLS_DeptAreaDetailsLocation      
 --  select top 100 * from MstLocationUserLocation      
 END              
 ELSE              
 BEGIN              
                
    
  DECLARE @TargetDate Date     
  DECLARE @StartDate Date            
  DECLARE @STATUS INT = 0    
   
               
   EXEC CLS_GetTargetDate @Year, @Month , @WeekNo, @TargetDate OUTPUT;  
   --SELECT @TargetDate  
  
            
 select @STATUS = LovId from FMLovMst where ScreenName = 'JIScheduleGeneration' and LovKey = 'StatusJIValues' and FieldValue = 'Open'             
              
 SELECT  UserAreaCode, UserAreaName, C.FieldValue As [JISchedule]              
   ,ISNULL( CONVERT(varchar(10), DAY(@TargetDate)) + '-' +  UPPER(CONVERT(varchar(3), DATENAME(m, @TargetDate))) + '-' + DATENAME(YEAR, @TargetDate) , '') AS TargetDate, @STATUS AS [STATUS], DeptAreaId         
    , REPLACE( ISNULL((      
 SELECT * FROM (select D.LocationCode as UserLocationCode, E.UserLocationName as UserLocationName,      
   CASE WHEN D.[Floor] = 'True' then '' else 'NA' end as [F],       
  CASE WHEN D.[Walls] = 'True' then '' else 'NA' end as [W],       
  CASE WHEN D.[Celling] = 'True' then '' else 'NA' end as [C],       
  CASE WHEN D.[WindowsDoors] = 'True' then '' else 'NA' end as [WD],       
  CASE WHEN D.[ReceptaclesContainers] = 'True' then '' else 'NA' end as [R],       
  CASE WHEN D.[FurnitureFixtureEquipments] = 'True' then '' else 'NA' end as [FF]      
 FROM CLS_DeptAreaDetailsLocation D      
 JOIN MstLocationUserLocation E ON D.LocationCode = E.UserLocationCode          
   where D.DeptAreaId = A.DeptAreaId And D.[Status] = 1 ) K FOR JSON AUTO), '') , '''', '')  as UserAreaLocations        
 FROM CLS_DeptAreaDetails A       
 JOIN FMLovMst B ON A.Status = B.LovId               
 LEFT JOIN FMLovMst C ON A.JISchedule = C.LovId               
 WHERE B.FieldValue = 'Active'              
          
          
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
 Error_Procedure() as 'SP_CLS_JIScheduleGenerationFetch',                
 Error_Severity() as ErrorSeverity,                
 Error_State() as ErrorState,                
 GETDATE () as DateErrorRaised                
END CATCH              
end
GO
