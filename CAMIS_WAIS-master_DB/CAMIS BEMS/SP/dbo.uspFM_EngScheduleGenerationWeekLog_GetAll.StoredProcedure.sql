USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGenerationWeekLog_GetAll]    Script Date: 20-09-2021 17:05:51 ******/
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
--EXEC uspFM_EngScheduleGenerationWeekLog_GetAll  @pFacilityId=144,@pWorkGroupId=170,@pTypeOfPlanner=34,@pYear=2021      
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
CREATE PROCEDURE  [dbo].[uspFM_EngScheduleGenerationWeekLog_GetAll]          
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
      
--DECLARE @mWeekNum INT,      
--  @mYearNum char(4),      
--  @mStartOfWeek datetime,      
--  @mEndOfWeek datetime      
      
---- Execution      
      
-- set @mYearNum = @pYear      
      
-- SELECT  @mWeekNum = ISNULL(WeekNo,0)+1      
-- FROM EngScheduleGenerationWeekLog      
-- WHERE ServiceId = 1      
--   AND FacilityId = @pFacilityId      
--   AND ClassificationId = @pWorkGroupId      
--   AND TypeOfPlanner = @pTypeOfPlanner      
--   AND Year = @pYear      
      
      
--if year (DATEADD(wk, DATEDIFF(wk, 7, '1/1/' + @mYearNum) + (@mWeekNum-1), 7)) != @pYear      
--begin       
-- SELECT  @mWeekNum = ISNULL(WeekNo,0)+1      
-- FROM EngScheduleGenerationWeekLog      
-- WHERE ServiceId = 1      
--   AND FacilityId = @pFacilityId      
--   AND ClassificationId = @pWorkGroupId      
--   AND TypeOfPlanner = @pTypeOfPlanner      
--   AND Year = @pYear+1      
      
--   set @mYearNum = @pYear+1      
--end      
      
--IF (@mWeekNum IS NULL)       
--SET @mWeekNum=1      
    
--SELECT @mStartOfWeek = DATEADD(wk, DATEDIFF(wk, 7, '1/1/' + @mYearNum) + (@mWeekNum-1), 7)      
----SELECT @mEndOfWeek  = DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + @mYearNum) + (@mWeekNum-1), 6)      
--SELECT @mEndOfWeek  = DATEADD(DD, 6, @mStartOfWeek)       
      

--	  if exists(
--			   SELECT TOP 1 WeekLogId,ISNULL(WeekNo,1) AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate      
--		 FROM EngScheduleGenerationWeekLog      
--		 WHERE ServiceId = 1      
--		   AND FacilityId = @pFacilityId      
--		   AND ClassificationId = @pWorkGroupId      
--		   AND TypeOfPlanner = @pTypeOfPlanner      
--		   AND Year = @pYear      
--		   order by WeekLogId desc
--		 --ORDER BY Year DESC, WeekNo DESC   
--	  )
--	  begin 

	
--	   SELECT TOP 1 WeekLogId,iif(Documentno=0,ISNULL(WeekNo+1,1) ,ISNULL(WeekNo,1)) AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate      
--		FROM EngScheduleGenerationWeekLog      
--		WHERE ServiceId = 1      
--		  AND FacilityId = @pFacilityId      
--		  AND ClassificationId = @pWorkGroupId      
--		  AND TypeOfPlanner = @pTypeOfPlanner      
--		  AND Year = @pYear      
--		  order by  WeekLogId desc
--		--ORDER BY Year DESC, WeekNo DESC   
--	  end

--	  else 
--	  begin 
--	  SELECT 0 WeekLogId,@mWeekNum AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate
--	  end
   
      
-- --SELECT 0 WeekLogId,@mWeekNum AS WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate      
      


Declare @DBNAME Varchar(max)=(SELECT DB_NAME() AS [Current Database])
if(@DBNAME like '%FEMS%')
Begin 
set @pWorkGroupId=@pWorkGroupId;
End
else if (@DBNAME like '%BEMS%' )
Begin 
set @pWorkGroupId=0;
End
else if (@DBNAME like '%ICT%')
Begin 
set @pWorkGroupId=0;
End

