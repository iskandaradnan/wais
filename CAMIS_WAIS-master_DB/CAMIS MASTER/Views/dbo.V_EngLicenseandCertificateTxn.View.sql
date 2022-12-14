USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngLicenseandCertificateTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngLicenseandCertificateTxn]
AS
	SELECT	DISTINCT License.LicenseId,
			License.CustomerId,
			Customer.CustomerName,
			License.FacilityId,
			Facility.FacilityName,
			License.LicenseNo,
			LovStatus.FieldValue AS StatusVal,
			LovCategory.FieldValue AS CategoryVal,
			IssueBody.IssuingBodyName	AS	IssuingBodyVal,
			CAST(License.ExpireDate AS DATE)	AS ExpiryDate,
			Asset.AssetNo,
			Asset.AssetDescription,
			License.ClassGrade,
			License.ModifiedDateUTC
	FROM	EngLicenseandCertificateTxn						AS	License			WITH(NOLOCK)
			LEFT JOIN EngLicenseandCertificateTxnDet		AS	LicenseDet		WITH(NOLOCK)	ON	License.LicenseId	=	LicenseDet.LicenseId
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	License.CustomerId	=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	License.FacilityId	=	Facility.FacilityId
			LEFT JOIN EngAsset								AS	Asset			WITH(NOLOCK)	ON	LicenseDet.AssetId	=	Asset.AssetId
			LEFT JOIN FMLovMst								AS	LovStatus		WITH(NOLOCK)	ON	License.Status		=	LovStatus.LovId
			LEFT JOIN FMLovMst								AS	LovCategory		WITH(NOLOCK)	ON	License.Category	=	LovCategory.LovId
			LEFT JOIN MstIssuingBody						AS	IssueBody		WITH(NOLOCK)	ON	License.IssuingBody	=	IssueBody.IssuingBodyId
GO
