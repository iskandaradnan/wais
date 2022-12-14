USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Rescheduling_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoAssesmentTxn_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_Rescheduling_GetById] @pWorkOrderId=132

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_Rescheduling_GetById]                           

  @pWorkOrderId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN


		SELECT		MWO.WorkOrderId,
					UserArea.UserAreaName,
					UserLocation.UserLocationName,
					Planner.TypeOfPlanner,
					MWO.AssignedUserId,
					UserReg.StaffName	AS Assignee,
					RescheduleRemarks as Reason
		FROM		EngMaintenanceWorkOrderTxn				AS	MWO				WITH(NOLOCK)
					INNER JOIN	EngAsset					AS	Asset			WITH(NOLOCK) ON	MWO.AssetId				= Asset.AssetId
					LEFT JOIN	EngPlannerTxn				AS	Planner			WITH(NOLOCK) ON	MWO.PlannerId			= Planner.PlannerId
					INNER JOIN	MstLocationUserLocation		AS	UserLocation	WITH(NOLOCK) ON	Asset.UserLocationId	= UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea			AS	UserArea		WITH(NOLOCK) ON	Asset.UserAreaId		= UserArea.UserAreaId
					INNER JOIN	UMUserRegistration			AS	UserReg			WITH(NOLOCK) ON	MWO.AssignedUserId		= UserReg.UserRegistrationId
		WHERE	MWO.WorkOrderId = @pWorkOrderId

		SELECT		MWO.WorkOrderId,
					MWO.AssetId,
					Asset.AssetNo,
					MWO.MaintenanceWorkNo,
					--MWO.PreviousTargetDateTime AS ScheduledDate,
					MWO.TargetDateTime AS ScheduledDate,
					MWO.TargetDateTime AS ReScheduledDate,
					MWO.AssigneeLovId,
					UserReg.StaffName AS Assignee
		FROM		EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
					INNER JOIN	EngAsset				AS	Asset		WITH(NOLOCK) ON	MWO.AssetId			= Asset.AssetId
					LEFT JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK) ON	MWO.PlannerId		= Planner.PlannerId
					INNER JOIN	UMUserRegistration		AS	UserReg		WITH(NOLOCK) ON	MWO.AssignedUserId	= UserReg.UserRegistrationId
	WHERE	MWO.WorkOrderId = @pWorkOrderId
	ORDER BY MWO.ModifiedDate ASC


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
