USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderStatusHistory_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMaintenanceWorkOrderStatusHistory_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMaintenanceWorkOrderStatusHistory_GetById] @pWorkOrderId=39,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROC  [dbo].[UspFM_EngMaintenanceWorkOrderStatusHistory_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		INT--,
  --@pPageIndex		INT,
  --@pPageSize		INT	


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @TotalRecords INT
	--DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

	--SELECT	@TotalRecords	=	COUNT(*)
	--FROM	EngMaintenanceWorkOrderStatusHistory				AS StatusHistory
	--		INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on StatusHistory.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
	--		INNER JOIN	EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId			= Asset.AssetId
	--		INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on StatusHistory.ServiceId				= ServiceKey.ServiceId
	--		INNER JOIN  UMUserRegistration						AS UMUser							WITH(NOLOCK)			on StatusHistory.ModifiedBy				= UMUser.UserRegistrationId
	--		INNER JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on StatusHistory.Status					= WorkOrderStatus.LovId
	--WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId 

	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPage = CEILING(@pTotalPage)
																
	SELECT	StatusHistory.WorkOrderHistoryId					AS WorkOrderHistoryId,		
			StatusHistory.CustomerId							AS CustomerId,
			StatusHistory.FacilityId							AS FacilityId,
			StatusHistory.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			StatusHistory.WorkOrderId							AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime        AS MaintenanceWorkDateTime,
			Asset.AssetNo										AS AssetNo,
			StatusHistory.Status								AS Status,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue,
			UMUser.StaffName									AS ModifiedStaffName,
			Desig.Designation									AS ModifiedStaffDesig,
			--@TotalRecords										AS TotalRecords,
			--@pTotalPage											AS TotalPageCalc,
			StatusHistory.CreatedDate							AS CreatedDate,
			StatusHistory.Timestamp								AS Timestamp
	FROM	EngMaintenanceWorkOrderStatusHistory				AS StatusHistory
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on StatusHistory.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN	EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId			= Asset.AssetId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on StatusHistory.ServiceId				= ServiceKey.ServiceId
			INNER JOIN  UMUserRegistration						AS UMUser							WITH(NOLOCK)			on StatusHistory.ModifiedBy				= UMUser.UserRegistrationId
			LEFT JOIN	UserDesignation							AS Desig							WITH(NOLOCK)			on UMUser.UserDesignationId				= Desig.UserDesignationId
			INNER JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on StatusHistory.Status					= WorkOrderStatus.LovId
	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId 
	ORDER BY MaintenanceWorkOrder.ModifiedDate ASC
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
