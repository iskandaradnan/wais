USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRegistration_Export]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserRegistration_Export
Description			: Get all Registered Users.
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMUserRegistration_Export  @StrCondition='',@StrSorting=null,@UserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_UMUserRegistration_Export]


	@StrCondition	NVARCHAR(MAX)	= NULL,
	@StrSorting		NVARCHAR(MAX)	= NULL,
	@UserId			INT				= null

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values


-- Execution


SET @qry = '

declare @UserTypeId  int
	SELECT  distinct UserLoc.FacilityId,UserReg.UserTypeId into #FacilityAccesslist 
	FROM	UMUserRegistration					AS UserReg		WITH(NOLOCK)			
			INNER JOIN UMUserLocationMstDet		AS UserLoc		WITH(NOLOCK) ON UserReg.UserRegistrationId	= UserLoc.UserRegistrationId
		where UserReg.UserRegistrationId = ' + cast( @UserId as varchar(50)) + ' 

select top 1  @UserTypeId=UserTypeId from #FacilityAccesslist

select distinct u.UserRegistrationId  into #tUserRegistration1 from  UMUserLocationMstDet u
Left  join #FacilityAccesslist					AS UserReg		WITH(NOLOCK) ON UserReg.FacilityId	= u.FacilityId
where UserReg.FacilityId is null
select distinct u.UserRegistrationId  into #tUserRegistration from  UMUserLocationMstDet u
inner join UMUserRegistration					AS UserReg		WITH(NOLOCK) ON UserReg.UserRegistrationId	= u.UserRegistrationId
 where  u.FacilityId in (select FacilityId from  #FacilityAccesslist )
 and  not exists (select 1 from  #tUserRegistration1 t1  where t1.UserRegistrationId = u.UserRegistrationId)
and  ( (@UserTypeId=5   ) or (@UserTypeId=3  and UserReg.UserTypeId not in (3,5) )
 or (@UserTypeId in (1,2,4)  and 1=0 )
)

SELECT	StaffName,
					UserName Username,
					Gender,
					[PhoneNo.],
					Email,
					[MobileNo.],
					[DateOfJoining],
					UserTypeValue	AS	LoginUserType,
					StatusValue		AS	Status,
					Designation,
					Nationality,
					Grade,
					Competency	AS	Competency,
					Speciality,
					Department,
					ContractorName,
					CenterPool as CentralPool,
					CustomerName	AS	Customer,
					LocationName	AS	Facility,
					UserRole		AS	UserRole,
					LabourCostPerHour
			FROM [V_UMUserRegistration_Export] v
			WHERE 1 = 1 
			and exists (select 1 from #tUserRegistration  t where v.UserRegistrationId = t.UserRegistrationId) ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'v.ModifiedDateUTC DESC')

print @qry;
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
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
