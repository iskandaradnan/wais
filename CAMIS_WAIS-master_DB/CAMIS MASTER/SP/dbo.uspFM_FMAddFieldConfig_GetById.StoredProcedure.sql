USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMAddFieldConfig_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMAddFieldConfig_GetById
Description			: To Get config fields for the screen
Authors				: Dhilip V
Date				: 11-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_FMAddFieldConfig_GetById] @pCustomerId=1,@pScreenNameLovId=314

SELECT * FROM FMAddFieldConfig
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FMAddFieldConfig_GetById]                           

  @pCustomerId			INT,
  @pScreenNameLovId		INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    SELECT	AddFieldConfigId,
			Config.CustomerId,
			Customer.CustomerName,
			ScreenNameLovId,
			LovScreenName.FieldValue	AS ScreenName,
			FieldTypeLovId,
			LovFieldType.FieldValue	AS FieldType,
			Config.FieldName,
			Name,
			DropDownValues,
			RequiredLovId,
			LovRequired.FieldValue	AS IsRequired,
			PatternLovId,
			LovPattern.FieldValue	AS Pattern,
			LovPattern.Remarks	AS PatternValue,
			MaxLength,
			dbo.[udf_AdditionalFieldsCheck](@pCustomerId, ScreenNameLovId, Config.FieldName, FieldTypeLovId) AS IsUsed
	FROM	FMAddFieldConfig								AS Config			WITH(NOLOCK)
			INNER JOIN	MstCustomer							AS Customer			WITH(NOLOCK)	ON Config.CustomerId		= Customer.CustomerId
			INNER JOIN	FMLovMst							AS LovScreenName	WITH(NOLOCK)	ON Config.ScreenNameLovId	= LovScreenName.LovId
			INNER JOIN	FMLovMst							AS LovFieldType		WITH(NOLOCK)	ON Config.FieldTypeLovId	= LovFieldType.LovId
			INNER JOIN	FMLovMst							AS LovRequired		WITH(NOLOCK)	ON Config.RequiredLovId		= LovRequired.LovId
			LEFT JOIN	FMLovMst							AS LovPattern		WITH(NOLOCK)	ON Config.PatternLovId		= LovPattern.LovId
	WHERE	Config.CustomerId = @pCustomerId 
			AND Config.ScreenNameLovId = @pScreenNameLovId 

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
