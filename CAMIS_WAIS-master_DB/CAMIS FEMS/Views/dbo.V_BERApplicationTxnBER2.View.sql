USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_BERApplicationTxnBER2]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[V_BERApplicationTxnBER2]
AS
	SELECT	BER.ApplicationId,
			BER.CustomerId,
			Customer.CustomerName,
			BER.FacilityId,
			Facility.FacilityName,
			Facility.FacilityCode,
			cast(BER.ApplicationDate AS date)	AS BERDate,
			BER.BERno,			
			Asset.AssetNo,
			--Asset.AssetDescription,
			--UserArea.UserAreaName,
			UserLocation.UserLocationCode,
			UMUser.StaffName					AS	Applicant,
			UMUserModifiedBy.StaffName			AS	LastActionBy,
			BER.BERStatus						AS	BERStatus,
			LovBERStatus.FieldValue				AS	BERStatusValue,			
			BER.ModifiedDateUTC
	FROM	BERApplicationTxn					AS BER					WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer			WITH(NOLOCK)	ON	BER.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility			WITH(NOLOCK)	ON	BER.FacilityId			=	Facility.FacilityId
			INNER JOIN EngAsset					AS	Asset				WITH(NOLOCK)	ON	BER.AssetId				=	Asset.AssetId
			LEFT JOIN MstLocationUserArea		AS	UserArea			WITH(NOLOCK)	ON	Asset.UserAreaId		=	UserArea.UserAreaId
			LEFT JOIN MstLocationUserLocation	AS	UserLocation		WITH(NOLOCK)	ON	Asset.UserLocationId	=	UserLocation.UserLocationId
			LEFT JOIN FMLovMst					AS	LovBERStatus		WITH(NOLOCK)	ON	BER.BERStatus			=	LovBERStatus.LovId
			LEFT JOIN UMUserRegistration		AS	UMUser				WITH(NOLOCK)	ON	BER.ApplicantUserId		=	UMUser.UserRegistrationId
			LEFT JOIN UMUserRegistration		AS	UMUserModifiedBy	WITH(NOLOCK)	ON	BER.ModifiedBy			=	UMUserModifiedBy.UserRegistrationId
	WHERE	BER.BERStage	=	2
GO
