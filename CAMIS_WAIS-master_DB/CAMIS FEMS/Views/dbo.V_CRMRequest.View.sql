USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_CRMRequest]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_CRMRequest]
AS
	SELECT	CRM.CRMRequestId,
			CRM.CustomerId,
			Customer.CustomerName,
			CRM.FacilityId,
			Facility.FacilityName,
			CRM.RequestNo,
			CRM.RequestDateTime,
			LovRequestType.FieldValue			AS	TypeOfRequestVal,
			LovStatus.FieldValue				AS	RequestStatusValue,
			CRM.IsWorkOrder,
			CRM.ModifiedDateUTC,
			CRM.Requester						AS ReqStaffId,
			UserRegUser.StaffName				AS ReqStaff,
			CRM.ModelId,
			Model.Model,
			CRM.ManufacturerId,
			M.Manufacturer	,
			CRM.GuId,
			CRM.RequestStatus				
	FROM	CRMRequest							AS CRM WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON	CRM.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	CRM.FacilityId		=	Facility.FacilityId
			INNER JOIN FMLovMst					AS	LovRequestType	WITH(NOLOCK)	ON	CRM.TypeOfRequest	=	LovRequestType.LovId
			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON	CRM.RequestStatus	=	LovStatus.LovId
			LEFT JOIN UMUserRegistration		AS	UserRegUser		WITH(NOLOCK)	ON	CRM.Requester		=	UserRegUser.UserRegistrationId
			left JOIN EngAssetStandardizationModel AS	Model		WITH(NOLOCK)	ON	Model.ModelId		=	CRM.ModelId
			left join EngAssetStandardizationManufacturer as M		WITH(NOLOCK)	ON	CRM.ManufacturerId	=	M.ManufacturerId
GO
