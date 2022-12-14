USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngLicenseandCertificateTxn_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngLicenseandCertificateTxn_Export]
AS
	SELECT	Distinct
			License.LicenseId,
			License.CustomerId,
			Customer.CustomerName,
			License.FacilityId,
			Facility.FacilityName,
			License.LicenseNo,
			'BEMS'						AS	Service,
			LovCategory.FieldValue		AS	CategoryVal,
			License.IfOthersSpecify		AS	[IfOthers,Specify],
			LovType.FieldValue			AS	Type,
			License.ClassGrade			AS	[ClassGrade],
			LovStatus.FieldValue AS StatusVal,
			UMUser.StaffName		ContactPerson,
			IssueBody.IssuingBodyName	AS	IssuingBodyVal,
			FORMAT(License.IssuingDate,'dd-MMM-yyyy') IssuingDate,
			FORMAT(License.NotificationForInspection,'dd-MMM-yyyy') AS	NotificationForInspection,
			FORMAT(License.InspectionConductedOn,'dd-MMM-yyyy')		AS	InspectionConductedOn,
			FORMAT(License.NextInspectionDate,'dd-MMM-yyyy')		AS	NextInspectionDate,
			cast ( License.ExpireDate as date) as ExpiryDate,
			--FORMAT(License.ExpireDate,'dd-MMM-yyyy')	AS ExpiryDate,
			FORMAT(License.PreviousExpiryDate,'dd-MMM-yyyy')	AS PreviousExpiryDate,
			License.RegistrationNo,
			Asset.AssetNo,
			Asset.AssetDescription,
			TypeCode.AssetTypeDescription		AS	[TypeCodeDescription],
			LicenseDet.Remarks,
			License.ModifiedDateUTC,
			License.LicenseDescription
	FROM	EngLicenseandCertificateTxn						AS	License			WITH(NOLOCK)
			--outer apply (select top 1 AssetId , a.Remarks as Remarks  from EngLicenseandCertificateTxnDet a WITH(NOLOCK) where License.LicenseId				=	a.LicenseId  order by LicenseDetId desc) 		AS	LicenseDet		
			Left join EngLicenseandCertificateTxnDet AS	LicenseDet WITH(NOLOCK) ON License.LicenseId				=	LicenseDet.LicenseId 			
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	License.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	License.FacilityId				=	Facility.FacilityId
			LEFT JOIN EngAsset								AS	Asset			WITH(NOLOCK)	ON	LicenseDet.AssetId				=	Asset.AssetId
			LEFT JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	Asset.AssetTypeCodeId			=	TypeCode.AssetTypeCodeId
			LEFT JOIN FMLovMst								AS	LovStatus		WITH(NOLOCK)	ON	License.Status					=	LovStatus.LovId
			LEFT JOIN FMLovMst								AS	LovCategory		WITH(NOLOCK)	ON	License.Category				=	LovCategory.LovId
			LEFT JOIN MstIssuingBody						AS	IssueBody		WITH(NOLOCK)	ON	License.IssuingBody				=	IssueBody.IssuingBodyId
			LEFT JOIN FMLovMst								AS	LovType			WITH(NOLOCK)	ON	License.Type					=	LovType.LovId
			LEFT JOIN UMUserRegistration					AS	UMUser			WITH(NOLOCK)	ON	License.ContactPersonUserId		=	UMUser.UserRegistrationId
GO
