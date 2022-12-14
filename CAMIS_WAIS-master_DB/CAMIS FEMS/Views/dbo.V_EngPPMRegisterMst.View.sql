USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPPMRegisterMst]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngPPMRegisterMst]

AS
		SELECT		DISTINCT PPMRegisterMst.PPMId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					PPMRegisterMst.BemsTaskCode,
					Model.Model,
					LovFrequency.FieldValue AS	PPMFrequency,
					PPMRegisterMst.PPMChecklistNo,
					PPMRegisterHistory.UploadDate,
					PPMRegisterMst.ModifiedDateUTC
		FROM		EngPPMRegisterMst							AS	PPMRegisterMst		WITH(NOLOCK)
					INNER JOIN EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON PPMRegisterMst.ModelId			=	Model.ModelId
					INNER JOIN EngAssetTypeCode					AS	TypeCode			WITH(NOLOCK) ON PPMRegisterMst.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
					INNER JOIN FMLovMst							AS	LovFrequency		WITH(NOLOCK) ON PPMRegisterMst.PPMFrequency		=	LovFrequency.LovId
					LEFT JOIN EngPPMRegisterHistoryMst			AS	PPMRegisterHistory	WITH(NOLOCK) ON PPMRegisterMst.PPMId			=	PPMRegisterHistory.PPMId
		WHERE		PPMRegisterMst.Active =1
GO
