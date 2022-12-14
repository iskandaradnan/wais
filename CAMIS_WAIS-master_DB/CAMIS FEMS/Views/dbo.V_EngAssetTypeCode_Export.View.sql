USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetTypeCode_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngAssetTypeCode_Export]
AS
	SELECT	Distinct Service.ServiceKey		AS	Service,	
			Classification.AssetClassificationCode,
			Classification.AssetClassificationDescription,
			TypeCode.AssetTypeCode,
			Typecode.ExpectedLifeSpan,
			TypeCode.AssetTypeDescription,			
			stuff((select ',' +lov.Fieldvalue from  EngAssetTypeCodeFlag TypeCodeFlag
									LEFT JOIN  fmlovmst		AS	lov	WITH(NOLOCK)	ON lov.lovid = TypeCodeFlag.MaintenanceFlag
					where TypeCode.AssetTypeCodeId		=	TypeCodeFlag.AssetTypeCodeId
					FOR XML PATH('')  ),1,1,'') MaintenanceFlag,
			--LovFlag.FieldValue						AS	MaintenanceFlag,
			LovEqupFunction.FieldValue				AS	EquipmentFunctionDescription,
			LovLifeExpec.FieldValue                 AS  LifeExpectancy,
			--LovContract.FieldValue                  AS  TypeofContract, 
			'BEMS' AS [QAPAssetService],
			CASE WHEN ISNULL(TypeCode.QAPAssetTypeB1,0)=1 THEN 'Yes'
				 WHEN ISNULL(TypeCode.QAPAssetTypeB1,0)=0 THEN 'No'
			END								AS		[QAPAssetTypeB1],
			CASE WHEN ISNULL(TypeCode.QAPServiceAvailabilityB2,0)=1 THEN 'Yes'
				 WHEN ISNULL(TypeCode.QAPServiceAvailabilityB2,0)=0 THEN 'No'
			END								AS		[QAPServiceAvailabilityB2],
			QAPUptimeTargetPerc,
			FORMAT(EffectiveFrom,'dd-MMM-yyyy')		AS	EffectiveFrom,
			FORMAT(TypeCode.EffectiveTo ,'dd-MMM-yyyy')		AS	EffectiveTo,
			TRPILessThan5YrsPerc,
			TRPI5to10YrsPerc,
			TRPIGreaterThan10YrsPerc,
			Cast ((Parameter.TypeCodeParameter) as Nvarchar(500)) TypeCodeParameter ,
			Variation.VariationRate,
			FORMAT(Variation.EffectiveFromDate,'dd-MMM-yyyy') as EffectiveFromDate	,
			TypeCode.ModifiedDateUTC
	FROM	EngAssetTypeCode							AS	TypeCode			WITH(NOLOCK)
			INNER JOIN EngAssetClassification			AS	Classification		WITH(NOLOCK)	ON	TypeCode.AssetClassificationId				=	Classification.AssetClassificationId
			INNER JOIN MstService						AS	Service				WITH(NOLOCK)	ON	TypeCode.ServiceId							=	Service.ServiceId
			--INNER JOIN EngAssetTypeCodeFlag				AS	TypeCodeFlag		WITH(NOLOCK)	ON	TypeCode.AssetTypeCodeId					=	TypeCodeFlag.AssetTypeCodeId
			--INNER JOIN FMLovMst							AS	LovFlag				WITH(NOLOCK)	ON	TypeCodeFlag.MaintenanceFlag				=	LovFlag.LovId
			INNER JOIN FMLovMst							AS	LovEqupFunction		WITH(NOLOCK)	ON	TypeCode.EquipmentFunctionCatagoryLovId		=	LovEqupFunction.LovId
			INNER JOIN FMLovMst							AS	LovLifeExpec		WITH(NOLOCK)	ON	TypeCode.LifeExpectancy		=	LovLifeExpec.LovId
			--INNER JOIN FMLovMst							AS	LovContract		WITH(NOLOCK)		ON	TypeCode.TypeOfContractLovId		=	LovContract.LovId
			INNER JOIN EngAssetTypeCodeVariationRate	AS	Variation		WITH(NOLOCK)		ON	TypeCode.AssetTypeCodeId		=	Variation.AssetTypeCodeId
			INNER JOIN EngAssetTypeCodeParameter		AS	Parameter		WITH(NOLOCK)		ON	Variation.TypeCodeParameterId		=	Parameter.TypeCodeParameterId
	WHERE	TypeCode.Active=1
GO
