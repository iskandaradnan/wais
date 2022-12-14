USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPlanner_FetchWarranty]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAssetPlanner_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetPlanner_FetchWarranty]  @pAssetNo='',@pPageIndex=1,@pPageSize=1000,@pAssetTypeCodeId='',@pCurrentAssetId='',@pAssetClassificationId='',@pFacilityId=1,@pAssetType=80
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPlanner_FetchWarranty]                           
                            
  @pAssetNo					NVARCHAR(100)	=	NULL,
  @pAssetTypeCodeId			NVARCHAR(100)	=	NULL,
  @pCurrentAssetId			INT				=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pAssetClassificationId	INT				=	NULL,
  @pFacilityId				INT,
  @pAssetType				INT


AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
	DECLARE @WhereCondition NVARCHAR(MAX)

-- Default Values
	IF (ISNULL(@pAssetType,0)=81)
		SET @WhereCondition ='((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NOT NULL))'
	ELSE IF (ISNULL(@pAssetType,0)=88)
		SET @WhereCondition ='((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Asset.WarrantyEndDate >= GETDATE()))'
	ELSE IF (ISNULL(@pAssetType,0)=82)
		SET @WhereCondition ='1=1'
-- Execution
	IF OBJECT_ID('FetchResult2') IS NOT NULL
	BEGIN
	  DROP TABLE FetchResult2
	END

-- Contract Assets

IF ( ISNULL(@pAssetType,0)=81)
	BEGIN
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					OUTER APPLY	(	SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate
									FROM	(	SELECT COR.ContractorId,
												CORDet.AssetId,
												RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,
												MAX(ContractEndDate)  ContractEndDate,
												MAX(ContractStartDate)  ContractStartDate
												FROM EngContractOutRegister COR
													INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId
												WHERE  CORDet.AssetId=Asset.AssetId
												GROUP BY COR.ContractorId,CORDet.AssetId
											)a 
									WHERE RowValue =1
								) Contractor					
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	Contractor.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo dET WHERE ContractorandVend.ContractorId=dET.ContractorId) AS ContactInfo
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NOT NULL))

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
					Contractor.ContractEndDate,
					ContractorandVend.SSMRegistrationCode AS ContractorCode,
					ContractorandVend.ContractorName		  AS	ContractorName,
					ContactInfo.ContactNo		AS	ContactNumber,
					Asset.SerialNo,
					81 AS TypeofAsset,
					'Contract' as TypeofAssetValue,
					@TotalRecords AS TotalRecords
	
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					OUTER APPLY	(	SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate
									FROM	(	SELECT COR.ContractorId,
												CORDet.AssetId,
												RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,
												MAX(ContractEndDate)  ContractEndDate,
												MAX(ContractStartDate)  ContractStartDate
												FROM EngContractOutRegister COR
													INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId
												WHERE  CORDet.AssetId=Asset.AssetId
												GROUP BY COR.ContractorId,CORDet.AssetId
											)a 
									WHERE RowValue =1
								) Contractor					
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	Contractor.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo dET WHERE ContractorandVend.ContractorId=dET.ContractorId) AS ContactInfo
					
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NOT NULL))
		ORDER BY	Asset.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
END


-- Warrenty Assets

