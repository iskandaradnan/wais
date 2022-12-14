USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetPPMCheckList_GetById
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetPPMCheckList_GetById  @pPPMCheckListId=76

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckList_GetById]                           
  @pPPMCheckListId		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pPPMCheckListId,0) = 0) RETURN

	--	1	EngAssetPPMCheckList
	SELECT		PPMCheckList.PPMCheckListId,
				PPMCheckList.AssetTypeCodeId,
				TypeCode.AssetTypeCode,
				TypeCode.AssetTypeDescription	AS	AssetTypeCodeDesc,
				PPMCheckList.TaskCode,
				PPMCheckList.TaskDescription,
				PPMCheckList.PPMChecklistNo,
				PPMCheckList.ManufacturerId,
				Manufacturer.Manufacturer,
				PPMCheckList.ModelId,
				Model.Model,
				PPMCheckList.PPMFrequency		AS	PPMFrequency,
				LovFrequency.FieldValue			AS	PPMFrequencyName,
				PPMCheckList.PPMHours,
				PPMCheckList.SpecialPrecautions,
				PPMCheckList.Remarks,
				PPMCheckList.Active,
				PPMCheckList.ServiceId,
 				PPMCheckList.[Timestamp]

	    From EngAssetPPMCheckList PPMCheckList
			INNER JOIN EngAssetTypeCode						AS	TypeCode		 WITH(NOLOCK) ON PPMCheckList.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
			INNER JOIN FMLovMst								AS	LovFrequency	 WITH(NOLOCK) ON PPMCheckList.PPMFrequency		=	LovFrequency.LovId
		    INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK) ON PPMCheckList.ManufacturerId		=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS	Model					WITH(NOLOCK) ON PPMCheckList.ModelId				=	Model.ModelId
		WHERE	PPMCheckList.PPMCheckListId	=	@pPPMCheckListId

	

		--	5	EngAssetPPMCheckListMaintTasksMstDet
		SELECT	Quantasks.PPMCheckListQNId,
				Quantasks.PPMCheckListId,
				Quantasks.QuantitativeTasks,
				Quantasks.UOM,
				UOM.UnitOfMeasurement,
				Quantasks.SetValues,
				Quantasks.LimitTolerance,
				Quantasks.Active
		FROM	EngAssetPPMCheckListQuantasksMstDet	AS	Quantasks	WITH(NOLOCK)
		INNER JOIN FMUOM										AS	UOM			 WITH(NOLOCK) ON Quantasks.UOM				=	UOM.UOMId
		WHERE	PPMCheckListId	=	@pPPMCheckListId


		Select  CategoryList.CategoryId,
				CategoryId.FieldValue as CategoryIdValue
		       ,Category.PPMCheckListCategoryId
			   ,Category.Number
			   ,Category.Description
			   ,Category.Active
        from  EngAssetPPMCheckListCategory as CategoryList
		INNER JOIN EngAssetPPMCheckListCategory					AS	Category		 WITH(NOLOCK) ON CategoryList.CategoryId					=	Category.CategoryId
		INNER JOIN FMLovMst										AS	CategoryId		 WITH(NOLOCK) ON Category.PPMCheckListCategoryId		=	CategoryId.LovId
		where CategoryList.PPMCheckListId	=	@pPPMCheckListId



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
