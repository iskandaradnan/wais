USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Fetch_FAcilityWorkshop]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAsset_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAsset_Fetch]  @pAssetNo='',@pPageIndex=1,@pPageSize=100,@pAssetTypeCodeId=null,@pCurrentAssetId=153,@pAssetClassificationId=0,@pFacilityId=1,@pTypeOfAsset=NULL,@pIsFromAssetRegister=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAsset_Fetch_FAcilityWorkshop]                           
                            
  @pAssetNo					NVARCHAR(100)	=	NULL,
  @pAssetTypeCodeId			NVARCHAR(100)	=	NULL,
  @pCurrentAssetId			INT				=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pAssetClassificationId	INT				=	NULL,
  @pFacilityId				INT,	
  @pTypeOfAsset				INT	= null,
  @pIsFromAssetRegister		INT	= null,
  @pTypeofPlanner			INT	= null

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values
	IF(ISNULL(@pTypeOfAsset,0)=0)
		BEGIN
			SET @pTypeOfAsset=0
		END
	ELSE
		BEGIN
			SET @pTypeOfAsset= (SELECT CASE WHEN @pTypeOfAsset=107 THEN 190
										WHEN @pTypeOfAsset=109 THEN 191 END)
		END

declare @lTypeofPlanner int 

select @lTypeofPlanner  = case when @pTypeofPlanner = 198 then 96
								when @pTypeofPlanner = 343 then 97
								when @pTypeofPlanner = 36 then 98
								ELSE
								null
								END


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification	= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId		= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer			= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model					= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId		= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	UserLocation.UserAreaId		= UserArea.UserAreaId
					LEFT JOIN	(select  AssetId,max(ContractId) ContractId from EngContractOutRegisterDet group by AssetId)			AS	ContractOutRegDet	 ON	Asset.AssetId					= ContractOutRegDet.AssetId
					LEFT JOIN	EngContractOutRegister				AS	ContractOutReg		WITH(NOLOCK) ON	ContractOutRegDet.ContractId	= ContractOutReg.ContractId
					LEFT JOIN  FMLovMst								AS ContractType			WITH(NOLOCK) ON Asset.ContractType				= ContractType.LovId
					--LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	ContractOutReg.ContractorId		= ContractorandVend.ContractorId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =   @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>   @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pTypeOfAsset,'')='' )		OR (ISNULL(@pTypeOfAsset,'') <> '' AND ISNULL(Asset.TypeOfAsset,0) = @pTypeOfAsset))
					AND ((ISNULL(@pIsFromAssetRegister,'')='' )		OR (ISNULL(@pIsFromAssetRegister,'') <> '' AND Asset.IsLoaner = 0))
					and  (  isnull(@pTypeofPlanner,0) =0  or exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=@lTypeofPlanner and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId))

		SELECT		 Asset.AssetId,
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
					@TotalRecords AS TotalRecords					
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					LEFT JOIN	(select  AssetId,max(ContractId) ContractId from EngContractOutRegisterDet group by AssetId)			AS	ContractOutRegDet ON	Asset.AssetId					= ContractOutRegDet.AssetId
					LEFT JOIN	EngContractOutRegister				AS	ContractOutReg		WITH(NOLOCK) ON	ContractOutRegDet.ContractId	= ContractOutReg.ContractId
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	ContractOutReg.ContractorId		= ContractorandVend.ContractorId
					LEFT  JOIN  FMLovMst								AS ContractType						WITH(NOLOCK)			on Asset.ContractType							= ContractType.LovId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pTypeOfAsset,'')='' )		OR (ISNULL(@pTypeOfAsset,'') <> '' AND ISNULL(Asset.TypeOfAsset,0) = @pTypeOfAsset))
					AND ((ISNULL(@pIsFromAssetRegister,'')='' )		OR (ISNULL(@pIsFromAssetRegister,'') <> '' AND Asset.IsLoaner = 0))
					and  ( isnull(@pTypeofPlanner,0) =0  or exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=@lTypeofPlanner and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId))
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
