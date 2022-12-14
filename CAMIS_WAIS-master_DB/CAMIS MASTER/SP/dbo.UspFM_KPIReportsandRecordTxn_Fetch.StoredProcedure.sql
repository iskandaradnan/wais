USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_KPIReportsandRecordTxn_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngStockAdjustmentTxn_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_KPIReportsandRecordTxn_Fetch] @pMonth=5,@pYear=2018,@pFacilityId=1,@pCustomerId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_KPIReportsandRecordTxn_Fetch]                           
  @pMonth				INT	=	NULL,
  @pYear				INT	=	NULL,
  @pFacilityId			INT	=	NULL,
  @pCustomerId			INT	=	NULL
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pMonth,0) = 0) RETURN

	DECLARE @pReportsandRecordTxnId INT

	SET @pReportsandRecordTxnId = (SELECT ReportsandRecordTxnId FROM KPIReportsandRecordTxn WHERE Month = @pMonth AND Year = @pYear AND FacilityId = @pFacilityId)


	IF(@pReportsandRecordTxnId IS NOT NULL)
	BEGIN
    SELECT	ReportsandRecordDet.ReportsandRecordTxnDetId			AS ReportsandRecordTxnDetId,
			ReportsandRecordDet.ReportsandRecordTxnId				AS ReportsandRecordTxnId,
			ReportsandRecordDet.CustomerReportId					AS CustomerReportId,
			ReportsandRecordDet.ReportName								AS ReportName,
			ReportsandRecordDet.Submitted							AS Submitted,
			ReportsandRecordDet.Verified							AS Verified,
			ReportsandRecordDet.Remarks								AS Remarks,
			ReportsandRecord.Submitted								AS RecordSubmitted,
			ReportsandRecord.Verified								AS RecordVerified,
			CASE WHEN ISNULL(ReportsandRecord.Submitted,0)=0 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN '' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN 'Submitted' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ReportsandRecord.Verified =1 THEN 'Verified' ELSE '' END END END AS Status

	FROM	KPIReportsandRecordTxn									AS ReportsandRecord			WITH(NOLOCK)
			INNER JOIN  KPIReportsandRecordTxnDet					AS ReportsandRecordDet		WITH(NOLOCK)	ON ReportsandRecord.ReportsandRecordTxnId		= ReportsandRecordDet.ReportsandRecordTxnId
			--LEFT JOIN  MstCustomerReport							AS CustomerReport			WITH(NOLOCK)	ON ReportsandRecordDet.CustomerReportId			= CustomerReport.CustomerReportId
	WHERE	ReportsandRecord.ReportsandRecordTxnId = @pReportsandRecordTxnId 
	ORDER BY ReportsandRecord.ModifiedDate ASC
	END

	IF(@pReportsandRecordTxnId IS NULL)
	BEGIN
    SELECT	0														AS ReportsandRecordTxnDetId,
			0														AS ReportsandRecordTxnId,
			CustomerReport.CustomerReportId							AS CustomerReportId,
			CustomerReport.ReportName								AS ReportName,
			CAST(0 AS BIT)											AS Submitted,
			CAST(0 AS BIT)											AS Verified,
			''														AS Remarks,
			CAST(0 AS BIT)										    AS RecordSubmitted,
			CAST(0 AS BIT)											AS RecordVerified,
			''														AS Status
	FROM	MstCustomerReport										AS CustomerReport			
	WHERE	CustomerReport.FacilityId			= @pFacilityId
	--ORDER BY ReportsandRecord.ModifiedDate ASC

	UNION

	 SELECT	0														AS ReportsandRecordTxnDetId,
			0														AS ReportsandRecordTxnId,
			CustomerReport.CustomerReportId							AS CustomerReportId,
			CustomerReport.ReportName								AS ReportName,
			CAST(0 AS BIT)											AS Submitted,
			CAST(0 AS BIT)											AS Verified,
			''														AS Remarks,
			CAST(0 AS BIT)											AS RecordSubmitted,
			CAST(0 AS BIT)											AS RecordVerified,
			''														AS Status
	FROM	MstCustomerReport										AS CustomerReport			
	WHERE	CustomerReport.FacilityId			IS NULL AND CustomerReport.CustomerId = @pCustomerId
	--ORDER BY ReportsandRecord.ModifiedDate ASC

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
