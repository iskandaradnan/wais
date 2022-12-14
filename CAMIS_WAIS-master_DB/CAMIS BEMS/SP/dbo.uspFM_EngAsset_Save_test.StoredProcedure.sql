USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Save_test]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAsset_Save
Description			: If aSSET already exists then update else insert.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

-- Insert
EXEC uspFM_EngAsset_Save  @pAssetId	=0,@pUserId=2,@pCustomerId='1',@pFacilityId='1',@pServiceId='2',@pWorkGroupId='1',@pAssetClassification='1',@pIsAssetOld='1',@pQRCode=NULL
,@pAssetPreRegistrationNo='',@pAssetNo='0014654656',@pAssetNoOld='0014654656',@pAssetDescription='Xray Machine',@pAssetTypeCodeId=4,@pCommissioningDate='2018-04-07'
,@pServiceStartDate='2018-04-07 11:20:51.830',@pServiceStartDateUTC='2018-04-07 05:51:54.977',@pEffectiveDate='2018-04-07 11:22:17.760',@pEffectiveDateUTC='2018-04-07 05:52:17.760'
,@pExpectedLifespan=10,@pAssetStatusLovId=1,@pRealTimeStatusLovId='',@pOperatingHours='0',@pImage1FMDocumentId='',@pImage2FMDocumentId='',@pImage3FMDocumentId=''
,@pImage4FMDocumentId='',@pVedioFMDocumentId='',@pUserAreaId=null,@pUserLocationId=null,@pManufacturer='2',@pModel='1',@pAppliedPartTypeLovId='',@pEquipmentClassLovId=''
,@pSerialNo='A001dfu',@pRiskRating='',@pMainSupplier='ABC Limited',@pManufacturingDate='2018-04-07 11:25:32.937',@pManufacturingDateUTC='2018-04-07 05:55:32.937'
,@pSpecificationUnit='',@pPowerSpecification='0',@pVolt='0',@pPpmPlannerId='1',@pRiPlannerId='0',@pOtherPlannerId='0',@pPurchaseCostRM='1522',@pPurchaseDate='2018-04-07 11:25:32.937'
,@pPurchaseDateUTC='2018-04-07 05:55:32.937',@pWarrantyDuration='12',@pWarrantyStartDate='2018-04-07 11:25:32.937',@pWarrantyStartDateUTC='2018-04-07 05:55:32.937'
,@pWarrantyEndDate='2019-04-07 11:25:32.937',@pWarrantyEndDateUTC='2019-04-07 05:55:32.937'		,@pCumulativePartCost='0',@pCumulativeLabourCost='0',@pCumulativeContractCost='0'
,@pRegistrationNo='ABCD001',@pChassisNo='15467gugehf990',@pEngineCapacity='50',@pFuelType='',@pSpecification='',@pDisposalApprovalDate=null,@pDisposalApprovalDateUTC=null
,@pDisposedDate='',@pDisposedDateUTC=null,@pDisposedBy='',@pDisposeMethod='',@pAuthorization='',@pTestingandCommissioningDetId='',@pAssetParentId='',@pAssetStandardizationId=null
,@pNamePlateManufacturer='AUDI',@pPowerSpecificationWatt='0',@pPowerSpecificationAmpere='0',@pPurchaseCategory=5,@pActive='',@pBuiltIn=''


