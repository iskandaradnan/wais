USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPlannerTxn_Others_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngPlannerTxn_Others_Export]

AS

    SELECT	DISTINCT

			Planner.PlannerId,

			Planner.CustomerId,

			Planner.FacilityId,



			ServiceKey.ServiceKey as Service,

			Planner.Year,

			AssetWorkGroup.WorkGroupCode,

						--AssetWorkGroup.WorkGroupDescription,

			WorkOrderType.FieldValue	AS TypeOfPlanner,

			WorkOrderType.FieldValue	AS TypeOfPlannerGrid,

			LocationUserArea.UserAreaCode,

			LocationUserArea.UserAreaName,

			CompanyStaff.StaffName		AS	Assignee,

			FacilityStaff.StaffName		AS	FacilityRepresentative,



			AssetClassification.AssetClassificationCode,

			AssetClassification.AssetClassificationDescription,

			AssetTypeCode.AssetTypeCode,

			AssetTypeCode.AssetTypeDescription,

			Asset.AssetNo,

			StandardizationModel.Model,

			StandardizationManufacturer.Manufacturer,

			Asset.SerialNo,

			StandardTasks.TaskCode,

			StandardTasks.TaskDescription,

			EngineerStaff.StaffName	AS	Engineer,

			Planner.ScheduleType								AS ScheduleTypeLovId,

			ScheduleType.FieldValue	AS ScheduleType,

			Planner.Status										AS StatusLovId,

			PlannerStatus.FieldValue		AS Status,

			PlannerStatus.FieldValue		AS StatusGrid,

			PlanTxnDet.PlannerDate,

			Planner.ModifiedDateUTC

	FROM	EngPlannerTxn										AS Planner					WITH(NOLOCK)

			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			ON Planner.ServiceId					= ServiceKey.ServiceId

			INNER JOIN  EngAssetWorkGroup						AS AssetWorkGroup			WITH(NOLOCK)			ON Planner.WorkGroupId					= AssetWorkGroup.WorkGroupId

			LEFT  JOIN  MstLocationUserArea						AS LocationUserArea			WITH(NOLOCK)			ON Planner.UserAreaId					= LocationUserArea.UserAreaId	

			LEFT  JOIN  UMUserRegistration						AS CompanyStaff				WITH(NOLOCK)			ON Planner.AssigneeCompanyUserId		= CompanyStaff.UserRegistrationId	

			LEFT  JOIN  UMUserRegistration						AS FacilityStaff			WITH(NOLOCK)			ON Planner.FacilityUserId				= FacilityStaff.UserRegistrationId	

			LEFT  JOIN  UMUserRegistration						AS EngineerStaff			WITH(NOLOCK)			ON Planner.EngineerUserId				= EngineerStaff.UserRegistrationId	

			LEFT JOIN  EngAssetClassification					AS AssetClassification		WITH(NOLOCK)			ON Planner.AssetClassificationId		= AssetClassification.AssetClassificationId

			LEFT  JOIN  EngAssetTypeCode						AS AssetTypeCode			WITH(NOLOCK)			on Planner.AssetTypeCodeId				= AssetTypeCode.AssetTypeCodeId

			LEFT  JOIN  EngAsset								AS Asset					WITH(NOLOCK)			ON Planner.AssetId						= Asset.AssetId

			LEFT  JOIN  EngAssetTypeCodeStandardTasksDet		AS StandardTasks			WITH(NOLOCK)			ON Planner.StandardTaskDetId			= StandardTasks.StandardTaskDetId

			LEFT  JOIN  FMLovMst								AS ScheduleType				WITH(NOLOCK)			ON Planner.ScheduleType					= ScheduleType.LovId

			LEFT  JOIN  FMLovMst								AS PlannerStatus			WITH(NOLOCK)			ON Planner.Status						= PlannerStatus.LovId

			LEFT  JOIN  FMLovMst								AS WorkOrderType			WITH(NOLOCK)			ON Planner.TypeOfPlanner				= WorkOrderType.LovId

			LEFT  JOIN  FMLovMst								AS WarrantyType				WITH(NOLOCK)			ON Planner.TypeOfPlanner				= WarrantyType.LovId

			LEFT  JOIN  EngAssetSupplierWarranty				AS AssetSupplier			WITH(NOLOCK)			ON Planner.AssetId						= AssetSupplier.AssetId AND  AssetSupplier.Category =13

			LEFT  JOIN  MstContractorandVendor					AS ContractorandVendor		WITH(NOLOCK)			ON AssetSupplier.ContractorId			= ContractorandVendor.ContractorId

			LEFT  JOIN  EngContractOutRegisterDet				AS ContractOutRegisterDet	WITH(NOLOCK)			ON Planner.AssetId						= ContractOutRegisterDet.AssetId

			LEFT  JOIN	EngContractOutRegister					AS ContractOutRegister		WITH(NOLOCK)			ON ContractOutRegisterDet.ContractId	= ContractOutRegister.ContractId

			LEFT  JOIN	MstContractorandVendor					AS CContractorandVendor		WITH(NOLOCK)			ON ContractOutRegister.ContractorId		= CContractorandVendor.ContractorId

			LEFT  JOIN  EngAssetStandardizationModel            AS StandardizationModel     WITH(NOLOCK)			ON Asset.Model        = StandardizationModel.ModelId

			LEFT  JOIN  EngAssetStandardizationManufacturer     AS StandardizationManufacturer     WITH(NOLOCK)			ON Asset.Manufacturer               = StandardizationManufacturer.ManufacturerId

			--outer apply dbo.SplitString(Planner.Date,',') as PDate

			--outer apply dbo.SplitString(Planner.Month,',') as PMonth 

			--outer apply dbo.SplitString(Planner.Week,',') as PWeek 

			--outer apply dbo.SplitString(Planner.Day,',') as PDay 

			--LEFT JOIN FMTimeMonth	AS FMMonth		WITH(NOLOCK)			ON PMonth.Item	=	FMMonth.MonthId

			INNER JOIN  EngPlannerTxnDet						AS PlanTxnDet				WITH(NOLOCK)			ON Planner.PlannerId					= PlanTxnDet.PlannerId

	WHERE	Planner.TypeOfPlanner in (36,198,343)
GO
