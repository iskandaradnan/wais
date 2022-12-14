USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_Print]    Script Date: 20-09-2021 16:43:00 ******/
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
EXEC [uspFM_EngAssetPPMCheckList_Print]  @pPPMCheckListId= 86,@pWorkOrderId=256
SELECT * FROM EngAssetPPMCheckList
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckList_Print]                           
  @pPPMCheckListId		NVARCHAR(200),
  @pWorkOrderId			NVARCHAR(200) null
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
 				PPMCheckList.[Timestamp],
				WO.WorkOrderId,
				WO.MaintenanceWorkNo,
				FORMAT(wo.MaintenanceWorkDateTime,'dd-MMM-yyyy') AS WorkOrderDate,		
				Asset.AssetId,
				Asset.AssetNo,
				(select top 1 t.StaffName from UMUserRegistration t  where UserRegistrationId=CompInfo.CompletedBy) as CompletedBy ,
				(select top 1 t.StaffName from UMUserRegistration t where UserRegistrationId= CompInfo.AcceptedBy) as VerifiedBy
	    From EngAssetPPMCheckList PPMCheckList
			INNER JOIN EngAssetTypeCode						AS	TypeCode		 WITH(NOLOCK) ON PPMCheckList.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
			INNER JOIN FMLovMst								AS	LovFrequency	 WITH(NOLOCK) ON PPMCheckList.PPMFrequency		=	LovFrequency.LovId
		    INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK) ON PPMCheckList.ManufacturerId		=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS	Model					WITH(NOLOCK) ON PPMCheckList.ModelId	=	Model.ModelId
			INNER JOIN EngAsset							as Asset   	WITH(NOLOCK)  on TypeCode.AssetTypeCodeId = Asset.AssetTypeCodeId
			INNER JOIN EngMaintenanceWorkOrderTxn		as WO   	WITH(NOLOCK)  on  WO.AssetId = Asset.AssetId
			left  join EngMwoCompletionInfoTxn			as CompInfo   	WITH(NOLOCK)  on CompInfo.WorkOrderId = WO.WorkOrderId
		WHERE	PPMCheckList.PPMCheckListId	=	@pPPMCheckListId and ( @pWorkOrderId is null or WO.WorkOrderId = @pWorkOrderId)

	

		--	5	EngAssetPPMCheckListMaintTasksMstDet
		SELECT	PPMCheckListQNId,
				PPMCheckListId,
				QuantitativeTasks,
				UOM,
				SetValues,
				LimitTolerance,
				Active
		FROM	EngAssetPPMCheckListQuantasksMstDet	AS	Quantasks	WITH(NOLOCK)
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
