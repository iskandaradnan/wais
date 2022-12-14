USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_FMLovMst_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_FMLovMst_Export]
AS
	SELECT	DISTINCT Lov.LovId,
			ModuleName,
			ScreenName,
			FieldName,
			CASE	WHEN LovType =302 THEN  'System'
					WHEN LovType =303 THEN  'User'
					ELSE null 
			END AS LovType,
			LovKey,
			FieldCode,
			FieldValue,
			Remarks,
			SortNo,
			CASE	WHEN IsDefault =1 THEN  'Yes'
					ELSE 'No' 
			END AS IsDefault,
			ModifiedDateUTC
	FROM	FMLovMst	AS	Lov	WITH(NOLOCK)

UNION
	
	SELECT	DISTINCT LovId,
			ModuleName,
			ScreenName,
			FieldName,
			'System' AS LovType,
			LovKey,
			FieldCode,
			FieldValue,
			Remarks,
			SortNo,
			CASE	WHEN IsDefault =1 THEN  'Yes'
					ELSE 'No' 
			END AS IsDefault,
			ModifiedDateUTC
	FROM	V_FMLovMst_MetaData	AS	Lov	WITH(NOLOCK)
GO
