USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPMLoadBalancing_Test]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PPMLoadBalancing_Test
Description			: Get the Work orders for PPMLoadBalancing
Authors				: Dhilip V
Date				: 30-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_PPMLoadBalancing_Test  @pStaffMasterId=1,@pAssetClassificationId=NULL,@pUserAreaId=NULL,@pUserLocationId=NULL,@pYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_PPMLoadBalancing_Test]                           
		
		@pStaffMasterId			INT,
		@pAssetClassificationId INT	=	NULL,
		@pUserAreaId			INT	=	NULL,
		@pUserLocationId		INT	=	NULL,
		@pYear					INT	=	NULL

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


	IF(ISNULL(@pStaffMasterId,0) = 0) RETURN



		SELECT	@TotalRecords=COUNT(*)
		FROM	EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
				INNER JOIN	MstCustomer				AS	Customer	WITH(NOLOCK)	ON	MWO.CustomerId		=	Customer.CustomerId
				INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK)	ON	MWO.FacilityId		=	Facility.FacilityId
				INNER JOIN	UMUserRegistration		AS	Staff		WITH(NOLOCK)	ON	MWO.EngineerUserId	=	Staff.UserRegistrationId
				INNER JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK)	ON	MWO.PlannerId		=	Planner.PlannerId
		WHERE	((ISNULL(@pYear,'') = '' )	OR (ISNULL(@pYear,'') <> '' AND YEAR(MWO.TargetDateTime) =  @pYear ))
				AND ((ISNULL(@pStaffMasterId,'') = '' )	OR (ISNULL(@pStaffMasterId,'') <> '' AND MWO.EngineerUserId =  @pStaffMasterId ))
				AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND Planner.AssetClassificationId =  @pAssetClassificationId ))
				AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND Planner.UserAreaId =  @pUserAreaId ))
				AND ((ISNULL(@pUserLocationId,'') = '' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Planner.UserAreaId =  @pUserLocationId ))


		SET @AvgRecords = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(12 AS NUMERIC(24,2))



		SELECT	@TotalRecords	AS TotalRecordsPerYear,
				@AvgRecords		AS AvgRecordsPerMonth


		SELECT	DATENAME(MONTH , DATEADD( MONTH , MONTH(TargetDateTime) , 0 ) - 1 )  Month, 
				SUM( CASE WHEN (DATEPART(DAY, DATEDIFF(DAY, 0, TargetDateTime)/7 * 7)/7 + 1 )=1 THEN 1 ELSE 0 END ) AS Week1,
				SUM( CASE WHEN (DATEPART(DAY, DATEDIFF(DAY, 0, TargetDateTime)/7 * 7)/7 + 1 )=2 THEN 1 ELSE 0 END ) AS Week2,
				SUM( CASE WHEN (DATEPART(DAY, DATEDIFF(DAY, 0, TargetDateTime)/7 * 7)/7 + 1 )=3 THEN 1 ELSE 0 END ) AS Week3,
				SUM( CASE WHEN (DATEPART(DAY, DATEDIFF(DAY, 0, TargetDateTime)/7 * 7)/7 + 1 )=4 THEN 1 ELSE 0 END ) AS Week4,
				SUM( CASE WHEN (DATEPART(DAY, DATEDIFF(DAY, 0, TargetDateTime)/7 * 7)/7 + 1 )=5 THEN 1 ELSE 0 END ) AS Week5
		FROM	EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)
				INNER JOIN	MstCustomer				AS	Customer	WITH(NOLOCK)	ON	MWO.CustomerId		=	Customer.CustomerId
				INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK)	ON	MWO.FacilityId		=	Facility.FacilityId
				INNER JOIN	UMUserRegistration		AS	Staff		WITH(NOLOCK)	ON	MWO.EngineerUserId	=	Staff.UserRegistrationId
				INNER JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK)	ON	MWO.PlannerId		=	Planner.PlannerId
		WHERE	((ISNULL(@pYear,'') = '' )	OR (ISNULL(@pYear,'') <> '' AND YEAR(MWO.TargetDateTime) =  @pYear ))
				AND ((ISNULL(@pStaffMasterId,'') = '' )	OR (ISNULL(@pStaffMasterId,'') <> '' AND MWO.EngineerUserId =  @pStaffMasterId ))
				AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND Planner.AssetClassificationId =  @pAssetClassificationId ))
				AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND Planner.UserAreaId =  @pUserAreaId ))
				AND ((ISNULL(@pUserLocationId,'') = '' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Planner.UserAreaId =  @pUserLocationId ))
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
