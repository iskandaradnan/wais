USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_KPIGeneration_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_KPIGeneration_GetById
Description			: Get monthly service fee
Authors				: Biju NB
Date				: 07-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_KPIGeneration_GetById  @pYear = 2018, @pMonth = 5, @pCustomerId = 1, @pFacilityId = 2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_KPIGeneration_GetById]                           
		
		@pYear					INT,
		@pMonth					INT,
		@pCustomerId			INT	=	NULL,
		@pFacilityId			INT	=	NULL
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	IF NOT EXISTS (SELECT 1 FROM FinMonthlyFeeTxn A
			JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId
	WHERE A.[Year] = @pYear AND B.[Month] = @pMonth AND A.CustomerId = @pCustomerId AND A.FacilityId = @pFacilityId)
	BEGIN

	SELECT 0 AS MonthlyServiceFee, 0 AS IsDeductionGenerated

	END
	
	ELSE
	BEGIN

	IF EXISTS(SELECT 1 FROM DedGenerationTxn WHERE FacilityId = @pFacilityId AND Month = @pMonth AND Year = @pYear)
	BEGIN
	SELECT	B.BemsMSF	MonthlyServiceFee, 1 AS IsDeductionGenerated
	FROM	FinMonthlyFeeTxn A
			JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId
	WHERE A.[Year] = @pYear AND B.[Month] = @pMonth AND A.CustomerId = @pCustomerId AND A.FacilityId = @pFacilityId
	END

	ELSE 
	BEGIN
		SELECT	B.BemsMSF	MonthlyServiceFee, 0 AS IsDeductionGenerated
	FROM	FinMonthlyFeeTxn A
			JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId
	WHERE A.[Year] = @pYear AND B.[Month] = @pMonth AND A.CustomerId = @pCustomerId AND A.FacilityId = @pFacilityId
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
