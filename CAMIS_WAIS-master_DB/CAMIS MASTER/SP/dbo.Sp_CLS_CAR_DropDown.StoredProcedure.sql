USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CAR_DropDown]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CAR_DropDown]
@pScreenName	nvarchar(400)
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	if(@pScreenName = 'CorrectiveActionReport')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CARPriorityValues' and ScreenName = @pScreenName

	        SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CARStatusValues' and  ScreenName = @pScreenName	 

			SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CARResponsibilityValues' and  ScreenName = @pScreenName	 
			
		     SELECT	LovId	AS LovId,	FieldValue	AS FieldValue, IsDefault,SortNo		FROM	FMLovMst WITH(NOLOCK)
		     WHERE	Active = 1 	AND LovKey='FileTypeValues'  

			 SELECT IndicatorMasterId AS LovId , IndicatorNo AS FieldValue, CAST(0 as bit) AS IsDefault FROM HWMS_IndicatorMaster 

			

			
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
