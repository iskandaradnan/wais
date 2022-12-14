USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_UnScheduled_Print]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMaintenanceWorkOrderTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMaintenanceWorkOrderTxn_unScheduled_Print] @pWorkOrderId=6132
SELECT * FROM EngMaintenanceWorkOrderTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_UnScheduled_Print]   
                        

  @pWorkOrderId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

    SELECT	MaintenanceWorkOrder.WorkOrderId					AS WorkOrderId,
			Facility.FacilityCode								AS FacilityCode,
			Facility.FacilityName								AS FacilityName,
			WorkOrderPriority.FieldValue						AS [Priority],
			MaintenanceWorkOrder.MaintenanceWorkNo				AS [WorkOrderNumber],
			WorkCategory.FieldValue								AS Category,
			WorkType.FieldValue									AS [Type],
			REPLACE(CONVERT(VARCHAR,MaintenanceWorkOrder.MaintenanceWorkDateTime,106),' ','-')		AS WorkOrderDate,
			RequestorStaffId.StaffName							AS [RequestorName],
			RequestorDesignation.Designation					AS Designation,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			UserLocationId.UserLocationCode						AS AssetLocationCode,
			UserLocationId.UserLocationName						AS AssetLocationName,
			AssetTypeCodeId.AssetTypeCode						AS TypeCode,
			UserAreaId.UserAreaCode								AS UserAreaCode,
			UserAreaId.UserAreaName								AS UserAreaName,
			VariationStatus.FieldValue							AS VariationStatus,
			Manuf.Manufacturer									AS Manufacturer,
			Model.Model											AS Model,
			MaintenanceWorkOrder.MaintenanceDetails				AS BreakDownDetails,
			Contractor.ContractorName							AS ContractorName,
			Contractor.ContractorCode							AS ContractorCode,
			Contractor.ContactPerson							AS ContactPerson,
			Contractor.PhoneNo									AS PhoneNo,
			ContractorStartDate			AS StartDate,
			ContractorEndDate			AS  EndDate,	
			REPLACE(CONVERT(VARCHAR,MWOA.ResponseDateTime,106),' ','-')			AS AssesmentResponseDate,
			(select top 1 StaffName from UMUserRegistration  u where u.UserRegistrationId  =  MaintenanceWorkOrder.AssignedUserId ) as  AssesmentResponseBy,
			(select top 1 StaffName from UMUserRegistration  u where u.UserRegistrationId  =  MWOC.AcceptedBy ) as  AssesmentVerifiedBy,
			REPLACE(CONVERT(VARCHAR,MWOC.HandoverDateTime,106),' ','-')			AS AssesmentVerifiedDateTime,
			(select top 1 FieldValue from FMLovMst  u where u.lovid  =  MWOA.AssetRealtimeStatus ) as  RealtimeStatus ,
			MWOC.StartDateTime  as CompletionInfoStartDateTime,
			MWOC.EndDateTime	as CompletionInfoEndDateTime,
			(select top 1 t.StaffName from UMUserRegistration t  where UserRegistrationId=MWOC.CompletedBy) as CompletionInfoCompletedBy ,
			(select top 1 t.StaffName from UMUserRegistration t where UserRegistrationId= MWOC.AcceptedBy) as CompletionInfoVerifiedBy,
			(select fieldvalue from fmlovmst where lovid=MWOC.QCCode) as SymptomCode,
			MWOC.RepairDetails	AS ActionTaken
	FROM	EngMaintenanceWorkOrderTxn							AS MaintenanceWorkOrder				WITH(NOLOCK)			
			INNER JOIN  MstLocationFacility						AS Facility							WITH(NOLOCK)			on MaintenanceWorkOrder.FacilityId				= Facility.FacilityId
			INNER JOIN  EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId					= Asset.AssetId
			LEFT JOIN	EngAssetStandardizationManufacturer		AS Manuf							WITH(NOLOCK)			on Asset.Manufacturer							= Manuf.ManufacturerId
			LEFT JOIN	EngAssetStandardizationModel			AS Model							WITH(NOLOCK)			on Asset.Model									= Model.ModelId
			LEFT  JOIN  UMUserRegistration						AS RequestorStaffId					WITH(NOLOCK)			on MaintenanceWorkOrder.RequestorUserId			= RequestorStaffId.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS RequestorDesignation				WITH(NOLOCK)			on RequestorStaffId.UserDesignationId			= RequestorDesignation.UserDesignationId
			LEFT  JOIN  MstLocationUserLocation					AS UserLocationId					WITH(NOLOCK)			on Asset.UserLocationId							= UserLocationId.UserLocationId
			LEFT  JOIN  MstLocationUserArea						AS UserAreaId						WITH(NOLOCK)			on UserLocationId.UserAreaId					= UserAreaId.UserAreaId
			LEFT  JOIN  EngAssetTypeCode						AS AssetTypeCodeId					WITH(NOLOCK)			on Asset.AssetTypeCodeId						= AssetTypeCodeId.AssetTypeCodeId
			LEFT  JOIN  FMLovMst								AS WorkCategory						WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory	= WorkCategory.LovId
			LEFT  JOIN  FMLovMst								AS WorkType							WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkType		= WorkType.LovId
			LEFT  JOIN  FMLovMst								AS TypeOfWorkOrder					WITH(NOLOCK)			on MaintenanceWorkOrder.TypeOfWorkOrder			= TypeOfWorkOrder.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderPriority				WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderPriority		= WorkOrderPriority.LovId
			OUTER APPLY (select top 1   VariationStatus from 	VmVariationTxn AS VmVar1			WITH(NOLOCK)			where Asset.AssetId								= VmVar1.AssetId
			order by VariationId desc) VmVar
			LEFT  JOIN  FMLovMst								AS VariationStatus					WITH(NOLOCK)			on Vmvar.VariationStatus						= VariationStatus.LovId
			left join EngMwoAssesmentTxn						AS MWOA								WITH(NOLOCK)			on MWOA.WorkOrderId	= MaintenanceWorkOrder.WorkOrderId
			left join EngMwoCompletionInfoTxn						AS MWOC								WITH(NOLOCK)			on MWOC.WorkOrderId	= MaintenanceWorkOrder.WorkOrderId

			outer apply (select top 1
			ContractOutReg.ContractNo as ContractorCode,
			MstContractor.ContractorName,
			info.Name as ContactPerson,
			info.ContactNo as PhoneNo,
			REPLACE(CONVERT(VARCHAR,ContractOutReg.ContractStartDate,106),' ','-')		AS ContractorStartDate,
			REPLACE(CONVERT(VARCHAR,ContractOutReg.ContractEndDate,106),' ','-')			AS ContractorEndDate		
			
			from 	EngContractOutRegisterDet		AS 	ContractOutRegDet	WITH(NOLOCK)
			INNER JOIN	EngContractOutRegister			AS 	ContractOutReg		WITH(NOLOCK)	ON ContractOutRegDet.ContractId		= ContractOutReg.ContractId
			INNER JOIN  MstContractorandVendor			AS	MstContractor		WITH(NOLOCK)	ON ContractOutReg.ContractorId		= MstContractor.ContractorId
			outer apply (select top 1 Name,ContactNo from MstContractorandVendorContactInfo AS	VendorContact	where ContractOutReg.ContractorId		= MstContractor.ContractorId) info
			where  Asset.AssetId					= ContractOutRegDet.AssetId)  Contractor			


	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId AND MaintenanceWorkOrder.MaintenanceWorkCategory = 188
	ORDER BY MaintenanceWorkOrder.ModifiedDate ASC




END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
