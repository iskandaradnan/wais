USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGeneration_Generate_job]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngScheduleGeneration_Generate
Description			: Get the Deduction_DashBoard
Authors				: Dhilip V
Date				: 11-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngScheduleGeneration_Generate  @pCustomerId=1,@pFacilityId=1,@pWorkGroupId=1,@pTypeOfPlanner=34,@pYear=2018,@pWeekNo=3,@pWeekStartDate='2018-01-01 00:00:00.000',@pWeekEndDate='2018-01-20 00:00:00.000',
@pUserId=1,@pPageIndex=1,@pPageSize=5,@pUserAreaId	= NULL,	@pUserLocationId= NULL

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngScheduleGeneration_Generate_job]    
				@pYear				INT  = null
AS                                               
BEGIN




declare @mFacilityId		INT,
		@mCustomerId		INT,
		@mWorkGroupId		INT,
		@mTypeOfPlanner		INT,
		@mYear				INT,
		@mWeekNo			INT,
		@mWeekStartDate		DATETIME,
		@mWeekEndDate		DATETIME,
		@mUserId			INT,
		@WeekStartDate_end	DATETIME,
		@mWeekEndDate_end	DATETIME,
		@mYearNext			INT
	
	
select @mYear = isnull(@pYear,year(getdate())+1)
select @mWorkGroupId=1, @mUserId = 1,@mTypeOfPlanner=34  --PPM

select @mYearNext=@mYear+1

create table #Week(WeekLogId int,WeekNoToBeGenerated int,WeekStartDate datetime,WeekEndDate datetime)
insert into #Week  (WeekLogId ,WeekNoToBeGenerated ,WeekStartDate ,WeekEndDate)
exec uspFM_EngScheduleGenerationWeekLog_GetAll @pWorkGroupId=@mWorkGroupId,@pFacilityId=@mFacilityId,@pYear=@mYearNext,@pTypeOfPlanner=@mTypeOfPlanner

SELECT @WeekStartDate_end=WeekStartDate,@mWeekEndDate_end=WeekEndDate from #Week  

TRUNCATE TABLE #Week	

create table #Temp_FacilityList (Id int identity(1,1),FacilityId  int,CustomerId int,status char(1))

insert into #Temp_FacilityList(FacilityId,CustomerId)
select distinct  FacilityId,CustomerId  from EngPlannerTxn  where Year=@mYear



declare @mstart  int, @mincr  int  , @mmax int

select  @mmax =max(id)  from #Temp_FacilityList

			insert into #Week  (WeekLogId ,WeekNoToBeGenerated ,WeekStartDate ,WeekEndDate)
			exec uspFM_EngScheduleGenerationWeekLog_GetAll @pWorkGroupId=@mWorkGroupId,@pFacilityId=@mFacilityId,@pYear=@mYear,@pTypeOfPlanner=@mTypeOfPlanner

			select @mWeekNo =WeekNoToBeGenerated, @mWeekStartDate = WeekStartDate, @mWeekEndDate = WeekEndDate from #Week  

	WHILE Not (@WeekStartDate_end=@mWeekStartDate  and @mWeekEndDate_end=@mWeekEndDate) and exists (select top 1 1 from #Temp_FacilityList)
	BEGIN		

		select  @mmax =max(id)  from #Temp_FacilityList
		select @mincr=1
		
		WHILE @mincr<=@mmax
		BEGIN

			select @mFacilityId=null,@mCustomerId=null	
			select @mFacilityId = FacilityId,@mCustomerId=CustomerId from #Temp_FacilityList  where id=@mincr		
			

			exec uspFM_EngScheduleGeneration_Generate @pFacilityId=@mFacilityId , @pCustomerId =@mCustomerId ,@pWorkGroupId=@mWorkGroupId
						,@pTypeOfPlanner=@mTypeOfPlanner,@pYear=@mYear,@pWeekNo=@mWeekNo,@pWeekStartDate=@mWeekStartDate,@pWeekEndDate=@mWeekEndDate,@pUserId=1,
						 @pPageIndex=1,@pPageSize=1,@pUserAreaId=null,@pUserLocationId=null		


			SET @mincr=@mincr+1


		END

			TRUNCATE TABLE #Week	
	
			SELECT @mWeekNo =null ,@mWeekStartDate=null,@mWeekEndDate=null

			insert into #Week  (WeekLogId ,WeekNoToBeGenerated ,WeekStartDate ,WeekEndDate)
			exec uspFM_EngScheduleGenerationWeekLog_GetAll @pWorkGroupId=@mWorkGroupId,@pFacilityId=@mFacilityId,@pYear=@mYear,@pTypeOfPlanner=@mTypeOfPlanner

			select @mWeekNo =WeekNoToBeGenerated, @mWeekStartDate = WeekStartDate, @mWeekEndDate = WeekEndDate from #Week  
				

	END

END
GO
