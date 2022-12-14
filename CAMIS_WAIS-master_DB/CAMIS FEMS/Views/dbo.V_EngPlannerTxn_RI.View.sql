USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPlannerTxn_RI]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngPlannerTxn_RI]
AS
	SELECT	Planner.PlannerId,
			Planner.CustomerId,
			Customer.CustomerName,
			Planner.FacilityId,
			Facility.FacilityName,
			WorkGroup.WorkGroupCode,
			WorkGroup.WorkGroupDescription,
			UserArea.UserAreaCode,
			UserArea.UserAreaName,
			(SELECT	ISNULL(COUNT(AssetNo),0)
			FROM	EngAsset 
			WHERE	UserAreaId = UserArea.UserAreaId)	AS TotalNoOfAssets,
			Planner.ScheduleType								AS ScheduleTypeLovId,
			LovScheduleType.FieldValue					AS ScheduleType,
			Planner.Status										AS StatusLovId,
			LovStatus.FieldValue						AS Status,
			LovStatus.FieldValue						AS StatusGrid,
			Planner.AssigneeCompanyUserId,
			AssigneeCompanyUserId.StaffName             AS Assignee,
			Planner.ModifiedDateUTC
	FROM	EngPlannerTxn								AS Planner WITH(NOLOCK)
			INNER JOIN MstCustomer						AS	Customer		WITH(NOLOCK)	ON Planner.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility				AS	Facility		WITH(NOLOCK)	ON Planner.FacilityId				=	Facility.FacilityId
			INNER JOIN EngAssetWorkGroup				AS	WorkGroup		WITH(NOLOCK)	ON Planner.WorkGroupId				=	WorkGroup.WorkGroupId
			LEFT JOIN MstLocationUserArea				AS	UserArea		WITH(NOLOCK)	ON Planner.UserAreaId				=	UserArea.UserAreaId
			LEFT JOIN FMLovMst							AS	LovScheduleType	WITH(NOLOCK)	ON Planner.ScheduleType				=	LovScheduleType.LovId
			LEFT JOIN FMLovMst							AS	LovStatus		WITH(NOLOCK)	ON Planner.Status					=	LovStatus.LovId
			LEFT JOIN UMUserRegistration				AS	AssigneeCompanyUserId	WITH(NOLOCK)	ON Planner.AssigneeCompanyUserId					=	AssigneeCompanyUserId.UserRegistrationId
	WHERE	Planner.TypeOfPlanner=35
GO
