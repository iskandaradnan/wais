USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoCompletionInfoTxn_Mobile_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoCompletionInfoTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMwoCompletionInfoTxn_mOBILE_GetById] @pAssignedUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoCompletionInfoTxn_Mobile_GetById]                           
  @pUserId			INT	=	NULL,
  @pAssignedUserId		INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(ISNULL(@pAssignedUserId,0) = 0) RETURN

	

    SELECT	MwoCompletion.CompletionInfoId						AS CompletionInfoId,
			MwoCompletion.CustomerId							AS CustomerId,
			MwoCompletion.FacilityId							AS FacilityId,
			MwoCompletion.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoCompletion.WorkOrderId							AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MaintenanceWorkOrder.TargetDateTime					AS TargetDateTime,
			MwoCompletion.RepairDetails							AS RepairDetails,
			MwoCompletion.PPMAgreedDate							AS PPMAgreedDate,
			MwoCompletion.PPMAgreedDateUTC						AS PPMAgreedDateUTC,
			MwoCompletion.StartDateTime							AS StartDateTime,
			MwoCompletion.StartDateTimeUTC						AS StartDateTimeUTC,
			MwoCompletion.EndDateTime							AS EndDateTime,
			MwoCompletion.EndDateTimeUTC						AS EndDateTimeUTC,
			MwoCompletion.HandoverDateTime						AS HandoverDateTime,
			MwoCompletion.HandoverDateTimeUTC					AS HandoverDateTimeUTC,
			MwoCompletion.CompletedBy							AS CompletedBy,
			CompletedBy.StaffName								AS CompletedByValue,
			CDesignation.Designation							AS CompletedByDesignation,
			MwoCompletion.AcceptedBy							AS AcceptedBy,
			AcceptedBy.StaffName								AS AcceptedByName,
			ADesignation.Designation							AS AcceptedByDesignation,
			MwoCompletion.[Signature]							AS [Signature],
			MwoCompletion.ServiceAvailability					AS ServiceAvailability,
			MwoCompletion.LoanerProvision						AS LoanerProvision,
			MwoCompletion.HandoverDelay							AS HandoverDelay,
			MwoCompletion.DowntimeHoursMin						AS DowntimeHoursMin,
			MwoCompletion.CauseCode								AS CauseCode,
			CauseCode.FieldValue								AS CauseCodeValue,
			MwoCompletion.QCCode								AS QCCode,
			QCCode.FieldValue									AS QCCodeValue,
			MwoCompletion.ResourceType							AS ResourceType,
			ResourceType.FieldValue								AS ResourceTypeValue,
			MwoCompletion.LabourCost							AS LabourCost,
			MwoCompletion.PartsCost								AS PartsCost,
			MwoCompletion.ContractorCost						AS ContractorCost,
			MwoCompletion.TotalCost								AS TotalCost,
			MwoCompletion.ContractorId							AS ContractorId,
			ContractorandVendor.SSMRegistrationCode				AS SSMRegistrationCode,
			ContractorandVendor.ContractorName					AS ContractorName,
			MwoCompletion.ContractorHours						AS ContractorHours,
			MwoCompletion.PartsRequired							AS PartsRequired,
			MwoCompletion.Approved								AS Approved,
			MwoCompletion.AppType								AS AppType,
			MwoCompletion.RepairHours							AS RepairHours,
			MwoCompletion.ProcessStatus							AS ProcessStatus,
			ProcessStatus.FieldValue							AS ProcessStatusValue,
			MwoCompletion.ProcessStatusDate						AS ProcessStatusDate,
			MwoCompletion.ProcessStatusReason					AS ProcessStatusReason,
			ProcessStatusReason.FieldValue						AS ProcessStatusReasonValue,
			MwoCompletion.RunningHours							AS RunningHours,
			MwoCompletionDet.CompletionInfoDetId				AS CompletionInfoDetId,
			MwoCompletionDet.CustomerId							AS CustomerId,
			MwoCompletionDet.FacilityId							AS FacilityId,
			MwoCompletionDet.ServiceId							AS ServiceId,
			MwoCompletionDet.CompletionInfoId					AS CompletionInfoId,
			MwoCompletionDet.UserId								AS StaffMasterId,
			--UserReg.StaffEmployeeId						AS StaffEmployeeId,
			UserReg.StaffName									AS StaffMasterIdValue,
			MwoCompletionDet.StandardTaskDetId					AS StandardTaskDetId,
			StandardTaskDetId.TaskCode							AS TaskCode,
			StandardTaskDetId.TaskDescription					AS TaskDescription,
			MwoCompletionDet.StartDateTime						AS StartDateTime,
			MwoCompletionDet.StartDateTimeUTC					AS StartDateTimeUTC,
			MwoCompletionDet.EndDateTime						AS EndDateTime,
			MwoCompletionDet.EndDateTimeUTC						AS EndDateTimeUTC,
			MwoCompletionDet.RepairHours						AS RepairHours,
			MwoCompletion.Timestamp								AS Timestamp
	FROM	EngMwoCompletionInfoTxn								AS MwoCompletion
			INNER JOIN	EngMwoCompletionInfoTxnDet				AS MwoCompletionDet					WITH(NOLOCK)			on MwoCompletion.CompletionInfoId		= MwoCompletionDet.CompletionInfoId
			LEFT  JOIN  UMUserRegistration						AS UserReg							WITH(NOLOCK)			on MwoCompletionDet.UserId				= UserReg.UserRegistrationId
			LEFT  JOIN  EngAssetTypeCodeStandardTasksDet		AS StandardTaskDetId				WITH(NOLOCK)			on MwoCompletionDet.StandardTaskDetId	= StandardTaskDetId.StandardTaskDetId
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoCompletion.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoCompletion.ServiceId				= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS CompletedBy						WITH(NOLOCK)			on MwoCompletion.CompletedBy			= CompletedBy.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS AcceptedBy						WITH(NOLOCK)			on MwoCompletion.AcceptedBy				= AcceptedBy.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS CDesignation						WITH(NOLOCK)			on CompletedBy.UserDesignationId		= CDesignation.UserDesignationId
			LEFT  JOIN  UserDesignation							AS ADesignation						WITH(NOLOCK)			on AcceptedBy.UserDesignationId			= ADesignation.UserDesignationId
			LEFT  JOIN  MstContractorandVendor					AS ContractorandVendor				WITH(NOLOCK)			on MwoCompletion.ContractorId			= ContractorandVendor.ContractorId
			LEFT  JOIN  FMLovMst								AS CauseCode						WITH(NOLOCK)			on MwoCompletion.CauseCode				= CauseCode.LovId
			LEFT  JOIN  FMLovMst								AS QCCode							WITH(NOLOCK)			on MwoCompletion.QCCode					= QCCode.LovId
			LEFT  JOIN  FMLovMst								AS ResourceType						WITH(NOLOCK)			on MwoCompletion.ResourceType			= ResourceType.LovId
			LEFT  JOIN  FMLovMst								AS ProcessStatus					WITH(NOLOCK)			on MwoCompletion.ProcessStatus			= ProcessStatus.LovId
			LEFT  JOIN  FMLovMst								AS ProcessStatusReason				WITH(NOLOCK)			on MwoCompletion.ProcessStatusReason	= ProcessStatusReason.LovId
	WHERE	MaintenanceWorkOrder.AssignedUserId = @pAssignedUserId 
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
		   );
		THROW;

END CATCH
GO
