USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPCarTxn_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_QAPCarTxn_Fetch]
Description			: CAR number fetch control
Authors				: Dhilip V
Date				: 19-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_QAPCarTxn_Fetch]  @pCARNumber=null,@pPageIndex=1,@pPageSize=20,@pFacilityId=1,@pCARId=36,@pIndicatorId=1

SELECT * FROM QAPCarTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_QAPCarTxn_Fetch]                           
                            
  @pCARNumber				NVARCHAR(100)	=NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pFacilityId				INT,
  @pCARId					INT				=NULL,
  @pIndicatorId				INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

		SELECT CarId INTO #CarIdResult FROM QAPCarTxn WHERE IsAutoCar =1
	--	EXCEPT
	--	SELECT FollowupCARId FROM QAPCarTxn WHERE FollowupCARId IS NOT NULL

-- Default Values

-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		QAPCarTxn					AS	Car		WITH(NOLOCK)
		WHERE		((ISNULL(@pCARNumber,'')='' )		OR (ISNULL(@pCARNumber,'') <> '' AND Car.CARNumber LIKE '%' + @pCARNumber + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )	OR (ISNULL(@pFacilityId,'') <> '' AND Car.FacilityId = @pFacilityId))
					AND ((ISNULL(@pIndicatorId,'')='' )	OR (ISNULL(@pIndicatorId,'') <> '' AND Car.QAPIndicatorId = @pIndicatorId))
					AND ((ISNULL(@pCARId,'')='' )	OR (ISNULL(@pCARId,'') <> '' AND Car.CarId <> @pCARId))
					AND IsAutoCar =1 AND CarId IN (SELECT CarId FROM #CarIdResult)

		SELECT		Car.CarId,
					Car.CARNumber,
					Car.CARDate,
					Car.FromDate,
					Car.ToDate,
					@TotalRecords AS TotalRecords
		FROM		QAPCarTxn					AS	Car		WITH(NOLOCK)
		WHERE		((ISNULL(@pCARNumber,'')='' )		OR (ISNULL(@pCARNumber,'') <> '' AND Car.CARNumber LIKE '%' + @pCARNumber + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )	OR (ISNULL(@pFacilityId,'') <> '' AND Car.FacilityId = @pFacilityId))
					AND ((ISNULL(@pIndicatorId,'')='' )	OR (ISNULL(@pIndicatorId,'') <> '' AND Car.QAPIndicatorId = @pIndicatorId))
					AND ((ISNULL(@pCARId,'')='' )	OR (ISNULL(@pCARId,'') <> '' AND Car.CarId <> @pCARId))
					AND IsAutoCar =1 AND CarId IN (SELECT CarId FROM #CarIdResult)
		ORDER BY	Car.ModifiedDateUTC DESC
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
