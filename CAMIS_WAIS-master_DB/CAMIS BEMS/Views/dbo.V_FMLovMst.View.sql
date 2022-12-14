USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_FMLovMst]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_FMLovMst]
AS
	SELECT	DISTINCT 
			Lov.ModuleName,
			Lov.ScreenName,			
			Lov.LovKey,
			LovType.FieldValue	AS LovType,
			MAX(Lov.ModifiedDateUTC) AS	ModifiedDateUTC
	FROM	FMLovMst	AS	Lov	WITH(NOLOCK)
			LEFT JOIN FMLovMst	AS LovType WITH(NOLOCK) ON  Lov.LovType	=	LovType.LovId
	where   Lov.LovKey!= 'DefectFlagValue'
	GROUP BY Lov.ModuleName,Lov.ScreenName,Lov.LovKey,LovType.FieldValue

UNION
	SELECT	DISTINCT 
			ModuleName,
			ScreenName,			
			LovKey,
			LovType,
			MAX(ModifiedDateUTC) AS	ModifiedDateUTC
	FROM	[V_FMLovMst_MetaData]
	GROUP BY ModuleName,ScreenName,LovKey,LovType
GO
