USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstWorkingCalender_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstWorkingCalender_GetById
Description			: Get the working calender datails
Authors				: Dhilip V
Date				: 03-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstWorkingCalender_GetById  @pFacilityId=1 , @pYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_MstWorkingCalender_GetById]                           
  @pFacilityId		INT,
  @pYear			INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pYear,0) = 0) RETURN

    SELECT	MstCalender.[CustomerId]			AS	[CustomerId],
			MstCalender.[FacilityId]			AS	[FacilityId],
			MstCalender.[CalenderId]			AS	[CalenderId],
			MstCalender.[Year]					AS	[YearId],
			DetCalender.[Month]					AS	[MonthId],
			TimeMonth.[Month]					AS	[MonthName],
			DetCalender.[Day]					AS	[Day],
			DetCalender.[IsWorking]				AS	[IsWorking]
 	FROM	MstWorkingCalender					AS	MstCalender		WITH(NOLOCK)	
			INNER JOIN MstWorkingCalenderDet	AS	DetCalender		WITH(NOLOCK)	ON	MstCalender.CalenderId		=	DetCalender.CalenderId
			INNER JOIN FMTimeMonth				AS	TimeMonth		WITH(NOLOCK)	ON	DetCalender.Month			=	TimeMonth.MonthId
			--INNER JOIN FMTimeWeekDay			AS	TimeWeekDay		WITH(NOLOCK)	ON	DetCalender.Day			=	TimeWeekDay.WeekDayId
	WHERE	MstCalender.FacilityId = @pFacilityId
			AND MstCalender.Year = @pYear
	ORDER BY MstCalender.Year ASC ,DetCalender.Month ASC ,DetCalender.Day ASC
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
