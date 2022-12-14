USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPMLoadBalancing_GetAll]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PPMLoadBalancing_GetAll
Description			: Get the Work orders for PPMLoadBalancing
Authors				: Dhilip V
Date				: 30-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_PPMLoadBalancing_GetAll  @pStaffMasterId=null,@pAssetClassificationId=NULL,@pUserAreaId=NULL,@pUserLocationId=NULL,@pYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_PPMLoadBalancing_GetAll]                           
		
		@pStaffMasterId			INT	=	NULL,
		@pAssetClassificationId INT	=	NULL,
		@pUserAreaId			INT	=	NULL,
		@pUserLocationId		INT	=	NULL,
		@pYear					INT	=	NULL,
		@pFacilityId			INT =	NULL

AS                                               

BEGIN TRY

-- Paramter Validation 
				
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE	@TotalRecords	INT
	DECLARE	@AvgRecords		NUMERIC(24,2)

-- Default Values


-- Execution




		SELECT	@TotalRecords=COUNT(*)
		FROM	EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
				INNER JOIN	MstCustomer				AS	Customer	WITH(NOLOCK)	ON	MWO.CustomerId		=	Customer.CustomerId
				INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK)	ON	MWO.FacilityId		=	Facility.FacilityId
				INNER JOIN	EngAsset				AS	Asset			WITH(NOLOCK)	ON	MWO.AssetId				=	Asset.AssetId
				INNER JOIN	UMUserRegistration		AS	Staff		WITH(NOLOCK)	ON	MWO.EngineerUserId	=	Staff.UserRegistrationId
				INNER JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK)	ON	MWO.PlannerId		=	Planner.PlannerId
				
		WHERE	((ISNULL(@pYear,'') = '' )	OR (ISNULL(@pYear,'') <> '' AND YEAR(MWO.TargetDateTime) =  @pYear ))
				AND ((ISNULL(@pStaffMasterId,'') = '' )	OR (ISNULL(@pStaffMasterId,'') <> '' AND ( MWO.EngineerUserId =  @pStaffMasterId OR  MWO.AssignedUserId =  @pStaffMasterId ) ))
				AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =  @pAssetClassificationId ))
				AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId =  @pUserAreaId ))
				AND ((ISNULL(@pUserLocationId,'') = '' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId =  @pUserLocationId ))
				AND MWO.MaintenanceWorkCategory = 187 AND MWO.WorkOrderStatus IN (192)
				AND MWO.FacilityId = @pFacilityId

		SET @AvgRecords = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(12 AS NUMERIC(24,2))



		SELECT	ISNULL(@TotalRecords,0)		AS TotalRecordsPerYear,
				ISNULL(@AvgRecords,0)		AS AvgRecordsPerMonth


		SELECT	LEFT(DATENAME(MONTH , DATEADD( MONTH , MONTH(TargetDateTime) , 0 ) - 1 ),3)  Month, 
				SUM( CASE WHEN (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1)=1 THEN 1 ELSE 0 END ) AS Week1,
				SUM( CASE WHEN (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1)=2 THEN 1 ELSE 0 END ) AS Week2,
				SUM( CASE WHEN (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1)=3 THEN 1 ELSE 0 END ) AS Week3,
				SUM( CASE WHEN (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1)=4 THEN 1 ELSE 0 END ) AS Week4,
				SUM( CASE WHEN (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1)=5 THEN 1 ELSE 0 END ) AS Week5
		FROM	EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
				INNER JOIN	MstCustomer				AS	Customer	WITH(NOLOCK)	ON	MWO.CustomerId		=	Customer.CustomerId
				INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK)	ON	MWO.FacilityId		=	Facility.FacilityId
				INNER JOIN	EngAsset				AS	Asset			WITH(NOLOCK)	ON	MWO.AssetId				=	Asset.AssetId
				INNER JOIN	UMUserRegistration		AS	Staff		WITH(NOLOCK)	ON	MWO.EngineerUserId	=	Staff.UserRegistrationId
				INNER JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK)	ON	MWO.PlannerId		=	Planner.PlannerId
		WHERE	((ISNULL(@pYear,'') = '' )	OR (ISNULL(@pYear,'') <> '' AND YEAR(MWO.TargetDateTime) =  @pYear ))
				AND ((ISNULL(@pStaffMasterId,'') = '' )	OR (ISNULL(@pStaffMasterId,'') <> '' AND ( MWO.EngineerUserId =  @pStaffMasterId OR  MWO.AssignedUserId =  @pStaffMasterId ) ))
				AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =  @pAssetClassificationId ))
				AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId =  @pUserAreaId ))
				AND ((ISNULL(@pUserLocationId,'') = '' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId =  @pUserLocationId ))
				AND MWO.MaintenanceWorkCategory = 187 AND MWO.WorkOrderStatus IN (192)
				AND MWO.FacilityId = @pFacilityId
		GROUP BY  MONTH(TargetDateTime) 


	--ORDER BY MWO.TargetDateTime  DESC
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
