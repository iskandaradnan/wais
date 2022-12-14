USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMWorkOrderReschedule_Fetch]    Script Date: 20-09-2021 16:43:00 ******/
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
EXEC [uspFM_CRMWorkOrderReschedule_Fetch] @pTypeOfRequest=134,@pFacilityId=1

SELECT * FROM EngAsset
SELECT * FROM EngMaintenanceWorkOrderTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMWorkOrderReschedule_Fetch]                           
  

  @pTypeOfRequest			INT				=	NULL,
  @pFacilityId				INT
 -- @pPageIndex				INT,
 -- @pPageSize				INT
  

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	--DECLARE @TotalRecords INT
	--DECLARE	@pTotalPage		NUMERIC(24,2)
-- Default Values


-- Execution
	--	SELECT		@TotalRecords	=	COUNT(*)
	--	FROM		EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
	--				INNER JOIN	EngAsset				AS	Asset		WITH(NOLOCK) ON	MWO.AssetId			= Asset.AssetId
	--				INNER JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK) ON	MWO.PlannerId		= Planner.PlannerId
	--	WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2 AND MWO.WorkOrderStatus = 192
	--				AND ((ISNULL(@pUserAreaId,'')='' )		OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId =  + @pUserAreaId ))
	--				AND ((ISNULL(@pUserLocationId,'')='' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId =  + @pUserLocationId ))
	--				AND ((ISNULL(@pAssigneeId,'')='' )		OR (ISNULL(@pAssigneeId,'') <> '' AND MWO.AssignedUserId =  + @pAssigneeId ))
	--				AND ((ISNULL(@pTypeOfRequest,'')='' )	OR (ISNULL(@pTypeOfRequest,'') <> '' AND Planner.TypeOfPlanner =  + @pTypeOfRequest ))
	--				AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))
	--SET @pTotalPage = CEILING(@pTotalPage)

		SELECT		CRW.CRMRequestWOId,

					CRW.CRMWorkOrderNo,
					CRW.CRMWorkOrderDateTime,
					CRR.RequestNo
					--@TotalRecords AS TotalRecords,
					--@pTotalPage as TotalPageCalc
		FROM		CRMRequestWorkOrderTxn				AS	CRW				WITH(NOLOCK)
					INNER JOIN	FMLovMst				AS	TypeOfRequest	WITH(NOLOCK) ON	CRW.TypeOfRequest	= TypeOfRequest.LovId
					INNER JOIN	CRMRequest				AS	CRR				WITH(NOLOCK) ON	CRW.CRMRequestId	= CRR.CRMRequestId
		WHERE		((ISNULL(@pTypeOfRequest,'')='' )	OR (ISNULL(@pTypeOfRequest,'') <> '' AND CRW.TypeOfRequest =   @pTypeOfRequest ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND CRW.FacilityId = @pFacilityId))
					AND CRW.AssignedUserId IS NULL
					AND CRW.Status in (139)
		ORDER BY	CRW.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
