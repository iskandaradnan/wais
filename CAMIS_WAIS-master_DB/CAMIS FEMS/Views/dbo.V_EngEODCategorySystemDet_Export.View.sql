USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODCategorySystemDet_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngEODCategorySystemDet_Export]
AS
	SELECT		Service.ServiceKey							AS ServiceName,
				EODCategorySys.CategorySystemName,
				TypeCode.AssetTypeCode,
				TypeCode.AssetTypeDescription,
				CASE WHEN EODCategorySysDet.Active=1 THEN 'Active'
					 WHEN EODCategorySysDet.Active=1 THEN 'InActive'
				END											AS	Status,
				EODCategorySysDet.ModifiedDateUTC
	FROM		EngEODCategorySystemDet						AS	EODCategorySysDet	WITH(NOLOCK)				
				INNER JOIN EngEODCategorySystem				AS	EODCategorySys		WITH(NOLOCK) ON EODCategorySys.CategorySystemId		=	EODCategorySysDet.CategorySystemId
				INNER JOIN MstService						AS	Service				WITH(NOLOCK) ON EODCategorySys.ServiceId			=	Service.ServiceId
				INNER JOIN EngAssetTypeCode					AS	TypeCode			WITH(NOLOCK) ON EODCategorySysDet.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
GO
