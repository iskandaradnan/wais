USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODCategorySystem]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngEODCategorySystem]
AS
	SELECT		CategorySystemId,
				ServiceKey AS ServiceName,
				EODCategorySys.CategorySystemName,
				EODCategorySys.ModifiedDateUTC
	FROM		EngEODCategorySystem EODCategorySys WITH(NOLOCK)
				INNER JOIN MstService WITH(NOLOCK) ON EODCategorySys.ServiceId = MstService.ServiceId
GO
