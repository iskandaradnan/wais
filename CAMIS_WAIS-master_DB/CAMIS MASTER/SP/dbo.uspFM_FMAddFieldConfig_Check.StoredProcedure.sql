USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMAddFieldConfig_Check]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMAddFieldConfig_Check
Description			: To Get config fields for the screen
Authors				: Dhilip V
Date				: 11-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_FMAddFieldConfig_Check] @pCustomerId=38,@pScreenNameLovId=314

SELECT * FROM FMAddFieldConfig
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FMAddFieldConfig_Check]                           

  @pCustomerId			INT,
  @pScreenNameLovId		INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mAddFieldsCheck int 

	SET @mAddFieldsCheck=0

	IF(( SELECT	COUNT(*)
			FROM	FMAddFieldConfig			AS Config			WITH(NOLOCK)
					INNER JOIN	MstCustomer		AS Customer			WITH(NOLOCK)	ON Config.CustomerId		= Customer.CustomerId
					INNER JOIN	FMLovMst		AS LovScreenName	WITH(NOLOCK)	ON Config.ScreenNameLovId	= LovScreenName.LovId
			WHERE	Config.CustomerId = @pCustomerId 
					AND Config.ScreenNameLovId = @pScreenNameLovId 
		) >0)
		BEGIN
			SET @mAddFieldsCheck = (SELECT	COUNT(*)
									FROM	FMAddFieldConfig			AS Config			WITH(NOLOCK)
											INNER JOIN	MstCustomer		AS Customer			WITH(NOLOCK)	ON Config.CustomerId		= Customer.CustomerId
											INNER JOIN	FMLovMst		AS LovScreenName	WITH(NOLOCK)	ON Config.ScreenNameLovId	= LovScreenName.LovId
									WHERE	Config.CustomerId = @pCustomerId 
											AND Config.ScreenNameLovId = @pScreenNameLovId )
	END
	ELSE
	BEGIN
		SET @mAddFieldsCheck=0
	END

SELECT @mAddFieldsCheck

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
