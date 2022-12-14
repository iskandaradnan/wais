USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_AssetClassificationList]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_Home_DashBoard_WorkOrder]
Description			: Get the Home DashBoard WorkOrder
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_Home_DashBoard_AssetClassificationList]  @pFacilityId=1,@pStartDateMonth=5,@pEndDateMonth=7,@pStartDateYear=2018,@pEndDateYear=2018,@pUserId=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_AssetClassificationList]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   ,
		@pEndDateMonth			INT	  ,
		@pStartDateYear			INT	  ,
		@pEndDateYear			INT	  ,
		@pUserId				INT   = NULL

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
		CREATE TABLE #TempTableCount (ID INT ,AssetClassificationCode NVARCHAR(200) , AssetClassificationDescription NVARCHAR(200) , COUNTVALUE INT DEFAULT 0,PERVALUE NUMERIC(24,2) DEFAULT 0)

		INSERT INTO #TempTableCount(ID,AssetClassificationCode,AssetClassificationDescription)
		SELECT AssetClassificationId,AssetClassificationCode,AssetClassificationDescription FROM EngAssetClassification

-- Work Order
	
	
	SELECT A.AssetClassification,COUNT(*) AS COUNTVALUE INTO #TempResult FROM EngAsset A
	INNER JOIN #TempTableCount B ON A.AssetClassification = B.ID
	WHERE AssetStatusLovId = 1 AND 
	FacilityId = @pFacilityId
	and isnull(a.IsLoaner,0)=0
	GROUP BY A.AssetClassification,A.FacilityId


	UPDATE B SET B.COUNTVALUE = A.COUNTVALUE FROM #TempResult A INNER JOIN #TempTableCount B ON A.AssetClassification = B.ID


	DECLARE @mSumofValue NUMERIC(24,2) 
	SET @mSumofValue = (SELECT SUM(COUNTVALUE) FROM #TempTableCount)

	UPDATE #TempTableCount SET PERVALUE = IIF(@mSumofValue=0,0,(CAST(COUNTVALUE AS numeric(24,2)) /@mSumofValue) * 100.00)


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
		   );
		THROW;

END CATCH
GO
