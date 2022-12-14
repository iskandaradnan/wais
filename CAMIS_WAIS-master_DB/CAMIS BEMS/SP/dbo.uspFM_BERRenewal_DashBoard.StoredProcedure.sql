USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERRenewal_DashBoard]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERRenewal_DashBoard
Description			: Get the Deduction_DashBoard
Authors				: Dhilip V
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_BERRenewal_DashBoard  @pFacilityId=2,@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BERRenewal_DashBoard]    
		@pFacilityId	INT,
		@pPageIndex		INT,
		@pPageSize		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE	@TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

-- Default Values

	

-- Execution

	SELECT 	@TotalRecords	=	COUNT(1) 
			FROM	BERApplicationTxn								AS	BER				WITH(NOLOCK)
			INNER JOIN FMLovMst								AS	LovBERStatus	WITH(NOLOCK)	ON	BER.BERStatus		=	LovBERStatus.LovId
			INNER JOIN BERApplicationRenewalHistoryTxnDet	AS	RenewalHistory	WITH(NOLOCK)	ON	BER.ApplicationId	=	RenewalHistory.ApplicationId
	WHERE	BER.FacilityId	=	@pFacilityId

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))
	SET @pTotalPage = CEILING(@pTotalPage)

	SELECT	BER.BERno,
			LovBERStatus.FieldValue	AS	BERStatusName,
			RenewalHistory.RenewalDate,
			@TotalRecords			AS	TotalRecords,
			@pTotalPage				AS	TotalPageCalc
	FROM	BERApplicationTxn								AS	BER				WITH(NOLOCK)
			INNER JOIN FMLovMst								AS	LovBERStatus	WITH(NOLOCK)	ON	BER.BERStatus		=	LovBERStatus.LovId
			INNER JOIN BERApplicationRenewalHistoryTxnDet	AS	RenewalHistory	WITH(NOLOCK)	ON	BER.ApplicationId	=	RenewalHistory.ApplicationId
	WHERE	BER.FacilityId	=	@pFacilityId
	ORDER BY	RenewalHistory.RenewalDate DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY  

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
