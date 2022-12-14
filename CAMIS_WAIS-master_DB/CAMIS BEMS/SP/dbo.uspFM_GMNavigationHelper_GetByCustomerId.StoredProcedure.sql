USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GMNavigationHelper_GetByCustomerId]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_GMNavigationHelper_GetByCustomerId]
Description			: To Get the CustomerConfig Values
Authors				: Dhilip V
Date				: 30-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_GMNavigationHelper_GetByCustomerId] @pCustomerId=88

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_GMNavigationHelper_GetByCustomerId]                           

  @pCustomerId			INT


AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SELECT	CustomerValues.ConfigValueId,
			CustomerValues.CustomerId,
			CustomerValues.ConfigKeyId,
			CustomerValues.ConfigKeyLovId AS ThemeColorId,			
			LovVal.FieldValue	AS ThemeColorName,
			Customer.CustomerName  as CustomerName

	FROM	FMConfigCustomerValues AS CustomerValues
	LEFT JOIN FMLovMst								AS LovVal		WITH(NOLOCK)	ON CustomerValues.ConfigKeyLovId			= LovVal.LovId
	LEFT JOIN MstCustomer								AS Customer		WITH(NOLOCK)	ON CustomerValues.CustomerId			= Customer.CustomerId

	--inner join MstCustomer AS Customer WITH(NOLOCK) ON  CustomerValues.CustomerId = Customer.CustomerId
	WHERE	CustomerValues.CustomerId	=	@pCustomerId
	AND CustomerValues.ConfigKeyId=12



END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   throw;
END CATCH
GO
