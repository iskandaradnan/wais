USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_UMUserShifts]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_UMUserShifts]
AS
	SELECT	DISTINCT 
			UserShift.UserRegistrationId,
			UserShift.UserShiftsId,
			UserShift.CustomerId,
			Customer.CustomerName,
			UserLoc.FacilityId,
			Facility.FacilityName,
			UserReg.StaffName			AS StaffName,
			UserReg.UserName,
			LovShift.FieldValue			AS ShiftLunchTime,
			UserShift.LeaveFrom,
			UserShift.LeaveTo,
			UserShift.ModifiedDateUTC
	FROM	UMUserShifts						AS	UserShift		WITH(NOLOCK)
			--LEFT JOIN UMUserShiftsDet			AS	UserShiftDet	WITH(NOLOCK)	ON	UserShift.UserShiftsId			=	UserShiftDet.UserShiftsId
			LEFT JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON	UserShift.CustomerId			=	Customer.CustomerId			
			INNER JOIN FMLovMst					AS	LovShift		WITH(NOLOCK)	ON	UserShift.LunchTimeLovId		=	LovShift.LovId
			INNER JOIN UMUserRegistration		AS	UserReg			WITH(NOLOCK)	ON	UserShift.UserRegistrationId	=	UserReg.UserRegistrationId
			INNER join UMUserLocationMstDet		AS	UserLoc			WITH(NOLOCK)	ON	UserLoc.UserRegistrationId		=	UserReg.UserRegistrationId --and UserShift.FacilityId	=UserLoc.FacilityId
			LEFT JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	UserLoc.FacilityId			=	Facility.FacilityId
GO
