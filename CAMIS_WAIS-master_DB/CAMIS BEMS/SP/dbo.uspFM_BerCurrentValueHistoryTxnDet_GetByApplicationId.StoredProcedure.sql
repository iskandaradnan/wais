USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BerCurrentValueHistoryTxnDet_GetByApplicationId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BerCurrentValueHistoryTxnDet_GetByApplicationId
Description			: To Get the data from table BERApplicationTxn using the Primary Key id
Authors				: Dhilip V
Date				: 21-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_BerCurrentValueHistoryTxnDet_GetByApplicationId] @pApplicationId=16
SELECT * FROM BERApplicationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BerCurrentValueHistoryTxnDet_GetByApplicationId]                           

  @pApplicationId   INT	=	NULL


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE	  @TotalRecords		INT
	--DECLARE   @pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pApplicationId,0) = 0) RETURN

	--SELECT	@TotalRecords	=	COUNT(*)
	--FROM	BERApplicationTxn									AS BERApplication		WITH(NOLOCK)
	--		INNER JOIN BerCurrentValueHistoryTxnDet				AS BerCurrentValue		WITH(NOLOCK)	ON BERApplication.ApplicationId	=	BerCurrentValue.ApplicationId
	--		LEFT JOIN UMUserRegistration						AS UserReg				WITH(NOLOCK)	ON BerCurrentValue.CreatedBy	=	UserReg.UserRegistrationId
	--WHERE	BERApplication.ApplicationId = @pApplicationId 




    SELECT	BERApplication.ApplicationId						AS ApplicationId,
			BerCurrentValue.CurrentValueId						AS CurrentValueId,
			BerCurrentValue.CurrentValue						AS CurrentValue,
			BerCurrentValue.Remarks								AS Remarks,
			UserReg.StaffName									AS UpdatedBy
	FROM	BERApplicationTxn									AS BERApplication		WITH(NOLOCK)
			INNER JOIN BerCurrentValueHistoryTxnDet				AS BerCurrentValue		WITH(NOLOCK)	ON BERApplication.ApplicationId	=	BerCurrentValue.ApplicationId
			LEFT JOIN UMUserRegistration						AS UserReg				WITH(NOLOCK)	ON BerCurrentValue.CreatedBy	=	UserReg.UserRegistrationId
	WHERE	BERApplication.ApplicationId = @pApplicationId 
	ORDER BY BERApplication.ModifiedDate DESC


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
