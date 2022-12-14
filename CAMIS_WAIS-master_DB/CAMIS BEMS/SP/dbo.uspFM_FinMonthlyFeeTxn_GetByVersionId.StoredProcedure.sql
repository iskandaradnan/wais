USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FinMonthlyFeeTxn_GetByVersionId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FinMonthlyFeeTxn_GetByVersionId
Description			: To Get the data from table FinMonthlyFeeTxn using the Primary Key id
Authors				: Dhilip V
Date				: 03-MAY-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_FinMonthlyFeeTxn_GetByVersionId] @pYear=2019,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_FinMonthlyFeeTxn_GetByVersionId]   
                        
  @pYear			INT,
  @pFacilityId		INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



 			SELECT	DISTINCT MonthlyFeeHistory.VersionNo AS LovId,
					MonthlyFeeHistory.VersionNo AS FieldValue
			FROM	FinMonthlyFeeHistoryTxnDet	AS MonthlyFeeHistory WITH(NOLOCK)	
					INNER JOIN FinMonthlyFeeTxn	AS MonthlyFee		 WITH(NOLOCK)	ON MonthlyFee.MonthlyFeeId = MonthlyFee.MonthlyFeeId
			WHERE	MonthlyFee.Year				=	@pYear
					AND MonthlyFee.FacilityId	=	@pFacilityId
					AND MonthlyFeeHistory.Year		=	@pYear
					--AND MonthlyFee.MonthlyFeeId	IN (SELECT MonthlyFeeId FROM FinMonthlyFeeHistoryTxnDet WHERE MonthlyFeeId IN 
					--(SELECT MonthlyFeeId FROM FinMonthlyFeeTxn WHERE Year =@pYear AND FacilityId =@pFacilityId) )

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
