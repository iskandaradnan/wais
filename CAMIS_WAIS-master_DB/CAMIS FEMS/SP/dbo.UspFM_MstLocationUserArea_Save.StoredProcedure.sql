USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserArea_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSupplierWarranty_Save
Description			: If User Area Code already exists then update else insert.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationUserArea_Save  @pUserAreaId='',@CustomerId=1,@FacilityId=1,@BlockId=1,@LevelId=2,@UserAreaCode='AAA',@UserAreaName='AAA'
,@CompanyStaffId=24,@HospitalStaffId=25,@ActiveFromDate='2018-04-05 15:23:36.317',@ActiveFromDateUTC='2018-04-05 09:54:01.900',@ActiveToDate=''		
,@ActiveToDateUTC='',@Remarks='',@CreatedBy=2,@ModifiedBy=2,@Active='',@BuiltIn=''
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_MstLocationUserArea_Save]
	
         @UserAreaId	    INT=NULL,		
         @UserAreaCode		NVARCHAR(100)=null,
         @UserAreaName		NVARCHAR(100)=null,
         @LevelId			INT=NULL,
         @CustomerId		INT=NULL,
         @BlockId			INT=NULL,
         @FacilityId		INT=NULL,
         @Active		    bit ,
         @HospitalStaffId	INT=NULL,
         @CompanyStaffId	INT=NULL,
         @Remarks			NVARCHAR(1000)=null,
         @UserId			INT=null  ,
		@ActiveFromDate		DATETIME = null,
		@ActiveFromDateUTC	DATETIME = null,
		@ActiveToDate		DATETIME = null,
		@ActiveToDateUTC	DATETIME = null
		--@pQRCode			VARBINARY(MAX)	=NULL
		
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
 

	IF EXISTS (SELECT 1 FROM MstLocationUserArea WITH(NOLOCK) WHERE UserAreaId=@UserAreaId)

		BEGIN
		
		DECLARE	   @mStatus NVARCHAR(1000)
		DECLARE    @mLastUpdatedBy NVARCHAR(1000)
		DECLARE    @mDepartmentHead NVARCHAR(1000)
		DECLARE    @mCompanyRepresentative NVARCHAR(1000)
		SET		   @mStatus = (SELECT CASE when Active = 1 then 'Active' else case when Active = 0 then 'Inactive' END END as Status FROM  MstLocationUserArea where UserAreaId =@UserAreaId)
		SET		   @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationUserArea B on A.UserRegistrationId = B.ModifiedBy WHERE B.UserAreaId =@UserAreaId )	
		SET		   @mDepartmentHead = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationUserArea B on A.UserRegistrationId = B.FacilityUserId WHERE B.UserAreaId =@UserAreaId)	
		SET		   @mCompanyRepresentative = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationUserArea B on A.UserRegistrationId = B.CustomerUserId WHERE B.UserAreaId =@UserAreaId)	
		insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)
		select 'MstLocationUserArea',GuId,(SELECT @mStatus AS Status,UserArea.ActiveFromDate AS ServiceStartDate,UserArea.ActiveToDate as StopServiceDate, @mDepartmentHead as [Department/UnitIncharge], @mCompanyRepresentative as CompanyRepresentative,
		UserArea.Remarks
		FROM MstLocationUserArea UserArea
		where UserArea.UserAreaId =@UserAreaId
		FOR JSON AUTO),GETDATE(),GETUTCDATE() from MstLocationUserArea b1 where UserAreaId =@UserAreaId
		and Not  ( isnull(ActiveFromDate,'')=isnull(@ActiveFromDate,'') and  isnull(ActiveToDate,'')=isnull(@ActiveToDate,'')  and isnull(Active,'')= isnull(@Active,'') 
		and isnull(CustomerUserId,'') =isnull(@CompanyStaffId,'') and isnull( FacilityUserId ,'')=isnull(@HospitalStaffId,'') )
					
			UPDATE MstLocationUserArea SET	
								
							UserAreaName								=@UserAreaName,
							ActiveFromDate								= @ActiveFromDate,			
							ActiveFromDateUTC							= @ActiveFromDateUTC,		
							ActiveToDate								= @ActiveToDate,		
							ActiveToDateUTC								= @ActiveToDateUTC,		
							Remarks										= @Remarks,				
							CreatedBy									= @UserId,				
							ModifiedBy									= @UserId,				
							Active										= @Active,					
											
							ModifiedDate								= GETDATE(),
							ModifiedDateUTC								= GETUTCDATE()
					WHERE	UserAreaId									= @UserAreaId

			--INSERT INTO MstLocationUserAreaHistory (	UserAreaId,
			--											ActiveFromDate,
			--											ActiveFromDateUTC,
			--											ActiveToDate,
			--											ActiveToDateUTC,
			--											Remarks,
			--											CreatedBy,
			--											CreatedDate,
			--											CreatedDateUTC,
			--											ModifiedBy,
			--											ModifiedDate,
			--											ModifiedDateUTC
			--										)
			--								VALUES	(	@UserAreaId,
			--											@ActiveFromDate,
			--											@ActiveFromDateUTC,
			--											@ActiveToDate,
			--											@ActiveToDateUTC,
			--											@Remarks,
			--											@UserId,
			--											GETDATE(),
			--											GETUTCDATE(),
			--											@UserId,
			--											GETDATE(),
			--											GETUTCDATE()
			--										)

					SELECT	UserAreaId,
				[Timestamp],
				'' AS	ErrorMessage,
					GuId, UserAreaCode
		FROM	MstLocationUserArea
		WHERE	UserAreaId= @UserAreaId
		END

	ELSE

		BEGIN
			INSERT INTO MstLocationUserArea(

								
								CustomerId,
								FacilityId,
								BlockId,
								LevelId,
								UserAreaCode,
								UserAreaName,
								CustomerUserId,
								FacilityUserId,
								ActiveFromDate,
								ActiveFromDateUTC,
								ActiveToDate,
								ActiveToDateUTC,
								Remarks,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC,
								Active
											
																						
							
							)	OUTPUT INSERTED.UserAreaId INTO @Table
							VALUES
							(
							 @CustomerId,
							 @FacilityId,
							 @BlockId,
							 @LevelId,
							 @UserAreaCode,
							 @UserAreaName,
							 @CompanyStaffId,
							 @HospitalStaffId,
							 @ActiveFromDate,
							 @ActiveFromDateUTC,
							 @ActiveToDate,
							 @ActiveToDateUTC,
							 @Remarks,
							 @UserId,
							 GETDATE(),
							 GETUTCDATE(),
							 @UserId,
							 GETDATE(),
							 GETUTCDATE(),
							 @Active
							-- @pQRCode

							)
	--DECLARE @mPrimaryId INT 
	--SET @mPrimaryId = (SELECT ID FROM @Table)

	--		INSERT INTO MstLocationUserAreaHistory (	UserAreaId,
	--													ActiveFromDate,
	--													ActiveFromDateUTC,
	--													ActiveToDate,
	--													ActiveToDateUTC,
	--													Remarks,
	--													CreatedBy,
	--													CreatedDate,
	--													CreatedDateUTC,
	--													ModifiedBy,
	--													ModifiedDate,
	--													ModifiedDateUTC
	--												)
	--										VALUES	(	@mPrimaryId,
	--													@ActiveFromDate,
	--													@ActiveFromDateUTC,
	--													@ActiveToDate,
	--													@ActiveToDateUTC,
	--													@Remarks,
	--													@UserId,
	--													GETDATE(),
	--													GETUTCDATE(),
	--													@UserId,
	--													GETDATE(),
	--													GETUTCDATE()
	--												)


				SELECT	UserAreaId,
					'' AS	ErrorMessage,
					GuId,
				[Timestamp],UserAreaCode
		FROM	MstLocationUserArea
		WHERE	UserAreaId IN (SELECT ID FROM @Table)
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