--Update
EXEC uspFM_EngAsset_Save  @pAssetId	=27,@pUserId=2,@pCustomerId='1',@pFacilityId='1',@pServiceId='2',@pWorkGroupId='1',@pAssetClassification='1',@pIsAssetOld='1',@pQRCode=NULL
,@pAssetPreRegistrationNo='',@pAssetNo='0014654656',@pAssetNoOld='0014654656',@pAssetDescription='Xray Machine',@pAssetTypeCodeId=4,@pCommissioningDate='2018-04-07'
,@pServiceStartDate='2018-04-07 11:20:51.830',@pServiceStartDateUTC='2018-04-07 05:51:54.977',@pEffectiveDate='2018-04-07 11:22:17.760',@pEffectiveDateUTC='2018-04-07 05:52:17.760'
,@pExpectedLifespan=10,@pAssetStatusLovId=1,@pRealTimeStatusLovId='',@pOperatingHours='0',@pImage1FMDocumentId='',@pImage2FMDocumentId='',@pImage3FMDocumentId=''
,@pImage4FMDocumentId='',@pVedioFMDocumentId='',@pUserAreaId=null,@pUserLocationId=null,@pManufacturer='2',@pModel='1',@pAppliedPartTypeLovId='',@pEquipmentClassLovId=''
,@pSerialNo='A001dfu',@pRiskRating='',@pMainSupplier='ABC Limited',@pManufacturingDate='2018-04-07 11:25:32.937',@pManufacturingDateUTC='2018-04-07 05:55:32.937'
,@pSpecificationUnit='',@pPowerSpecification='0',@pVolt='0',@pPpmPlannerId='1',@pRiPlannerId='0',@pOtherPlannerId='0',@pPurchaseCostRM='1522',@pPurchaseDate='2018-04-07 11:25:32.937'
,@pPurchaseDateUTC='2018-04-07 05:55:32.937',@pWarrantyDuration='12',@pWarrantyStartDate='2018-04-07 11:25:32.937',@pWarrantyStartDateUTC='2018-04-07 05:55:32.937'
,@pWarrantyEndDate='2019-04-07 11:25:32.937',@pWarrantyEndDateUTC='2019-04-07 05:55:32.937'		,@pCumulativePartCost='0',@pCumulativeLabourCost='0',@pCumulativeContractCost='0'
,@pRegistrationNo='ABCD001',@pChassisNo='15467gugehf990',@pEngineCapacity='50',@pFuelType='',@pSpecification='',@pDisposalApprovalDate=null,@pDisposalApprovalDateUTC=null
,@pDisposedDate='',@pDisposedDateUTC=null,@pDisposedBy='',@pDisposeMethod='',@pAuthorization='',@pTestingandCommissioningDetId='',@pAssetParentId='',@pAssetStandardizationId=null
,@pNamePlateManufacturer='AUDI',@pPowerSpecificationWatt='0',@pPowerSpecificationAmpere='0',@pPurchaseCategory=5,@pActive='',@pBuiltIn=''

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAsset_Save_test]
	--@pEngAssetSoftware						[dbo].[udt_EngAssetSoftware]	READONLY,
	@pAssetId								INT,
	@pUserId								INT,
	@pCustomerId							INT,
	@pFacilityId							INT,
	@pServiceId								INT,
	@pAssetNo								NVARCHAR(100)			=NULL,
	@pAssetPreRegistrationNo				NVARCHAR(100)			=NULL,
	@pAssetTypeCodeId						INT,
	@pAssetClassification					INT						=NULL,
	@pAssetDescription						NVARCHAR(500),
	@pCommissioningDate						DATETIME,
	@pAssetParentId							INT						=NULL,
	@pServiceStartDate						DATETIME,
	@pEffectiveDate							DATETIME				=NULL,
	@pExpectedLifespan						INT						= null,
	@pRealTimeStatusLovId					INT						=NULL,
	@pAssetStatusLovId						INT						=NULL,
	@pOperatingHours						NUMERIC(24,2)			=0,
	@pUserLocationId						INT						=NULL,
	@pManufacturer							INT						=NULL,
	@pModel									INT						=NULL,
	@pAppliedPartTypeLovId					INT						=NULL,
	@pEquipmentClassLovId					INT						=NULL,
	@pSpecification							INT						=NULL,
	@pSerialNo								NVARCHAR(100)			=NULL,

	@pRiskRating							INT			=NULL,

	@pMainSupplier							NVARCHAR(100)			=NULL,
	@pManufacturingDate						DATETIME				=NULL,
	@pPowerSpecification					INT						=NULL,
	@pPowerSpecificationWatt				NUMERIC(24,2)			=0,
	@pPowerSpecificationAmpere				NUMERIC(24,2)			=0,
	@pVolt									NUMERIC(24,2)			=NULL,
	@pPpmPlannerId							INT						=NULL,
	@pRiPlannerId							INT						=NULL,
	@pOtherPlannerId						INT						=NULL,
	@pPurchaseCostRM						NUMERIC(24,2)			=NULL,
	@pPurchaseDate							DATETIME				=NULL,
	@pPurchaseCategory						INT						=NULL,
	@pWarrantyDuration						NUMERIC(24,0)			=NULL,
	@pWarrantyStartDate						DATETIME				=NULL,
	@pWarrantyEndDate						DATETIME				=NULL,
	@pCumulativePartCost					NUMERIC(24,2)			=0,
	@pCumulativeLabourCost					NUMERIC(24,2)			=0,
	@pCumulativeContractCost				NUMERIC(24,2)			=0,
	@pDisposalApprovalDate					DATETIME				=NULL,
	@pDisposedDate							DATETIME				=NULL,
	@pDisposedBy							NVARCHAR(200)			=NULL,
	@pDisposeMethod							NVARCHAR(100)			=NULL,
	@pNamePlateManufacturer					NVARCHAR(200)			=NULL,
	@pTimestamp								varbinary(100)			=NULL,
	@pIsLoaner								BIT						=0,
	@pTypeOfAsset							INT						=NULL,
	


	@pIsAssetOld							BIT						=NULL,
	@pQRCode								VARBINARY(MAX)			=NULL,
	@pAssetNoOld							NVARCHAR(100)			=NULL,
	@pServiceStartDateUTC					DATETIME				=NULL,
	@pEffectiveDateUTC						DATETIME				=NULL,
	@pImage1FMDocumentId					INT						=NULL,
	@pImage2FMDocumentId					INT						=NULL,
	@pImage3FMDocumentId					INT						=NULL,
	@pImage4FMDocumentId					INT						=NULL,
	@pVedioFMDocumentId						INT						=NULL,
	@pUserAreaId							INT						=NULL,
	@pManufacturingDateUTC					DATETIME				=NULL,
	@pSpecificationUnit						INT						=NULL,
	@pPurchaseDateUTC						DATETIME				=NULL,
	@pWarrantyStartDateUTC					DATETIME				=NULL,
	@pWarrantyEndDateUTC					DATETIME				=NULL,
	@pRegistrationNo						NVARCHAR(400)			=NULL,
	@pChassisNo								NVARCHAR(500)			=NULL,
	@pEngineCapacity						NVARCHAR(50)			=NULL,
	@pFuelType								INT						=NULL,
	@pDisposalApprovalDateUTC				DATETIME				=NULL,
	@pDisposedDateUTC						DATETIME				=NULL,
	@pAuthorization							INT						=NULL,
	@pTestingandCommissioningDetId			INT						=NULL,
	@pAssetStandardizationId				INT						=NULL,
	@pActive								INT						=1,
	@pBuiltIn								INT						=1,

	@pTransferFacilityName					NVARCHAR(500)			=NULL,
	@pTransferRemarks						NVARCHAR(500)			=NULL,
	@pPreviousAssetNo						NVARCHAR(500)           =NULL,
	@pPurchaseOrderNo						NVARCHAR(100)			=NULL,
	@pInstalledLocationId					INT						=NULL,
	@pSoftwareVersion						NVARCHAR(100)			=NULL,
	@pSoftwareKey							NVARCHAR(100)			=NULL,
	@pTransferMode							INT						=NULL,
	@pOtherTransferDate						DATETIME				=NULL,
	@pMainsFuseRating						NUMERIC(24,2)			=NULL,
	@pRunningHoursCapture					INT						=NULL,
	@pContractType							INT						=NULL,
	@pCompanyStaffId						INT						=NULL

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
	SET @pServiceStartDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceStartDate)
	SET @pEffectiveDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pEffectiveDate)
	SET @pManufacturingDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pManufacturingDate)
	SET @pPurchaseDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pPurchaseDate)
	SET @pIsLoaner					=	ISNULL(@pIsLoaner,0)

