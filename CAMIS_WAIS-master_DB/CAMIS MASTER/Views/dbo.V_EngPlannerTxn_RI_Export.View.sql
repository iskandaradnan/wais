USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPlannerTxn_RI_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngPlannerTxn_RI_Export]
AS
    SELECT	DISTINCT
			Planner.PlannerId									AS PlannerId,
			Planner.CustomerId									AS CustomerId,
			Planner.FacilityId									AS FacilityId,
			Planner.ServiceId									AS ServiceId,

			ServiceKey.ServiceKey								AS ServiceKey,
			Planner.[Year]										AS [Year],
			AssetWorkGroup.WorkGroupCode						AS WorkGroupCode,
			LocationUserArea.UserAreaCode						AS UserAreaCode,
			LocationUserArea.UserAreaName						AS UserAreaName,
			(SELECT	ISNULL(COUNT(DISTINCT AssetNo),0)
			FROM	EngAsset 
			WHERE	UserAreaId = LocationUserArea.UserAreaId)	AS TotalNoOfAssets,

			CompanyStaff.StaffName								AS Assignee,
			FacilityStaff.StaffName								AS FacilityRepresentative,
			EngineerStaff.StaffName								AS Engineer,
			Planner.ScheduleType								AS ScheduleTypeLovId,
			ScheduleType.FieldValue								AS ScheduleType,
			Planner.Status										AS StatusLovId,
			PlannerStatus.FieldValue							AS Status,
			PlannerStatus.FieldValue							AS StatusGrid,
			FORMAT(PlanTxnDet.PlannerDate,'dd-MMM-yyyy')		AS	PlannerDate,
			--FMMonth.Month										AS Month,
			--PDate.Item											AS Date,
			--PWeek.Item											AS Week,
			--PDay.Item										AS Day,
			--Planner.Day										AS Day			
			Planner.ModifiedDateUTC
	FROM	EngPlannerTxn										AS Planner					WITH(NOLOCK)
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			ON Planner.ServiceId					= ServiceKey.ServiceId
			INNER JOIN  EngAssetWorkGroup						AS AssetWorkGroup			WITH(NOLOCK)			ON Planner.WorkGroupId					= AssetWorkGroup.WorkGroupId
			LEFT  JOIN  MstLocationUserArea						AS LocationUserArea			WITH(NOLOCK)			ON Planner.UserAreaId					= LocationUserArea.UserAreaId	
			LEFT  JOIN  UMUserRegistration						AS CompanyStaff				WITH(NOLOCK)			ON Planner.AssigneeCompanyUserId		= CompanyStaff.UserRegistrationId	
			LEFT  JOIN  UMUserRegistration						AS FacilityStaff			WITH(NOLOCK)			ON Planner.FacilityUserId				= FacilityStaff.UserRegistrationId	
			LEFT  JOIN  UMUserRegistration						AS EngineerStaff			WITH(NOLOCK)			ON Planner.EngineerUserId				= EngineerStaff.UserRegistrationId	
			LEFT  JOIN  EngAssetTypeCodeStandardTasksDet		AS StandardTasks			WITH(NOLOCK)			ON Planner.StandardTaskDetId			= StandardTasks.StandardTaskDetId
			LEFT  JOIN  FMLovMst								AS ScheduleType				WITH(NOLOCK)			ON Planner.ScheduleType					= ScheduleType.LovId
			LEFT  JOIN  FMLovMst								AS PlannerStatus			WITH(NOLOCK)			ON Planner.Status						= PlannerStatus.LovId
			--outer apply dbo.SplitString(Planner.Date,',') as PDate
			--outer apply dbo.SplitString(Planner.Month,',') as PMonth 
			--outer apply dbo.SplitString(Planner.Week,',') as PWeek 
			--outer apply dbo.SplitString(Planner.Day,',') as PDay 
			--LEFT JOIN FMTimeMonth	AS FMMonth		WITH(NOLOCK)			ON PMonth.Item	=	FMMonth.MonthId
			INNER JOIN  EngPlannerTxnDet						AS PlanTxnDet				WITH(NOLOCK)			ON Planner.PlannerId					= PlanTxnDet.PlannerId
	WHERE	Planner.TypeOfPlanner = 35
GO
