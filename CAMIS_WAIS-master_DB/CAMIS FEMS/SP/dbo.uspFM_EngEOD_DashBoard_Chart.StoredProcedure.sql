USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEOD_DashBoard_Chart]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEOD_DashBoard_Chart
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 09-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngEOD_DashBoard_Chart  @pNoOfMonth=6, @pFacilityId=2
SELECT * FROM	EngEODCaptureTxnDet
SELECT * FROM	EngEODCaptureTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngEOD_DashBoard_Chart]                           
		--@pYear			INT,
		@pNoOfMonth		INT,
		@pFacilityId	INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

CREATE TABLE #EODDashboardChart
	(
		[Month] int,
		[MonthName] varchar(20),
		[Year] int,
		BEMSTotal numeric(12,2),
		BEMSPass numeric(12,2),
		BEMSFail numeric(12,2),
		BEMSPassPercentage numeric(12,2)
	)

-- Default Values

	--SELECT MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
	--FROM    (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) t(m)  order by [Year] asc,[Month] asc

IF (@pNoOfMonth=3)
	BEGIN
		INSERT INTO #EODDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2)) t(m)  order by [Year] asc,[Month] asc
	END

ELSE IF (@pNoOfMonth=4)
	BEGIN
		INSERT INTO #EODDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2),(3)) t(m)  order by [Year] asc,[Month] asc
	END

ELSE IF (@pNoOfMonth=6)
	BEGIN
		INSERT INTO #EODDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2),(3),(4),(5)) t(m)  order by [Year] asc,[Month] asc
	END

ELSE IF (@pNoOfMonth=12)
	BEGIN
		INSERT INTO #EODDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) t(m)  order by [Year] asc,[Month] asc

	END
-- Execution


	--BEMS Total
	SELECT	MONTH(RecordDate) AS [Month],
			Year(RecordDate) AS [Year], 
			ISNULL(COUNT(*),0) AS BEMSTotal
	INTO	#EODBEMSTotal 
	FROM	EngEODCaptureTxnDet A 
			INNER JOIN EngEODCaptureTxn B ON A.CaptureId = b.CaptureId 
			INNER JOIN EngEODParameterMappingDet C ON A.ParameterMappingDetId = C.ParameterMappingDetId
	WHERE	B.[ServiceId] = 2 AND B.FacilityId = @pFacilityId
			AND YEAR(B.RecordDate) 
		IN (SELECT Year FROM #EODDashboardChart) AND Month(B.RecordDate) in (SELECT Month FROM #EODDashboardChart) 
			AND A.[Status] IN (1,2) 
	GROUP BY MONTH(RecordDate), Year(RecordDate)

	UPDATE A
	SET A.BEMSTotal = B.BEMSTotal
	FROM #EODDashboardChart A INNER JOIN #EODBEMSTotal B ON A.[Month] = B.[Month] AND A.Year = B.Year

	--BEMS Pass
	SELECT	MONTH(RecordDate) AS [Month],
			Year(RecordDate) AS [Year], 
			ISNULL(COUNT(*),0) AS BEMSPass
	INTO	#EODBEMSPass 
	FROM	EngEODCaptureTxnDet A 
			INNER JOIN EngEODCaptureTxn B ON A.CaptureId = b.CaptureId 
			INNER JOIN EngEODParameterMappingDet C ON A.ParameterMappingDetId = C.ParameterMappingDetId
	WHERE	B.[ServiceId] = 2 AND B.FacilityId = @pFacilityId
			AND YEAR(B.RecordDate) 
		IN (SELECT Year FROM #EODDashboardChart) AND Month(B.RecordDate) in (SELECT Month FROM #EODDashboardChart) 
	AND A.[Status] = 1 
	GROUP BY MONTH(RecordDate), Year(RecordDate)

	UPDATE A
	SET A.BEMSPass = B.BEMSPass
	FROM #EODDashboardChart A INNER JOIN #EODBEMSPass B ON A.[Month] = B.[Month] AND A.Year = B.Year

	--BEMS Fail
	SELECT	MONTH(RecordDate) AS [Month],
			Year(RecordDate) AS [Year], 
			ISNULL(COUNT(*),0) AS BEMSFail
	INTO	#EODBEMSFail 
	FROM	EngEODCaptureTxnDet A 
			INNER JOIN EngEODCaptureTxn B ON A.CaptureId = b.CaptureId 
			INNER JOIN EngEODParameterMappingDet C ON A.ParameterMappingDetId = C.ParameterMappingDetId
	WHERE	B.[ServiceId] = 2 AND B.FacilityId = @pFacilityId
			AND YEAR(B.RecordDate) 
		IN (SELECT Year FROM #EODDashboardChart) AND Month(B.RecordDate) in (SELECT Month FROM #EODDashboardChart) 
	AND A.[Status] = 2 
	GROUP BY MONTH(RecordDate), Year(RecordDate)
		
	UPDATE A
	SET A.BEMSFail = B.BEMSFail
	FROM #EODDashboardChart A INNER JOIN #EODBEMSFail B ON A.[Month] = B.[Month] AND A.Year = B.Year

	-- BEMS Pass Percentage
	UPDATE #EODDashboardChart
	SET BEMSPassPercentage = CASE WHEN ISNULL(BEMSPass,0) > 0 THEN ISNULL(BEMSPass,0) / ISNULL(BEMSTotal,0)*100.00 ELSE 0 END

	SELECT	[Month],
			[MonthName],
			[Year],
			ISNULL(BEMSPass,0)				AS	BEMSPassCount,
			ISNULL(BEMSFail,0)				AS	BEMSFailCount,
			ISNULL(BEMSTotal,0)				AS	BEMSTotalCount,
			ISNULL(BEMSPassPercentage,0)	AS	BEMSPassPercentage
	FROM #EODDashboardChart order by [Year] asc,[Month] asc

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
GO
