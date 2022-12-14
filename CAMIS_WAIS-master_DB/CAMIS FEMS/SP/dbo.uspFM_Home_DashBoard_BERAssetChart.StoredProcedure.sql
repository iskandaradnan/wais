USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_BERAssetChart]    Script Date: 20-09-2021 16:56:53 ******/
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
EXEC [uspFM_Home_DashBoard_BERAssetChart]  @pFacilityId=1,@pStartDateMonth=8,@pEndDateMonth=8,@pStartDateYear=2018,@pEndDateYear=2018,@pUserId =NULL

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_BERAssetChart]    
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
		CREATE TABLE #TempTableCount (ID INT , NAME NVARCHAR(100) , BER1COUNTVALUE INT DEFAULT 0,BER2COUNTVALUE INT DEFAULT 0,BER1PERVALUE NUMERIC(24,2) DEFAULT 0,BER2PERVALUE NUMERIC(24,2) DEFAULT 0)

		INSERT INTO #TempTableCount(ID,NAME) VALUES (202,'Draft')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (203,'Submitted')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (204,'Clarification Sought By HD')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (205,'Clarification Sought By Liaison Officer')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (206,'Approved')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (207,'Forwarded to Liaison Officer')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (208,'Recommended')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (209,'Clarified By Applicant')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (210,'Rejected')
		

-- Work Order
	
	
	UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 202
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=202

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 202
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=202


		UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 203
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=203

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 203
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=203

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 204
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=204

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 204
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=204

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 205
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=205

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 205
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=205

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 206
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=206

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 206
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=206

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 207
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=207

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 207
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=207

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 208
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=208

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 208
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=208

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 209
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=209

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 209
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=209

			UPDATE #TempTableCount  SET BER1COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 1 AND BERStatus = 210
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=210

		UPDATE #TempTableCount  SET BER2COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	WHERE BERStage = 2 AND BERStatus = 210
		  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY BERStage,FacilityId),0) WHERE ID=210

	--UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	--INNER JOIN EngAsset B ON A.AssetId = B.AssetId
	--WHERE CAST(B.WarrantyEndDate AS DATE) > CAST (GETDATE() AS DATE)
	--	  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
	--	  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
	--	  AND A.FacilityId = @pFacilityId
	--GROUP BY A.FacilityId),0) WHERE ID=3

	--UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM BERApplicationTxn A
	--INNER JOIN  EngAsset B ON A.AssetId = B.AssetId
	--WHERE  CAST(B.WarrantyEndDate AS DATE) < CAST (GETDATE() AS DATE) 
	--	  AND MONTH(ApplicationDate) BETWEEN @pStartDateMonth	AND @pEndDateMonth
	--	  AND YEAR(ApplicationDate) BETWEEN @pStartDateYear		AND @pEndDateYear
	--	  AND A.FacilityId = @pFacilityId
	--GROUP BY A.FacilityId),0) WHERE ID=4


	DECLARE @mSumofValueBer1 NUMERIC(24,2) 
	DECLARE @mSumofValueBer2 NUMERIC(24,2) 
	SET @mSumofValueBer1 = (SELECT SUM(BER1COUNTVALUE) FROM #TempTableCount)
	SET @mSumofValueBer2 = (SELECT SUM(BER2COUNTVALUE) FROM #TempTableCount)

	UPDATE #TempTableCount SET BER1PERVALUE = IIF(@mSumofValueBer1=0,0,(CAST(BER1COUNTVALUE AS numeric(24,2)) /@mSumofValueBer1) * 100.00)
	UPDATE #TempTableCount SET BER2PERVALUE = IIF(@mSumofValueBer2=0,0,(CAST(BER2COUNTVALUE AS numeric(24,2)) /@mSumofValueBer2) * 100.00)
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
		   throw;

END CATCH
GO