-- Execution

 DECLARE @pOutParam NVARCHAR(50),@mDefaultkey NVARCHAR(50),@mFacilityCode  NVARCHAR(50)
 	IF(@pTypeOfAsset = 190)
		BEGIN
			SET @mDefaultkey='L'
		END
	ELSE IF(@pTypeOfAsset = 191)
		BEGIN
			SET @mDefaultkey='T'
		END
	ELSE IF(ISNULL(@pIsLoaner,0) = 0)
		BEGIN
			SET @mDefaultkey='H'
		END
	
	SET @mFacilityCode = (SELECT TOP 1 FacilityCode FROM MstLocationFacility WHERE FacilityId	=	@pFacilityId)
	SET @mDefaultkey= (SELECT LEFT(@mFacilityCode,3) + @mDefaultkey )

	IF (ISNULL(@pAssetId,0)=0 OR @pAssetId='')

	BEGIN

	IF EXISTS (SELECT TestingandCommissioningDetId FROM EngAsset WHERE TestingandCommissioningDetId=@PTestingandCommissioningDetId)
		BEGIN
			SELECT	0 AS AssetId,null as AssetNo,
					NULL [Timestamp],
					'Asset Pre Registration No. already used' ErrorMessage,
					NULL AS GuId
		END
	ELSE
		BEGIN

		EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngAsset',@pCustomerId=null,@pFacilityId=null,@Defaultkey=@mDefaultkey,@pService=null,@pMonth=null,@pYear=null,@pOutParam=@pOutParam OUTPUT
		SELECT @pAssetNo= @pOutParam 
			
			INSERT INTO EngAsset(
								CustomerId,						
								FacilityId,					
								ServiceId,						
								AssetClassification,			
								IsAssetOld,												
								AssetPreRegistrationNo,			
								AssetNo,						
								AssetNoOld,						
								AssetDescription,				
								AssetTypeCodeId,				
								CommissioningDate,				
								ServiceStartDate,				
								ServiceStartDateUTC,			
								EffectiveDate,					
								EffectiveDateUTC,				
								ExpectedLifespan,				
								AssetStatusLovId,				
								RealTimeStatusLovId,			
								OperatingHours,					
								Image1FMDocumentId,				
								Image2FMDocumentId,				
								Image3FMDocumentId,				
								Image4FMDocumentId,				
								VedioFMDocumentId,				
								UserAreaId,						
								UserLocationId,					
								Manufacturer,					
								Model,							
								AppliedPartTypeLovId,			
								EquipmentClassLovId,			
								SerialNo,						
								RiskRating,						
								MainSupplier,					
								ManufacturingDate,				
								ManufacturingDateUTC,			
								SpecificationUnit,				
								PowerSpecification,				
								Volt,							
								PpmPlannerId,					
								RiPlannerId,					
								OtherPlannerId,					
								PurchaseCostRM,					
								PurchaseDate,					
								PurchaseDateUTC,				
								WarrantyDuration,				
								WarrantyStartDate,				
								WarrantyStartDateUTC,			
								WarrantyEndDate,				
								WarrantyEndDateUTC,				
								CumulativePartCost,				
								CumulativeLabourCost,			
								CumulativeContractCost,			
								RegistrationNo,					
								ChassisNo,						
								EngineCapacity,					
								FuelType,						
								Specification,					
								DisposalApprovalDate,			
								DisposalApprovalDateUTC,		
								DisposedDate,					
								DisposedDateUTC,				
								DisposedBy,						
								DisposeMethod,					
								[Authorization],					
								TestingandCommissioningDetId,	
								AssetParentId,					
								CreatedBy,						
								CreatedDate,					
								CreatedDateUTC,					
								ModifiedBy,						
								ModifiedDate,					
								ModifiedDateUTC,
								AssetStandardizationId,
								NamePlateManufacturer,
								PowerSpecificationWatt,
								PowerSpecificationAmpere,
								PurchaseCategory,		
								Active,							
								BuiltIn,
								IsLoaner,
								TypeOfAsset,
								TransferFacilityName,
								TransferRemarks	,
								PreviousAssetNo	,
								PurchaseOrderNo	,
								InstalledLocationId,
								SoftwareVersion,
								SoftwareKey,
								TransferMode,
								OtherTransferDate,
								MainsFuseRating,
								IsMailSent,
								RunningHoursCapture,
								ContractType,
								CompanyStaffId

							
							)	OUTPUT INSERTED.AssetId INTO @Table
							VALUES
							(
								@pCustomerId,						
								@pFacilityId,					
								@pServiceId,						
								@pAssetClassification,			
								@pIsAssetOld,												
								@pAssetPreRegistrationNo,			
								@pAssetNo,						
								@pAssetNoOld,						
								@pAssetDescription,				
								@pAssetTypeCodeId,				
								@pCommissioningDate,				
								@pServiceStartDate,				
								@pServiceStartDateUTC,			
								@pEffectiveDate,					
								@pEffectiveDateUTC,				
								@pExpectedLifespan,				
								@pAssetStatusLovId,				
								@pRealTimeStatusLovId,			
								@pOperatingHours,					
								@pImage1FMDocumentId,				
								@pImage2FMDocumentId,				
								@pImage3FMDocumentId,				
								@pImage4FMDocumentId,				
								@pVedioFMDocumentId,				
								@pUserAreaId,						
								@pUserLocationId,					
								@pManufacturer,					
								@pModel,							
								@pAppliedPartTypeLovId,			
								@pEquipmentClassLovId,			
								@pSerialNo,						
								@pRiskRating,						
								@pMainSupplier,					
								@pManufacturingDate,				
								@pManufacturingDateUTC,			
								@pSpecificationUnit,				
								@pPowerSpecification,				
								@pVolt,							
								@pPpmPlannerId,					
								@pRiPlannerId,					
								@pOtherPlannerId,					
								@pPurchaseCostRM,					
								@pPurchaseDate,					
								@pPurchaseDateUTC,				
								@pWarrantyDuration,				
								@pWarrantyStartDate,				
								@pWarrantyStartDateUTC,			
								@pWarrantyEndDate,				
								@pWarrantyEndDateUTC,				
								@pCumulativePartCost,				
								@pCumulativeLabourCost,			
								@pCumulativeContractCost,			
								@pRegistrationNo,					
								@pChassisNo,						
								@pEngineCapacity,					
								@pFuelType,						
								@pSpecification,					
								@pDisposalApprovalDate,			
								@pDisposalApprovalDateUTC,		
								@pDisposedDate,					
								@pDisposedDateUTC,				
								@pDisposedBy,						
								@pDisposeMethod,					
								@pAuthorization,					
								@pTestingandCommissioningDetId,	
								@pAssetParentId,					
								@pUserId,						
								GETDATE(),					
								GETUTCDATE(),					
								@pUserId,						
								GETDATE(),					
								GETUTCDATE(),
								@pAssetStandardizationId,
								@pNamePlateManufacturer,
								@pPowerSpecificationWatt,
								@pPowerSpecificationAmpere,
								@pPurchaseCategory,				
								@pActive,							
								@pBuiltIn,
								@pIsLoaner,
								@pTypeOfAsset	,
								@pTransferFacilityName,
								@pTransferRemarks	,
								@pPreviousAssetNo	,
								@pPurchaseOrderNo	,
								@pUserLocationId,
								@pSoftwareVersion,
								@pSoftwareKey,
								@pTransferMode,
								@pOtherTransferDate,
								@pMainsFuseRating,
								0,
								ISNULL(@pRunningHoursCapture,100)		,
								@pContractType,
								@pCompanyStaffId							 
							)

