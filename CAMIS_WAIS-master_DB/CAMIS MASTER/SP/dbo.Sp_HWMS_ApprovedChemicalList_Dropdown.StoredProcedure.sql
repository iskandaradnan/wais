USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ApprovedChemicalList_Dropdown]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Dropdown
Description			: Get lov values by passing LovKeys.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Dropdown  @pLovKey='StatusValue'
EXEC uspFM_Dropdown 'RiskRatingValue,MaintenanceFlagValue,EquipmentFunctionDescriptionValue,YesNoValue,TypeCodeSpecTypeValue,TypeCodeSpecUnitValue'
SELECT * FROM FMLovMst
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
2		04/07/2018	COMMA SEPARATED
========================================================================================================*/
CREATE PROCEDURE [dbo].[Sp_HWMS_ApprovedChemicalList_Dropdown]                          
  @pScreenName	nvarchar(400)
  -- exec Sp_HWMS_ApprovedChemicalList_Dropdown 'ApprovedChemicalLists'
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	
	if(@pScreenName = 'ApprovedChemicalLists')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ChemicalStatusValue' and ModuleName='CLS'


	        SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CategoryValues' and  ModuleName='CLS'
	  
	   
	        SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='AreaOfApplicationValues' and  ModuleName='CLS'

			SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault,SortNo		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='AreaofApplicationValues1' and  ScreenName = 'ApprovedChemicalLists'
	
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
