USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_VMRollOverFeeReport]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_VMRollOverFeeReport]

AS

	SELECT	FeeReport.RollOverFeeId,

			Service.ServiceKey	AS Service,

			AssetClassify.AssetClassificationDescription	AS AssetClassification,

			DateName( month , DateAdd( month , FeeReport.Month , -1 ) )AS Month,

			FeeReport.Year,

			UserReg.StaffName		AS	DoneBy,

			LovStatus.FieldValue		AS	Status,

			CASE	WHEN StatusFlag	=	9 THEN 'Verify'

					WHEN StatusFlag	=	7 THEN 'Approve'

					WHEN StatusFlag	=	8 THEN 'Reject'

					WHEN StatusFlag	=	1 THEN 'Saved'

			ELSE NULL END StatusFlag,

			FeeReport.ModifiedDateUTC,
			FeeReport.FacilityId

	FROM	VMRollOverFeeReport					AS	FeeReport		WITH(NOLOCK)

			LEFT JOIN UMUserRegistration		AS	UserReg			WITH(NOLOCK)	ON	FeeReport.DoneBy				=	UserReg.UserRegistrationId

			LEFT JOIN MstService				AS	Service			WITH(NOLOCK)	ON	FeeReport.ServiceId				=	Service.ServiceId

			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON	FeeReport.Status				=	LovStatus.LovId

			LEFT JOIN EngAssetClassification	AS	AssetClassify	WITH(NOLOCK)	ON	FeeReport.AssetClassificationId	=	AssetClassify.AssetClassificationId
GO
