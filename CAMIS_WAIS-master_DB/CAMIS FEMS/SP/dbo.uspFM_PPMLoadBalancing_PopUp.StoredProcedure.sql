USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPMLoadBalancing_PopUp]    Script Date: 24-01-2022 13:34:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_PPMLoadBalancing_PopUp

Description			: Get the Work orders for PPMLoadBalancing

Authors				: Dhilip V

Date				: 30-April-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

EXEC uspFM_PPMLoadBalancing_PopUp  @pStaffMasterId=NULL,@pAssetClassificationId=NULL,@pUserAreaId=NULL,@pUserLocationId=NULL,@pMonth=null,@pYear=2018

,@pWeek=NULL,@pFacilityId=1,@pPageIndex=1,@pPageSize=5000



-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/

DROP PROCEDURE  [dbo].[uspFM_PPMLoadBalancing_PopUp]   
GO
CREATE PROCEDURE  [dbo].[uspFM_PPMLoadBalancing_PopUp]                           

		

		@pStaffMasterId			INT,

		@pAssetClassificationId INT	=	NULL,

		@pUserAreaId			INT	=	NULL,

		@pUserLocationId		INT	=	NULL,

		@pYear					INT	=	NULL,

		@pMonth					INT	=	NULL,

		@pWeek					INT	=	NULL,

		@pFacilityId			INT =	NULL,

		@pPageIndex				INT,

		@pPageSize				INT

		



AS                                               



BEGIN TRY



-- Paramter Validation 



	SET NOCOUNT ON; 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration



	DECLARE	@TotalRecords INT

	DECLARE	@pTotalPage		NUMERIC(24,2)



-- Default Values



		--SET @pAssetClassificationId  =  NULLIF(@pAssetClassificationId,0)

		--SET @pUserAreaId			 =  NULLIF(@pUserAreaId,0)

		--SET @pUserLocationId		 =  NULLIF(@pUserLocationId,0)		



IF (@pWeek =6)

	BEGIN

		SET @pWeek = NULL

	END

