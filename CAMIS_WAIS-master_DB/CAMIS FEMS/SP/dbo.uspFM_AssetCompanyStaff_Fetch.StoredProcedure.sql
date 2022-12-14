USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_AssetCompanyStaff_Fetch]    Script Date: 20-09-2021 16:56:52 ******/
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

CREATE PROCEDURE  [dbo].[uspFM_AssetCompanyStaff_Fetch]                           
  --@pUserId			INT	=	NULL,
  @pAssetId		INT,
  @pRequestorId INT	=	NULL,
  @pLoanerTestEquipmentBookingId INT	=	NULL


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT,@mIsExtension BIT,@mAssetId INT,@mEndDate DATETIME,@mCurrDate DATETIME


	IF(ISNULL(@pAssetId,0) = 0) RETURN
	

	select a.AssetNo,b.StaffName, b.Email from EngAsset a
	
	left join UMUserRegistration b on a.CompanyStaffId = b.UserRegistrationId 
	 where a.AssetId=@pAssetId
	     

    select top 1  b.StaffName, b.Email from EngLoanerTestEquipmentBookingTxn a
	
	left join UMUserRegistration b on a.RequestorId = b.UserRegistrationId 
	 where a.LoanerTestEquipmentBookingId=@pLoanerTestEquipmentBookingId




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
