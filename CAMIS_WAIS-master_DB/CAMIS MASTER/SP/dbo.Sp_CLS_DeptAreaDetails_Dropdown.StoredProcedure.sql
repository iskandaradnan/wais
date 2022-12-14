USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDetails_Dropdown]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[Sp_CLS_DeptAreaDetails_Dropdown](                          
  @pScreenName	nvarchar(400))
  -- exec Sp_CLS_DeptAreaDetails_Dropdown 'ApprovedChemicalList'
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	
	if(@pScreenName = 'DeptAreaDetail' )
	BEGIN
	        SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CategoryofAreaValues' and  ScreenName = @pScreenName

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='DeptsStatusValues'  AND ModuleName='CLS'


	        SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='OperatingDaysValues' AND  ModuleName='CLS'
	  
	   
	        SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='DeptWorkingHoursValues'   AND  ModuleName='CLS'

			 SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='DeptJIScheduleValues' AND   ModuleName='CLS'

			SELECT	LovId		AS LovId,	FieldValue	AS FieldValue, IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ContainerReceptaclesWashingValues' AND   ModuleName='CLS'

			SELECT LovId		AS LovId,	FieldValue AS FieldValue,	IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='FrequencyValues' AND   ModuleName='CLS'

			SELECT LovId		AS LovId,	FieldValue AS FieldValue,	IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='VariationStatusValues' AND   ModuleName='CLS'

			SELECT LovId		AS LovId,	FieldValue AS FieldValue,	IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ToiletTypeValues' AND   ModuleName='CLS'

			SELECT LovId		AS LovId,	FieldValue AS FieldValue,	IsDefault		FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ToiletDetailsValues' AND   ModuleName='CLS'


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
