USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetOthersPlanner_Search]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAsset_Search]
Description			: Asset number Search popup
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetOthersPlanner_Search]  @pAssetNo='',@pTypeCode=NULL,@pAssetNoOld=NULL,@pPageIndex=1,@pPageSize=5,@pFacilityId=1,@pTypeOfAsset=NULL

EXEC [uspFM_EngAssetOthersPlanner_Search] @pAssetNo='',@pAssetDescription='',@pAssetTypeCodeId='',@pAssetClassificationId='',@pFacilityId=1,@pPageIndex=1,@pPageSize=10
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetOthersPlanner_Search]                           
                            
  @pAssetNo				NVARCHAR(100)	=	NULL,
  @pAssetDescription	NVARCHAR(100)	=	NULL,
  @pAssetTypeCodeId		NVARCHAR(100)	=	NULL,     
  @pTypeOfPlanner		INT				=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pAssetClassificationId	INT				=	NULL,
  @pFacilityId			INT
  

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
		FROM		EngAsset					AS Asset WITH(NOLOCK)
					INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification	= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode		AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId		= TypeCode.AssetTypeCodeId
					LEFT JOIN	MstLocationUserLocation	AS UserLocation 		WITH(NOLOCK) ON Asset.UserLocationId		= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea		AS UserArea 			WITH(NOLOCK) ON UserLocation.UserAreaId			= UserArea.UserAreaId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK) ON	Asset.Manufacturer		= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel	AS	Model	WITH(NOLOCK) ON	Asset.Model		= Model.ModelId
					LEFT JOIN	(select  AssetId,max(ContractId) ContractId from EngContractOutRegisterDet group by AssetId)			AS	ContractOutRegDet	ON	Asset.AssetId					= ContractOutRegDet.AssetId
					LEFT JOIN	EngContractOutRegister				AS	ContractOutReg		WITH(NOLOCK) ON	ContractOutRegDet.ContractId	= ContractOutReg.ContractId
					--LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	ContractOutReg.ContractorId		= ContractorandVend.ContractorId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =   @pAssetTypeCodeId ))
					AND ((ISNULL(@pAssetDescription,'')='' )		OR (ISNULL(@pAssetDescription,'') <> '' AND Asset.AssetDescription LIKE '%' + @pAssetDescription + '%'))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					and exists (select 1 from EngAssetTypeCodeFlag  t where MaintenanceFlag in ( 96,97,98) and t.AssetTypeCodeId=TypeCode.AssetTypeCodeId and t.MaintenanceFlag in ( 96,97,98))



		SELECT		Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetNoOld,
					Asset.AssetDescription,
					AssetClassification.AssetClassificationId,
					AssetClassification.AssetClassificationCode,
					TypeCode.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					Asset.Manufacturer		AS ManufacturerId,
					Manufacturer.Manufacturer,
					Asset.Model				AS	ModelId,
					Model.Model,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					Asset.WarrantyEndDate,
					Asset.MainSupplier,
					ContractOutReg.ContractEndDate,
					ContractOutReg.AResponsiblePerson	AS	ContractorName,
					ContractOutReg.AContactNumber		AS	ContactNumber,
					Asset.SerialNo,
					Asset.ContractType,
					ContractType.FieldValue as ContractTypeValue,					
					@TotalRecords AS TotalRecords,
					CASE WHEN @pTypeOfPlanner = 198
					THEN PPMCheckListId 
					ELSE NULL 
					END AS TaskCodeId,
					CASE WHEN @pTypeOfPlanner = 198
					THEN PPMC.TaskCode
					ELSE ''
					END AS TaskCode
					--PPMCheckListId as TaskCodeId,
					--PPMC.TaskCode	
		FROM		EngAsset					AS Asset WITH(NOLOCK)
					INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification	= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode		AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId		= TypeCode.AssetTypeCodeId
					LEFT JOIN	MstLocationUserLocation	AS UserLocation 		WITH(NOLOCK) ON Asset.UserLocationId		= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea		AS UserArea 			WITH(NOLOCK) ON UserLocation.UserAreaId			= UserArea.UserAreaId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK) ON	Asset.Manufacturer		= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel	AS	Model	WITH(NOLOCK) ON	Asset.Model		= Model.ModelId
					LEFT JOIN	(select  AssetId,max(ContractId) ContractId from EngContractOutRegisterDet group by AssetId)			AS	ContractOutRegDet	 ON	Asset.AssetId					= ContractOutRegDet.AssetId
					LEFT JOIN	EngContractOutRegister				AS	ContractOutReg		WITH(NOLOCK) ON	ContractOutRegDet.ContractId	= ContractOutReg.ContractId
					LEFT  JOIN  FMLovMst								AS ContractType						WITH(NOLOCK)			on Asset.ContractType							= ContractType.LovId
					--LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	ContractOutReg.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 PPMCheckListId,TaskCode FROM EngAssetPPMCheckList PPMCL WHERE PPMCL.AssetTypeCodeId=Asset.AssetTypeCodeId and Asset.Model	=PPMCL.ModelId ) AS PPMC
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =   @pAssetTypeCodeId ))
					AND ((ISNULL(@pAssetDescription,'')='' )		OR (ISNULL(@pAssetDescription,'') <> '' AND Asset.AssetDescription LIKE '%' + @pAssetDescription + '%'))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					and exists (select 1 from EngAssetTypeCodeFlag  t where MaintenanceFlag in ( 96,97,98) and t.AssetTypeCodeId=TypeCode.AssetTypeCodeId and t.MaintenanceFlag in ( 96,97,98))
		ORDER BY	Asset.ModifiedDateUTC DESC
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
