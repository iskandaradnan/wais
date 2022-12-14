USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPlannerTxn]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_EngPlannerTxn]

AS

	SELECT	Planner.PlannerId,

			Planner.CustomerId,

			Customer.CustomerName,

			Planner.FacilityId,

			Facility.FacilityName,

			WorkGroup.WorkGroupCode,

			WorkGroup.WorkGroupDescription,

			Classification.AssetClassificationCode,

			Classification.AssetClassificationDescription,

			AssetTypeCode.AssetTypeCode,

			AssetTypeCode.AssetTypeDescription,

			Asset.AssetNo,

			Asset.AssetDescription,

			UserArea.UserAreaCode,

			UserArea.UserAreaName,

			StandardTasks.TaskCode,

			Planner.ScheduleType								AS ScheduleTypeLovId,

			LovScheduleType.FieldValue	AS ScheduleType,

			Planner.Status										AS StatusLovId,

			LovStatus.FieldValue		AS Status,

			LovStatus.FieldValue		AS StatusGrid,

			Planner.AssigneeCompanyUserId,

			AssigneeCompanyUserId.StaffName						AS Assignee,

			Planner.ModifiedDateUTC,
			generationtype.FieldValue as  TaskCodeOptionValue 

	FROM	EngPlannerTxn								AS Planner WITH(NOLOCK)

			INNER JOIN MstCustomer						AS	Customer		WITH(NOLOCK)	ON Planner.CustomerId				=	Customer.CustomerId

			INNER JOIN MstLocationFacility				AS	Facility		WITH(NOLOCK)	ON Planner.FacilityId				=	Facility.FacilityId

			INNER JOIN EngAssetWorkGroup				AS	WorkGroup		WITH(NOLOCK)	ON Planner.WorkGroupId				=	WorkGroup.WorkGroupId

			LEFT JOIN EngAssetTypeCode					AS	AssetTypeCode	WITH(NOLOCK)	ON Planner.AssetTypeCodeId			=	AssetTypeCode.AssetTypeCodeId

			INNER JOIN EngAsset							AS	Asset			WITH(NOLOCK)	ON Planner.AssetId					=	Asset.AssetId

			LEFT JOIN MstLocationUserArea				AS	UserArea		WITH(NOLOCK)	ON Planner.UserAreaId				=	UserArea.UserAreaId

			LEFT JOIN EngAssetPPMCheckList				AS	StandardTasks	WITH(NOLOCK)	ON Planner.StandardTaskDetId		=	StandardTasks.PPMCheckListId

			LEFT JOIN EngAssetClassification			AS	Classification	WITH(NOLOCK)	ON Planner.AssetClassificationId	=	Classification.AssetClassificationId

			LEFT JOIN FMLovMst							AS	LovScheduleType	WITH(NOLOCK)	ON Planner.ScheduleType				=	LovScheduleType.LovId

			LEFT JOIN FMLovMst							AS	LovStatus		WITH(NOLOCK)	ON Planner.Status					=	LovStatus.LovId
			LEFT JOIN FMLovMst							AS	generationtype		WITH(NOLOCK)	ON Planner.generationtype		=	generationtype.LovId

			LEFT JOIN UMUserRegistration				AS	AssigneeCompanyUserId	WITH(NOLOCK)	ON Planner.AssigneeCompanyUserId					=	AssigneeCompanyUserId.UserRegistrationId

	WHERE	Planner.TypeOfPlanner=34
GO
