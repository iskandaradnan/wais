USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMConfigCustomerValues_GetCustomerConfig]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMConfigCustomerValues_GetCustomerConfig
Description			: To Get the CustomerConfig Values
Authors				: Dhilip V
Date				: 30-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_FMConfigCustomerValues_GetCustomerConfig] @pCustomerId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FMConfigCustomerValues_GetCustomerConfig]                           

  @pCustomerId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	SELECT	ConfigValueId,
			KeyName,
			LovMst.FieldValue	AS KeyValues
	FROM	FMConfigCustomerValues AS CustomerValues
			INNER JOIN FMLovMst	AS	LovMst ON CustomerValues.ConfigKeyLovId = LovMst.LovId
	WHERE	CustomerId	=	@pCustomerId



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
