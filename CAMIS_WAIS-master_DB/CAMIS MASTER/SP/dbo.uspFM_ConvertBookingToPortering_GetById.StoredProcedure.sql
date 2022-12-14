USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ConvertBookingToPortering_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoAssesmentTxn_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Dhilip V
Date				: 16-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_ConvertBookingToPortering_GetById] @pLoanerTestEquipmentBookingId=34
	
SELECT * FROM EngLoanerTestEquipmentBookingTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_ConvertBookingToPortering_GetById]                           

  @pLoanerTestEquipmentBookingId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT,@mIsExtension BIT,@mAssetId INT,@mEndDate DATETIME,@mCurrDate DATETIME


	IF(ISNULL(@pLoanerTestEquipmentBookingId,0) = 0) RETURN
	
	SELECT @mAssetId = AssetId
	FROM EngLoanerTestEquipmentBookingTxn WHERE LoanerTestEquipmentBookingId = @pLoanerTestEquipmentBookingId


	SELECT	@pLoanerTestEquipmentBookingId										AS LoanerTestEquipmentBookingId,
			Asset.AssetId,
			Asset.FacilityId,
			Facility.FacilityCode												AS FromFacilityCode,
			Facility.FacilityName												AS FromFacilityName,
			Block.BlockId,
			Block.BlockCode														AS FromBlockCode,
			Block.BlockName														AS FromBlockName,
			LocationLevel.LevelId,
			LocationLevel.LevelCode												AS FromLevelCode,
			LocationLevel.LevelName												AS FromLevelName,
			UserArea.UserAreaId,
			UserArea.UserAreaCode												AS FromUserAreaCode,
			UserArea.UserAreaName												AS FromUserAreaName,
			UserLocation.UserLocationId,
			UserLocation.UserLocationCode										AS FromUserLocationCode,
			UserLocation.UserLocationName										AS FromUserLocationName
	INTO	#AssetFromLocation	
	FROM	EngAsset									AS Asset
			INNER JOIN  MstLocationFacility				AS Facility				WITH(NOLOCK)	ON Asset.FacilityId			= Facility.FacilityId
			INNER JOIN  MstLocationUserLocation			AS UserLocation			WITH(NOLOCK)	ON Asset.UserLocationId		= UserLocation.UserLocationId
			INNER JOIN  MstLocationUserArea				AS UserArea				WITH(NOLOCK)	ON Asset.UserAreaId			= UserArea.UserAreaId			
			INNER JOIN  MstLocationLevel				AS LocationLevel		WITH(NOLOCK)	ON UserArea.LevelId				= LocationLevel.LevelId
			INNER JOIN  MstLocationBlock				AS Block				WITH(NOLOCK)	ON UserArea.BlockId				= Block.BlockId
	WHERE	Asset.AssetId = @mAssetId
			
			

	SELECT	LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId				AS LoanerTestEquipmentBookingId,
			LoanerTestEquipmentBooking.CustomerId								AS CustomerId,
			LoanerTestEquipmentBooking.FacilityId								AS FacilityId,
			LoanerTestEquipmentBooking.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey												AS ServiceValue,
			LoanerTestEquipmentBooking.AssetId									AS AssetId,
			Asset.AssetNo														AS AssetNo,
			Asset.AssetDescription												AS AssetDescription,
			LoanerTestEquipmentBooking.WorkOrderId								AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo								AS MaintenanceWorkNo,
			LoanerTestEquipmentBooking.BookingStartFrom							AS BookingStartFrom,
			LoanerTestEquipmentBooking.BookingEnd								AS BookingEnd,
			LoanerTestEquipmentBooking.MovementCategory							AS MovementCategory,
			MovementCategory.FieldValue											AS MovementCategoryValue,
			LoanerTestEquipmentBooking.CustomerId                               As ToCustomerId,
			LoanerTestEquipmentBooking.ToFacility								AS ToFacilityId,
			Facility.FacilityCode												AS FacilityCode,
			Facility.FacilityName												AS FacilityName,
			LoanerTestEquipmentBooking.ToBlock									AS ToBlockId,
			Block.BlockCode														AS ToBlockCode,
			Block.BlockName														AS ToBlockName,
			LoanerTestEquipmentBooking.ToLevel									AS ToLevelId,
			LocationLevel.LevelCode												AS ToLevelCode,
			LocationLevel.LevelName												AS ToLevelName,
			LoanerTestEquipmentBooking.ToUserArea								AS ToUserAreaId,
			UserArea.UserAreaCode												AS ToUserAreaCode,
			UserArea.UserAreaName												AS ToUserAreaName,
			LoanerTestEquipmentBooking.ToUserLocation							AS ToUserLocationId,
			UserLocation.UserLocationCode										AS ToUserLocationCode,
			UserLocation.UserLocationName										AS ToUserLocationName,
			LoanerTestEquipmentBooking.RequestorId								AS RequestorId,
			UMUser.StaffName													AS RequestorName,
			Designation.Designation												AS Designation,
			LoanerTestEquipmentBooking.RequestType								AS RequestType,
			RequestType.FieldValue												AS RequestTypeValue,
			LoanerTestEquipmentBooking.BookingStatus							AS BookingStatus,
			BookingStatus.FieldValue											AS BookingStatusValue,
			LoanerTestEquipmentBooking.Timestamp								AS Timestamp	,
			Asset.CustomerId													AS FromCustomerId,
			Asset.FacilityId													AS FromFacilityId,
			Facility.FacilityCode												AS FromFacilityCode,
			Facility.FacilityName												AS FromFacilityName,
			AssetFrom.BlockId													AS FromBlockId,
			AssetFrom.FromBlockCode												AS FromBlockCode,
			AssetFrom.FromBlockName												AS FromBlockName,
			AssetFrom.LevelId													AS FromLevelId,
			AssetFrom.FromLevelCode												AS FromLevelCode,
			AssetFrom.FromLevelName												AS FromLevelName,
			AssetFrom.UserAreaId												AS FromUserAreaId,
			AssetFrom.FromUserAreaCode											AS FromUserAreaCode,
			AssetFrom.FromUserAreaName											AS FromUserAreaName,
			AssetFrom.UserLocationId											AS FromUserLocationId,
			AssetFrom.FromUserLocationCode										AS FromUserLocationCode,
			AssetFrom.FromUserLocationName										AS FromUserLocationName


	FROM	EngLoanerTestEquipmentBookingTxn									AS LoanerTestEquipmentBooking
			INNER JOIN  MstService												AS ServiceKey						WITH(NOLOCK)			on LoanerTestEquipmentBooking.ServiceId						= ServiceKey.ServiceId
			INNER JOIN  EngAsset												AS Asset							WITH(NOLOCK)			on LoanerTestEquipmentBooking.AssetId						= Asset.AssetId
			LEFT  JOIN  EngMaintenanceWorkOrderTxn								AS MaintenanceWorkOrder				WITH(NOLOCK)			on LoanerTestEquipmentBooking.WorkOrderId					= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstLocationFacility										AS Facility							WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToFacility					= Facility.FacilityId
			INNER JOIN  MstLocationBlock										AS Block							WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToBlock						= Block.BlockId
			INNER JOIN  MstLocationLevel										AS LocationLevel					WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToLevel						= LocationLevel.LevelId
			INNER JOIN  MstLocationUserArea										AS UserArea							WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToUserArea					= UserArea.UserAreaId
			INNER JOIN  MstLocationUserLocation									AS UserLocation						WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToUserLocation				= UserLocation.UserLocationId
			LEFT  JOIN  UMUserRegistration										AS UMUser							WITH(NOLOCK)			on LoanerTestEquipmentBooking.RequestorId					= UMUser.UserRegistrationId
			LEFT  JOIN  UserDesignation											AS Designation						WITH(NOLOCK)			on UMUser.UserDesignationId									= Designation.UserDesignationId
			INNER JOIN  FMLovMst												AS MovementCategory					WITH(NOLOCK)			on LoanerTestEquipmentBooking.MovementCategory				= MovementCategory.LovId
			INNER JOIN  FMLovMst												AS RequestType						WITH(NOLOCK)			on LoanerTestEquipmentBooking.RequestType					= RequestType.LovId
			INNER JOIN  FMLovMst												AS BookingStatus					WITH(NOLOCK)			on LoanerTestEquipmentBooking.BookingStatus					= BookingStatus.LovId
			INNER JOIN  #AssetFromLocation										AS AssetFrom						WITH(NOLOCK)			on LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId	= AssetFrom.LoanerTestEquipmentBookingId
	WHERE	LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId = @pLoanerTestEquipmentBookingId 
	ORDER BY MaintenanceWorkOrder.ModifiedDate ASC

	
	     	SELECT 	@mCustomerId	= CustomerId ,
			@mFacilityId	=	ToFacility,
			@mBlockId		=	ToBlock,
			@mLevelId		=	ToLevel,
			@mUserAreaId	=	ToUserArea,
			@mUserLocationId = ToUserLocation FROM EngLoanerTestEquipmentBookingTxn where LoanerTestEquipmentBookingId = @pLoanerTestEquipmentBookingId

			SELECT * FROM (
				SELECT	FacilityId				AS	LovId,
						FacilityName			AS	FieldValue,
						0						IsDefault,
						'MstLocationFacility'	AS	LovKey		
				FROM MstLocationFacility WHERE CustomerId =	@mCustomerId
			
				UNION
			
				SELECT	BlockId				AS	LovId,
						BlockName			AS	FieldValue,
						0						IsDefault,
						'MstLocationBlock'	AS	LovKey		
				FROM MstLocationBlock WHERE FacilityId =	@mFacilityId
			
				UNION
			
				SELECT	LevelId				AS	LovId,
						LevelName			AS	FieldValue,
						0						IsDefault,
						'MstLocationLevel'	AS	LovKey		
				FROM MstLocationLevel WHERE BlockId =	@mBlockId
			
				UNION
			
				SELECT	UserAreaId				AS	LovId,
						UserAreaName			AS	FieldValue,
						0						IsDefault,
						'MstLocationUserArea'	AS	LovKey		
				FROM MstLocationUserArea WHERE LevelId =	@mLevelId
			
				UNION
			
				SELECT	UserLocationId				AS	LovId,
						UserLocationName			AS	FieldValue,
						0						IsDefault,
						'MstLocationUserLocation'	AS	LovKey		
				FROM MstLocationUserLocation WHERE UserAreaId =	@mUserAreaId
				) Sub ORDER BY LovKey ASC

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
