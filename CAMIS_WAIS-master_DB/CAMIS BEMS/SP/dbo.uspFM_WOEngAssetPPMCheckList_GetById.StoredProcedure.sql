USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WOEngAssetPPMCheckList_GetById]    Script Date: 20-09-2021 17:05:52 ******/
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
EXEC [uspFM_WOEngAssetPPMCheckList_GetById]  @pPPMCheckListId=87,@pWorkOrderId=1217

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_WOEngAssetPPMCheckList_GetById]                           
  @pPPMCheckListId		INT,
  @pWorkOrderId			int
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution
	
		DECLARE @pWOPPMCheckListId	INT

		SET @pWOPPMCheckListId = (SELECT WOPPMCheckListId FROM EngAssetPPMCheckListWorkOrder WHERE PPMCheckListId	=	@pPPMCheckListId AND WorkOrderId = @pWorkOrderId)


	IF(ISNULL(@pPPMCheckListId,0) = 0) RETURN

	--	1	EngAssetPPMCheckList
	SELECT		PPMCheckListWorkOrder.WOPPMCheckListId,
				PPMCheckList.PPMCheckListId,
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

	    From  EngAssetPPMCheckListWorkOrder					AS  PPMCheckListWorkOrder 
			INNER JOIN EngAssetPPMCheckList					AS	PPMCheckList	 WITH(NOLOCK) ON PPMCheckListWorkOrder.PPMCheckListId	=	PPMCheckList.PPMCheckListId
			INNER JOIN EngAssetTypeCode						AS	TypeCode		 WITH(NOLOCK) ON PPMCheckList.AssetTypeCodeId			=	TypeCode.AssetTypeCodeId
			INNER JOIN FMLovMst								AS	LovFrequency	 WITH(NOLOCK) ON PPMCheckList.PPMFrequency				=	LovFrequency.LovId
		    INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	 WITH(NOLOCK) ON PPMCheckList.ManufacturerId			=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS	Model			 WITH(NOLOCK) ON PPMCheckList.ModelId					=	Model.ModelId
		WHERE	PPMCheckListWorkOrder.PPMCheckListId	=	@pPPMCheckListId AND PPMCheckListWorkOrder.WorkOrderId = @pWorkOrderId

	

		--	5	EngAssetPPMCheckListMaintTasksMstDet
		SELECT	QuantasksWO.WOPPMCheckListQNId,
				QuantasksWO.WOPPMCheckListId,
				QuantasksWO.PPMCheckListQNId,
				QuantasksWO.Value,
				QuantasksWO.Status,
				QuantasksWO.Remarks,
				Quantasks.QuantitativeTasks,
				Quantasks.UOM,
				UOM.UnitOfMeasurement,
				Quantasks.SetValues,
				Quantasks.LimitTolerance
		FROM	[EngAssetPPMCheckListQuantasksWorkOrderMstDet]	AS	QuantasksWO	WITH(NOLOCK)
		INNER JOIN [EngAssetPPMCheckListQuantasksMstDet]		AS	Quantasks	 WITH(NOLOCK) ON Quantasks.PPMCheckListQNId	=	QuantasksWO.PPMCheckListQNId
		INNER JOIN FMUOM										AS	UOM			 WITH(NOLOCK) ON Quantasks.UOM				=	UOM.UOMId
		WHERE	QuantasksWO.WOPPMCheckListId	=	@pWOPPMCheckListId


		Select  CategoryWO.WOCategoryId,
				CategoryWO.WOPPMCheckListId,
				CategoryWO.CategoryId,
				CategoryId.FieldValue as CategoryIdValue,
				CategoryWO.Status,
				CategoryWO.Remarks,
				Category.PPMCheckListCategoryId,
				Category.Number,
				Category.Description
        from  [EngAssetPPMCheckListCategoryWorkOrder]			AS  CategoryWO
		INNER JOIN EngAssetPPMCheckListCategory					AS	Category		 WITH(NOLOCK) ON CategoryWO.CategoryId					=	Category.CategoryId
		INNER JOIN FMLovMst										AS	CategoryId		 WITH(NOLOCK) ON Category.PPMCheckListCategoryId		=	CategoryId.LovId
		WHERE	CategoryWO.WOPPMCheckListId	=	@pWOPPMCheckListId




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
