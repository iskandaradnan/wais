USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserLocation_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_MstLocationUserLocation_Save

Description			: If User Location Code already exists then update else insert.

Authors				: Balaji M S

Date				: 04-April-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

EXEC uspFM_MstLocationUserLocation_Save  @pUserLocationId ='',@CustomerId='1',@FacilityId='1',@BlockId='1',@LevelId='3',@UserAreaId='2',@UserLocationCode='AAAA'		

,@UserLocationName='AAAA',@ActiveFromDate='2018-04-05 17:01:56.990',@ActiveFromDateUTC='2018-04-05 11:32:08.857',@ActiveToDate='',@ActiveToDateUTC='',	

@AuthorizedStaffId='26'	@Remarks='',@CreatedBy=2,@ModifiedBy=2,@Active='1',@BuiltIn='1'				



-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init :  Date       : Details

========================================================================================================*/



CREATE PROCEDURE  [dbo].[UspFM_MstLocationUserLocation_Save]

	

		@pUserLocationId						INT = null,

		@CustomerId								INT = null,

		@FacilityId								INT = null,

		@BlockId								INT = null,

		@LevelId								INT = null,

		@UserAreaId								INT = null,

		@UserLocationCode						NVARCHAR(150) = null,

		@UserLocationName						NVARCHAR(200) = null,

		@ActiveFromDate							DATETIME = null,

		@ActiveFromDateUTC						DATETIME = null,

		@ActiveToDate							DATETIME = null,

		@ActiveToDateUTC						DATETIME = null,

		@AuthorizedStaffId						INT = null,

		@UserId								    INT= null,				

		@Active									Bit	,

		@CompanyStaffId						INT=NULL	

	--	@pQRCode								VARBINARY(MAX)	=NULL			

		

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

 



	IF EXISTS (SELECT 1 FROM MstLocationUserLocation WITH(NOLOCK) WHERE UserLocationId=@pUserLocationId)



		BEGIN





		DECLARE	   @mStatus NVARCHAR(1000)

		DECLARE    @mLastUpdatedBy NVARCHAR(1000)

		DECLARE    @mAuthorizedPerson NVARCHAR(1000)

		

		SET		   @mStatus = (SELECT CASE when Active = 1 then 'Active' else case when Active = 0 then 'Inactive' END END as Status FROM  MstLocationUserLocation where UserLocationId =@pUserLocationId)

		SET		   @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationUserLocation B on A.UserRegistrationId = B.ModifiedBy WHERE B.UserLocationId =@pUserLocationId )	

		SET		   @mAuthorizedPerson = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationUserLocation B on A.UserRegistrationId = B.AuthorizedUserId WHERE B.UserLocationId =@pUserLocationId)	

		
		
		insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)

		select 'MstLocationUserLocation',GuId,(SELECT @mStatus AS Status,UserLocation.ActiveFromDate, @mAuthorizedPerson as  LocationIncharge

		FROM MstLocationUserLocation UserLocation

		where UserLocation.UserLocationId =@pUserLocationId

		FOR JSON AUTO),GETDATE(),GETUTCDATE() from MstLocationUserLocation where UserLocationId =@pUserLocationId
		and Not  ( isnull(ActiveFromDate,'')=isnull(@ActiveFromDate,'') and isnull(Active,'')= isnull(@Active,'') and isnull(AuthorizedUserId,'')=isnull(@AuthorizedStaffId,''))






			UPDATE MstLocationUserLocation SET								

						

							ActiveFromDate								=@ActiveFromDate,

							ActiveFromDateUTC							=@ActiveFromDateUTC,

							ActiveToDate								=@ActiveToDate,

							ActiveToDateUTC								=@ActiveToDateUTC,

							AuthorizedUserId							=@AuthorizedStaffId,

							--Remarks										=@Remarks,							

							ModifiedBy									=@UserId,

							ModifiedDate								=GETDATE(),

							ModifiedDateUTC								=GETUTCDATE(),

							CompanyStaffId								=@CompanyStaffId,

						   Active = @Active

					WHERE	UserLocationId=@pUserLocationId

						

							SELECT	UserLocationId,

				[Timestamp],GuId, UserLocationCode

		FROM	MstLocationUserLocation

		WHERE	UserLocationId =@pUserLocationId

		END



	ELSE



		BEGIN

			INSERT INTO MstLocationUserLocation(

								

								CustomerId,

								FacilityId,

								BlockId,

								LevelId,

								UserAreaId,

								UserLocationCode,

								UserLocationName,

								ActiveFromDate,

								ActiveFromDateUTC,

								ActiveToDate,

								ActiveToDateUTC,

								AuthorizedUserId,

							

								CreatedBy,

								CreatedDate,

								CreatedDateUTC,

								ModifiedBy,

								ModifiedDate,

								ModifiedDateUTC,

								Active		,

								CompanyStaffId

							--	QRCode				

							

							)	OUTPUT INSERTED.UserLocationId INTO @Table

							VALUES

							(

							 @CustomerId,

							 @FacilityId,

							 @BlockId,

							 @LevelId,

							 @UserAreaId,

							 @UserLocationCode,

							 @UserLocationName,

							 @ActiveFromDate,

							 @ActiveFromDateUTC,

							 @ActiveToDate,

							 @ActiveToDateUTC,

							 @AuthorizedStaffId,

														 

							 @UserId,

							 GETDATE(),

							 GETUTCDATE(),

							 @UserId,

							 GETDATE(),

							 GETUTCDATE(),

							 @Active,

							 @CompanyStaffId

							)

									

									SELECT	UserLocationId,

				[Timestamp],GuId, UserLocationCode

		FROM	MstLocationUserLocation

		WHERE	UserLocationId IN (SELECT ID FROM @Table)

		END







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
