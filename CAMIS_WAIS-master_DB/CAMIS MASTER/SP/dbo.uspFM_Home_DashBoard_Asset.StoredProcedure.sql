USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_Asset]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_Home_DashBoard_Asset]
Description			: Get the Home DashBoard Asset
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Home_DashBoard_Asset  @pFacilityId=2,@pStartDateMonth=5,@pEndDateMonth=7,@pStartDateYear=2018,@pEndDateYear=2018
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_Asset]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   =	NULL,
		@pEndDateMonth			INT	  =	NULL,
		@pStartDateYear			INT	  =	NULL,
		@pEndDateYear			INT	  =	NULL

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

		--SET @pStartDateMonth = MONTH(GETDATE())
		--SET @pEndDateMonth	 = MONTH(GETDATE())
		--SET @pStartDateYear	 = YEAR(GETDATE())
		--SET @pEndDateYear	 = YEAR(GETDATE())

-- Execution

	IF OBJECT_ID('#TempTableCount') IS NOT NULL
	DROP TABLE #TempTableCount

	CREATE TABLE #TempTableCount (ID INT , NAME NVARCHAR(100) , COUNTVALUE INT DEFAULT 0)

	INSERT INTO #TempTableCount(ID,NAME)  VALUES (1,'Active')
	INSERT INTO #TempTableCount(ID,NAME)  VALUES (2,'InActive')

-- Asset

	
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	INNER JOIN #TempTableCount B ON A.AssetStatusLovId = B.ID
	WHERE A.AssetStatusLovId = 1 
		  AND A.FacilityId = @pFacilityId
		  AND ( YEAR(A.ServiceStartDate) >= @pStartDateYear AND  YEAR(A.ServiceStartDate) <= @pEndDateYear) 
		  AND ( MONTH(A.ServiceStartDate) >= @pStartDateMonth AND  MONTH(A.ServiceStartDate) <= @pEndDateMonth)
		  AND B.ID =1 ),0) WHERE ID=1


	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A
	INNER JOIN #TempTableCount B ON A.AssetStatusLovId = B.ID
	WHERE AssetStatusLovId = 2 
		  AND FacilityId = @pFacilityId
		  AND ( YEAR(A.ServiceStartDate) >= @pStartDateYear AND  YEAR(A.ServiceStartDate) <= @pEndDateYear) 
		  AND ( MONTH(A.ServiceStartDate) >= @pStartDateMonth AND  MONTH(A.ServiceStartDate) <= @pEndDateMonth)
		  AND B.ID=2),0) WHERE ID=2

	SELECT * FROM #TempTableCount


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
