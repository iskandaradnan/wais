USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_KPIPer]    Script Date: 20-09-2021 17:05:52 ******/
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
EXEC [uspFM_Home_DashBoard_KPIPer]  @pFacilityId=2,@pStartDateMonth=1,@pEndDateMonth=7,@pStartDateYear=2018,@pEndDateYear=2018,@pUserId=NULL

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_KPIPer]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   ,
		@pEndDateMonth			INT	  ,
		@pStartDateYear			INT	  ,
		@pEndDateYear			INT	  ,
		@pUserId				INT   =NULL

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
		DECLARE @Cnt INT
-- Execution
		CREATE TABLE #TempTableCount (NAME NVARCHAR(100) , DeductionValue numeric(24,2) DEFAULT 0.0,DeductionPercentage numeric(24,2))

-- Work Order
	
	INSERT INTO #TempTableCount(NAME,DeductionValue,DeductionPercentage)
	SELECT C.IndicatorNo,SUM(ISNULL(B.DeductionValue,0)),SUM(ISNULL(b.DeductionPercentage,0)) FROM DedGenerationTxn A
	INNER JOIN DedGenerationTxnDet B ON A.DedGenerationId = B.DedGenerationId
	INNER JOIN MstDedIndicatorDet C ON B.IndicatorDetId = C.IndicatorDetId
	INNER JOIN FMTimeMonth D ON A.Month = D.MonthId
	WHERE  A.Month BETWEEN @pStartDateMonth	AND @pEndDateMonth
		  AND A.YEAR BETWEEN @pStartDateYear		AND @pEndDateYear
		  AND A.FacilityId = @pFacilityId
	GROUP BY C.IndicatorNo
	
	SELECT @Cnt=COUNT(*) FROM #TempTableCount

	IF(ISNULL(@Cnt,0)=0)
		BEGIN
			SELECT	
					IndicatorNo AS NAME,
					0.00 as DeductionValue,
					0.00 as DeductionPercentage
			FROM MstDedIndicatorDet
		END
	ELSE
		BEGIN
			SELECT * FROM #TempTableCount
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
