USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_WorkOrder]    Script Date: 20-09-2021 16:56:53 ******/
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
EXEC uspFM_Home_DashBoard_WorkOrder  @pFacilityId=2,@pStartDateMonth=5,@pEndDateMonth=7,@pStartDateYear=2018,@pEndDateYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_WorkOrder]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   ,
		@pEndDateMonth			INT	  ,
		@pStartDateYear			INT	  ,
		@pEndDateYear			INT	  

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
		CREATE TABLE #TempTableCount (ID INT , NAME NVARCHAR(100) , COUNTVALUE INT DEFAULT 0)

		INSERT INTO #TempTableCount(ID,NAME) VALUES (192,'Open')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (193,'Work In Progress')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (194,'Completed')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (195,'Closed')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (196,'Cancelled')
		INSERT INTO #TempTableCount(ID,NAME) VALUES (197,'Not Done & Closed')

-- Work Order
	
	
	UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM EngMaintenanceWorkOrderTxn A
	INNER JOIN #TempTableCount B ON A.WorkOrderStatus = B.ID
	WHERE WorkOrderStatus = 192 
		  AND MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY WorkOrderStatus,FacilityId),0) WHERE ID=192

	UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM EngMaintenanceWorkOrderTxn A
	INNER JOIN #TempTableCount B ON A.WorkOrderStatus = B.ID
	WHERE WorkOrderStatus = 193 
		  AND MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY WorkOrderStatus,FacilityId),0) WHERE ID=193

	UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM EngMaintenanceWorkOrderTxn A
	INNER JOIN #TempTableCount B ON A.WorkOrderStatus = B.ID
	WHERE WorkOrderStatus = 194 
		  AND MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY WorkOrderStatus,FacilityId),0) WHERE ID=194

	UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM EngMaintenanceWorkOrderTxn A
	INNER JOIN #TempTableCount B ON A.WorkOrderStatus = B.ID
	WHERE WorkOrderStatus = 195 
		  AND MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY WorkOrderStatus,FacilityId),0) WHERE ID=195

	UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM EngMaintenanceWorkOrderTxn A
	INNER JOIN #TempTableCount B ON A.WorkOrderStatus = B.ID
	WHERE WorkOrderStatus = 196 
		  AND MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY WorkOrderStatus,FacilityId),0) WHERE ID=196

	UPDATE #TempTableCount  SET COUNTVALUE = ISNULL((SELECT COUNT(*) AS COUNTVALUE FROM EngMaintenanceWorkOrderTxn A
	INNER JOIN #TempTableCount B ON A.WorkOrderStatus = B.ID
	WHERE WorkOrderStatus = 197 
		  AND MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND FacilityId = @pFacilityId
	GROUP BY WorkOrderStatus,FacilityId),0) WHERE ID=197


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
