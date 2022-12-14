USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Import_Test]    Script Date: 20-09-2021 17:05:51 ******/
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

CREATE  PROCEDURE  [dbo].[uspFM_EngAsset_Import_Test]
	
			
			@pAssetId						INT	= NULL,
			@pFacilityId					INT = NULL,
			@pAssetClassification			NVARCHAR(1000)  = NULL,
			@pAssetPreRegistrationNo		NVARCHAR(1000)  = NULL,
			@pTypeCode 						NVARCHAR(1000)  = NULL,
			@pModel							NVARCHAR(1000)  = NULL,
			@pManufacturer					NVARCHAR(1000)  = NULL,
			@pCurrentLocationName			NVARCHAR(1000)  = NULL,
			@pAppliedPartType				NVARCHAR(1000)  = NULL

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
			@mAssetPreRegistrationNoId		INT,
			@mTypeCodeId					INT, 				
			@mModelId						INT,					
			@mManufacturerId				INT,			
			@mCurrentLocationNameId			INT,	
			@mUserAreaId         			INT,	
			@mAppliedPartTypeId				INT,			
			@mErrorMessage	  NVARCHAR(500) ='',
			@mLenErrorMsg		      		INT,
			@mPurchaseOrderNo NVARCHAR(500) ='',
			@mPurchaseCost      NUMERIC(13)=null,
			@mPurchaseDate       DATETIME = null,
			@mWarrantyStartDate  DATETIME = null,
			@mWarrantyEndDate    DATETIME = null,
			@mTandCDate          DATETIME = null,
			@mServiceStartDate   DATETIME = null,
			@mWarrantyDuration        int = null
			
-- Default Values


-- Execution

	SET @mAssetClassificationId = (SELECT AssetClassificationId FROM EngAssetClassification WHERE LTRIM(RTRIM(AssetClassificationDescription))	=	LTRIM(RTRIM(@pAssetClassification)))
	
    SET @mTypeCodeId = (SELECT AssetTypeCodeId FROM EngAssetTypeCode WHERE LTRIM(RTRIM(AssetTypeCode))	=	LTRIM(RTRIM(@pTypeCode)) AND AssetClassificationId = @mAssetClassificationId)

	(SELECT TestingandCommissioningDetId,PurchaseOrderNo,PurchaseCost,PurchaseDate,WarrantyStartDate,WarrantyEndDate,WarrantyDuration,TandCDate,ServiceStartDate 
	into #EngTestingandCommissioning from EngTestingandCommissioningTxnDet A INNER JOIN EngTestingandCommissioningTxn B ON A.TestingandCommissioningId = B.TestingandCommissioningId
	WHERE LTRIM(RTRIM(AssetPreRegistrationNo))	=	LTRIM(RTRIM(@pAssetPreRegistrationNo)) AND B.AssetTypeCodeId = @mTypeCodeId)

	SET @mAssetPreRegistrationNoId = (SELECT TestingandCommissioningDetId FROM #EngTestingandCommissioning);

	SET @mPurchaseOrderNo = (SELECT PurchaseOrderNo FROM #EngTestingandCommissioning);
	SET @mPurchaseCost = (SELECT PurchaseCost FROM #EngTestingandCommissioning);
	SET @mPurchaseDate = (SELECT PurchaseDate FROM #EngTestingandCommissioning);
	SET @mWarrantyStartDate = (SELECT WarrantyStartDate FROM #EngTestingandCommissioning);
	SET @mWarrantyEndDate = (SELECT WarrantyEndDate FROM #EngTestingandCommissioning);
	SET @mTandCDate = (SELECT TandCDate FROM #EngTestingandCommissioning);
	SET @mServiceStartDate = (SELECT ServiceStartDate FROM #EngTestingandCommissioning);
	SET @mWarrantyDuration = (SELECT WarrantyDuration FROM #EngTestingandCommissioning);


	SET @mModelId = (SELECT A.ModelId FROM EngAssetStandardizationModel A INNER JOIN EngAssetStandardization B ON A.ModelId = B.ModelId  
	WHERE LTRIM(RTRIM(A.Model))	=	LTRIM(RTRIM(@pModel)) AND B.AssetTypeCodeId = @mTypeCodeId);

	SET @mManufacturerId = (SELECT A.ManufacturerId FROM EngAssetStandardizationManufacturer A INNER JOIN EngAssetStandardization B ON A.ManufacturerId = B.ManufacturerId  
	WHERE LTRIM(RTRIM(A.Manufacturer))	=	LTRIM(RTRIM(@pManufacturer)) AND B.AssetTypeCodeId = @mTypeCodeId);


	SET @mCurrentLocationNameId = (SELECT UserLocationId FROM MstLocationUserLocation WHERE LTRIM(RTRIM(UserLocationName))	=	LTRIM(RTRIM(@pCurrentLocationName)) AND FacilityId = @pFacilityId);
	SET @mUserAreaId = (SELECT UserAreaId FROM MstLocationUserLocation WHERE LTRIM(RTRIM(UserLocationName))	=	LTRIM(RTRIM(@pCurrentLocationName)) AND FacilityId = @pFacilityId);

	SET @mAppliedPartTypeId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pAppliedPartType)) AND LovKey='AppliedPartTypeValue');

	

	IF (ISNULL(@mAssetClassificationId,0)=0)
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset Classification' ErrorMessage)

		END
	
	IF (ISNULL(@mAssetPreRegistrationNoId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset Pre Registration No.' ErrorMessage)
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

	IF (ISNULL(@mCurrentLocationNameId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Current Location Name' ErrorMessage)
	END

	--IF (ISNULL(@mAppliedPartTypeId,0)=0)
	--BEGIN
	--	SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Applied Part Type' ErrorMessage)
	--END


	SET @mLenErrorMsg = LEN(@mErrorMessage)

			SELECT	 
			@mAssetClassificationId					     AS AssetClassificationId,	
			@mAssetPreRegistrationNoId				     AS AssetPreRegistrationNoId,	
			@mTypeCodeId							     AS TypeCodeId,				
			@mModelId								     AS ModelId,					
			@mManufacturerId						     AS ManufacturerId,			
			@mCurrentLocationNameId					     AS CurrentLocationNameId,		
			@mAppliedPartTypeId						     AS AppliedPartTypeId,			
			@mPurchaseOrderNo                            AS PurchaseOrderNo,   
			@mPurchaseCost                               AS PurchaseCost,          
			@mPurchaseDate     		                     AS PurchaseDate,     
			@mWarrantyStartDate                          AS WarrantyStartDate,   
			@mWarrantyEndDate                            AS WarrantyEndDate,       
			@mTandCDate                                  AS TandCDate,            
			@mServiceStartDate                           AS ServiceStartDate,     
			@mWarrantyDuration                           AS WarrantyDuration,    
			@mUserAreaId                                 AS UserAreaId,  
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
