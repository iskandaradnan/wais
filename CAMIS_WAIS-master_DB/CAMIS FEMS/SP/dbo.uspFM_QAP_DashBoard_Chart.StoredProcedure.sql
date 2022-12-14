USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAP_DashBoard_Chart]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAP_DashBoard_Chart
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 09-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_QAP_DashBoard_Chart  @pFacilityId=2,@pNoOfMonth=6

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_QAP_DashBoard_Chart]   
		@pNoOfMonth		INT,
		@pFacilityId	INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

CREATE TABLE #QAPDashboardChart
	(
		[Month] int,
		[MonthName] varchar(20),
		[Year] int,
		B1 numeric(12,2),
		B2 numeric(12,2),
		B1Percent numeric(12,2),
		B2Percent numeric(12,2)
	)

-- Default Values

	--SELECT MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
	--FROM    (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) t(m)  order by [Year] asc,[Month] asc

IF (@pNoOfMonth=3)
	BEGIN
		INSERT INTO #QAPDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2)) t(m)  order by [Year] asc,[Month] asc
	END

ELSE IF (@pNoOfMonth=4)
	BEGIN
		INSERT INTO #QAPDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2),(3)) t(m)  order by [Year] asc,[Month] asc
	END

ELSE IF (@pNoOfMonth=6)
	BEGIN
		INSERT INTO #QAPDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2),(3),(4),(5)) t(m)  order by [Year] asc,[Month] asc
	END

ELSE IF (@pNoOfMonth=12)
	BEGIN
		INSERT INTO #QAPDashboardChart ([Month], [MonthName],[Year])

		SELECT	MONTH(DATEADD(mm, -m, GETDATE())) AS [Month],
				LEFT(DATENAME(mm,  DATEADD(mm, -m, GETDATE())), 3) AS [MonthName], 
				YEAR(DATEADD(mm, -m, GETDATE())) AS [Year] 
		FROM    (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) t(m)  order by [Year] asc,[Month] asc

	END
-- Execution


	SELECT	[Month],
			[MonthName],
			[Year],
			ISNULL(B1,0)				AS	B1,
			ISNULL(B2,0)				AS	B2,
			ISNULL(B1Percent,0)			AS	B1Percent,
			ISNULL(B2Percent,0)	AS	B2Percent
	FROM #QAPDashboardChart order by [Year] asc,[Month] asc

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
