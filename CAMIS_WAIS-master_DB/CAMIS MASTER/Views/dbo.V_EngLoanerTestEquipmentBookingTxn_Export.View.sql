USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngLoanerTestEquipmentBookingTxn_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngLoanerTestEquipmentBookingTxn_Export]
AS
	SELECT	DISTINCT BookingTxn.LoanerTestEquipmentBookingId,
			BookingTxn.CustomerId,
			Customer.CustomerName,
			BookingTxn.FacilityId,
			Facility.FacilityName,

			Asset.AssetNo					AS LoanerTestNo,
			WorkOrder.MaintenanceWorkNo		AS WorkOrderNo,
			Cast(BookingTxn.BookingStartFrom as date)	AS	BookingStartFrom,
			Cast(BookingTxn.BookingEnd as date)	AS	BookingEnd,
			LovMovCategory.FieldValue		AS MovementCategory,
			ToFacility.FacilityName			AS ToFacility,
			ToBlock.BlockName				AS ToBlock,
			ToLevel.LevelName				AS ToLevel,
			ToUserArea.UserAreaName			AS ToUserArea,
			ToUserLocation.UserLocationName	AS ToUserLocation,
			UserReg.StaffName				AS RequestorName,
			Designation.Designation			AS Position,
			LovReqType.FieldValue			AS RequestType,
			LovBookingStatus.FieldValue		AS BookingStatusValue,
			Assettype.AssetTypeCode		    AS TypeCode,
			Assettype.AssetTypeDescription  As TypeDescription,
			Model.Model						As Model,
			Manufacturer.Manufacturer       As Manufacturer,
			Asset.AssetDescription			AS LoanerTestName,			
			BookingTxn.ModifiedDateUTC
	FROM	EngLoanerTestEquipmentBookingTxn				AS	BookingTxn			WITH(NOLOCK)
	        LEFT JOIN  EngMaintenanceWorkOrderTxn			AS  WorkOrder			with(nolock)    on  BookingTxn.WorkOrderId		= WorkOrder.WorkOrderId
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON	BookingTxn.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON	BookingTxn.FacilityId		=	Facility.FacilityId
			LEFT JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON	BookingTxn.AssetId			=	Asset.AssetId
			LEFT JOIN FMLovMst								AS	LovBookingStatus	WITH(NOLOCK)	ON	BookingTxn.BookingStatus	=	LovBookingStatus.LovId
			LEFT JOIN UMUserRegistration					AS	UserReg				WITH(NOLOCK)	ON	BookingTxn.RequestorId		=	UserReg.UserRegistrationId
			LEFT JOIN UserDesignation						AS	Designation			WITH(NOLOCK)	ON	UserReg.UserDesignationId	=	Designation.UserDesignationId
			LEFT JOIN FMLovMst								AS	LovMovCategory		WITH(NOLOCK)	ON	BookingTxn.MovementCategory	=	LovMovCategory.LovId
			LEFT JOIN MstLocationFacility					AS	ToFacility			WITH(NOLOCK)	ON	BookingTxn.ToFacility		=	ToFacility.FacilityId
			LEFT JOIN MstLocationBlock						AS	ToBlock				WITH(NOLOCK)	ON	BookingTxn.ToBlock			=	ToBlock.BlockId
			LEFT JOIN MstLocationLevel						AS	ToLevel				WITH(NOLOCK)	ON	BookingTxn.ToLevel			=	ToLevel.LevelId
			LEFT JOIN MstLocationUserArea					AS	ToUserArea			WITH(NOLOCK)	ON	BookingTxn.ToUserArea		=	ToUserArea.UserAreaId
			LEFT JOIN MstLocationUserLocation				AS	ToUserLocation		WITH(NOLOCK)	ON	BookingTxn.ToUserLocation	=	ToUserLocation.UserLocationId
			LEFT JOIN FMLovMst								AS	LovReqType			WITH(NOLOCK)	ON	BookingTxn.RequestType		=	LovReqType.LovId
			LEFT JOIN EngAssetTypeCode						AS  Assettype			WITH(NOLOCK)	ON	Asset.AssetTypeCodeId		=	Assettype.AssetTypeCodeId
			LEFT JOIN EngAssetStandardizationModel			AS  Model			    WITH(NOLOCK)	ON	Asset.Model				    =   Model.ModelId
			LEFT JOIN EngAssetStandardizationManufacturer   AS  Manufacturer		WITH(NOLOCK)	ON	Asset.Manufacturer			=   Manufacturer.ManufacturerId
GO
