USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PorteringTransaction_Sync_GetAll]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PorteringTransaction_Sync_GetAll
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_PorteringTransaction_Sync_GetAll] @pPorteringId = '186,187'
select * from PorteringTransaction
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_PorteringTransaction_Sync_GetAll]                           
 -- @pUserId				INT	=	NULL,
  @pPorteringId			nvarchar(1000)


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT

	IF(ISNULL(@pPorteringId,'') = '') RETURN

	SELECT	Portering.PorteringId								AS PorteringId,
			Portering.FromCustomerId							AS FromCustomerId,
			FromCustomer.CustomerName							AS FromCustomerName,
			Portering.FromFacilityId							AS FromFacilityId,
			FromFacility.FacilityName							AS FromFacilityName,
			Portering.FromBlockId								AS FromBlockId,
			FromBlock.BlockCode									AS FromBlockCode,
			FromBlock.BlockName									AS FromBlockName,
			Portering.FromLevelId								AS FromLevelId,
			FromLevel.LevelCode									AS FromLevelCode,
			FromLevel.LevelName									AS FromLevelName,
			Portering.FromUserAreaId							AS FromUserAreaId,
			FromUserArea.UserAreaCode							AS FromUserAreaCode,
			FromUserArea.UserAreaName							AS FromUserAreaName,
			Portering.FromUserLocationId						AS FromUserLocationId,
			FromUserLocation.UserLocationCode					AS FromUserLocationCode,
			FromUserLocation.UserLocationName					AS FromUserLocationName,
			Portering.RequestorId								AS RequestorId,
			RequestorStaff.StaffName							AS RequestorName,
		    RequestorDesignation.Designation					AS RequestorDesignation,
		
			Portering.RequestTypeLovId							AS RequestTypeLovId,
		--	RequestTypeLov.FieldValue							AS RequestTypeLovValue,
			Portering.MovementCategory							AS MovementCategory,
			MovementCategory.FieldValue							AS MovementCategoryValue,
			Portering.ModeOfTransport							AS ModeOfTransport,
			ModeOfTransport.FieldValue							AS ModeOfTransportValue,
			Portering.ToCustomerId								AS ToCustomerId,
			ToCustomer.CustomerName								AS ToCustomerName,
			Portering.ToFacilityId								AS ToFacilityId,
			ToFacility.FacilityName								AS ToFacilityName,
			Portering.ToBlockId									AS ToBlockId,
			ToBlock.BlockCode									AS ToBlockCode,
			ToBlock.BlockName									AS ToBlockName,
			Portering.ToLevelId									AS ToLevelId,
			ToLevel.LevelCode									AS ToLevelCode,
			ToLevel.LevelName									AS ToLevelName,
			Portering.ToUserAreaId								AS ToUserAreaId,
			ToUserArea.UserAreaCode								AS ToUserAreaCode,
			ToUserArea.UserAreaName								AS ToUserAreaName,
			Portering.ToUserLocationId							AS ToUserLocationId,
			ToUserLocation.UserLocationCode						AS ToUserLocationCode,
			ToUserLocation.UserLocationName						AS ToUserLocationName,
			Portering.AssignPorterId							AS AssignPorterId,
			PorterStaff.StaffName								AS AssignPorterName,
			Portering.ConsignmentNo								AS ConsignmentNo,
			Portering.PorteringStatus							AS PorteringStatus,
			PorteringStatus.FieldValue							AS PorteringStatusValue,
			Portering.ReceivedBy								AS ReceivedBy,
			ReceivedBy.StaffName								AS ReceivedByValue,
			Portering.CurrentWorkFlowId							AS CurrentWorkFlowId,
			Portering.Remarks									AS Remarks,
			Portering.AssetId									AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Portering.PorteringDate								AS PorteringDate,
			Portering.PorteringNo								AS PorteringNo,
			Portering.[Timestamp]								AS [Timestamp],
			Portering.SupplierLovId								AS SupplierLovId,
			Portering.SupplierId,
			Portering.CourierName, 
			Portering.ConsignmentDate,
			Portering.WorkOrderId,
			Portering.ScanAsset,
			Portering.WFStatusApprovedDate,
			WorkOrder.MaintenanceWorkNo

	FROM	PorteringTransaction								AS Portering
			INNER JOIN	MstCustomer								AS FromCustomer				WITH(NOLOCK)	ON Portering.FromCustomerId			= FromCustomer.CustomerId
			INNER JOIN  MstLocationFacility						AS FromFacility				WITH(NOLOCK)	ON Portering.FromFacilityId			= FromFacility.FacilityId
			INNER JOIN  MstLocationBlock						AS FromBlock				WITH(NOLOCK)	ON Portering.FromBlockId			= FromBlock.BlockId
			INNER JOIN  MstLocationLevel						AS FromLevel				WITH(NOLOCK)	ON Portering.FromLevelId			= FromLevel.LevelId
			INNER JOIN  MstLocationUserArea						AS FromUserArea				WITH(NOLOCK)	ON Portering.FromUserAreaId			= FromUserArea.UserAreaId
			INNER JOIN  MstLocationUserLocation					AS FromUserLocation			WITH(NOLOCK)	ON Portering.FromUserLocationId		= FromUserLocation.UserLocationId
			LEFT  JOIN  UMUserRegistration						AS RequestorStaff			WITH(NOLOCK)	ON Portering.RequestorId			= RequestorStaff.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS RequestorDesignation		WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorDesignation.UserDesignationId
			--INNER JOIN  FMLovMst								AS RequestTypeLov			WITH(NOLOCK)	ON Portering.RequestTypeLovId		= RequestTypeLov.LovId
			INNER JOIN  FMLovMst								AS MovementCategory			WITH(NOLOCK)	ON Portering.MovementCategory		= MovementCategory.LovId	
			INNER JOIN  FMLovMst								AS ModeOfTransport			WITH(NOLOCK)	ON Portering.ModeOfTransport		= ModeOfTransport.LovId
			INNER JOIN	MstCustomer								AS ToCustomer				WITH(NOLOCK)	ON Portering.ToCustomerId			= ToCustomer.CustomerId
			LEFT JOIN  MstLocationFacility						AS ToFacility				WITH(NOLOCK)	ON Portering.ToFacilityId			= ToFacility.FacilityId
			LEFT JOIN  MstLocationBlock							AS ToBlock					WITH(NOLOCK)	ON Portering.ToBlockId				= ToBlock.BlockId
			LEFT JOIN  MstLocationLevel							AS ToLevel					WITH(NOLOCK)	ON Portering.ToLevelId				= ToLevel.LevelId
			LEFT JOIN  MstLocationUserArea						AS ToUserArea				WITH(NOLOCK)	ON Portering.ToUserAreaId			= ToUserArea.UserAreaId
			LEFT JOIN  MstLocationUserLocation					AS ToUserLocation			WITH(NOLOCK)	ON Portering.ToUserLocationId		= ToUserLocation.UserLocationId
			LEFT  JOIN  FMLovMst								AS PorteringStatus			WITH(NOLOCK)	ON Portering.PorteringStatus		= PorteringStatus.LovId
			LEFT  JOIN  UMUserRegistration						AS ReceivedBy				WITH(NOLOCK)	ON Portering.ReceivedBy				= ReceivedBy.UserRegistrationId
			LEFT  JOIN  EngAsset								AS Asset					WITH(NOLOCK)	ON Portering.AssetId				= Asset.AssetId
			LEFT  JOIN  EngMaintenanceWorkOrderTxn				AS WorkOrder				WITH(NOLOCK)	ON Portering.WorkOrderId			= WorkOrder.WorkOrderId
			LEFT  JOIN  UMUserRegistration						AS PorterStaff		     	WITH(NOLOCK)	ON Portering.AssignPorterId			= PorterStaff.UserRegistrationId

	WHERE	Portering.PorteringId IN  (SELECT ITEM FROM dbo.[SplitString] (@pPorteringId,','))    
	ORDER BY Portering.ModifiedDate ASC

	



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