--- To update AssetId in TandC

		UPDATE	TC	SET TC.AssetId	=	(SELECT ID FROM @Table)
		FROM EngTestingandCommissioningTxn TC INNER JOIN EngTestingandCommissioningTxnDet TCDet ON TC.TestingandCommissioningId=TCDet.TestingandCommissioningId
		WHERE (TCDet.TestingandCommissioningDetId	=	@pTestingandCommissioningDetId OR TCDet.AssetPreRegistrationNo	= @pAssetPreRegistrationNo)

		DECLARE @mPrimaryId INT
		SET @mPrimaryId	=	(SELECT ID FROM @Table)

		

		SELECT	AssetId,AssetNo,
				[Timestamp],
				'' ErrorMessage,
				GuId
		FROM	EngAsset
		WHERE	AssetId IN (SELECT ID FROM @Table)
		END


	END
	ELSE


		BEGIN

		Print 'a'

			DECLARE @mTimestamp varbinary(100);
			select @mTimestamp = Timestamp from EngAsset where AssetId=@pAssetId

			IF (@mTimestamp=@pTimestamp)
			
			BEGIN

			DECLARE    @mLastUpdatedBy NVARCHAR(1000)
			DECLARE    @mPurchaseCategory NVARCHAR(1000)
			DECLARE    @mAssetStatus NVARCHAR(1000)
			DECLARE    @mEquipmentClass NVARCHAR(1000)

			SET		   @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN EngAsset B on A.UserRegistrationId = B.ModifiedBy WHERE B.AssetId =@pAssetId )	
			SET		   @mPurchaseCategory = (SELECT a.FieldValue FROM FMLovMst  A INNER JOIN EngAsset B on A.LovId = B.PurchaseCategory  WHERE B.AssetId = @pAssetId)
			SET		   @mAssetStatus = (SELECT a.FieldValue FROM FMLovMst  A INNER JOIN EngAsset B on A.LovId = B.AssetStatusLovId  WHERE B.AssetId = @pAssetId)
			SET		   @mEquipmentClass = (SELECT a.FieldValue FROM FMLovMst  A INNER JOIN EngAsset B on A.LovId = B.EquipmentClassLovId  WHERE B.AssetId = @pAssetId)

			insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)
			select 'EngAsset',GuId,
			(SELECT		Asset.AssetDescription AS AssetDescription ,
						@mAssetStatus AS AssetStatus,
						Asset.NamePlateManufacturer AS NamePlateManufacturer,
						@mPurchaseCategory AS PurchaseCategory,
						@mEquipmentClass AS EquipmentClass,
						Asset.SoftwareVersion,
						Asset.SoftwareKey,
						Asset.PowerSpecificationWatt,
						Asset.PowerSpecificationAmpere,
						Asset.Volt,Asset.MainsFuseRating,
						@mLastUpdatedBy    as LastUpdatedBy,
						Asset.ModifiedDate as LastUpdateOn  
			FROM		EngAsset Asset
			WHERE		AssetId =@pAssetId
						FOR JSON AUTO),GETDATE(),GETUTCDATE() from EngAsset Asset1 where AssetId =@pAssetId
			AND			Not (
						isnull(Asset1.AssetDescription,'') = isnull(@pAssetDescription,'')
						AND isnull(Asset1.AssetStatusLovId,'') = isnull(@pAssetStatusLovId,'')
						AND isnull(Asset1.NamePlateManufacturer,'') = isnull(@pNamePlateManufacturer,'')
						AND isnull(Asset1.PurchaseCategory,'') = isnull(@pPurchaseCategory,'')
						AND isnull(Asset1.EquipmentClassLovId,'')	= isnull(@pEquipmentClassLovId,'')
						AND isnull(Asset1.SoftwareVersion,'')  = isnull(@pSoftwareVersion,'')
						AND isnull(Asset1.SoftwareKey,'')  = isnull(@pSoftwareKey,'')
						AND isnull(Asset1.PowerSpecificationWatt,'') = isnull(@pPowerSpecificationWatt,'')
						AND isnull(Asset1.PowerSpecificationAmpere,'') = isnull(@pPowerSpecificationAmpere,'')
						AND isnull(Asset1.Volt,0) =isnull(@pVolt,0)
						ANd isnull(Asset1.MainsFuseRating,0) = isnull(@pMainsFuseRating,0)
						)

					
			declare @variationid  int,@LContractType int
			select @LContractType=ContractType from EngAsset WHERE	AssetId=@pAssetId
			if @pContractType!=@LContractType
			begin
				select top 1 @variationid = variationid from VmVariationTxn where 	AssetId=@pAssetId  order by variationid desc				
				update VmVariationTxn set VariationWFStatus = Null  where  variationid = @variationid
			end

			UPDATE EngAsset SET				
											
							CustomerId									= @pCustomerId,									
							FacilityId									= @pFacilityId,						
							ServiceId									= @pServiceId,					
							AssetClassification							= @pAssetClassification,			
							IsAssetOld									= @pIsAssetOld,						
							--AssetPreRegistrationNo						= @pAssetPreRegistrationNo,			
							--AssetNo										= @pAssetNo,						
							--AssetNoOld									= @pAssetNoOld,						
							AssetDescription							= @pAssetDescription,				
							AssetTypeCodeId								= @pAssetTypeCodeId,				
							CommissioningDate							= @pCommissioningDate,				
							ServiceStartDate							= @pServiceStartDate,				
							ServiceStartDateUTC							= @pServiceStartDateUTC,			
							EffectiveDate								= @pEffectiveDate,					
							EffectiveDateUTC							= @pEffectiveDateUTC,				
							ExpectedLifespan							= @pExpectedLifespan,				
							AssetStatusLovId							= @pAssetStatusLovId,				
							RealTimeStatusLovId							= @pRealTimeStatusLovId,			
							OperatingHours								= @pOperatingHours,					
							Image1FMDocumentId							= @pImage1FMDocumentId,				
							Image2FMDocumentId							= @pImage2FMDocumentId,				
							Image3FMDocumentId							= @pImage3FMDocumentId,				
							Image4FMDocumentId							= @pImage4FMDocumentId,				
							VedioFMDocumentId							= @pVedioFMDocumentId,				
							UserAreaId									= @pUserAreaId,						
							UserLocationId								= @pUserLocationId,					
							Manufacturer								= @pManufacturer,					
							Model										= @pModel,							
							AppliedPartTypeLovId						= @pAppliedPartTypeLovId,			
							EquipmentClassLovId							= @pEquipmentClassLovId,			
							SerialNo									= @pSerialNo,						
							RiskRating									= @pRiskRating,						
							MainSupplier								= @pMainSupplier,					
							ManufacturingDate							= @pManufacturingDate,				
							ManufacturingDateUTC						= @pManufacturingDateUTC,			
							SpecificationUnit							= @pSpecificationUnit,				
							PowerSpecification							= @pPowerSpecification,				
							Volt										= @pVolt,							
							PpmPlannerId								= @pPpmPlannerId,					
							RiPlannerId									= @pRiPlannerId,					
							OtherPlannerId								= @pOtherPlannerId,					
							PurchaseCostRM								= @pPurchaseCostRM,					
							PurchaseDate								= @pPurchaseDate,					
							PurchaseDateUTC								= @pPurchaseDateUTC,				
							WarrantyDuration							= @pWarrantyDuration,				
							WarrantyStartDate							= @pWarrantyStartDate,				
							WarrantyStartDateUTC						= @pWarrantyStartDateUTC,			
							WarrantyEndDate								= @pWarrantyEndDate,				
							WarrantyEndDateUTC							= @pWarrantyEndDateUTC,				
							CumulativePartCost							= @pCumulativePartCost,				
							CumulativeLabourCost						= @pCumulativeLabourCost,			
							CumulativeContractCost						= @pCumulativeContractCost,			
							RegistrationNo								= @pRegistrationNo,					
							ChassisNo									= @pChassisNo,						
							EngineCapacity								= @pEngineCapacity,					
							FuelType									= @pFuelType,						
							Specification								= @pSpecification,					
							DisposalApprovalDate						= @pDisposalApprovalDate,			
							DisposalApprovalDateUTC						= @pDisposalApprovalDateUTC,		
							DisposedDate								= @pDisposedDate,					
							DisposedDateUTC								= @pDisposedDateUTC,				
							DisposedBy									= @pDisposedBy,						
							DisposeMethod								= @pDisposeMethod,					
							[Authorization]								= @pAuthorization,					
							TestingandCommissioningDetId				= @pTestingandCommissioningDetId,	
							AssetParentId								= @pAssetParentId,
							AssetStandardizationId						= @pAssetStandardizationId,	
							NamePlateManufacturer						= @pNamePlateManufacturer,
							PowerSpecificationWatt						= @pPowerSpecificationWatt,
							PowerSpecificationAmpere					= @pPowerSpecificationAmpere,
							PurchaseCategory							= @pPurchaseCategory,		
							ModifiedBy									= @pUserId,						
							ModifiedDate								= GETDATE(),					
							ModifiedDateUTC								= GETUTCDATE(),
							IsLoaner									= @pIsLoaner,
							TypeOfAsset									= @pTypeOfAsset,
							TransferFacilityName						= @pTransferFacilityName,
							TransferRemarks							= @pTransferRemarks	,
							PreviousAssetNo							= @pPreviousAssetNo	,
							PurchaseOrderNo							= @pPurchaseOrderNo	,
							SoftwareVersion						=		@pSoftwareVersion,
							SoftwareKey							=		@pSoftwareKey	,
							TransferMode						=	@pTransferMode,		
							OtherTransferDate					=   @pOtherTransferDate,
							MainsFuseRating						=   @pMainsFuseRating,
							RunningHoursCapture					=	ISNULL(@pRunningHoursCapture,100),
							ContractType						=	@pContractType,
							CompanyStaffId						=   @pCompanyStaffId
							OUTPUT INSERTED.AssetId INTO @Table
					WHERE	AssetId=@pAssetId

		UPDATE	TC	SET TC.AssetId	=	@pAssetId
		FROM EngTestingandCommissioningTxn TC INNER JOIN EngTestingandCommissioningTxnDet TCDet ON TC.TestingandCommissioningId=TCDet.TestingandCommissioningId
		WHERE (TCDet.TestingandCommissioningDetId	=	@pTestingandCommissioningDetId OR TCDet.AssetPreRegistrationNo	= @pAssetPreRegistrationNo)


		DELETE FROM EngAssetSoftware WHERE AssetId=@pAssetId --AND AssetSoftwareId IN (SELECT AssetSoftwareId FROM @pEngAssetSoftware WHERE IsDeleted = 1 )

		


		

				SELECT	AssetId,AssetNo,
						[Timestamp],
						'' ErrorMessage,
						GuId
				FROM	EngAsset
				WHERE	AssetId IN (SELECT ID FROM @Table)

		END
		ELSE
			BEGIN
				SELECT	AssetId,AssetNo,
						[Timestamp],
						'Record Modified. Please Re-Select' AS ErrorMessage,
						GuId
				FROM	EngAsset
				WHERE	AssetId =@pAssetId
			END
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
		   );
		   throw;

END CATCH
GO
