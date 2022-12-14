USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Import]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockUpdateRegisterTxn_Import
Description			: If Stock Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_EngAsset_Import] @pAssetId=null,@pFacilityId=1,@pAssetClassification='asdasd',@pAssetPreRegistrationNo='BEMS/TC/210',@pTypeCode='typecode12',
@pModel='Splendor2',@pManufacturer= 'New Manufacturer 1 Biju',@pCurrentLocationName='asdsadadsd',@pAppliedPartType='B'
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_EngAsset_Import]
			
				
				@pFacilityId					INT = NULL,
				@pAssetClassification			NVARCHAR(1000)  = NULL,
				@pAssetPreRegistrationNo		NVARCHAR(1000)  = NULL,				
				@pTypeCode 						NVARCHAR(1000)  = NULL,
				@pModel							NVARCHAR(1000)  = NULL,
				@pManufacturer					NVARCHAR(1000)  = NULL,
				@pCurrentLocationName			NVARCHAR(1000)  = NULL,
				--@pAppliedPartType				NVARCHAR(1000)  = NULL
				@pContractType					NVARCHAR(1000)  = NULL,
				@pRequestorName					NVARCHAR(1000)  = NULL,
				@pAssignee					    NVARCHAR(1000)  = NULL,
				@pVariationStatus				NVARCHAR(1000)  = NULL,
				@pCompanyRepresentative		    NVARCHAR(1000)  = NULL,
				@pFacilityRepresentative	    NVARCHAR(1000)  = NULL,
				@pVendorName					NVARCHAR(1000)  = NULL
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE	@mAssetClassificationId			INT,
			--@mAssetPreRegistrationNoId		INT,
			@mTypeCodeId					INT, 				
			@mModelId						INT,					
			@mManufacturerId				INT,			
			@mCurrentLocationNameId			INT,	
			@mUserAreaId         			INT,	
			--@mAppliedPartTypeId				INT,			
			@mErrorMessage	  NVARCHAR(500) ='',
			@mLenErrorMsg		      		INT,
			@mPurchaseOrderNo NVARCHAR(500) ='',
			@mPurchaseCost      NUMERIC(13)=null,
			@mPurchaseDate       DATETIME = null,
			@mWarrantyStartDate  DATETIME = null,
			@mWarrantyEndDate    DATETIME = null,
			@mTandCDate          DATETIME = null,
			@mServiceStartDate   DATETIME = null,
			
			@mSerialNo			NVARCHAR(500) ='',
			@mContractTypeId		  INT = null, 
			@mWarrantyDuration        int = null,
			@mVariationStatus		  int = null,
			@mCompanyRepresentative	  int = null,
			@mFacilityRepresentative			int = null,
			-- CRM 
			@mRequestorId			int = null , 
			@mAssigneeId			int = null ,
			@mContractorId			INT = NULL
-- Default Values


