USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_DeductionRevenueList]    Script Date: 20-09-2021 17:05:52 ******/
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
EXEC [uspFM_Home_DashBoard_DeductionRevenueList]  @pFacilityId=1,@pStartDateMonth=8,@pEndDateMonth=8,@pStartDateYear=2018,@pEndDateYear=2018,@pUserId=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_DeductionRevenueList]    
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

DECLARE @pCustomerId INT

SET @pCustomerId = (SELECT CustomerId FROM MstLocationFacility WHERE FacilityId = @pFacilityId)

-- Default Values

		--SET @pStartDateMonth = MONTH(GETDATE())
		--SET @pEndDateMonth	 = MONTH(GETDATE())
		--SET @pStartDateYear	 = YEAR(GETDATE())
		--SET @pEndDateYear	 = YEAR(GETDATE())

-- Execution




		IF EXISTS(SELECT 1 FROM FMConfigCustomerValues WHERE CustomerId =@pCustomerId AND ConfigKeyId BETWEEN 5 AND 10 AND ConfigKeyLovId = 99)
		BEGIN
		IF (@pStartDateMonth = @pEndDateMonth)
		BEGIN

		CREATE TABLE #TempTableCount (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2),MonthId INT,MonthValue NVARCHAR(100) )

		INSERT INTO #TempTableCount(ID,BemsMSF,BemsCF,BemsKPIF,MonthId,MonthValue)
		SELECT A.MonthlyFeeId,ISNULL(B.TotalFee,0),ISNULL(B.BemsCF,0),ISNULL(B.BemsKPIF,0),B.Month,C.Month FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON
		A.MonthlyFeeId = B.MonthlyFeeId
		INNER JOIN FMTimeMonth C	ON B.Month = C.MonthId
		 WHERE A.Year BETWEEN @pStartDateYear AND @pEndDateYear AND 
		 B.Month BETWEEN @pStartDateMonth AND @pEndDateMonth 
		 AND A.FacilityId = @pFacilityId

-- Work Order

		CREATE TABLE #TempTableCounts (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2))
		INSERT INTO #TempTableCounts (ID,BemsMSF,BemsCF,BemsKPIF)
		SELECT 1,SUM(ISNULL(BemsMSF,0)),SUM(ISNULL(BemsCF,0)),SUM(ISNULL(BemsKPIF,0))FROM #TempTableCount
		
		--SELECT * FROM #TempTableCounts

		CREATE TABLE #TempResultSet(ID int, Name nvarchar(200), countValues numeric(24,2))

		insert into #TempResultSet(Id,Name) values (1,'Monthly Service Fee')
		insert into #TempResultSet(Id,Name) values (2,'Amendment Fee')
		insert into #TempResultSet(Id,Name) values (3,'KPI Fee')

		UPDATE B SET B.countValues = ISNULL(A.BemsMSF,0) FROM #TempTableCounts A , #TempResultSet B WHERE B.Name = 'Monthly Service Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsCF,0) FROM #TempTableCounts A , #TempResultSet B WHERE B.Name = 'Amendment Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsKPIF,0) FROM #TempTableCounts A , #TempResultSet B WHERE B.Name = 'KPI Fee'

		SELECT * FROM #TempResultSet

		END

		IF (@pStartDateMonth <> @pEndDateMonth)
		BEGIN

		CREATE TABLE #TempTableCount1 (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2),MonthId INT,MonthValue NVARCHAR(100) )

		INSERT INTO #TempTableCount1(ID,BemsMSF,BemsCF,BemsKPIF,MonthId,MonthValue)
		SELECT A.MonthlyFeeId,ISNULL(B.TotalFee,0),ISNULL(B.BemsCF,0),ISNULL(B.BemsKPIF,0),B.Month,C.Month FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON
		A.MonthlyFeeId = B.MonthlyFeeId
		INNER JOIN FMTimeMonth C	ON B.Month = C.MonthId
		 WHERE A.Year BETWEEN @pStartDateYear AND @pEndDateYear AND 
		 B.Month BETWEEN @pStartDateMonth AND @pEndDateMonth 
		 AND A.FacilityId = @pFacilityId

-- Work Order

		CREATE TABLE #TempTableCounts1 (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2))
		INSERT INTO #TempTableCounts1 (ID,BemsMSF,BemsCF,BemsKPIF)
		SELECT 1,SUM(ISNULL(BemsMSF,0)),SUM(ISNULL(BemsCF,0)),SUM(ISNULL(BemsKPIF,0))FROM #TempTableCount1
		
		--SELECT * FROM #TempTableCounts

		CREATE TABLE #TempResultSet1(ID int, Name nvarchar(200), countValues numeric(24,2))

		insert into #TempResultSet1(Id,Name) values (1,'Yearly Service Fee')
		insert into #TempResultSet1(Id,Name) values (2,'Amendment Fee')
		insert into #TempResultSet1(Id,Name) values (3,'KPI Fee')

		UPDATE B SET B.countValues = ISNULL(A.BemsMSF,0) FROM #TempTableCounts1 A , #TempResultSet1 B WHERE B.Name = 'Yearly Service Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsCF,0) FROM #TempTableCounts1 A , #TempResultSet1 B WHERE B.Name = 'Amendment Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsKPIF,0) FROM #TempTableCounts1 A , #TempResultSet1 B WHERE B.Name = 'KPI Fee'

		SELECT * FROM #TempResultSet1

		END
		END

