USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetPPMCheckList]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngAssetPPMCheckList]
AS
	SELECT		PPMCheckList.PPMCheckListId,
				TypeCode.AssetTypeCode,
				TypeCode.AssetTypeDescription,
				PPMCheckList.TaskCode,
				Manufacturer.Manufacturer,
				Model.Model,
				LovFrequency.FieldValue			AS	PPMFrequencyValue,
				PPMCheckList.PPMHours,
				CASE	WHEN PPMCheckList.Active=1 THEN 'Active'
						WHEN PPMCheckList.Active=0 THEN 'InActive'
				END		AS	'Active',
 				PPMCheckList.ModifiedDateUTC
		FROM	EngAssetPPMCheckList AS	PPMCheckList					WITH(NOLOCK)
				
				INNER JOIN EngAssetTypeCode	AS	TypeCode							WITH(NOLOCK) ON PPMCheckList.AssetTypeCodeId		=	TypeCode.AssetTypeCodeId
				INNER JOIN FMLovMst	AS	LovFrequency								WITH(NOLOCK) ON PPMCheckList.PPMFrequency			=	LovFrequency.LovId
				INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK) ON PPMCheckList.ManufacturerId		=	Manufacturer.ManufacturerId
				INNER JOIN EngAssetStandardizationModel	AS	Model					WITH(NOLOCK) ON PPMCheckList.ModelId				=	Model.ModelId
GO
