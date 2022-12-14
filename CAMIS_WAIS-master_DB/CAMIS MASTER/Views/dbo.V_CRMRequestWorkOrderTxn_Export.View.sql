USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_CRMRequestWorkOrderTxn_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_CRMRequestWorkOrderTxn_Export]
AS
    SELECT	CRMWO.CRMRequestWOId,
			CRMWO.CustomerId,
			CRMWO.FacilityId,
			CRMWO.ServiceId,
			CRMWO.CRMWorkOrderNo  AS CRMRequestWONo,
			FORMAT(CRMWO.CRMWorkOrderDateTime,'dd-MMM-yyyy'+' '+ convert(char(5), CRMWO.CRMWorkOrderDateTime, 108) )	AS CRMWorkOrderDateTime,
			LovStatus.FieldValue			AS	WorkOrderStatus,
			CRMWO.Description,
			LovReqType.FieldValue			AS	TypeOfRequest,
			CRM.RequestNo,
			Asset.AssetNo,
			Asset.AssetDescription,
			Manufacturer.Manufacturer,
			Model.Model,
			Staff.StaffName					AS	StaffName,
			CRMWO.Remarks,
			CRMWO.ModifiedDateUTC               AS ModifiedDateUTC
 	FROM	CRMRequestWorkOrderTxn								AS CRMWO			WITH(NOLOCK)
			LEFT JOIN  CRMRequest								AS	CRM				WITH(NOLOCK)	ON CRMWO.CRMRequestId		=	CRM.CRMRequestId
			LEFT JOIN  EngAsset									AS	Asset			WITH(NOLOCK)	ON CRMWO.AssetId			=	Asset.AssetId
			LEFT JOIN  EngAssetStandardizationManufacturer		AS	Manufacturer	WITH(NOLOCK)	ON CRMWO.ManufacturerId		=	Manufacturer.ManufacturerId
			LEFT JOIN  EngAssetStandardizationModel				AS	Model			WITH(NOLOCK)	ON CRMWO.ModelId			=	Model.ModelId
			LEFT JOIN  UMUserRegistration						AS	Staff			WITH(NOLOCK)	ON CRMWO.AssignedUserId		=	Staff.UserRegistrationId
			INNER JOIN  FMLovMst								AS	LovStatus		WITH(NOLOCK)	ON CRMWO.Status				=	LovStatus.LovId
			INNER JOIN  FMLovMst								AS	LovReqType		WITH(NOLOCK)	ON CRMWO.TypeOfRequest		=	LovReqType.LovId
GO
