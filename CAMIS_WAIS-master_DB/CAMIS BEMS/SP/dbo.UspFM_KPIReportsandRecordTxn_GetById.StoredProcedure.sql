USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_KPIReportsandRecordTxn_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngStockAdjustmentTxn_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_KPIReportsandRecordTxn_GetById] @pReportsandRecordTxnId=20

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_KPIReportsandRecordTxn_GetById]                           
  @pReportsandRecordTxnId   INT--,
  
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

			SELECT	ReportsandRecordDet.ReportsandRecordTxnDetId			AS ReportsandRecordTxnDetId,
			ReportsandRecordDet.ReportsandRecordTxnId				AS ReportsandRecordTxnId,
			Replace(ReportsandRecordDet.CustomerReportId,0,Null)	AS CustomerReportId,
			ReportsandRecordDet.ReportName								AS ReportName,
			ReportsandRecordDet.Submitted							AS Submitted,
			ReportsandRecordDet.Verified							AS Verified,
			ReportsandRecordDet.Remarks								AS Remarks,
			ReportsandRecord.Submitted								AS RecordSubmitted,
			ReportsandRecord.Verified								AS RecordVerified,
			CASE WHEN ISNULL(ReportsandRecord.Submitted,0)=0 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN '' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN 'Submitted' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ReportsandRecord.Verified =1 THEN 'Verified' ELSE '' END END END AS Status,
			ReportsandRecord.[Year],
			ReportsandRecord.[Month]
	FROM	KPIReportsandRecordTxn									AS ReportsandRecord			WITH(NOLOCK)
			INNER JOIN  KPIReportsandRecordTxnDet					AS ReportsandRecordDet		WITH(NOLOCK)	ON ReportsandRecord.ReportsandRecordTxnId		= ReportsandRecordDet.ReportsandRecordTxnId
			LEFT JOIN  MstCustomerReport							AS CustomerReport			WITH(NOLOCK)	ON ReportsandRecordDet.CustomerReportId			= CustomerReport.CustomerReportId
	WHERE	ReportsandRecord.ReportsandRecordTxnId  = @pReportsandRecordTxnId

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
