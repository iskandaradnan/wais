USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_UpTimeAssetList]    Script Date: 20-09-2021 17:05:52 ******/
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
EXEC [uspFM_Home_DashBoard_UpTimeAssetList]  @pFacilityId=1,@pStartDateMonth=5,@pEndDateMonth=7,@pStartDateYear=2018,@pEndDateYear=2018,@pUserId=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_UpTimeAssetList]    
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
	
	CREATE TABLE #TempAssetResult(AssetId int, HoursCalc numeric(24,2))

	INSERT INTO #TempAssetResult(AssetId,HoursCalc)
	SELECT A.AssetId,ISNULL(datediff(MINUTE, B.StartDateTime,B.EndDateTime) ,0) FROM EngMaintenanceWorkOrderTxn A INNER JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId
	WHERE A.FacilityId = @pFacilityId AND  MONTH(MaintenanceWorkDateTime) BETWEEN 01 AND @pEndDateMonth
	AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear AND @pEndDateYear


	CREATE TABLE #TempTotalAssetResult(AssetId int, TotalHoursCalc numeric(24,2),ActualHours numeric(24,2),QAPUpTimePer NUMERIC(24,2),QAPUpTimePerCalc numeric(24,2),PercentageMet bit,AssetClassificationId int)

	insert into #TempTotalAssetResult(AssetId,TotalHoursCalc)
	select AssetId,SUM(HoursCalc) from #TempAssetResult group by AssetId

	Update #TempTotalAssetResult set ActualHours = 525600.00 

	UPDATE A SET A.QAPUpTimePer = ISNULL(C.QAPUptimeTargetPerc,0) FROM #TempTotalAssetResult A INNER JOIN EngAsset B ON A.AssetId = B.AssetId 
	INNER JOIN EngAssetTypeCode c  on b.AssetTypeCodeId = c.AssetTypeCodeId

	Update #TempTotalAssetResult set QAPUpTimePerCalc = CASE  when ActualHours =0 THEN 0 ELSE  (TotalHoursCalc/ActualHours) * 100 END 

	Update #TempTotalAssetResult set PercentageMet = CASE  when QAPUpTimePerCalc> =QAPUpTimePer THEN 1 ELSE  0 END 

	update a set a.AssetClassificationId = c.AssetClassificationId  FROM #TempTotalAssetResult a inner join EngAsset b on a.AssetId = b.AssetId
	inner join EngAssetClassification c on b.AssetClassification = c.AssetClassificationId

	
	SELECT A.AssetClassificationId,COUNT(*) AS COUNTVALUE INTO #TempCountResult FROM #TempTotalAssetResult A
	GROUP BY A.AssetClassificationId

	update a set a.COUNTVALUE = ISNULL(b.COUNTVALUE,0) FROM #TempTableCount a inner join #TempCountResult b on a.ID = b.AssetClassificationId

	
	--SELECT * FROM #TempTotalAssetResult

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
