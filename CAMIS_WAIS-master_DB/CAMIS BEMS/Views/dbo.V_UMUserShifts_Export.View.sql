USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_UMUserShifts_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_UMUserShifts_Export]
AS
	SELECT	DISTINCT UserShift.UserShiftsId,
			UserShift.CustomerId,
			Customer.CustomerName,
			UserLoc.FacilityId,
			Facility.FacilityName,
			UserReg.StaffName			AS StaffName,
			''''+Cast ((UserReg.MobileNumber) as nvarchar(100))		AS MobileNo,
			UserReg.UserName,
			UserType.Name				AS UserType,
			Designation.Designation,
			--LovShift.FieldValue			AS ShiftLunchTime,
			--LovUserShift.FieldValue     AS ShiftTime,
			case when ShiftStartTime is null and ShiftStartTimeMin is null then '' else right('00'+cast(isnull(ShiftStartTime,0) as varchar(10)),2) +':'+right('00'+cast(isnull(ShiftStartTimeMin,0) as varchar(10)),2)  end as ShiftStarttime,
			case when ShiftendTime is null and ShiftendTimeMin is null then '' else right('00'+cast(isnull(ShiftendTime,0) as varchar(10)),2)  +':'+right('00'+cast(isnull(ShiftendTimeMin,0) as varchar(10)) ,2)  end as ShiftEndtime,
			case when ShiftBreakStartTime is null and ShiftBreakStartTimemin is null then '' else right('00'+cast(isnull(ShiftBreakStartTime,0) as varchar(10)),2) +':'+right('00'+cast(isnull(ShiftBreakStartTimemin,0) as varchar(10)) ,2)  end as ShiftBreakStartTime

,
			case when ShiftBreakEndTime is null and ShiftBreakEndTimemin is null then '' else right('00'+cast(isnull(ShiftBreakEndTime,0) as varchar(10)),2)  +':'+right('00'+cast(isnull(ShiftBreakEndTimemin,0) as varchar(10)),2)   end as ShiftBreakEndTime,
			
			cast(UserShiftDet.LeaveFrom as date) as LeaveFrom,
			cast(UserShiftDet.LeaveTo as date) as LeaveTo,
			cast(UserShiftDet.NoOfDays as int) as NoOfDays,
			UserShift.ModifiedDateUTC
	FROM	UMUserShifts						AS	UserShift		    WITH(NOLOCK)
			LEFT JOIN	MstCustomer				AS	Customer			WITH(NOLOCK)		ON	UserShift.CustomerId			=	Customer.CustomerId
			--LEFT JOIN	MstLocationFacility		AS	Facility			WITH(NOLOCK)	    ON	UserShift.FacilityId			=	Facility.FacilityId
			--LEFT JOIN	FMLovMst				AS	LovShift		    WITH(NOLOCK)		ON	UserShift.LunchTimeLovId		=	LovShift.LovId
			--LEFT JOIN	FMLovMst				AS	LovUserShift		WITH(NOLOCK)		ON	UserShift.ShiftTimeLovId		=	LovUserShift.LovId			
			INNER JOIN UMUserRegistration		AS	UserReg			WITH(NOLOCK)	ON	UserShift.UserRegistrationId	=	UserReg.UserRegistrationId
			INNER join UMUserLocationMstDet		AS	UserLoc			WITH(NOLOCK)	ON	UserLoc.UserRegistrationId		=	UserReg.UserRegistrationId --and UserShift.FacilityId	=UserLoc.FacilityId
			LEFT JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	UserLoc.FacilityId			=	Facility.FacilityId
			INNER JOIN  UMUserType				AS	UserType			WITH(NOLOCK)		ON	UserReg.UserTypeId				=	UserType.UserTypeId
			INNER JOIN  UserDesignation			AS	Designation			WITH(NOLOCK)		ON	UserReg.UserDesignationId		=	Designation.UserDesignationId
			--INNER JOIN  FMLovMst				AS	AccessLevel			WITH(NOLOCK)		ON	UserReg.AccessLevel				=	AccessLevel.LovId
			LEFT JOIN  UMUserShiftsDet			AS	UserShiftDet		WITH(NOLOCK)		ON	UserShift.UserShiftsId			=	UserShiftDet.UserShiftsId
GO