-- Execution

		-- Get Week Calendar from Master DB
		select top 1 * into #Calendar from UetrackMasterdbPreProd..PPMLoadBalanceWeekCalendar where year=@pYear and Week=@pWeek
		and Month=left( DateName( month , DateAdd( month , @pMonth , -1 )),3)

		SELECT	@TotalRecords	=	COUNT(1)

		FROM	EngMaintenanceWorkOrderTxn			AS	MWO			WITH(NOLOCK)

				INNER JOIN	MstCustomer				AS	Customer	WITH(NOLOCK)	ON	MWO.CustomerId		=	Customer.CustomerId

				INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK)	ON	MWO.FacilityId		=	Facility.FacilityId

				INNER JOIN	EngAsset				AS	Asset		WITH(NOLOCK)	ON	MWO.AssetId			=	Asset.AssetId

				INNER JOIN	UMUserRegistration		AS	Staff		WITH(NOLOCK)	ON	MWO.EngineerUserId	=	Staff.UserRegistrationId

				INNER JOIN	EngPlannerTxn			AS	Planner		WITH(NOLOCK)	ON	MWO.PlannerId		=	Planner.PlannerId

				LEFT JOIN	FMLovMst				AS	LovStatus	WITH(NOLOCK)	ON	MWO.WorkOrderStatus	=	LovStatus.LovId


		WHERE	((ISNULL(@pYear,'') = '' )	OR (ISNULL(@pYear,'') <> '' AND YEAR(MWO.TargetDateTime) =  @pYear ))
				
				AND MWO.TargetDateTime>=(select Week_start from #Calendar) AND MWO.TargetDateTime<=(select Week_end from #Calendar)

				--AND ((ISNULL(@pMonth,'') = '' )	OR (ISNULL(@pMonth,'') <> '' AND MONTH(MWO.TargetDateTime) =  @pMonth ))

				--AND ((ISNULL(@pWeek,'') = '' )	OR (ISNULL(@pWeek,'') <> '' AND (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1) =  @pWeek ))

				--AND ((ISNULL(@pStaffMasterId,'') = '' )	OR (ISNULL(@pStaffMasterId,'') <> '' AND ( MWO.EngineerUserId =  @pStaffMasterId OR  MWO.AssignedUserId =  @pStaffMasterId ) ))

				AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =  @pAssetClassificationId ))

				AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId =  @pUserAreaId ))

				AND ((ISNULL(@pUserLocationId,'') = '' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId =  @pUserLocationId ))

				AND MWO.MaintenanceWorkCategory = 187 AND MWO.WorkOrderStatus IN (192)

				AND MWO.FacilityId = @pFacilityId



	SET @pTotalPage = IIF(@pPageSize=0,0,CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2)))

	SET @pTotalPage = CEILING(@pTotalPage)





		SELECT	MWO.WorkOrderId,

				MWO.MaintenanceWorkNo,

				Asset.AssetNo,

				Asset.AssetDescription,

				MWO.TargetDateTime,

				MWO.WorkOrderStatus,

				LovStatus.FieldValue		AS  WorkOrderStatusValue,

				MWO.Timestamp,

				@TotalRecords				AS	TotalRecords,

				@pTotalPage					AS	TotalPage,

				Staff.StaffName				AS	Assignee 

		FROM	EngMaintenanceWorkOrderTxn			AS	MWO				WITH(NOLOCK)

				INNER JOIN	MstCustomer				AS	Customer		WITH(NOLOCK)	ON	MWO.CustomerId			=	Customer.CustomerId

				INNER JOIN	MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	MWO.FacilityId			=	Facility.FacilityId

				INNER JOIN	EngAsset				AS	Asset			WITH(NOLOCK)	ON	MWO.AssetId				=	Asset.AssetId

				INNER JOIN	UMUserRegistration		AS	Staff			WITH(NOLOCK)	ON	MWO.EngineerUserId		=	Staff.UserRegistrationId

				INNER JOIN	EngPlannerTxn			AS	Planner			WITH(NOLOCK)	ON	MWO.PlannerId			=	Planner.PlannerId

				LEFT JOIN	FMLovMst				AS	LovStatus	WITH(NOLOCK)	ON	MWO.WorkOrderStatus	=	LovStatus.LovId

		WHERE	((ISNULL(@pYear,'') = '' )	OR (ISNULL(@pYear,'') <> '' AND YEAR(MWO.TargetDateTime) =  @pYear ))

				AND MWO.TargetDateTime>=(select Week_start from #Calendar) AND MWO.TargetDateTime<=(select Week_end from #Calendar)

				--AND ((ISNULL(@pMonth,'') = '' )	OR (ISNULL(@pMonth,'') <> '' AND MONTH(MWO.TargetDateTime) =  @pMonth ))

				--AND ((ISNULL(@pWeek,'') = '' )	OR (ISNULL(@pWeek,'') <> '' AND (DATEPART(WEEK, TargetDateTime)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,TargetDateTime), 0))+ 1) =  @pWeek ))

				AND ((ISNULL(@pStaffMasterId,'') = '' )	OR (ISNULL(@pStaffMasterId,'') <> '' AND ( MWO.EngineerUserId =  @pStaffMasterId OR  MWO.AssignedUserId =  @pStaffMasterId ) ))

				AND ((ISNULL(@pAssetClassificationId,'') = '' )	OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =  @pAssetClassificationId ))

				AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId =  @pUserAreaId ))

				AND ((ISNULL(@pUserLocationId,'') = '' )	OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId =  @pUserLocationId ))

				AND MWO.MaintenanceWorkCategory = 187 AND MWO.WorkOrderStatus IN (192)

				AND MWO.FacilityId = @pFacilityId

		ORDER BY	MWO.ModifiedDateUTC

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