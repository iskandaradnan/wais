USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[ChemicalInUse_Dropdowns]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ChemicalInUse_Dropdowns]                         
  @pLovKey	nvarchar(4000)
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	IF(@pLovKey='ChemicalInUseCategoryValues')
		BEGIN
			SELECT	LovId		AS LovId,
					FieldValue	AS FieldValue					
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 
					AND LovKey='ChemicalInUseCategoryValues'
	   END
	   ELSE IF(@pLovKey='ChemicalInUseAreaOfApplicationValues')
	   BEGIN
	   SELECT	LovId		AS LovId,
					FieldValue	AS FieldValue					
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 
					AND LovKey='ChemicalInUseAreaOfApplicationValues'
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
