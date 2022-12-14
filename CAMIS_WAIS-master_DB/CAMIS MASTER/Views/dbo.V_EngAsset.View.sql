USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAsset]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngAsset]
AS
	SELECT	DISTINCT Asset.AssetId,
			Asset.CustomerId,
			Customer.CustomerName,
			Asset.FacilityId,
			Facility.FacilityName,
			Classification.AssetClassificationCode			AS AssetClassificationCode,
			Classification.AssetClassificationDescription	AS AssetClassification,
			Asset.AssetNo,
			--Asset.AssetNoOld,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			UserLocation.UserLocationCode,
			UserLocation.UserLocationName,
			Manufacturer.Manufacturer,
			Model.Model,
			CASE 
				WHEN Asset.AssetStatusLovId = 1 THEN 'Active'
				WHEN Asset.AssetStatusLovId = 2 THEN 'Inactive'
			END		AS Active,
			Asset.[Authorization]		AS [AuthorizationId],
			Authoriz.FieldValue AS [AuthorizationStatus],
			VarStatus.VariationStatus,
			Asset.IsLoaner,
			CASE	WHEN Asset.IsLoaner = 1		THEN 'YES'
					WHEN Asset.IsLoaner	= 0		THEN 'NO'
					ELSE		'NO'
			END																			AS IsLoanerValue,
			Asset.ModifiedDateUTC,
			--COALESCE(Contractor.ContractorId,ThirdParty.ContractorId)					AS ContractorId,
			--COALESCE(SuppUserReg.UserRegistrationId,SupThirdParty.UserRegistrationId)	AS	UserRegistrationId
			Contractor.ContractorId,
			SuppUserReg.UserRegistrationId,
			UserArea.UserAreaName,
			ContractType.FieldValue		AS ContractTypeName,
			Asset.SerialNo				AS SerialNumber,
			ContractType.FieldValue		AS ContractType
	FROM	EngAsset										AS	Asset			WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	Asset.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	Asset.FacilityId				=	Facility.FacilityId
			INNER JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	Asset.AssetTypeCodeId			=	TypeCode.AssetTypeCodeId
			LEFT  JOIN MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON Asset.UserAreaId			=	UserArea.UserAreaId
			INNER JOIN MstLocationUserLocation				AS	UserLocation	WITH(NOLOCK)	ON	Asset.UserLocationId			=	UserLocation.UserLocationId
			INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK)	ON	Asset.Manufacturer				=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON	Asset.Model						=	Model.ModelId
			LEFT  JOIN EngAssetClassification				AS	Classification	WITH(NOLOCK)	ON	Asset.AssetClassification		=	Classification.AssetClassificationId
			LEFT JOIN	FMLovMst							AS Authoriz			WITH(NOLOCK)	ON Asset.[Authorization]			=	Authoriz.LovId

				
			OUTER APPLY (SELECT  TOP 1 ContractorId,AssetId from
						(SELECT COR.ContractorId,CORDet.AssetId,1 as RowValue
						from EngContractOutRegister AS COR
						inner join  EngContractOutRegisterDet AS CORDet on COR.ContractId=CORDet.ContractId 
						WHERE CORDet.AssetId=Asset.AssetId AND COR.ContractEndDate>= GETDATE()
						group by COR.ContractorId,CORDet.AssetId,ContractType
						union all
						SELECT ContractorId,AssetId,0 as RowValue
						 FROM	EngAssetSupplierWarranty	AS SupplierWarr
						 WHERE	SupplierWarr.AssetId	=	Asset.AssetId
						AND SupplierWarr.Category	=	15
						)a  order by  RowValue desc ) Contractor
				OUTER APPLY (select top 1 UserRegistrationId from 	UMUserRegistration					AS SuppUserReg1		WITH(NOLOCK)	where Contractor.ContractorId	=	SuppUserReg1.ContractorId) as SuppUserReg

							
			--OUTER APPLY (SELECT DISTINCT TOP 1 ContractorId,AssetId from
			--			(SELECT COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue
			--			from EngContractOutRegister AS COR
			--			inner join  EngContractOutRegisterDet AS CORDet on COR.ContractId=CORDet.ContractId 
			--			WHERE CORDet.AssetId=Asset.AssetId AND COR.ContractEndDate>= GETDATE()
			--			group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor

			--LEFT JOIN	UMUserRegistration					AS SuppUserReg		WITH(NOLOCK)	ON Contractor.ContractorId	=	SuppUserReg.ContractorId
			OUTER APPLY (SELECT DISTINCT  TOP 1 LovVariation.FieldValue AS VariationStatus
						FROM	EngAsset		AS AssetVS WITH(NOLOCK) 
								INNER JOIN VmVariationTxn	AS	Variation		WITH(NOLOCK)	ON	AssetVS.AssetId				=	Variation.AssetId
								INNER JOIN FMLovMst			AS	LovVariation	WITH(NOLOCK)	ON	Variation.VariationStatus	=	LovVariation.LovId
						WHERE	Asset.AssetId	=	Variation.AssetId
						) VarStatus
			
			LEFT JOIN	FMLovMst								AS ContractType				WITH(NOLOCK)			ON Asset.ContractType	= ContractType.LovId
			----OUTER APPLY (SELECT ContractorId,AssetId
			----			 FROM	EngAssetSupplierWarranty	AS SupplierWarr
			----			 WHERE	SupplierWarr.AssetId	=	Asset.AssetId
			----					AND SupplierWarr.Category	=	15
			----			) ThirdParty
			----LEFT JOIN	UMUserRegistration					AS SupThirdParty		WITH(NOLOCK)	ON ThirdParty.ContractorId	=	SupThirdParty.ContractorId
GO
