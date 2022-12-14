USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngPPMRegisterMst_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngPPMRegisterMst_GetById
Description			: To Get the data from table EngPPMRegisterMst using the Primary Key id
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngPPMRegisterMst_GetById] @pPPMId=10,@pPageIndex=1,@pPageSize=5
SELECT * FROM EngPPMRegisterMst
SELECT * FROM EngPPMRegisterHistoryMst
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngPPMRegisterMst_GetById]                           

  @pPPMId			INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pPPMId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngPPMRegisterHistoryMst							AS PPMRegisterHistory	WITH(NOLOCK)
			LEFT JOIN	EngPPMRegisterMst						AS 	PPMRegister			WITH(NOLOCK)	ON PPMRegister.PPMId				= PPMRegisterHistory.PPMId
			LEFT JOIN	FMDocument								AS Document				WITH(NOLOCK)	ON PPMRegisterHistory.DocumentID	= Document.DocumentID
	WHERE	PPMRegister.PPMId = @pPPMId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	PPMRegister.PPMId									AS PPMId,
			PPMRegister.AssetTypeCodeId							AS AssetTypeCodeId,
			AssetTypeCode.AssetTypeCode							AS AssetTypeCode,
			AssetTypeCode.AssetTypeDescription					AS AssetTypeDescription,
			PPMRegister.BemsTaskCode							AS BemsTaskCode,
			PPMRegister.PPMChecklistNo							AS PPMChecklistNo,
			PPMRegister.ManufacturerId							AS ManufacturerId,
			Manufacturer.Manufacturer							AS Manufacturer,
			PPMRegister.ModelId									AS ModelId,
			Model.Model											AS Model,
			PPMRegister.PPMFrequency							AS PPMFrequency,
			PPMFrequency.FieldValue								AS PPMFrequencyValue,
			PPMRegister.PPMHours								AS PPMHours,
			PPMRegister.Timestamp								AS [Timestamp],
			PPMRegister.Active
	FROM	EngPPMRegisterMst									AS PPMRegister				WITH(NOLOCK)
			INNER JOIN  EngAssetTypeCode						AS AssetTypeCode			WITH(NOLOCK)	ON PPMRegister.AssetTypeCodeId		= AssetTypeCode.AssetTypeCodeId			
			LEFT JOIN	EngAssetStandardizationManufacturer		AS Manufacturer				WITH(NOLOCK)	ON PPMRegister.ManufacturerId		= Manufacturer.ManufacturerId
			LEFT JOIN	EngAssetStandardizationModel			AS Model					WITH(NOLOCK)	ON PPMRegister.ModelId				= Model.ModelId
			LEFT JOIN	FMLovMst								AS PPMFrequency				WITH(NOLOCK)	ON PPMRegister.PPMFrequency			= PPMFrequency.LovId
	WHERE	PPMRegister.PPMId = @pPPMId 


select		PPMRegisterHistory.PPMHistoryId						AS PPMHistoryId,
			PPMRegisterHistory.PPMId							AS PPMId,
			PPMRegisterHistory.DocumentId						AS DocumentId,
			Document.DocumentNo									AS DocumentNo,
			Document.DocumentTitle								AS DocumentTitle,
			PPMRegisterHistory.Version							AS Version,
			PPMRegisterHistory.EffectiveDate					AS EffectiveDate,
			PPMRegisterHistory.UploadDate						AS UploadDate,
			Document.DocumentTitle,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	EngPPMRegisterHistoryMst							AS PPMRegisterHistory	WITH(NOLOCK)
			LEFT JOIN	EngPPMRegisterMst						AS PPMRegister			WITH(NOLOCK)	ON PPMRegister.PPMId				= PPMRegisterHistory.PPMId
			LEFT JOIN	FMDocument								AS Document				WITH(NOLOCK)	ON PPMRegisterHistory.DocumentID	= Document.DocumentID
        
	WHERE	PPMRegister.PPMId = @pPPMId 
	ORDER BY PPMRegisterHistory.Version desc
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



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
