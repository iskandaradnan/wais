USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPPMRegisterMst_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngPPMRegisterMst_Export]

AS
		SELECT		DISTINCT PPMRegisterMst.PPMId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					PPMRegisterMst.BemsTaskCode,
					PPMRegisterMst.PPMChecklistNo,
					Manufacturer.Manufacturer,
					Model.Model,
					LovFrequency.FieldValue AS	PPMFrequency,
					PPMHours,
					PPMRegisterHistory.Version,
					FORMAT(PPMRegisterHistory.EffectiveDate,'dd-MMM-yyyy') AS EffectiveDate,
					FORMAT(PPMRegisterHistory.UploadDate,'dd-MMM-yyyy') AS UploadDate,
					PPMRegisterMst.Active,
					PPMRegisterMst.ModifiedDateUTC
		FROM		EngPPMRegisterMst								AS	PPMRegisterMst		WITH(NOLOCK)
					INNER JOIN MstService							AS	Service				WITH(NOLOCK) ON PPMRegisterMst.ServiceId		=	Service.ServiceId
					INNER JOIN EngAssetStandardizationModel			AS	Model				WITH(NOLOCK) ON PPMRegisterMst.ModelId			=	Model.ModelId
					INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON PPMRegisterMst.ManufacturerId	=	Manufacturer.ManufacturerId
					INNER JOIN EngAssetTypeCode						AS	TypeCode			WITH(NOLOCK) ON PPMRegisterMst.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
					INNER JOIN FMLovMst								AS	LovFrequency		WITH(NOLOCK) ON PPMRegisterMst.PPMFrequency		=	LovFrequency.LovId
					LEFT JOIN EngPPMRegisterHistoryMst				AS	PPMRegisterHistory	WITH(NOLOCK) ON PPMRegisterMst.PPMId			=	PPMRegisterHistory.PPMId
		WHERE		PPMRegisterMst.Active =1
GO
