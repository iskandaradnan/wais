USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetTypeCode]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngAssetTypeCode]
AS
	SELECT	TypeCode.AssetTypeCodeId,
			Classification.AssetClassificationCode,
			Classification.AssetClassificationDescription,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			TypeCode.ModifiedDateUTC
	FROM	EngAssetTypeCode							AS	TypeCode			WITH(NOLOCK)
			INNER JOIN EngAssetClassification			AS	Classification		WITH(NOLOCK)	ON	TypeCode.AssetClassificationId	=	Classification.AssetClassificationId
			--INNER JOIN EngAssetTypeCodeFlag				AS	TypeCodeFlag		WITH(NOLOCK)	ON	TypeCode.AssetTypeCodeId		=	TypeCodeFlag.AssetTypeCodeId
			--INNER JOIN FMLovMst							AS	LovFlag				WITH(NOLOCK)	ON	TypeCodeFlag.MaintenanceFlag	=	LovFlag.LovId
			--LEFT JOIN FMLovMst							AS	LovRiskRating		WITH(NOLOCK)	ON	TypeCode.RiskRatingLovId		=	LovRiskRating.LovId
	WHERE	TypeCode.Active=1
GO
