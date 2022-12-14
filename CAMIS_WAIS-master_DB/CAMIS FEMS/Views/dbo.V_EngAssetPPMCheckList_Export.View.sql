USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetPPMCheckList_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngAssetPPMCheckList_Export]
AS
	SELECT DISTINCT PPMCheckList.PPMCheckListId,
				PPMCheckList.PPMChecklistNo,
				TypeCode.AssetTypeCode,
				TypeCode.AssetTypeDescription  , 
				PPMCheckList.TaskCode,
				PPMCheckList.TaskDescription    AS  TaskCodeDescription,
				Manufacturer.Manufacturer,
				Model.Model,
				LovFrequency.FieldValue			AS	PPMFrequency,
				PPMCheckList.PPMHours,
				PPMCheckList.SpecialPrecautions,
				PPMCheckList.Remarks,
				LovCategory.FieldValue as Category,
				Category.Number,
				Category.Description,
				Task.QuantitativeTasks,
				UOMLOV.UnitOfMeasurement AS UOM,
				Task.SetValues,
				Task.LimitTolerance,
 				PPMCheckList.ModifiedDateUTC
		FROM	EngAssetPPMCheckList AS	PPMCheckList					WITH(NOLOCK)
				
				INNER JOIN EngAssetTypeCode	AS	TypeCode							WITH(NOLOCK) ON PPMCheckList.AssetTypeCodeId		=	TypeCode.AssetTypeCodeId
				INNER JOIN FMLovMst	AS	LovFrequency								WITH(NOLOCK) ON PPMCheckList.PPMFrequency			=	LovFrequency.LovId
				INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK) ON PPMCheckList.ManufacturerId		=	Manufacturer.ManufacturerId
				INNER JOIN EngAssetStandardizationModel	AS	Model					WITH(NOLOCK) ON PPMCheckList.ModelId				=	Model.ModelId
				INNER JOIN EngAssetPPMCheckListCategory	AS	Category					WITH(NOLOCK) ON PPMCheckList.PPMCheckListId				=	Category.PPMCheckListId
				INNER JOIN EngAssetPPMCheckListQuantasksMstDet	AS	Task					WITH(NOLOCK) ON PPMCheckList.PPMCheckListId				=	Task.PPMCheckListId
				LEFT JOIN FMUOM AS UOMLOV											WITH(NOLOCK) ON Task.UOM				=	UOMLOV.UOMId
				LEFT JOIN FMLovMst	AS	LovCategory								WITH(NOLOCK) ON Category.PPMCheckListCategoryId			=	LovCategory.LovId
GO
