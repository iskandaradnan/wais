USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODCategorySystemDet]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngEODCategorySystemDet]
AS
	SELECT		DISTINCT --EODCategorySysDet.CategorySystemDetId,
				EODCategorySysDet.CategorySystemId,
				ServiceKey				AS ServiceName,
				EODCategorySys.CategorySystemName,
				MAX(EODCategorySysDet.ModifiedDateUTC)	AS	ModifiedDateUTC
	FROM		EngEODCategorySystem	AS EODCategorySys				WITH(NOLOCK)
				INNER JOIN MstService									WITH(NOLOCK) ON EODCategorySys.ServiceId = MstService.ServiceId
				INNER JOIN EngEODCategorySystemDet AS EODCategorySysDet	WITH(NOLOCK) ON EODCategorySys.CategorySystemId = EODCategorySysDet.CategorySystemId
	GROUP BY	EODCategorySysDet.CategorySystemId,
				ServiceKey,
				EODCategorySys.CategorySystemName
GO
