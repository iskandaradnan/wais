USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPlannerTxn_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngPlannerTxn_Export]
AS
	SELECT	Planner.PlannerId,
			Planner.CustomerId,
			Customer.CustomerName,
			Planner.FacilityId,
			Facility.FacilityName,
			WorkGroup.WorkGroupCode,
			WorkGroup.WorkGroupDescription,
			Classification.AssetClassificationCode,
			AssetTypeCode.AssetTypeCode,
			Asset.AssetNo,
			Asset.AssetDescription,
			StandardTasks.TaskCode,
			LovScheduleType.FieldValue	AS ScheduleType,
			LovStatus.FieldValue		AS Status,
			LovStatus.FieldValue		AS StatusGrid,
			Planner.ModifiedDateUTC
	FROM	EngPlannerTxn AS Planner WITH(NOLOCK)
			INNER JOIN MstCustomer						AS	Customer		WITH(NOLOCK)	ON Planner.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility				AS	Facility		WITH(NOLOCK)	ON Planner.FacilityId				=	Facility.FacilityId
			INNER JOIN EngAssetWorkGroup				AS	WorkGroup		WITH(NOLOCK)	ON Planner.WorkGroupId				=	WorkGroup.WorkGroupId
			INNER JOIN EngAssetTypeCode					AS	AssetTypeCode	WITH(NOLOCK)	ON Planner.AssetTypeCodeId			=	AssetTypeCode.AssetTypeCodeId
			INNER JOIN EngAsset							AS	Asset			WITH(NOLOCK)	ON Planner.AssetId					=	Asset.AssetId
			LEFT JOIN EngAssetTypeCodeStandardTasksDet	AS	StandardTasks	WITH(NOLOCK)	ON Planner.StandardTaskDetId		=	StandardTasks.StandardTaskDetId
			LEFT JOIN EngAssetClassification			AS	Classification	WITH(NOLOCK)	ON Planner.AssetClassificationId	=	Classification.AssetClassificationId
			LEFT JOIN FMLovMst							AS	LovScheduleType	WITH(NOLOCK)	ON Planner.ScheduleType				=	LovScheduleType.LovId
			LEFT JOIN FMLovMst							AS	LovStatus		WITH(NOLOCK)	ON Planner.Status					=	LovStatus.LovId
GO
