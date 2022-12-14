USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FinMonthlyFeeTxnRevision_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FinMonthlyFeeTxnRevision_GetById
Description			: To Get the data from table FinMonthlyFeeTxn using the Primary Key id
Authors				: Dhilip V
Date				: 03-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_FinMonthlyFeeTxnRevision_GetById] @pMonthlyFeeId=18,@pVersionNo=1,@pYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_FinMonthlyFeeTxnRevision_GetById]                           

  @pFacilityId		INT,
  @pVersionNo		INT,
  @pYear			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    SELECT	MonthlyFeeTxn.MonthlyFeeId							AS MonthlyFeeId,
			MonthlyFeeTxn.CustomerId							AS CustomerId,
			MonthlyFeeTxn.FacilityId							AS FacilityId,
			MonthlyFeeTxn.Year									AS Year,
			MonthlyFeeHistory.MonthlyFeeDetId					AS MonthlyFeeDetId,
			MonthlyFeeHistory.MonthlyFeeId						AS MonthlyFeeId,
			MonthlyFeeHistory.Month								AS Month,
			MonthlyFeeMonth.Month								AS MonthlyFeeMonth,
			MonthlyFeeHistory.VersionNo							AS VersionNo,
			MonthlyFeeHistory.BemsMSF							AS BemsMSF,
			MonthlyFeeHistory.BemsCF							AS BemsCF,
			MonthlyFeeHistory.BemsPercent						AS BemsPercent,
			MonthlyFeeHistory.TotalFee							AS TotalFee,
			MonthlyFeeHistory.IsAmdGenerated					AS IsAmdGenerated,
			MonthlyFeeHistory.AmdUserId							AS AmdUserId,
			MonthlyFeeHistory.AmdDate							AS AmdDate,
			MonthlyFeeHistory.AmdDateUTC						AS AmdDateUTC,
			MonthlyFeeTxn.Timestamp								AS Timestamp
	FROM	FinMonthlyFeeTxn									AS MonthlyFeeTxn		WITH(NOLOCK)
			INNER JOIN  FinMonthlyFeeHistoryTxnDet				AS MonthlyFeeHistory	WITH(NOLOCK)	ON MonthlyFeeTxn.MonthlyFeeId	= MonthlyFeeHistory.MonthlyFeeId
			INNER JOIN	FMTimeMonth								AS MonthlyFeeMonth		WITH(NOLOCK)	on MonthlyFeeHistory.Month		= MonthlyFeeMonth.MonthId
	WHERE	MonthlyFeeTxn.FacilityId		= @pFacilityId 
			AND MonthlyFeeTxn.Year			=	@pYear
			AND MonthlyFeeHistory.VersionNo	=	@pVersionNo
	ORDER BY MonthlyFeeMonth.MonthId ASC



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