Declare @YearEndWeekNo int=
	 (Select 
	  TOP 1 WeekNo
	  From	  EngScheduleGenerationWeekLog      
	  WHERE 
	  FacilityId = @pFacilityId      
	  AND ClassificationId = @pWorkGroupId      
	  AND TypeOfPlanner = @pTypeOfPlanner      
	  AND Year = @pYear      
	  order by  WeekLogId desc ), @MaxWeeknNoExists int=(select NoOfweeks from [UetrackMasterdbPreProd]..[GmMaintenanceYearDetailsMst] where [Year]=@pYear),@WeekLogId int,
	  @WeekStartDate daTETIME,@WeekEndDate dATEtIME,@WeekNo Int,
	  @CurrentWeekStartDate daTETIME,@CurrentWeekEndDate dATEtIME,@CurrentWeekNo Int
	  
	  
	  

IF EXISTS(select 1 from [UetrackMasterdbPreProd]..[GmMaintenanceYearDetailsMst] where [Year]=@pYear)
BEGIN 

	  
	  

					  IF EXISTS(
					  Select 
					  TOP 1 WeekLogId
					  From	  EngScheduleGenerationWeekLog      
					  WHERE 
					  FacilityId = @pFacilityId      
					  AND ClassificationId = @pWorkGroupId      
					  AND TypeOfPlanner = @pTypeOfPlanner      
					  AND Year = @pYear      
					  order by  WeekLogId desc 
					  )

				BEGIN 
	  

					  SELECT  TOP 1 
					  @WeekLogId=WeekLogId,
					  @WeekNo=ISNULL(WeekNo+1,1),
					  @WeekStartDate=WeekEndDate+1, 
					  @WeekEndDate =(WeekEndDate)+7 
					  From	  EngScheduleGenerationWeekLog      
					  WHERE 
					  FacilityId = @pFacilityId      
					  AND ClassificationId = @pWorkGroupId      
					  AND TypeOfPlanner = @pTypeOfPlanner      
					  AND Year = @pYear      
					  order by  WeekLogId desc 

				END

ELSE

				BEGIN 
					 SELECT
					  @WeekLogId=0,
					  @WeekNo=1,
					  @WeekStartDate=StartDate, 
					  @WeekEndDate =StartDate+6
					  --0 WeekLogId,1 AS WeekNoToBeGenerated,StartDate WeekStartDate, StartDate+6 WeekEndDate             
					  From 
					  [UetrackMasterdbPreProd]..[GmMaintenanceYearDetailsMst]  where [year]=@pyear
				END


END
	  
	  
	  
	  
	  
	  
	  
	  
	  ELSE
	  BEGIN 
		EXEC [UetrackMasterdbPreProd]..usp_GMMaintenanceHistory @pYear
		
	  Select 
	--  0 WeekLogId,1 AS WeekNoToBeGenerated,StartDate WeekStartDate, StartDate+6 WeekEndDate             
					@WeekLogId=0,
					  @WeekNo=1,
					  @WeekStartDate=StartDate, 
					  @WeekEndDate =StartDate+6
	  From 
	  [UetrackMasterdbPreProd]..[GmMaintenanceYearDetailsMst]
	  where [year]=@pyear
	  END


	  
	  				  Select 
					  TOP 1 @CurrentWeekNo=WeekNo,@CurrentWeekStartDate=WeekStartDate,@CurrentWeekEndDate=WeekEndDate
					  From	  EngScheduleGenerationWeekLog      
					  WHERE 
					  FacilityId = @pFacilityId      
					  AND ClassificationId = @pWorkGroupId      
					  AND TypeOfPlanner = @pTypeOfPlanner      
					  AND Year = @pYear      
					  order by  WeekLogId desc 
		

	   Select		 iif(@MaxWeeknNoExists=@YearEndWeekNo,@CurrentWeekNo,@WeekLogId)WeekLogId,
					 iif(@MaxWeeknNoExists=@YearEndWeekNo,99,@WeekNo)WeekNoToBeGenerated,
					 iif(@MaxWeeknNoExists=@YearEndWeekNo,@CurrentWeekStartDate,@WeekStartDate)WeekStartDate, 
					 iif(@MaxWeeknNoExists=@YearEndWeekNo,@CurrentWeekEndDate,@WeekEndDate)WeekEndDate 

      
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
GO
