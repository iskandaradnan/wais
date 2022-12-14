USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGenerationWeekLog_GetAll]    Script Date: 27-12-2021 15:06:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : uspFM_EngScheduleGenerationWeekLog_GetAll      
Description   : Get the Deduction_DashBoard      
Authors    : Dhilip V      
Date    : 11-May-2018      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
--EXEC uspFM_EngScheduleGenerationWeekLog_GetAll  @pFacilityId=144,@pWorkGroupId=161,@pTypeOfPlanner=343,@pYear=2021      
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
ALTER PROCEDURE  [dbo].[uspFM_EngScheduleGenerationWeekLog_GetAll]          
  @pFacilityId INT,      
  @pWorkGroupId INT,      
  @pTypeOfPlanner INT,      
  @pYear   INT      
AS                                                     
      
BEGIN TRY      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;       
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      
-- Declaration      
      
      
-- Default Values      
      
DECLARE @mWeekNum INT,      
  @mYearNum char(4),      
  @mStartOfWeek datetime,      
  @mEndOfWeek datetime      
      
-- Execution      
      
 set @mYearNum = @pYear      
      
 SELECT  @mWeekNum = ISNULL(WeekNo,0)+1      
 FROM EngScheduleGenerationWeekLog      
 WHERE ServiceId = 1      
   AND FacilityId = @pFacilityId      
   AND ClassificationId = @pWorkGroupId      
   AND TypeOfPlanner = @pTypeOfPlanner      
   AND Year = @pYear      
      
      
if year (DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + @mYearNum) + (@mWeekNum-1), 7)) != @pYear      
begin       
 SELECT  @mWeekNum = ISNULL(WeekNo,0)+1      
 FROM EngScheduleGenerationWeekLog      
 WHERE ServiceId = 1      
   AND FacilityId = @pFacilityId      
   AND ClassificationId = @pWorkGroupId      
   AND TypeOfPlanner = @pTypeOfPlanner      
   AND Year = @pYear+1      
      
   set @mYearNum = @pYear+1      
end      
      
IF (@mWeekNum IS NULL)       
SET @mWeekNum=1      
    
SELECT @mStartOfWeek = DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + @mYearNum) + (@mWeekNum-1), 7)      
--SELECT @mEndOfWeek  = DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + @mYearNum) + (@mWeekNum-1), 6)      
SELECT @mEndOfWeek  = DATEADD(DD, 6, @mStartOfWeek)       
      

	  if exists(
			   SELECT TOP 1 WeekLogId,ISNULL(WeekNo,1) AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate      
		 FROM EngScheduleGenerationWeekLog      
		 WHERE ServiceId = 1      
		   AND FacilityId = @pFacilityId      
		   AND ClassificationId = @pWorkGroupId      
		   AND TypeOfPlanner = @pTypeOfPlanner      
		   AND Year = @pYear      
		   order by WeekLogId desc
		 --ORDER BY Year DESC, WeekNo DESC   
	  )
	  begin 

	
	   SELECT TOP 1 WeekLogId,iif(Documentno=0,ISNULL(WeekNo+1,1) ,ISNULL(WeekNo,1)) AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate      
		FROM EngScheduleGenerationWeekLog      
		WHERE ServiceId = 1      
		  AND FacilityId = @pFacilityId      
		  AND ClassificationId = @pWorkGroupId      
		  AND TypeOfPlanner = @pTypeOfPlanner      
		  AND Year = @pYear      
		  order by  WeekLogId desc
		--ORDER BY Year DESC, WeekNo DESC   
	  end

	  else 
	  begin 
	  SELECT 0 WeekLogId,@mWeekNum AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate
	  end
   
      
 --SELECT 0 WeekLogId,@mWeekNum AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate      
      
      
END TRY      
      
BEGIN CATCH      
      
 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     )      
      
END CATCH

