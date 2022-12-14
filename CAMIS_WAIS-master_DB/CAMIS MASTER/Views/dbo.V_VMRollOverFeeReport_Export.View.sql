USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_VMRollOverFeeReport_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_VMRollOverFeeReport_Export]
AS
	SELECT	FeeReport.RollOverFeeId,
			Service.ServiceKey	AS Service,
			--AssetClassify.AssetClassificationCode	AS AssetClassification,
			DateName( month , DateAdd( month , FeeReport.Month , -1 ) )AS Month,
			FeeReport.Year,
			UserReg.StaffName		AS	DoneBy,
			LovStatus.FieldValue		AS	Status,
			FeeReport.ModifiedDateUTC,
			FeeReport.FacilityId
	FROM	VMRollOverFeeReport					AS	FeeReport		WITH(NOLOCK)
			LEFT JOIN UMUserRegistration		AS	UserReg			WITH(NOLOCK)	ON	FeeReport.DoneBy				=	UserReg.UserRegistrationId
			LEFT JOIN MstService				AS	Service			WITH(NOLOCK)	ON	FeeReport.ServiceId				=	Service.ServiceId
			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON	FeeReport.Status				=	LovStatus.LovId
			LEFT JOIN EngAssetClassification	AS	AssetClassify	WITH(NOLOCK)	ON	FeeReport.AssetClassificationId	=	AssetClassify.AssetClassificationId
GO
