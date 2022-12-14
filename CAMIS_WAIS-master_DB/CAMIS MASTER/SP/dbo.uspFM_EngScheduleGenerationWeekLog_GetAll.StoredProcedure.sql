USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGenerationWeekLog_GetAll]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngScheduleGenerationWeekLog_GetAll
Description			: Get the Deduction_DashBoard
Authors				: Dhilip V
Date				: 11-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngScheduleGenerationWeekLog_GetAll  @pFacilityId=2,@pWorkGroupId=1,@pTypeOfPlanner=34,@pYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngScheduleGenerationWeekLog_GetAll]    
		@pFacilityId	INT,
		@pWorkGroupId	INT,
		@pTypeOfPlanner	INT,
		@pYear			INT
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

	SELECT  @mWeekNum	=	ISNULL(WeekNo,0)+1
	FROM	EngScheduleGenerationWeekLog
	WHERE	ServiceId	=	2
			AND FacilityId	=	@pFacilityId
			AND WorkGroupId	=	@pWorkGroupId
			AND TypeOfPlanner	=	@pTypeOfPlanner
			AND Year	=	@pYear


if	year (DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + @mYearNum) + (@mWeekNum-1), 6)) != @pYear
begin 
	SELECT  @mWeekNum	=	ISNULL(WeekNo,0)+1
	FROM	EngScheduleGenerationWeekLog
	WHERE	ServiceId	=	2
			AND FacilityId	=	@pFacilityId
			AND WorkGroupId	=	@pWorkGroupId
			AND TypeOfPlanner	=	@pTypeOfPlanner
			AND Year	=	@pYear+1

			set @mYearNum = @pYear+1
end

IF (@mWeekNum IS NULL) 
SET @mWeekNum=1

SELECT @mStartOfWeek	= DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + @mYearNum) + (@mWeekNum-1), 6)
SELECT @mEndOfWeek		= DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + @mYearNum) + (@mWeekNum-1), 5)

	--SELECT TOP 1 WeekLogId,ISNULL(WeekNo,0)+1	AS	WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate
	--FROM	EngScheduleGenerationWeekLog
	--WHERE	ServiceId	=	2
	--		AND FacilityId	=	@pFacilityId
	--		AND WorkGroupId	=	@pWorkGroupId
	--		AND TypeOfPlanner	=	@pTypeOfPlanner
	--		AND Year	=	@pYear
	--ORDER BY Year DESC, WeekNo DESC

	SELECT 0 WeekLogId,@mWeekNum	AS	WeekNoToBeGenerated,@mStartOfWeek WeekStartDate,@mEndOfWeek WeekEndDate


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
