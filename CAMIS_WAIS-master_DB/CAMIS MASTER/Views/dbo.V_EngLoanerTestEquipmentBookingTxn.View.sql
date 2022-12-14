USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngLoanerTestEquipmentBookingTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngLoanerTestEquipmentBookingTxn]
AS
	SELECT	DISTINCT BookingTxn.LoanerTestEquipmentBookingId,
			BookingTxn.CustomerId,
			Customer.CustomerName,
			BookingTxn.FacilityId,
			Facility.FacilityName,
			UserReg.StaffName			    AS RequestorName,
			Asset.AssetNo				    AS LoanerTestNo,
			Asset.AssetDescription		    AS LoanerTestName,
			LovBookingStatus.FieldValue	    AS BookingStatusValue,
			Assettype.AssetTypeCode	        AS AssetTypeCode,
			Assettype.AssetTypeDescription  As AssetTypeDescription,
			Model.Model					    As Model,
			Manufacturer.Manufacturer 		As Manufacturer,
			BookingTxn.BookingStartFrom,
			BookingTxn.BookingEnd,
			WorkOrder.MaintenanceWorkNo WorkOrderNo,
			BookingTxn.ModifiedDateUTC
	FROM	EngLoanerTestEquipmentBookingTxn				AS	BookingTxn			WITH(NOLOCK)
	        LEFT JOIN  EngMaintenanceWorkOrderTxn			AS  WorkOrder			with(nolock)    on  BookingTxn.WorkOrderId		= WorkOrder.WorkOrderId
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON	BookingTxn.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON	BookingTxn.FacilityId		=	Facility.FacilityId
			LEFT JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON	BookingTxn.AssetId			=	Asset.AssetId
			LEFT JOIN FMLovMst								AS	LovBookingStatus	WITH(NOLOCK)	ON	BookingTxn.BookingStatus	=	LovBookingStatus.LovId
			LEFT JOIN UMUserRegistration					AS	UserReg				WITH(NOLOCK)	ON	BookingTxn.RequestorId		=	UserReg.UserRegistrationId
			LEFT JOIN EngAssetTypeCode						AS  Assettype			WITH(NOLOCK)	ON	Asset.AssetTypeCodeId		=	Assettype.AssetTypeCodeId
			LEFT JOIN EngAssetStandardizationModel			AS  Model			    WITH(NOLOCK)	ON	Asset.Model				    =   Model.ModelId
			LEFT JOIN EngAssetStandardizationManufacturer   AS  Manufacturer		WITH(NOLOCK)	ON	Asset.Manufacturer			=   Manufacturer.ManufacturerId
GO
