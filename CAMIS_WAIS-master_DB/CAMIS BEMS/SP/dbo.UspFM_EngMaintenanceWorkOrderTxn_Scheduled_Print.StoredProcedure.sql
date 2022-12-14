USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Scheduled_Print]    Script Date: 20-09-2021 17:05:51 ******/
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
EXEC [UspFM_EngMaintenanceWorkOrderTxn_Scheduled_Print] @pWorkOrderId=170

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Scheduled_Print]   
                        

  @pWorkOrderId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

    SELECT 	MaintenanceWorkOrder.WorkOrderId					AS WorkOrderId,
			Facility.FacilityCode								AS FacilityCode,
			Facility.FacilityName								AS FacilityName,
			WorkOrderPriority.FieldValue						AS [Priority],
			MaintenanceWorkOrder.MaintenanceWorkNo				AS [WorkOrderNumber],
			WorkCategory.FieldValue								AS Category,
			WorkType.FieldValue									AS [Type],
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS	WorkOrderDate,
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
			MaintenanceWorkOrder.MaintenanceDetails				AS MaintenanceDetails,
			Contractor.ContractorName							AS ContractorName,
			Contractor.ContractorCode							AS ContractorCode,
			Contractor.ContactPerson							AS ContactPerson,
			Contractor.PhoneNo									AS PhoneNo,
			ContractorStartDate			AS StartDate,
			ContractorEndDate			AS  EndDate,
			compinfo.StartDateTime  as CompletionInfoStartDateTime,
			compinfo.EndDateTime	as CompletionInfoEndDateTime,
			(select top 1 t.StaffName from UMUserRegistration t  where UserRegistrationId=compinfo.CompletedBy) as CompletedBy ,
			(select top 1 t.StaffName from UMUserRegistration t where UserRegistrationId= compinfo.AcceptedBy) as VerifiedBy,
			(select fieldvalue from fmlovmst where lovid=compinfo.QCCode) as SymptomCode,
			compinfo.RepairDetails		AS ActionTaken
	FROM	EngMaintenanceWorkOrderTxn							AS MaintenanceWorkOrder				WITH(NOLOCK)
			outer apply(select top  1	a.CompletionInfoId,CompletedBy,AcceptedBy,QCCode,min(b.StartDateTime) as StartDateTime,max(b.EndDateTime) as EndDateTime,RepairDetails from EngMwoCompletionInfoTxn a join  
			EngMwoCompletionInfoTxndet b  on a.CompletionInfoId = b.CompletionInfoId
			where a.WorkOrderId =  MaintenanceWorkOrder.WorkOrderId 
			group by a.CompletionInfoId,CompletedBy,AcceptedBy,QCCode,RepairDetails) compinfo
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
			outer apply	(select top 1 VariationStatus from  VmVariationTxn							AS VmVar1							WITH(NOLOCK)			where Asset.AssetId								= VmVar1.AssetId order by VariationId desc) Vmvar
			LEFT  JOIN  FMLovMst								AS VariationStatus					WITH(NOLOCK)			on Vmvar.VariationStatus						= VariationStatus.LovId
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

			--OUTER APPLY (SELECT DISTINCT TOP 1 ContractorId,AssetId,ContractorName,SSMRegistrationCode as ContractorCode,Name as ContactPerson,ContactNo as PhoneNo,
			--ContractStartDate as StartDate,ContractEndDate as EndDate
			--  from
			--			(SELECT COR.ContractorId,CORDet.AssetId,CORV.ContractorName,CORV.SSMRegistrationCode,CORVDet.Name,CORVDet.ContactNo,COR.ContractStartDate,COR.ContractEndDate
			--			,RANK() over(Partition by CORDet.AssetId order by COR.ContractEndDate desc ) as RowValue
			--			from EngContractOutRegister COR
			--			inner join  MstContractorandVendor CORV on CORV.ContractorId=COR.ContractorId
			--			inner join  MstContractorandVendorContactInfo CORVDet on CORVDet.ContractorId=CORV.ContractorId
			--			inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId 
						
			--			WHERE CORDet.AssetId=Asset.AssetId and cor.ContractEndDate>GETDATE()
			--			)a where RowValue =1  ) Contractor

	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId AND MaintenanceWorkOrder.MaintenanceWorkCategory = 187
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
