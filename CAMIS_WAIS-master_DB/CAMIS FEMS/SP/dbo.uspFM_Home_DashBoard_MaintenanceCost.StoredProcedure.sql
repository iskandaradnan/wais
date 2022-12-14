USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_MaintenanceCost]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_Home_DashBoard_MaintenanceCost]
Description			: Get the Home DashBoard MaintenanceCost
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Home_DashBoard_MaintenanceCost  @pFacilityId=1,@pStartDateMonth=1,@pEndDateMonth=8,@pStartDateYear=2018,@pEndDateYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_MaintenanceCost]    
		@pFacilityId			INT,
		@pStartDateMonth		INT,
		@pEndDateMonth			INT,
		@pStartDateYear			INT,
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

		DECLARE @StartDate DATETIME
		DECLARE @LastDate DATETIME
		DECLARE @EOM AS DATETIME, @EOMT AS DATETIME
	SET @StartDate= DATEFROMPARTS(@pStartDateYear, @pStartDateMonth , 01)
	SET @LastDate = DATEFROMPARTS(@pEndDateYear, @pEndDateMonth , 01)
	SET @EOM = CAST(EOMONTH(@LastDate) AS DATE)
	SET @EOMT = DATEADD(ms, -100, DATEADD(s, 86400, @EOM))	
	SET @LastDate  = @EOMT

-- Execution
		CREATE TABLE #TempTableCount (ID INT , NAME NVARCHAR(100) , COUNTVALUE numeric(24,2))
-- Maintenance Cost
	
	INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE)
	SELECT 0 AS ID,'Labour Cost' AS NAME,ISNULL(SUM(LabourCost),0) AS 'SUMVALUE' FROM EngMaintenanceWorkOrderTxn A 
	INNER JOIN EngMwoPartReplacementTxn B ON A.WorkOrderId = B.WorkOrderId
	WHERE  MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear AND @pEndDateYear
		  AND A.FacilityId = @pFacilityId

	INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE)
	SELECT 0 AS ID,'Spare Part Cost' AS NAME,ISNULL(SUM(TotalPartsCost),0) AS 'SUMVALUE' FROM EngMaintenanceWorkOrderTxn A 
	INNER JOIN EngMwoPartReplacementTxn B ON A.WorkOrderId = B.WorkOrderId
	WHERE MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear AND @pEndDateYear
		  AND A.FacilityId = @pFacilityId


	INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE)
	SELECT 0 AS ID,'Contractor Cost' AS NAME,ISNULL(SUM(C.ContractValue),0) AS 'SUMVALUE' FROM  EngContractOutRegisterDet C 
	INNER JOIN EngContractOutRegister D ON C.ContractId = D.ContractId
	WHERE ( (@StartDate BETWEEN ContractStartDate AND ContractEndDate
          OR @LastDate BETWEEN ContractStartDate AND ContractEndDate
		 ) 
		 or 
		 (ContractStartDate  BETWEEN    @StartDate AND @LastDate
          OR ContractEndDate  BETWEEN   @StartDate AND @LastDate
		 ) 
	) AND  d.FacilityId = @pFacilityId
	--GROUP BY A.FacilityId, A.AssetId



	INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE)
	SELECT 0 AS ID,'Vendor Cost' AS NAME,ISNULL(SUM(VendorCost),0) AS 'SUMVALUE' FROM EngMaintenanceWorkOrderTxn A 
	INNER JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId
	WHERE MONTH(MaintenanceWorkDateTime) BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND YEAR(MaintenanceWorkDateTime) BETWEEN @pStartDateYear AND @pEndDateYear
		  AND A.FacilityId = @pFacilityId


	SELECT * FROM #TempTableCount
END TRY

BEGIN CATCH

throw;

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
