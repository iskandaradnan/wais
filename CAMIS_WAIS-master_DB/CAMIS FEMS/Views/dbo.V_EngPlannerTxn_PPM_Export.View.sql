USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngPlannerTxn_PPM_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngPlannerTxn_PPM_Export]
AS
    SELECT	DISTINCT
			Planner.PlannerId									AS PlannerId,
			Planner.CustomerId									AS CustomerId,
			Planner.FacilityId									AS FacilityId,
			Planner.ServiceId									AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,

			WorkOrderType.FieldValue							AS WorkOrderTypeName,
			Planner.[Year]										AS [Year],
			CompanyStaff.StaffName								AS Assignee,
			AssetClassification.AssetClassificationDescription	AS AssetClassificationDescription,
			WarrantyType.FieldValue								AS WarrantyTypeName,
			AssetTypeCode.AssetTypeCode							AS AssetTypeCode,
			AssetTypeCode.AssetTypeDescription					AS AssetTypeDescription,
			Asset.AssetNo										AS AssetNo,
			Model.Model,
			Manufacturer.Manufacturer,
			Asset.SerialNo,
			PPMCheckList.TaskCode								AS [TaskCode],
			PPMCheckList.TaskDescription						AS PPMTaskDescription,
			Asset.WarrantyEndDate								AS WarrantyEndDate,
			ContractorandVendor.ContractorName					AS SupplierName,
			ContactInfo.ContactNo as ContactNumber,
			Planner.ScheduleType								AS ScheduleTypeLovId,
			ScheduleType.FieldValue								AS ScheduleType,
			Planner.Status										AS StatusLovId,
			PlannerStatus.FieldValue							AS Status,
			PlannerStatus.FieldValue							AS StatusGrid,
			FORMAT(PlanTxnDet.PlannerDate,'dd-MMM-yyyy')		AS	PlannerDate,
			--FacilityStaff.StaffName								AS FacilityRepresentative,
			--EngineerStaff.StaffName								AS Engineer,
			--FMMonth.Month										AS Month,
			--PDate.Item											AS Date,
			--PWeek.Item											AS Week,
			--PDay.Item										AS Day,
			--Planner.Day										AS Day			
			Planner.ModifiedDateUTC,
			generationtype.FieldValue as  TaskCodeOptionValue 
	FROM	EngPlannerTxn										AS Planner					WITH(NOLOCK)
			INNER JOIN  MstService								AS ServiceKey				WITH(NOLOCK)			ON Planner.ServiceId					= ServiceKey.ServiceId
			
			LEFT  JOIN  MstLocationUserArea						AS LocationUserArea			WITH(NOLOCK)			ON Planner.UserAreaId					= LocationUserArea.UserAreaId	
			LEFT  JOIN  UMUserRegistration						AS CompanyStaff				WITH(NOLOCK)			ON Planner.AssigneeCompanyUserId		= CompanyStaff.UserRegistrationId	
			LEFT  JOIN  UMUserRegistration						AS FacilityStaff			WITH(NOLOCK)			ON Planner.FacilityUserId				= FacilityStaff.UserRegistrationId	
			LEFT  JOIN  UMUserRegistration						AS EngineerStaff			WITH(NOLOCK)			ON Planner.EngineerUserId				= EngineerStaff.UserRegistrationId	
			LEFT JOIN  EngAssetClassification					AS AssetClassification		WITH(NOLOCK)			ON Planner.AssetClassificationId		= AssetClassification.AssetClassificationId
			LEFT  JOIN  EngAssetTypeCode						AS AssetTypeCode			WITH(NOLOCK)			on Planner.AssetTypeCodeId				= AssetTypeCode.AssetTypeCodeId
			LEFT  JOIN  EngAsset								AS Asset					WITH(NOLOCK)			ON Planner.AssetId						= Asset.AssetId
			LEFT  JOIN  EngAssetPPMCheckList					AS PPMCheckList				WITH(NOLOCK)			ON Planner.StandardTaskDetId			= PPMCheckList.PPMCheckListId
			LEFT  JOIN  FMLovMst								AS ScheduleType				WITH(NOLOCK)			ON Planner.ScheduleType					= ScheduleType.LovId
			LEFT  JOIN  FMLovMst								AS PlannerStatus			WITH(NOLOCK)			ON Planner.Status						= PlannerStatus.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderType			WITH(NOLOCK)			ON Planner.WorkOrderType				= WorkOrderType.LovId
			LEFT  JOIN  FMLovMst								AS WarrantyType				WITH(NOLOCK)			ON Planner.WarrantyType					= WarrantyType.LovId
			LEFT  JOIN  EngAssetSupplierWarranty				AS AssetSupplier			WITH(NOLOCK)			ON Planner.AssetId						= AssetSupplier.AssetId AND  AssetSupplier.Category =13
			LEFT  JOIN  MstContractorandVendor					AS ContractorandVendor		WITH(NOLOCK)			ON AssetSupplier.ContractorId			= ContractorandVendor.ContractorId
			OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
						FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
						WHERE ContractorandVendor.ContractorId	=	ContractorDet.ContractorId) AS ContactInfo
			LEFT  JOIN  EngContractOutRegisterDet				AS ContractOutRegisterDet	WITH(NOLOCK)			ON Planner.AssetId						= ContractOutRegisterDet.AssetId
			LEFT  JOIN	EngContractOutRegister					AS ContractOutRegister		WITH(NOLOCK)			ON ContractOutRegisterDet.ContractId	= ContractOutRegister.ContractId
			LEFT  JOIN	MstContractorandVendor					AS CContractorandVendor		WITH(NOLOCK)			ON ContractOutRegister.ContractorId		= CContractorandVendor.ContractorId
			LEFT  JOIN	EngAssetStandardizationModel			AS Model					WITH(NOLOCK)			ON Asset.Model							= Model.ModelId
			LEFT  JOIN	EngAssetStandardizationManufacturer		AS Manufacturer				WITH(NOLOCK)			ON Asset.Manufacturer					= Manufacturer.ManufacturerId
			--outer apply dbo.SplitString(Planner.Date,',') as PDate
			--outer apply dbo.SplitString(Planner.Month,',') as PMonth 
			--outer apply dbo.SplitString(Planner.Week,',') as PWeek 
			--outer apply dbo.SplitString(Planner.Day,',') as PDay 
			--LEFT JOIN FMTimeMonth	AS FMMonth		WITH(NOLOCK)			ON PMonth.Item	=	FMMonth.MonthId
			INNER JOIN  EngPlannerTxnDet						AS PlanTxnDet				WITH(NOLOCK)			ON Planner.PlannerId					= PlanTxnDet.PlannerId
			LEFT JOIN FMLovMst							AS	generationtype		WITH(NOLOCK)	ON Planner.generationtype		=	generationtype.LovId
	WHERE	Planner.TypeOfPlanner = 34
GO
