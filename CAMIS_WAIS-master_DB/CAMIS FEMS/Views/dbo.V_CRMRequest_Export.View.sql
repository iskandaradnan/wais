USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_CRMRequest_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_CRMRequest_Export]
AS
	SELECT	CRM.CustomerId,
			Customer.CustomerName,
			CRM.FacilityId,
			Facility.FacilityName,
			CRM.RequestNo,			
			CAST(CRM.RequestDateTime AS DATETIME)	AS	RequestDateTime,
			LovRequestType.FieldValue				AS	TypeOfRequestVal,
			LovStatus.FieldValue					AS	RequestStatusValue,
			AssetModel.Model,
			AssetManufacturer.Manufacturer,
			CRM.Remarks,
			CRM.RequestDescription,
			CRM.ModifiedDateUTC,
			CRM.Requester							AS ReqStaffId,
			UserRegUser.StaffName					AS ReqStaff,
			CRM.UserAreaId,
			Area.UserAreaCode,
			Area.UserAreaName,
			CRM.UserLocationId,
			Location.UserLocationCode,
			Location.UserLocationName,
			Asset.AssetNo,
			Asset.SerialNo,
			Asset.SoftwareVersion,
			Reqperson.StaffName						AS RequestedPerson,
			CRM.TargetDate,
			Assignee.StaffName						AS Assignee

	FROM	CRMRequest										AS	CRM					WITH(NOLOCK)			
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON	CRM.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON	CRM.FacilityId		=	Facility.FacilityId
			INNER JOIN FMLovMst								AS	LovRequestType		WITH(NOLOCK)	ON	CRM.TypeOfRequest	=	LovRequestType.LovId
			LEFT JOIN FMLovMst								AS	LovStatus			WITH(NOLOCK)	ON	CRM.RequestStatus	=	LovStatus.LovId
			LEFT JOIN EngAssetStandardizationModel			AS	AssetModel			WITH(NOLOCK)	ON	CRM.ModelId			=	AssetModel.ModelId
			LEFT JOIN EngAssetStandardizationManufacturer	AS	AssetManufacturer	WITH(NOLOCK)	ON	CRM.ManufacturerId	=	AssetManufacturer.ManufacturerId
			LEFT JOIN UMUserRegistration					AS	UserRegUser			WITH(NOLOCK)	ON	CRM.Requester		=	UserRegUser.UserRegistrationId
			LEFT JOIN MstLocationUserArea					AS	Area				WITH(NOLOCK)	ON	CRM.UserAreaId		=	Area.UserAreaId
			LEFT JOIN MstLocationUserLocation				AS	Location			WITH(NOLOCK)	ON	CRM.UserLocationId	=	Location.UserLocationId
			LEFT JOIN UMUserRegistration					AS	Reqperson			WITH(NOLOCK)	ON	CRM.RequestedPerson	=	Reqperson.UserRegistrationId
			LEFT JOIN UMUserRegistration					AS	Assignee			WITH(NOLOCK)	ON	CRM.AssigneeId		=	Assignee.UserRegistrationId
			LEFT JOIN CRMRequestDet							AS  CRMDet				WITH(NOLOCK)	ON	CRM.CRMRequestId	=	CRMDet.CRMRequestId
			LEFT JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON	CRMDet.AssetId		=	Asset.AssetId
GO
