USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_CRMRequestWorkOrderTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_CRMRequestWorkOrderTxn]
AS
   SELECT	CRMWO.CRMRequestWOId,
			CRMWO.CustomerId,
			Customer.CustomerName,
			CRMWO.FacilityId,
			Facility.FacilityName,
			CRMWO.ServiceId,
			CRMWO.CRMWorkOrderNo AS CRMRequestWONo,
			CRMREQ.RequestNo AS RequestNo,
			FORMAT(CRMWO.CRMWorkOrderDateTime,'dd-MMM-yyyy')	AS CRMWorkOrderDateTime,
			Asset.AssetNo,
			Manufacturer.Manufacturer,
			Model.Model,
			LovStatus.FieldValue			AS	WorkOrderStatus,
			LovReqType.FieldValue			AS	TypeOfRequest,
			Staff.StaffName					AS	StaffName,
			CRMWO.Remarks,
			CRMWO.ModifiedDateUTC
 	FROM	CRMRequestWorkOrderTxn			AS CRMWO			WITH(NOLOCK)
			INNER JOIN CRMRequest			AS CRMREQ			WITH(NOLOCK)	ON	CRMWO.CRMRequestId		=	CRMREQ.CRMRequestId
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON	CRMWO.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON	CRMWO.FacilityId		=	Facility.FacilityId
			INNER JOIN  FMLovMst			AS	LovStatus		WITH(NOLOCK)	ON CRMWO.Status				=	LovStatus.LovId
			INNER JOIN  FMLovMst			AS	LovReqType		WITH(NOLOCK)	ON CRMWO.TypeOfRequest		=	LovReqType.LovId
			LEFT JOIN  UMUserRegistration	AS	Staff			WITH(NOLOCK)	ON CRMWO.AssignedUserId		=	Staff.UserRegistrationId
			LEFT JOIN  EngAsset				AS	Asset			WITH(NOLOCK)	ON CRMWO.AssetId	=	Asset.AssetId
			LEFT JOIN  EngAssetStandardizationManufacturer		AS	Manufacturer	WITH(NOLOCK)	ON CRMWO.ManufacturerId		=	Manufacturer.ManufacturerId
			LEFT JOIN  EngAssetStandardizationModel				AS	Model			WITH(NOLOCK)	ON CRMWO.ModelId				=	Model.ModelId
GO