IF NOT EXISTS(SELECT 1 FROM FMConfigCustomerValues WHERE CustomerId =@pCustomerId AND ConfigKeyId BETWEEN 5 AND 10 AND ConfigKeyLovId = 99)
		BEGIN
		IF (@pStartDateMonth = @pEndDateMonth)
		BEGIN

		CREATE TABLE #TempTableCount21 (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2),MonthId INT,MonthValue NVARCHAR(100) )

		INSERT INTO #TempTableCount21(ID,BemsMSF,BemsCF,BemsKPIF,MonthId,MonthValue)
		SELECT A.MonthlyFeeId,ISNULL(B.TotalFee,0),ISNULL(B.BemsCF,0),ISNULL(B.BemsKPIF,0),B.Month,C.Month FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON
		A.MonthlyFeeId = B.MonthlyFeeId
		INNER JOIN FMTimeMonth C	ON B.Month = C.MonthId
		 WHERE A.Year BETWEEN @pStartDateYear AND @pEndDateYear AND 
		 B.Month BETWEEN @pStartDateMonth AND @pEndDateMonth 
		 AND A.FacilityId = @pFacilityId

-- Work Order

		CREATE TABLE #TempTableCounts21 (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2))
		INSERT INTO #TempTableCounts21 (ID,BemsMSF,BemsCF,BemsKPIF)
		SELECT 1,SUM(ISNULL(BemsMSF,0)),SUM(ISNULL(BemsCF,0)),SUM(ISNULL(BemsKPIF,0))FROM #TempTableCount21
		
		--SELECT * FROM #TempTableCounts

		CREATE TABLE #TempResultSet21(ID int, Name nvarchar(200), countValues numeric(24,2))

		insert into #TempResultSet21(Id,Name) values (1,'Monthly Service Fee')
		insert into #TempResultSet21(Id,Name) values (2,'Amendment Fee')
		insert into #TempResultSet21(Id,Name) values (3,'KPI Fee')

		UPDATE B SET B.countValues = ISNULL(A.BemsMSF,0) FROM #TempTableCounts21 A , #TempResultSet21 B WHERE B.Name = 'Monthly Service Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsCF,0) FROM #TempTableCounts21 A , #TempResultSet21 B WHERE B.Name = 'Amendment Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsKPIF,0) FROM #TempTableCounts21 A , #TempResultSet21 B WHERE B.Name = 'KPI Fee'

		SELECT * FROM #TempResultSet21

		END

		IF (@pStartDateMonth <> @pEndDateMonth)
		BEGIN

		CREATE TABLE #TempTableCount11 (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2),MonthId INT,MonthValue NVARCHAR(100) )

		INSERT INTO #TempTableCount11(ID,BemsMSF,BemsCF,BemsKPIF,MonthId,MonthValue)
		SELECT A.MonthlyFeeId,ISNULL(B.TotalFee,0),ISNULL(B.BemsCF,0),ISNULL(B.BemsKPIF,0),B.Month,C.Month FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON
		A.MonthlyFeeId = B.MonthlyFeeId
		INNER JOIN FMTimeMonth C	ON B.Month = C.MonthId
		 WHERE A.Year BETWEEN @pStartDateYear AND @pEndDateYear AND 
		 B.Month BETWEEN @pStartDateMonth AND @pEndDateMonth 
		 AND A.FacilityId = @pFacilityId

-- Work Order

		CREATE TABLE #TempTableCounts11 (ID INT ,BemsMSF NUMERIC(24,2)  , BemsCF NUMERIC(24,2) , BemsKPIF NUMERIC(24,2))
		INSERT INTO #TempTableCounts11 (ID,BemsMSF,BemsCF,BemsKPIF)
		SELECT 1,SUM(ISNULL(BemsMSF,0)),SUM(ISNULL(BemsCF,0)),SUM(ISNULL(BemsKPIF,0))FROM #TempTableCount11
		
		--SELECT * FROM #TempTableCounts

		CREATE TABLE #TempResultSet11(ID int, Name nvarchar(200), countValues numeric(24,2))

		insert into #TempResultSet11(Id,Name) values (1,'Yearly Service Fee')
		insert into #TempResultSet11(Id,Name) values (2,'Amendment Fee')
		insert into #TempResultSet11(Id,Name) values (3,'KPI Fee')

		UPDATE B SET B.countValues = ISNULL(A.BemsMSF,0) FROM #TempTableCounts11 A , #TempResultSet11 B WHERE B.Name = 'Yearly Service Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsCF,0) FROM #TempTableCounts11 A , #TempResultSet11 B WHERE B.Name = 'Amendment Fee'
		UPDATE B SET B.countValues = ISNULL(A.BemsKPIF,0) FROM #TempTableCounts11 A , #TempResultSet11 B WHERE B.Name = 'KPI Fee'

		SELECT * FROM #TempResultSet11 WHERE ID NOT IN (3)

		END
		END
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
