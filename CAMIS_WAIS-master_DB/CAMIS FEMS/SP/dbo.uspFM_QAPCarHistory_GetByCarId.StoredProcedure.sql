USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPCarHistory_GetByCarId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAPCarHistory_GetByCarId
Description			: To Get the Corrective Action Report details
Authors				: Dhilip V
Date				: 21-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_QAPCarHistory_GetByCarId] @pCarId=12

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_QAPCarHistory_GetByCarId]                           

  @pCarId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pCarId,0) = 0) RETURN


    SELECT	Car.CarId,
			CarHis.RootCause,
			CarHis.Solution,
			CarHis.Status,
			LovStatus.FieldValue			AS	StatusValue,
			CarHis.Remarks,
			LastModified.StaffName           ModifiedBy,
			CarHis.ModifiedDate


	FROM	QAPCarTxn						AS	Car					WITH(NOLOCK)
			INNER JOIN QAPCarHistory		AS	CarHis				WITH(NOLOCK) ON Car.CarId			=	CarHis.CarId
			LEFT JOIN FMLovMst				AS	LovStatus			WITH(NOLOCK) ON CarHis.Status		=	LovStatus.LovId
			LEFT  JOIN	UMUserRegistration	AS LastModified		WITH(NOLOCK)	 ON LastModified.UserRegistrationId	= CarHis.ModifiedBy
	WHERE	Car.CarId = @pCarId  


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
