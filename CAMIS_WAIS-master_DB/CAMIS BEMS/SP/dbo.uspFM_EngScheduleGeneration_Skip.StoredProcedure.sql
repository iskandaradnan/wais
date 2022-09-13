USE [UetrackBemsdbPreProd]
GO

/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGeneration_Skip]    Script Date: 27-12-2021 15:35:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

              
              
/*========================================================================================================              
           
-----------------------------------------------------------------------------------------------------------              
              
Unit Test:              
EXEC [uspFM_EngScheduleGeneration_Skip]  @pCustomerId=1,@pFacilityId=1,@pWorkGroupId=1,@pTypeOfPlanner=34,@pYear=2018,@pWeekNo=3,@pWeekStartDate='2018-01-01 00:00:00.000',@pWeekEndDate='2018-01-20 00:00:00.000',              
@pUserId=1,@pPageIndex=1,@pPageSize=5,@pUserAreaId = NULL, @pUserLocationId= NULL              
              
-----------------------------------------------------------------------------------------------------------              
Version History               
-----:------------:---------------------------------------------------------------------------------------              
Init : Date       : Details              
========================================================================================================*/              
DROP PROCEDURE  [dbo].[uspFM_EngScheduleGeneration_Skip]  
GO
CREATE PROCEDURE  [dbo].[uspFM_EngScheduleGeneration_Skip]                  
  @pFacilityId  INT,              
  @pCustomerId  INT,              
  @pWorkGroupId  INT,              
  @pTypeOfPlanner  INT,              
  @pYear    INT,              
  @pWeekNo   INT,              
  @pWeekStartDate  DATETIME,              
  @pWeekEndDate  DATETIME,              
  @pUserId   INT,              
  @pPageIndex   INT,              
  @pPageSize   INT,  
  @pModuleId   INT,              
  @pUserAreaId  INT = NULL,              
  @pUserLocationId INT = NULL              
AS                                                             
              
BEGIN TRY              
              
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT              
              
              
 SET NOCOUNT ON;               
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;              
 
 declare @ServiceId int,@id int 



 INSERT INTO EngScheduleGenerationWeekLog ( FacilityId,              
            CustomerId,              
            ServiceId,              
            TypeOfPlanner,              
            Year,              
            WeekNo,              
            WeekStartDate,              
            WeekEndDate,              
            GenerateDate,              
            WorkGroupId,              
            CreatedBy,              
		    CreatedDate,              
            CreatedDateUTC,              
            ModifiedBy,              
            ModifiedDate,              
            ModifiedDateUTC    
			,DocumentNo

			,ClassificationId           
           )               
         VALUES ( @pFacilityId,              
            @pCustomerId,              
            @pModuleId,              
            @pTypeOfPlanner,              
            @pYear,              
            iif(@pWeekNo=0,1,@pWeekNo),              
            @pWeekStartDate,              
            @pWeekEndDate,              
            GETDATE(),              
           1 ,              
            @pUserId,              
            GETDATE(),              
            GETUTCDATE(),              
            @pUserId,              
            GETDATE(),              
            GETUTCDATE() ,
			00000,
			0             
           )   

		   select 'Updated'  [Status]--convert(nvarchar(max),scope_identity())
		 
              
END TRY              
              
BEGIN CATCH              
              
          
              
 INSERT INTO ErrorLog(              
    Spname,              
    ErrorMessage,              
    createddate)              
 VALUES(  OBJECT_NAME(@@PROCID),              
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),              
    getdate()              
     );              
   THROW;              
              
END CATCH
GO


