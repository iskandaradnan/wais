USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstStaff_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstStaff_Save
Description			: If staff already exists then update else insert.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC UspFM_MstStaff_Save  @pStaffMasterId=0,@pCustomerId=1,@pFacilityId=2,@pUserRegistrationId=null,@pAccessLevel=10,
@pStaffEmployeeId='Test103',@pStaffName='TestStaff3',@pStaffRoleId=1,@pDesignationId=1,@pStaffCompetencyId=1,
@pStaffSpecialityId=1,@pStaffGraded=1,@pEmployeeTypeLovId=11,@pIsEmployeeShared=0,@pGender=3,@pNationality=1,@pEmail='test@ptest.com',@pContactNo='1234',
@pActive=1,@pBuiltIn=1,@pCreatedBy=1,@pModifiedBy=1

select * from MstStaff
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Dhilip V Date       :02-April-2018 Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstStaff_Save]
	@pStaffMasterId				INT,                     
	@pCustomerId				INT,
	@pFacilityId				INT,
	@pUserRegistrationId		INT				=	NULL,
	@pAccessLevel				INT,
	@pStaffEmployeeId			NVARCHAR(50),
	@pStaffName					NVARCHAR(100),
	@pStaffRoleId				INT,
	@pDesignationId				INT				=	NULL,
	@pStaffCompetencyId			NVARCHAR(100)	=	NULL,
	@pStaffSpecialityId			NVARCHAR(100)	=	NULL,
	@pStaffGraded				INT				=	NULL,
	@pStaffDepartmentId			INT				=	NULL,
	@pPersonalIdentityTypeLovId INT				=	1,
	@pPersonalUniqueId			NVARCHAR(100)	=	'ID101',
	@pEmployeeTypeLovId			INT				=	NULL,
	@pIsEmployeeShared			INT				=	NULL,
	@pGender					INT,
	@pNationality				INT,
	@pEmail						NVARCHAR(100),
	@pContactNo					NVARCHAR(50),
	@pActive					INT				=	1,
	@pBuiltIn					INT				=	1,
	@pCreatedBy					INT,
	@pModifiedBy				INT
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

   

	IF (ISNULL(@pStaffMasterId,0)>0)
		BEGIN
			UPDATE MstStaff SET	CustomerId					=	@pCustomerId,
								FacilityId					=	@pFacilityId,
								UserRegistrationId			=	@pUserRegistrationId,
								AccessLevel					=	@pAccessLevel,
								--StaffEmployeeId				=	@pStaffEmployeeId,
								StaffName					=	@pStaffName,
								StaffRoleId					=	@pStaffRoleId,
								DesignationId				=	@pDesignationId,
								StaffCompetencyId			=	@pStaffCompetencyId,
								StaffSpecialityId			=	@pStaffSpecialityId,
								StaffGraded					=	@pStaffGraded,
								StaffDepartmentId			=	@pStaffDepartmentId,
								PersonalIdentityTypeLovId	=	@pPersonalIdentityTypeLovId,
								PersonalUniqueId			=	@pPersonalUniqueId,
								EmployeeTypeLovId			=	@pEmployeeTypeLovId,
								IsEmployeeShared			=	@pIsEmployeeShared,
								Gender						=	@pGender,
								Nationality					=	@pNationality,
								Email						=	@pEmail,
								ContactNo					=	@pContactNo,
								Active						=	@pActive,
								ModifiedBy					=	@pModifiedBy,
								ModifiedDate				=	GETDATE(),
								ModifiedDateUTC				=	GETUTCDATE()
						WHERE	StaffMasterId				=	@pStaffMasterId

					SELECT StaffMasterId, 
							[Timestamp] 
					FROM MstStaff WITH(NOLOCK)
					WHERE StaffMasterId = @pStaffMasterId
		END
	ELSE
		BEGIN
			INSERT INTO MstStaff(	CustomerId,
									FacilityId,
									UserRegistrationId,
									AccessLevel,
									StaffEmployeeId,
									StaffName,
									StaffRoleId,
									DesignationId,
									StaffCompetencyId,
									StaffSpecialityId,
									StaffGraded,
									StaffDepartmentId,
									PersonalIdentityTypeLovId,
									PersonalUniqueId,
									EmployeeTypeLovId,
									IsEmployeeShared,
									Gender,
									Nationality,
									Email,
									ContactNo,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC,
									Active,
									BuiltIn
								)	OUTPUT INSERTED.StaffMasterId INTO @Table
								VALUES
								(	@pCustomerId,
									@pFacilityId,
									@pUserRegistrationId,
									@pAccessLevel,
									@pStaffEmployeeId,
									@pStaffName,
									@pStaffRoleId,
									@pDesignationId,
									@pStaffCompetencyId,
									@pStaffSpecialityId,
									@pStaffGraded,
									@pStaffDepartmentId,
									@pPersonalIdentityTypeLovId,
									@pPersonalUniqueId,
									@pEmployeeTypeLovId,
									@pIsEmployeeShared,
									@pGender,
									@pNationality,
									@pEmail,
									@pContactNo,
									@pCreatedBy,
									GETDATE(),
									GETUTCDATE(),
									@pModifiedBy,
									GETDATE(),
									GETUTCDATE(),
									@pActive,
									@pBuiltIn
								)
		END

		SELECT	StaffMasterId, 
				[Timestamp] 
		FROM MstStaff WITH(NOLOCK)
		WHERE StaffMasterId IN (SELECT ID FROM @Table)

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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
