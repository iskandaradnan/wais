USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEOD_DashBoard]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEOD_DashBoard
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 09-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngEOD_DashBoard  @pYear=2018,@pMonth=5,@pFacilityId=2
SELECT * FROM	EngEODCaptureTxnDet
SELECT * FROM	EngEODCaptureTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngEOD_DashBoard]                           
		@pFromYear			INT,
		@pFromMonth			INT,
		@pToYear			INT,
		@pToMonth			INT,
		@pFacilityId	INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	CREATE TABLE #EODDashboard
	(
		AssetTypeCodeId int,
		CategorySystemName varchar(100),
		Pass int,
		Fail int
	)

-- Default Values

	INSERT INTO #EODDashboard (AssetTypeCodeId, CategorySystemName)

	SELECT	AssetTypeCodeId,
			''
	FROM	EngEODParameterMapping  EODCatSys WITH(NOLOCK) 
	WHERE	EODCatSys.Active=1


-- Execution


	IF(ISNULL(@pFromYear,0) = 0) RETURN

	--Pass Count

	SELECT	AssetTypeCodeId, 
			ISNULL(COUNT(*),0) AS Pass
	INTO	#EODCategoryPass 
	FROM	EngEODCaptureTxnDet A 
			INNER JOIN EngEODCaptureTxn B ON A.CaptureId = b.CaptureId 
			INNER JOIN EngEODParameterMappingDet C ON A.ParameterMappingDetId = C.ParameterMappingDetId
	WHERE	B.FacilityId = @pFacilityId 
			AND MONTH(B.[RecordDate]) >= @pFromMonth	AND   MONTH(B.[RecordDate]) <= @pToMonth
			AND YEAR(B.[RecordDate]) = @pToYear 	AND   YEAR(B.[RecordDate]) = @pToYear
			AND A.[Status] = 1
	GROUP BY AssetTypeCodeId
	
	-- update pass count to #EODDashboard table
	UPDATE A SET A.Pass = B.Pass
	FROM	#EODDashboard A 
			INNER JOIN #EODCategoryPass B ON A.AssetTypeCodeId = B.AssetTypeCodeId

	--Fail count
	
	SELECT	AssetTypeCodeId, 
			ISNULL(COUNT(*),0) AS Fail
	INTO	#EODCategoryFail 
	FROM	EngEODCaptureTxnDet A 
			INNER JOIN EngEODCaptureTxn B ON A.CaptureId = b.CaptureId 
			INNER JOIN EngEODParameterMappingDet C ON A.ParameterMappingDetId = C.ParameterMappingDetId
	WHERE	B.FacilityId = @pFacilityId 
			AND MONTH(B.[RecordDate]) >= @pFromMonth	AND   MONTH(B.[RecordDate]) <= @pToMonth
			AND YEAR(B.[RecordDate]) = @pToYear 	AND   YEAR(B.[RecordDate]) = @pToYear
			AND A.[Status] = 2
	GROUP BY AssetTypeCodeId

	-- update pass count to #EODDashboard table

	UPDATE A SET A.Fail = B.Fail
	FROM	#EODDashboard A 
			INNER JOIN #EODCategoryFail B ON A.AssetTypeCodeId = B.AssetTypeCodeId

	SELECT AssetTypeCodeId, CategorySystemName, ISNULL(Pass,0) AS Pass, ISNULL(Fail,0) AS Fail FROM #EODDashboard 


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
