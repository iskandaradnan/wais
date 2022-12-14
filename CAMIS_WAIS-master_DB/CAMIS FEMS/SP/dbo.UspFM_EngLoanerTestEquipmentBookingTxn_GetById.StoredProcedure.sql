USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLoanerTestEquipmentBookingTxn_GetById]    Script Date: 20-09-2021 16:56:53 ******/
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
EXEC [UspFM_EngLoanerTestEquipmentBookingTxn_GetById] @pLoanerTestEquipmentBookingId=20

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngLoanerTestEquipmentBookingTxn_GetById]                           
  --@pUserId			INT	=	NULL,
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

	SELECT	IDENTITY(INT,1,1) AS ID,
			AssetId,
			BookingEnd
		INTO #TempBooking
	FROM EngLoanerTestEquipmentBookingTxn 
	WHERE AssetId = @mAssetId


	SELECT	@mEndDate=MAX(BookingEnd)
	FROM EngLoanerTestEquipmentBookingTxn 
	WHERE AssetId = @mAssetId
	GROUP BY AssetId

	--IF EXISTS (	SELECT * 
	--			FROM #TempBooking 
	--			WHERE	AssetId = @mAssetId AND DATEADD(DAY,-7,BookingEnd)<=GETDATE()
	--					--AND AssetId NOT IN (	SELECT AssetId 
	--					--						FROM EngLoanerTestEquipmentBookingTxn 
	--					--						WHERE AssetId = @mAssetId AND BookingEnd>= GETDATE())
	--										)

	SET @mEndDate =( SELECT @mEndDate -7)
	SET @mCurrDate= GETDATE()
	IF (DATEDIFF(DAY,@mEndDate,@mCurrDate)<=7)
	BEGIN
		SET @mIsExtension=1
	END
	ELSE
	BEGIN
		SET @mIsExtension=0
	END


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
			LoanerTestEquipmentBooking.ToFacility								AS ToFacility,
			Facility.FacilityCode												AS FacilityCode,
			Facility.FacilityName												AS FacilityName,
			LoanerTestEquipmentBooking.ToBlock									AS ToBlock,
			Block.BlockCode														AS BlockCode,
			Block.BlockName														AS BlockName,
			LoanerTestEquipmentBooking.ToLevel									AS ToLevel,
			LocationLevel.LevelCode												AS LevelCode,
			LocationLevel.LevelName												AS LevelName,
			LoanerTestEquipmentBooking.ToUserArea								AS ToUserArea,
			UserArea.UserAreaCode												AS UserAreaCode,
			UserArea.UserAreaName												AS UserAreaName,
			LoanerTestEquipmentBooking.ToUserLocation							AS ToUserLocation,
			UserLocation.UserLocationCode										AS UserLocationCode,
			UserLocation.UserLocationName										AS UserLocationName,
			LoanerTestEquipmentBooking.RequestorId								AS RequestorId,
			UMUser.StaffName													AS RequestorName,
			Designation.Designation												AS Designation,
			LoanerTestEquipmentBooking.RequestType								AS RequestType,
			RequestType.FieldValue												AS RequestTypeValue,
			LoanerTestEquipmentBooking.BookingStatus							AS BookingStatus,
			BookingStatus.FieldValue											AS BookingStatusValue,
			LoanerTestEquipmentBooking.Timestamp								AS Timestamp	,
			@mIsExtension														AS IsExtension,
			CASE WHEN ISNULL(Booking.Cnt,0) >0 THEN 1
					ELSE 0		
			END																	AS IsProteringDone,
			Asset.CompanyStaffId												AS LocationInchargeId, 
			LoanerTestEquipmentBooking.GuId
	FROM	EngLoanerTestEquipmentBookingTxn									AS LoanerTestEquipmentBooking
			INNER JOIN  MstService												AS ServiceKey						WITH(NOLOCK)			on LoanerTestEquipmentBooking.ServiceId				= ServiceKey.ServiceId
			INNER JOIN  EngAsset												AS Asset							WITH(NOLOCK)			on LoanerTestEquipmentBooking.AssetId				= Asset.AssetId
			LEFT  JOIN  EngMaintenanceWorkOrderTxn								AS MaintenanceWorkOrder				WITH(NOLOCK)			on LoanerTestEquipmentBooking.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstLocationFacility										AS Facility							WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToFacility			= Facility.FacilityId
			INNER JOIN  MstLocationBlock										AS Block							WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToBlock				= Block.BlockId
			INNER JOIN  MstLocationLevel										AS LocationLevel					WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToLevel				= LocationLevel.LevelId
			INNER JOIN  MstLocationUserArea										AS UserArea							WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToUserArea			= UserArea.UserAreaId
			INNER JOIN  MstLocationUserLocation									AS UserLocation						WITH(NOLOCK)			on LoanerTestEquipmentBooking.ToUserLocation		= UserLocation.UserLocationId
			LEFT  JOIN  UMUserRegistration										AS UMUser							WITH(NOLOCK)			on LoanerTestEquipmentBooking.RequestorId			= UMUser.UserRegistrationId
			LEFT  JOIN  UserDesignation											AS Designation						WITH(NOLOCK)			on UMUser.UserDesignationId							= Designation.UserDesignationId
			INNER JOIN  FMLovMst												AS MovementCategory					WITH(NOLOCK)			on LoanerTestEquipmentBooking.MovementCategory		= MovementCategory.LovId
			INNER JOIN  FMLovMst												AS RequestType						WITH(NOLOCK)			on LoanerTestEquipmentBooking.RequestType			= RequestType.LovId
			INNER JOIN  FMLovMst												AS BookingStatus					WITH(NOLOCK)			on LoanerTestEquipmentBooking.BookingStatus			= BookingStatus.LovId
			OUTER APPLY (SELECT COUNT(*) Cnt FROM PorteringTransaction AS Port WHERE Asset.AssetId	=	Port.AssetId AND LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId = Port.LoanerTestEquipmentBookingId) Booking
	WHERE	LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId = @pLoanerTestEquipmentBookingId 
	ORDER BY MaintenanceWorkOrder.ModifiedDate ASC

	
	     	SELECT 	@mCustomerId	= CustomerId ,
			@mFacilityId	=	ToFacility,
			@mBlockId		=	ToBlock,
			@mLevelId		=	ToLevel,
			@mUserAreaId	=	ToUserArea,
			@mUserLocationId = ToUserLocation FROM EngLoanerTestEquipmentBookingTxn where LoanerTestEquipmentBookingId = @pLoanerTestEquipmentBookingId

			SELECT * FROM (
				SELECT	FacilityId				AS	LovId, 0 IsDefault,
						FacilityName			AS	FieldValue,
						'MstLocationFacility'	AS	LovKey		
				FROM MstLocationFacility WHERE CustomerId =	@mCustomerId
			
				UNION
			
				SELECT	BlockId				AS	LovId, 0 IsDefault,
						BlockName			AS	FieldValue,
						'MstLocationBlock'	AS	LovKey		
				FROM MstLocationBlock WHERE FacilityId =	@mFacilityId
			
				UNION
			
				SELECT	LevelId				AS	LovId, 0 IsDefault,
						LevelName			AS	FieldValue,
						'MstLocationLevel'	AS	LovKey		
				FROM MstLocationLevel WHERE BlockId =	@mBlockId
			
				UNION
			
				SELECT	UserAreaId				AS	LovId, 0 IsDefault,
						UserAreaName			AS	FieldValue,
						'MstLocationUserArea'	AS	LovKey		
				FROM MstLocationUserArea WHERE LevelId =	@mLevelId
			
				UNION
			
				SELECT	UserLocationId				AS	LovId, 0 IsDefault,
						UserLocationName			AS	FieldValue,
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
