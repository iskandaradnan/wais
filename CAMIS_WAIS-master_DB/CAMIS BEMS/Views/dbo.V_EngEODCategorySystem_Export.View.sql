USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODCategorySystem_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngEODCategorySystem_Export]
AS
	SELECT		ServiceKey AS ServiceName,
				EODCategorySys.CategorySystemName,
				CASE WHEN EODCategorySys.Active=1 THEN 'Active'
					 WHEN EODCategorySys.Active=1 THEN 'InActive'
				END									AS	StatusValue,
				EODCategorySys.Remarks,
				EODCategorySys.ModifiedDateUTC
	FROM		EngEODCategorySystem EODCategorySys WITH(NOLOCK)
				INNER JOIN MstService WITH(NOLOCK) ON EODCategorySys.ServiceId = MstService.ServiceId
GO
