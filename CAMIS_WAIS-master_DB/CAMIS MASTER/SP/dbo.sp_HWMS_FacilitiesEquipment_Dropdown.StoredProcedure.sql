USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_FacilitiesEquipment_Dropdown]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-HWMS              
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
CREATE PROCEDURE [dbo].[sp_HWMS_FacilitiesEquipment_Dropdown]                          
  @pScreenName	nvarchar(400)
  -- exec sp_HWMS_FacilitiesEquipment_Dropdown 'FacilitiesEquipment'
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	
	if(@pScreenName = 'FacilitiesEquipment')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='FacilitiesStatusLovs' and ScreenName = @pScreenName


	   SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ItemTypesLovs' and  ScreenName = @pScreenName
	  
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
