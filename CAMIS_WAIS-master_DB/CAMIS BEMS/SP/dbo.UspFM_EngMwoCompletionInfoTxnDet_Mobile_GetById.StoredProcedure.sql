USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoCompletionInfoTxnDet_Mobile_GetById]    Script Date: 20-09-2021 17:05:51 ******/
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
EXEC [UspFM_EngMwoCompletionInfoTxnDet_Mobile_GetById] @pWorkOrderId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoCompletionInfoTxnDet_Mobile_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

	

    SELECT	MwoCompletionDet.CompletionInfoDetId				AS CompletionInfoDetId,
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
			MwoCompletionDet.Timestamp							AS Timestamp
	FROM	EngMwoCompletionInfoTxn								AS MwoCompletion
			INNER JOIN	EngMwoCompletionInfoTxnDet				AS MwoCompletionDet					WITH(NOLOCK)			on MwoCompletion.CompletionInfoId		= MwoCompletionDet.CompletionInfoId
			LEFT  JOIN  UMUserRegistration						AS UserReg							WITH(NOLOCK)			on MwoCompletionDet.UserId				= UserReg.UserRegistrationId
			LEFT  JOIN  EngAssetTypeCodeStandardTasksDet		AS StandardTaskDetId				WITH(NOLOCK)			on MwoCompletionDet.StandardTaskDetId	= StandardTaskDetId.StandardTaskDetId
	WHERE	MwoCompletion.WorkOrderId = @pWorkOrderId 
	ORDER BY MwoCompletionDet.ModifiedDate ASC
	
	declare @lFacilityId int

	select @lFacilityId=FacilityId from EngMwoCompletionInfoTxn where WorkOrderId = @pWorkOrderId 
	EXEC UspFM_UMUserRegistration_Mobile_GetAllUser @pFacilityId= @lFacilityId 
	EXEC UspFM_QCCodeandCauseCodeLoad_Mobile_GetbyId


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