IF (ISNULL(@pAssetType,0)=80)
	BEGIN
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					OUTER APPLY	(	SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate
									FROM	(	SELECT COR.ContractorId,
												CORDet.AssetId,
												RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,
												MAX(ContractEndDate)  ContractEndDate,
												MAX(ContractStartDate)  ContractStartDate
												FROM EngContractOutRegister COR
													INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId
												WHERE  CORDet.AssetId=Asset.AssetId
												GROUP BY COR.ContractorId,CORDet.AssetId
											)a 
									WHERE RowValue =1
								) Contractor					
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	Contractor.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo CCInfo WHERE  ContractorandVend.ContractorId=CCInfo.ContractorId) AS ContactInfo 
					OUTER APPLY (SELECT TOP 1 ContractorId,AssetId FROM EngAssetSupplierWarranty ASW where Category=13 AND ASW.AssetId=Asset.AssetId) AS SupplierWar 
					LEFT JOIN	MstContractorandVendor				AS	Supplier	WITH(NOLOCK) ON	SupplierWar.ContractorId		= Supplier.ContractorId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NULL AND Asset.WarrantyEndDate >= GETDATE()))

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
					Supplier.ContractorName AS MainSupplier,
					Contractor.ContractEndDate,
					ContractorandVend.SSMRegistrationCode AS ContractorCode,
					ContractorandVend.ContractorName		  AS	ContractorName,
					ContactInfo.ContactNo		AS	ContactNumber,
					Asset.SerialNo,
					80 AS TypeofAsset,
					'Warranty' as TypeofAssetValue,
					@TotalRecords AS TotalRecords
		INTO FetchResult2
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					OUTER APPLY	(	SELECT  ContractorId,AssetId,ContractEndDate,ContractStartDate
									FROM	(	SELECT COR.ContractorId,
												CORDet.AssetId,
												RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,
												MAX(ContractEndDate)  ContractEndDate,
												MAX(ContractStartDate)  ContractStartDate
												FROM EngContractOutRegister COR
													INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId
												WHERE  CORDet.AssetId=Asset.AssetId
												GROUP BY COR.ContractorId,CORDet.AssetId
											)a 
									WHERE RowValue =1
								) Contractor
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	Contractor.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo CCInfo WHERE  ContractorandVend.ContractorId=CCInfo.ContractorId) AS ContactInfo 
					OUTER APPLY (SELECT TOP 1 ContractorId,AssetId FROM EngAssetSupplierWarranty ASW where Category=13 AND ASW.AssetId=Asset.AssetId) AS SupplierWar 
					LEFT JOIN	MstContractorandVendor				AS	Supplier	WITH(NOLOCK) ON	SupplierWar.ContractorId		= Supplier.ContractorId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					AND ((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NULL AND Asset.WarrantyEndDate >= GETDATE()))
		ORDER BY	Asset.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
END

--- All Assets

IF ( ISNULL(@pAssetType,0)=82)
	BEGIN
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					LEFT JOIN	(	SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate
									FROM	(	SELECT COR.ContractorId,
												CORDet.AssetId,
												RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,
												MAX(ContractEndDate)  ContractEndDate,
												MAX(ContractStartDate)  ContractStartDate
												FROM EngContractOutRegister COR
													INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId 
												GROUP BY COR.ContractorId,CORDet.AssetId
											)a 
									WHERE RowValue =1
								) Contractor					ON Contractor.AssetId=Asset.AssetId
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	Contractor.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo dET WHERE ContractorandVend.ContractorId=dET.ContractorId) AS ContactInfo
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					--AND ((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NULL AND Asset.WarrantyEndDate >= GETDATE()))

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
					Contractor.ContractEndDate,
					ContractorandVend.SSMRegistrationCode AS ContractorCode,
					ContractorandVend.ContractorName		  AS	ContractorName,
					ContactInfo.ContactNo		AS	ContactNumber,
					Asset.SerialNo,
					82 AS TypeofAsset,
					'None' as TypeofAssetValue,
					@TotalRecords AS TotalRecords

		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					LEFT JOIN	(	SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate
									FROM	(	SELECT COR.ContractorId,
												CORDet.AssetId,
												RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,
												MAX(ContractEndDate)  ContractEndDate,
												MAX(ContractStartDate)  ContractStartDate
												FROM EngContractOutRegister COR
													INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId 
												GROUP BY COR.ContractorId,CORDet.AssetId
											)a 
									WHERE RowValue =1
								) Contractor					ON Contractor.AssetId=Asset.AssetId
					LEFT JOIN	MstContractorandVendor				AS	ContractorandVend	WITH(NOLOCK) ON	Contractor.ContractorId		= ContractorandVend.ContractorId
					OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo dET WHERE ContractorandVend.ContractorId=dET.ContractorId) AS ContactInfo
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))
					AND ((ISNULL(@pCurrentAssetId,'')='' )		OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))
					AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
					--AND ((ISNULL(@pAssetType,'')='' )		OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NULL AND Asset.WarrantyEndDate >= GETDATE()))
		ORDER BY	Asset.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
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
