USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserShifts_GetByUserRegId]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserShifts_GetByUserRegId
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_UMUserShifts_GetByUserRegId] @pUserRegistrationId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMUserShifts_GetByUserRegId]                           

  @pUserRegistrationId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pUserRegistrationId,0) = 0) RETURN


	SELECT	UserShifts.UserShiftsId								AS UserShiftsId,
			UserShifts.CustomerId								AS CustomerId,
			UserShifts.FacilityId								AS FacilityId,
			UserShifts.UserRegistrationId						AS UserRegistrationId,
			UserRegistration.StaffName							AS StaffName,
			UserRegistration.MobileNumber						AS MobileNumber,
			UserType.UserTypeId									AS UserTypeId,
			UserType.Name										AS UserTypeName,
			0													AS AccessLevelId,
			cast('' as nvarchar(50))							AS AccessLevelValue,
			Designation.UserDesignationId						AS UserDesignationId,
			Designation.Designation								AS DesignationName,
			UserShifts.LunchTimeLovId							AS LunchTimeLovId,
			UserShifts.ShiftTimeLovId							AS ShiftTimeLovId,
			LunchTimeLovId.FieldValue							AS LunchTimeLovValue,
			UserShifts.Timestamp								AS Timestamp,
			UserShifts.ShiftStartTime	,		
			UserShifts.ShiftStartTimeMin,		
			UserShifts.ShiftEndTime		,		
			UserShifts.ShiftEndTimeMin	,		
			UserShifts.ShiftBreakStartTime	,	
			UserShifts.ShiftBreakStartTimeMin	,
			UserShifts.ShiftBreakEndTime	,	
			UserShifts.ShiftBreakEndTimeMin				
	FROM	UMUserShifts										AS UserShifts
			INNER JOIN  FMLovMst								AS LunchTimeLovId					WITH(NOLOCK)			on UserShifts.LunchTimeLovId		= LunchTimeLovId.LovId
			INNER JOIN  UMUserRegistration						AS UserRegistration					WITH(NOLOCK)			on UserShifts.UserRegistrationId	= UserRegistration.UserRegistrationId
			INNER JOIN  UMUserType								AS UserType							WITH(NOLOCK)			on UserRegistration.UserTypeId		= UserType.UserTypeId
			INNER JOIN  UserDesignation							AS Designation						WITH(NOLOCK)			on UserRegistration.UserDesignationId = Designation.UserDesignationId
			--INNER JOIN  FMLovMst								AS AccessLevel						WITH(NOLOCK)			on UserRegistration.AccessLevel		= AccessLevel.LovId
	WHERE	UserShifts.UserRegistrationId = @pUserRegistrationId 
	ORDER BY UserShifts.ModifiedDate ASC

		SELECT	
			UserShiftsDet.UserShiftDetId						AS UserShiftDetId,
			UserShifts.UserShiftsId								AS UserShiftsId,
			UserShiftsDet.LeaveFrom								AS LeaveFrom,
			UserShiftsDet.LeaveTo								AS LeaveTo,
			UserShiftsDet.NoOfDays								AS NoOfDays,
			UserShiftsDet.Remarks								AS Remarks,
			UserShifts.Timestamp								AS Timestamp		
	FROM	UMUserShifts										AS UserShifts
			INNER JOIN	UMUserShiftsDet							AS UserShiftsDet					WITH(NOLOCK)			on UserShifts.UserShiftsId			= UserShiftsDet.UserShiftsId
	WHERE	UserShifts.UserRegistrationId = @pUserRegistrationId 
	ORDER BY UserShifts.ModifiedDate ASC


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
