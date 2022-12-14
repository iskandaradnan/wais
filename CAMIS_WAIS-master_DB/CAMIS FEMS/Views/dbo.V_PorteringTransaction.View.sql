USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_PorteringTransaction]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_PorteringTransaction]
AS
SELECT	DISTINCT Porter.PorteringId,
        	Porter.AssignPorterId as UserRegistrationId,
			Assignee.StaffName as Assignee,
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
			LovMovementCat.FieldValue				AS	MovementCategoryValue,
		
			Porter.ModifiedDateUTC
	FROM	PorteringTransaction					AS Porter				WITH(NOLOCK)
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON	Porter.FromCustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON	Porter.FromFacilityId		=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON	Porter.AssetId				=	Asset.AssetId
			INNER JOIN FMLovMst						AS	LovCurrentWF		WITH(NOLOCK)	ON	Porter.CurrentWorkFlowId	=	LovCurrentWF.LovId
			LEFT JOIN FMLovMst						AS	LovPorterStatus		WITH(NOLOCK)	ON	Porter.PorteringStatus		=	LovPorterStatus.LovId
			LEFT JOIN EngMaintenanceWorkOrderTxn	AS	MWO					WITH(NOLOCK)	ON	MWO.WorkOrderId				=	Porter.WorkOrderId
			LEFT JOIN FMLovMst						AS	LovMovementCat		WITH(NOLOCK)	ON	Porter.MovementCategory		=	LovMovementCat.LovId
			LEFT  JOIN UMUserRegistration			AS	Assignee			WITH(NOLOCK)	ON Porter.AssignPorterId			=	Assignee.UserRegistrationId
			
			--OUTER APPLY (SELECT TOP 1 MaintenanceWorkNo FROM EngMaintenanceWorkOrderTxn AS WO WHERE Asset.AssetId				=	WO.AssetId) MWO
GO