-- Execution

	SET @mAssetClassificationId = (SELECT AssetClassificationId FROM EngAssetClassification WHERE LTRIM(RTRIM(AssetClassificationCode))	=	LTRIM(RTRIM(@pAssetClassification)))
	
    SET @mTypeCodeId = (SELECT AssetTypeCodeId FROM EngAssetTypeCode WHERE LTRIM(RTRIM(AssetTypeCode))	=	LTRIM(RTRIM(@pTypeCode)) AND AssetClassificationId = @mAssetClassificationId)

	(SELECT TestingandCommissioningDetId,PurchaseOrderNo,PurchaseCost,PurchaseDate,WarrantyStartDate,WarrantyEndDate,WarrantyDuration,TandCDate,ServiceStartDate 
	,SerialNo
	
	into #EngTestingandCommissioning 
	from EngTestingandCommissioningTxnDet A 
	INNER JOIN EngTestingandCommissioningTxn B ON A.TestingandCommissioningId = B.TestingandCommissioningId
	WHERE LTRIM(RTRIM(AssetPreRegistrationNo))	=	LTRIM(RTRIM(@pAssetPreRegistrationNo)) AND B.AssetTypeCodeId = @mTypeCodeId)

	--SET @mAssetPreRegistrationNoId = (SELECT TestingandCommissioningDetId FROM #EngTestingandCommissioning);
	

	
	SET @mModelId = (SELECT top 1 A.ModelId FROM EngAssetStandardizationModel A INNER JOIN EngAssetStandardization B ON A.ModelId = B.ModelId  
	WHERE LTRIM(RTRIM(A.Model))	=	LTRIM(RTRIM(@pModel)) AND B.AssetTypeCodeId = @mTypeCodeId);
	
	SET @mManufacturerId = (SELECT top 1 A.ManufacturerId FROM EngAssetStandardizationManufacturer A
	 INNER JOIN EngAssetStandardization B ON A.ManufacturerId = B.ManufacturerId  
	WHERE LTRIM(RTRIM(A.Manufacturer))	=	LTRIM(RTRIM(@pManufacturer)) 
	--AND B.AssetTypeCodeId = @mTypeCodeId
	);


	SET @mRequestorId = (Select top 1 UserRegistrationId from UMUserRegistration where UserName= @pRequestorName or StaffName= @pRequestorName)
	SET @mAssigneeId = (Select top 1 UserRegistrationId from UMUserRegistration where UserName= @pAssignee or StaffName= @pRequestorName)
	SET @mCompanyRepresentative = (Select top 1 UserRegistrationId from UMUserRegistration where UserName= @pCompanyRepresentative or StaffName= @pRequestorName)
	SET @mFacilityRepresentative = (Select top 1 UserRegistrationId from UMUserRegistration where UserName= @pFacilityRepresentative or StaffName= @pRequestorName)
	--SET @mVariationStatus = (Select top 1 UserRegistrationId from UMUserRegistration where StaffName= @pVariationStatus)

	SET @mVariationStatus= (Select  LovId from FMLovMst where FieldValue= @pVariationStatus)
	SET @mCurrentLocationNameId = (SELECT UserLocationId FROM MstLocationUserLocation 
	WHERE LTRIM(RTRIM(UserLocationName))	=	LTRIM(RTRIM(@pCurrentLocationName)) AND FacilityId = @pFacilityId);
	SET @mUserAreaId = (SELECT UserAreaId FROM MstLocationUserLocation WHERE LTRIM(RTRIM(UserLocationName))	=	LTRIM(RTRIM(@pCurrentLocationName)) AND FacilityId = @pFacilityId);

	--SET @mAppliedPartTypeId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pAppliedPartType)) AND LovKey='AppliedPartTypeValue');

	SET @mContractTypeId = (select top 1 Lovid from FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pContractType)) and lovid > 200);

	SET @mContractorId = (Select top 1 ContractorId from MstContractorandVendor where LTRIM(RTRIM(ContractorName))	=	LTRIM(RTRIM(@pVendorName)))


	IF (ISNULL(@mAssetClassificationId,0)=0)
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset Classification' ErrorMessage)

		END
	
	

	IF (ISNULL(@mTypeCodeId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset Type Code' ErrorMessage)
	END

	IF (ISNULL(@mModelId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Model Name' ErrorMessage)
	END

	IF (ISNULL(@mManufacturerId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Manufacturer Name' ErrorMessage)
	END

	IF (ISNULL(@mRequestorId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Requestor Name' ErrorMessage)
	END
	IF (ISNULL(@mAssigneeId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asignee Name' ErrorMessage)
	END
	IF (ISNULL(@mCurrentLocationNameId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Current Location Name' ErrorMessage)
	END
	IF (ISNULL(@mVariationStatus,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Variation Status' ErrorMessage)
	END
	IF (ISNULL(@mFacilityRepresentative,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Facility Representative Name' ErrorMessage)
	END
	IF (ISNULL(@mCompanyRepresentative,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Company Representative  Name' ErrorMessage)
	END
	--IF (ISNULL(@mContractorId,0)=0)
	--BEGIN
	--	SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Vendor Name' ErrorMessage)
	--END
	IF (ISNULL(@mContractTypeId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Contractor Type' ErrorMessage)
	END
	--IF (ISNULL(@mAppliedPartTypeId,0)=0)
	--BEGIN
	--	SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Applied Part Type' ErrorMessage)
	--END


	SET @mLenErrorMsg = LEN(@mErrorMessage)

			SELECT	 
			@mAssetClassificationId					     AS AssetClassificationId,	
			--@mAssetPreRegistrationNoId				     AS AssetPreRegistrationNoId,	
			@mTypeCodeId							     AS TypeCodeId,				
			@mModelId								     AS ModelId,					
			@mManufacturerId						     AS ManufacturerId,			
			@mCurrentLocationNameId					     AS CurrentLocationNameId,		
			--@mAppliedPartTypeId						     AS AppliedPartTypeId,			
			@mPurchaseOrderNo                            AS PurchaseOrderNo,   
			@mPurchaseCost                               AS PurchaseCost,          
			@mPurchaseDate     		                     AS PurchaseDate,     
			@mWarrantyStartDate                          AS WarrantyStartDate,   
			@mWarrantyEndDate                            AS WarrantyEndDate,       
			@mTandCDate                                  AS TandCDate,            
			@mServiceStartDate                           AS ServiceStartDate,     
			@mWarrantyDuration                           AS WarrantyDuration,    
			@mUserAreaId                                 AS UserAreaId, 
			@mSerialNo									 AS SerialNo ,
			@mContractTypeId						     AS ContractTypeId,
			@mRequestorId								 AS RequestorId,
			@mAssigneeId								 AS AssigneeId,
			@mVariationStatus							 AS VariationStatus	,	
			@mCompanyRepresentative						 AS CompanyRepresentative,
			@mFacilityRepresentative					 AS FacilityRepresentative,
			@mContractorId							     AS ContractorId,
			SUBSTRING(@mErrorMessage,3,@mLenErrorMsg)	 AS ErrorMessage


	
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
		   );
		   THROW;

END CATCH
GO
