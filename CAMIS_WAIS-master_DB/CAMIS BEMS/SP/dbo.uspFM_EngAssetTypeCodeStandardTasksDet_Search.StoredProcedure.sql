USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCodeStandardTasksDet_Search]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCodeStandardTasksDet_Search
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetTypeCodeStandardTasksDet_Search  @pAssetTaskCode='',@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCodeStandardTasksDet_Search]                           
  @pAssetTaskCode		NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAssetPPMCheckList		AS	StandardTasCode
					INNER JOIN FMLovMst								AS	LovFrequency		WITH(NOLOCK) ON StandardTasCode.PPMFrequency			=	LovFrequency.LovId
					LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON StandardTasCode.ManufacturerId		=	Manufacturer.ManufacturerId
					LEFT JOIN EngAssetStandardizationModel			AS	Model				WITH(NOLOCK) ON StandardTasCode.ModelId				=	Model.ModelId
		WHERE		StandardTasCode.Active =1
					AND ((ISNULL(@pAssetTaskCode,'') = '' )	OR (ISNULL(@pAssetTaskCode,'') <> '' AND StandardTasCode.TaskCode LIKE + '%' + @pAssetTaskCode + '%' ))
		

		SELECT		StandardTasCode.PPMCheckListId AS  StandardTaskDetId,
					StandardTasCode.TaskCode,
					StandardTasCode.PPMChecklistNo,
					StandardTasCode.TaskDescription,
					StandardTasCode.ModifiedDateUTC,
					StandardTasCode.PPMFrequency,
					LovFrequency.FieldValue			AS	LovPPMFrequency,
					StandardTasCode.ManufacturerId,
					Manufacturer.Manufacturer,
					StandardTasCode.ModelId,
					Model.Model,
					StandardTasCode.PPMHours,
					@TotalRecords					AS	TotalRecords
		FROM		EngAssetPPMCheckList		AS	StandardTasCode
					INNER JOIN FMLovMst								AS	LovFrequency		WITH(NOLOCK) ON StandardTasCode.PPMFrequency			=	LovFrequency.LovId
					LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON StandardTasCode.ManufacturerId		=	Manufacturer.ManufacturerId
					LEFT JOIN EngAssetStandardizationModel			AS	Model				WITH(NOLOCK) ON StandardTasCode.ModelId				=	Model.ModelId
		WHERE		StandardTasCode.Active =1
					AND ((ISNULL(@pAssetTaskCode,'') = '' )	OR (ISNULL(@pAssetTaskCode,'') <> '' AND StandardTasCode.TaskCode LIKE + '%' + @pAssetTaskCode + '%' ))
		ORDER BY	StandardTasCode.ModifiedDateUTC DESC
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
