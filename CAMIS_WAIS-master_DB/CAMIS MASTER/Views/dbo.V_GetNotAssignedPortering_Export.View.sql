USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_GetNotAssignedPortering_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_GetNotAssignedPortering_Export]
AS
	SELECT	DISTINCT Porter.PorteringId,
			Porter.FromCustomerId,
			Customer.CustomerName,
			Porter.FromFacilityId					AS FacilityId,
			Facility.FacilityName,
			Asset.AssetNo,
			Porter.PorteringNo,
			Porter.PorteringDate,
			CASE WHEN   MWO.MaintenanceWorkNo = '0' THEN null else MWO.MaintenanceWorkNo	END	AS	 WorkOrderNo,
			LovCurrentWF.FieldValue					AS	WorkFlowStatus,
			Porter.PorteringStatus,
			LovPorterStatus.FieldValue				AS	PorteringStatusValue,
			Porter.ModifiedDateUTC,
			LovAssignType.FieldValue				AS AssigneeType,
			UserReg.StaffName						AS AssignedName,
			Facility.FacilityName					AS	[FromFacility],
			FromBlock.BlockName						AS	[FromBlock],
			FromLevel.LevelName						AS	[FromLevel],
			FromUserArea.UserAreaName				AS	[FromUserArea],
			FromUserLocation.UserLocationName		AS	[FromUserLocation]
	FROM	PorteringTransaction					AS Porter				WITH(NOLOCK)
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON	Porter.FromCustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON	Porter.FromFacilityId		=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON	Porter.AssetId				=	Asset.AssetId
			INNER JOIN FMLovMst						AS	LovCurrentWF		WITH(NOLOCK)	ON	Porter.CurrentWorkFlowId	=	LovCurrentWF.LovId
			LEFT JOIN FMLovMst						AS	LovPorterStatus		WITH(NOLOCK)	ON	Porter.PorteringStatus		=	LovPorterStatus.LovId
			LEFT JOIN EngMaintenanceWorkOrderTxn	AS	MWO					WITH(NOLOCK)	ON	MWO.WorkOrderId				=	Porter.WorkOrderId
			LEFT JOIN FMLovMst						AS	LovAssignType		WITH(NOLOCK)	ON	Porter.AssigneeLovId		=	LovAssignType.LovId
			LEFT JOIN UMUserRegistration			AS	UserReg				WITH(NOLOCK)	ON	Porter.AssignPorterId		=	UserReg.UserRegistrationId
			LEFT JOIN MstLocationBlock				AS	FromBlock			WITH(NOLOCK)	ON	Porter.FromBlockId			=	FromBlock.BlockId
			LEFT JOIN MstLocationLevel				AS	FromLevel			WITH(NOLOCK)	ON	Porter.FromLevelId			=	FromLevel.LevelId
			LEFT JOIN MstLocationUserArea			AS	FromUserArea		WITH(NOLOCK)	ON	Porter.FromUserAreaId		=	FromUserArea.UserAreaId
			LEFT JOIN MstLocationUserLocation		AS	FromUserLocation	WITH(NOLOCK)	ON	Porter.FromUserLocationId	=	FromUserLocation.UserLocationId
	WHERE	(Porter.AssigneeLovId = 330 OR Porter.AssigneeLovId IS NULL)
			AND ModeOfTransport = 217
			AND Porter.CurrentWorkFlowId = 247
GO
