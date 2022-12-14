USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WorkOrderReschedule_Fetch]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_WorkOrderReschedule_Fetch]
Description			: Work order fetch control for rescheduling
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_WorkOrderReschedule_Fetch] @pUserAreaId=null,@pUserLocationId=null,@pAssigneeId=1, @pTypeOfPlanner='',@pFacilityId=1,@pPageIndex=1,@pPageSize=5

SELECT * FROM EngAsset
SELECT * FROM EngMaintenanceWorkOrderTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WorkOrderReschedule_Fetch]                           
  
  @pUserAreaId				NVARCHAR(100)	=	NULL,
  @pUserLocationId			INT				=	NULL,
  @pAssigneeId				INT				=	NULL,
  @pTypeOfPlanner			INT				=	NULL,
  @pFacilityId				INT,
  @pPageIndex				INT,
  @pPageSize				INT
  

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)
-- Default Values


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
					INNER JOIN	EngAsset				AS	Asset		WITH(NOLOCK) ON	MWO.AssetId			= Asset.AssetId
					LEFT JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK) ON	MWO.PlannerId		= Planner.PlannerId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2 AND MWO.WorkOrderStatus in ( 192 , 385) AND MWO.MaintenanceWorkCategory=187
					AND ((ISNULL(@pUserAreaId,'')='' )		OR (ISNULL(@pUserAreaId,'') <> '' AND ISNULL(Asset.UserAreaId,0) =  + @pUserAreaId ))
					AND ((ISNULL(@pUserLocationId,'')='' )	OR (ISNULL(@pUserLocationId,'') <> '' AND ISNULL(Asset.UserLocationId,0) =  + @pUserLocationId ))
					AND ((ISNULL(@pAssigneeId,'')='' )		OR (ISNULL(@pAssigneeId,'') <> '' AND ISNULL(MWO.AssignedUserId,0) =  + @pAssigneeId ))
					AND ((ISNULL(@pTypeOfPlanner,'')='' )	OR (ISNULL(@pTypeOfPlanner,'') <> '' AND Planner.TypeOfPlanner =  + @pTypeOfPlanner ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))
	SET @pTotalPage = CEILING(@pTotalPage)

		SELECT		MWO.WorkOrderId,
					MWO.AssetId,
					Asset.AssetNo,
					MWO.MaintenanceWorkNo,
					MWO.TargetDateTime,
					@TotalRecords AS TotalRecords,
					@pTotalPage as TotalPageCalc
		FROM		EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
					INNER JOIN	EngAsset				AS	Asset		WITH(NOLOCK) ON	MWO.AssetId			= Asset.AssetId
					LEFT JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK) ON	MWO.PlannerId		= Planner.PlannerId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2 AND MWO.WorkOrderStatus  in ( 192 , 385)  AND MWO.MaintenanceWorkCategory=187
					AND ((ISNULL(@pUserAreaId,'')='' )		OR (ISNULL(@pUserAreaId,'') <> '' AND ISNULL(Asset.UserAreaId,0) =  + @pUserAreaId ))
					AND ((ISNULL(@pUserLocationId,'')='' )	OR (ISNULL(@pUserLocationId,'') <> '' AND ISNULL(Asset.UserLocationId,0) =  + @pUserLocationId ))
					AND ((ISNULL(@pAssigneeId,'')='' )		OR (ISNULL(@pAssigneeId,'') <> '' AND ISNULL(MWO.AssignedUserId,0) =  + @pAssigneeId ))
					AND ((ISNULL(@pTypeOfPlanner,'')='' )	OR (ISNULL(@pTypeOfPlanner,'') <> '' AND Planner.TypeOfPlanner =  + @pTypeOfPlanner ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
		ORDER BY	MWO.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
