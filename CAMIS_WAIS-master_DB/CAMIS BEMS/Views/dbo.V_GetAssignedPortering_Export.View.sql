USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_GetAssignedPortering_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_GetAssignedPortering_Export]
AS
	SELECT	DISTINCT Porter.PorteringId,
			Porter.FromCustomerId,
			Customer.CustomerName,
			Porter.FromFacilityId as FacilityId,
			Facility.FacilityName,
			Asset.AssetNo,
			Porter.PorteringNo,
			Porter.PorteringDate,
			case when   MWO.MaintenanceWorkNo = '0' then null else MWO.MaintenanceWorkNo	end	AS	 WorkOrderNo,
			LovCurrentWF.FieldValue		AS	WorkFlowStatus,
			Porter.PorteringStatus,
			LovPorterStatus.FieldValue	AS	PorteringStatusValue,
			Porter.ModifiedDateUTC,
			LovAssignType.FieldValue	AS AssigneeType,
			UserReg.StaffName			AS AssignedName
	FROM	PorteringTransaction					AS Porter				WITH(NOLOCK)
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON	Porter.FromCustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON	Porter.FromFacilityId		=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON	Porter.AssetId				=	Asset.AssetId
			INNER JOIN FMLovMst						AS	LovCurrentWF		WITH(NOLOCK)	ON	Porter.CurrentWorkFlowId	=	LovCurrentWF.LovId
			LEFT JOIN FMLovMst						AS	LovPorterStatus		WITH(NOLOCK)	ON	Porter.PorteringStatus		=	LovPorterStatus.LovId
			LEFT JOIN EngMaintenanceWorkOrderTxn	AS	MWO					WITH(NOLOCK)	ON	MWO.WorkOrderId				=	Porter.WorkOrderId
			LEFT JOIN FMLovMst						AS	LovAssignType		WITH(NOLOCK)	ON	Porter.AssigneeLovId		=	LovAssignType.LovId
			LEFT JOIN UMUserRegistration			AS	UserReg				WITH(NOLOCK)	ON	Porter.AssignPorterId		=	UserReg.UserRegistrationId
	WHERE	Porter.AssigneeLovId <> 330
			AND ModeOfTransport = 217
GO
