USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsignNoteOSWCN_Dropdown]    Script Date: 20-09-2021 16:43:00 ******/
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
CREATE PROCEDURE  [dbo].[Sp_HWMS_ConsignNoteOSWCN_Dropdown](                          
  @pScreenName	nvarchar(400))
 
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Execution
	
	if(@pScreenName = 'ConsignmentNoteOSWCN' )
	BEGIN
	        SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='TransportationCategoryValues' and  ScreenName = @pScreenName
		

			  SELECT	LovId	AS LovId,	FieldValue	AS FieldValue, IsDefault,SortNo		FROM	FMLovMst WITH(NOLOCK)
		    WHERE	Active = 1 	AND LovKey='FileTypeValues' and  ScreenName = 'ApprovedChemicalList'
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
