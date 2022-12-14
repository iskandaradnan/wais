USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_AssetRegisterUpload_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERApplicationTxn_Save
Description			: If BER ApplicationTxn already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_BERApplicationTxn_Save] @pApplicationId=0,@pUserId=2,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pBERno='BER002',@pAssetId=1,@pCRMRequestId=NULL,@pFreqDamSincPurchased=24,
@pTotalCostImprovement=50,@pMajorBreakdown='Repair',@pHealthySafetyHazards='Repair',@pEstRepcostToExpensive=50,@pRepairEstimate=2.5,@pValueAfterRepair=5.20,@pEstDurUsgAfterRepair=5.63,
@pNotReliable='jogojog',@pStatutoryRequirements='Active',@pOtherObservations='No',@pApplicantStaffId=null,@pBERStatus=1,@pBER2TechnicalCondition=null,@pBER2RepairedWell='Active',
@pBER2SafeReliable=50,@pBER2EstimateLifeTime=12,@pBER2Syor=21,@pBER2Remarks='Completed',@pTBER2StillLifeSpan=1,@pBIL='Rsrt',@pBER1Remarks='completed',@pParentApplicationId=1,
@pApprovedDate='2018-05-09 12:07:24.283',@pApprovedDateUTC='2018-05-09 12:07:24.283',@pIsRenewal=1,@pIsRenewalExclude=1,@pRenewalStatus=1,@pRenewalOthers='Others',
@pJustificationForCertificates='Certificates',@pApplicationDate='2018-05-09 12:07:24.283',@pRejectedBERReferenceId=null,@pBER2TechnicalConditionOthers='others',
@pBER2SafeReliableOthers='Others',@pBER2EstimateLifeTimeOthers='Others',@pBERStage=2,@pCircumstanceOthers='NA',@pExaminationFirstResultOthers='NA',@pEstimatedRepairCost=50

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_AssetRegisterUpload_Save]


            --- CRM Request
           
			@pCRMRequestId					INT						,
			@pUserId						INT						= NULL,
			@CustomerId						INT,
			@FacilityId						INT,
			@ServiceId						INT,
			@RequestNo						NVARCHAR(100)			=NULL,		
			@RequestStatus					INT,
			@RequestDescription				NVARCHAR(1000)			=NULL,
			@TypeOfRequest					INT,
			@Remarks						NVARCHAR(1000)			=NULL,			
			@pModelId						INT		=	NULL,
			@pManufacturerid				INT		=	NULL,
			@pUserAreaId					INT		=	NULL,
			@pUserLocationId				INT		=	NULL,			
			@pFlag							NVARCHAR(200) =NULL,
			@pTargetDate					DATETIME	= NULL,
			@pRequestedPerson				INT			= NULL,
			@pRequester						INT			= NULL,
			@pAssigneeId					INT			  = NULL,
			@pEntryUser						NVARCHAR(200) =NULL,
			@CurrDateTime				    DATETIME	= NULL,

            -- T and C 
			
			@pTestingandCommissioningId		INT							=	NULL,	
			@pTandCDocumentNo				NVARCHAR(50)				=	NULL,
			@pTandCDate						DATETIME,
			@pTandCDateUTC					DATETIME					=	NULL,
			@pAssetTypeCodeId				INT							=	NULL,
			@pTandCStatus					INT,
			@pTandCCompletedDate			DATETIME					=	NULL,
			@pTandCCompletedDateUTC			DATETIME					=	NULL,
			@pHandoverDate					DATETIME					=	NULL,
			@pHandoverDateUTC				DATETIME					=	NULL,
			@pVariationStatus				INT,
			@pTandCContractorRepresentative	NVARCHAR(100)				=	NULL,
			@pFmsCustomerRepresentativeId	INT,
			@pFmsFacilityRepresentativeId	INT,
			@pTandCRemarks					NVARCHAR(500)				=	NULL,
			@pPurchaseDate					DATETIME					=	NULL,
			@pPurchaseDateUTC				DATETIME					=	NULL,
			@pPurchaseCost					NUMERIC(24,2)				=	NULL,
			@pPurchaseOrderNo				NVARCHAR(100)				=	NULL,
			@pContractLPONo					NVARCHAR(100)				=	NULL,			
			@pServiceStartDate				DATETIME					=	NULL,
			@pServiceStartDateUTC			DATETIME					=	NULL,
			@pServiceEndDate				DATETIME					=	NULL,
			@pServiceEndDateUTC				DATETIME					=	NULL,
			@pMainSupplierCode				NVARCHAR(50)				=	NULL,
			@pMainSupplierName				NVARCHAR(100)				=	NULL,
			@pWarrantyStartDate				DATETIME					=	NULL,
			@pWarrantyStartDateUTC			DATETIME					=	NULL,
			@pWarrantyDuration				INT							=	NULL,
			@pWarrantyEndDate				DATETIME					=	NULL,
			@pWarrantyEndDateUTC			DATETIME					=	NULL,				
			@pVerifyRemarks					NVARCHAR(500)				=	NULL,
			@pApprovalRemarks				NVARCHAR(500)				=	NULL,
			@pRejectRemarks					NVARCHAR(500)				=	NULL,		
			@pStatus						INT							=	NULL,
			@pQRCode						VARBINARY(MAX)				=	NULL,
			@pAssetCategoryLovId            INT							=	NULL,		
			@pAssetNoOld					NVARCHAR(100)				=	NULL,
			@pSerialNo						NVARCHAR(100)				=	NULL,
			@pPONo							NVARCHAR(100)				=	NULL,
			@pRequiredCompletionDate		DATETIME					=	NULL,
			@pContractorId					INT							=   NULL,

			-- Asset register 

			@pAssetId								INT,			
			@pAssetNo								NVARCHAR(100)			=NULL,
			--@pAssetPreRegistrationNo				NVARCHAR(100)			=NULL,		
			@pAssetClassification					INT						=NULL,
			@pAssetDescription						NVARCHAR(500),
			
			
			
			@pCommissioningDate						DATETIME               = null,
			@pEffectiveDate							DATETIME				=NULL,
			@pExpectedLifespan						INT						= null,
			@pRealTimeStatusLovId					INT						=NULL,
			@pAssetStatusLovId						INT						=1,
			@pOperatingHours						NUMERIC(24,2)			=0,			
			@pAppliedPartTypeLovId					INT						=NULL,
			@pEquipmentClassLovId					INT						=NULL,
			@pSpecification							INT						=NULL,			

			@pRiskRating							INT			=NULL,

			@pMainSupplier							NVARCHAR(100)			=NULL,
			@pManufacturingDate						DATETIME				=NULL,
			@pPowerSpecification					INT						=NULL,
			@pPowerSpecificationWatt				NUMERIC(24,2)			=0,
			@pPowerSpecificationAmpere				NUMERIC(24,2)			=0,
			@pVolt									NUMERIC(24,2)			=NULL,
			@pPpmPlannerId							INT						=99,
			@pRiPlannerId							INT						=99,
			@pOtherPlannerId						INT						=99,
			--@pPurchaseCostRM						NUMERIC(24,2)			=NULL,
			--@pPurchaseDate							DATETIME				=NULL,
			@pPurchaseCategory						INT						=NULL,
			--@pWarrantyDuration						NUMERIC(24,0)			=NULL,
			--@pWarrantyStartDate						DATETIME				=NULL,
			--@pWarrantyEndDate						DATETIME				=NULL,
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
			--@pQRCode								VARBINARY(MAX)			=NULL,
			--@pAssetNoOld							NVARCHAR(100)			=NULL,
			--@pServiceStartDateUTC					DATETIME				=NULL,
			@pEffectiveDateUTC						DATETIME				=NULL,
			@pImage1FMDocumentId					INT						=NULL,
			@pImage2FMDocumentId					INT						=NULL,
			@pImage3FMDocumentId					INT						=NULL,
			@pImage4FMDocumentId					INT						=NULL,
			@pVedioFMDocumentId						INT						=NULL,
			--@pUserAreaId							INT						=NULL,
			@pManufacturingDateUTC					DATETIME				=NULL,
			@pSpecificationUnit						INT						=NULL,
			--@pPurchaseDateUTC						DATETIME				=NULL,
			--@pWarrantyStartDateUTC					DATETIME				=NULL,
			--@pWarrantyEndDateUTC					DATETIME				=NULL,
			@pRegistrationNo						NVARCHAR(400)			=NULL,
			@pChassisNo								NVARCHAR(500)			=NULL,
			@pEngineCapacity						NVARCHAR(50)			=NULL,
			@pFuelType								INT						=NULL,
			@pDisposalApprovalDateUTC				DATETIME				=NULL,
			@pDisposedDateUTC						DATETIME				=NULL,
			@pAuthorization							INT						=200,
			@pTestingandCommissioningDetId			INT						=NULL,
			@pAssetStandardizationId				INT						=NULL,
			@pActive								INT						=1,
			@pBuiltIn								INT						=1,

			@pTransferFacilityName					NVARCHAR(500)			=NULL,
			@pTransferRemarks						NVARCHAR(500)			=NULL,
			@pPreviousAssetNo						NVARCHAR(500)           =NULL,
			--@pPurchaseOrderNo						NVARCHAR(100)			=NULL,
			@pInstalledLocationId					INT						=NULL,
			@pSoftwareVersion						NVARCHAR(100)			=NULL,
			@pSoftwareKey							NVARCHAR(100)			=NULL,
			@pTransferMode							INT						=NULL,
			@pOtherTransferDate						DATETIME				=NULL,
			@pMainsFuseRating						NUMERIC(24,2)			=NULL,
			@pRunningHoursCapture					INT						=100,
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
	DECLARE @CurrDate		DATETIME = GETDATE()
	DECLARE @CurrDateUTC	DATETIME = GETUTCDATE()
	DECLARE @RequestDateTime	DATETIME = GETUTCDATE()
	DECLARE @RequestDateTimeUTC	DATETIME = GETUTCDATE()
	Declare @mCRMReqId int = null
	Declare @mTestingandCommissioningDetId int=null
-- Default Values

    SET @RequestDateTime = GETDATE()
-- Execution

	IF(@pCRMRequestId = NULL OR @pCRMRequestId =0)

	BEGIN
	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT
	SET @mMonth	=	MONTH(@RequestDateTime)
	SET @mYear	=	YEAR(@RequestDateTime)

	EXEC [uspFM_GenerateDocumentNumber] @pFlag='CRMRequest',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='CRM',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @RequestNo=@pOutParam

	          INSERT INTO CRMRequest(
											CustomerId,
											FacilityId,
											ServiceId,
											RequestNo,
											RequestDateTime,
											RequestDateTimeUTC,
											RequestStatus,
											RequestDescription,
											TypeOfRequest,
											Remarks,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC,
											IsWorkOrder	,
											ModelId,
											ManufacturerId,
											UserAreaId,
											UserLocationId,
											TargetDate,
											RequestedPerson,
											Requester, 
											AssigneeId
                           )OUTPUT INSERTED.CRMRequestId INTO @Table
			  VALUES					(
											@CustomerId,
											@FacilityId,
											@ServiceId,
											@RequestNo,
											@RequestDateTime,
											@RequestDateTimeUTC,
											@RequestStatus,
											@RequestDescription,
											@TypeOfRequest,
											@Remarks,
											@pUserId,
											@CurrDate,
											@CurrDateUTC,
											@pUserId,
											@CurrDate,
											@CurrDateUTC,
											0,
											@pModelId,
											@pManufacturerId,
											@pUserAreaId,
											@pUserLocationId,
											@PTargetDate,
											@pRequestedPerson,
											@pRequester	,
											@pAssigneeId																							
										)

				SELECT @mPrimaryId =	CRMRequestId FROM CRMRequest WHERE CRMRequestId	IN (SELECT ID FROM @Table)

				

	  INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,DoneDateUTC
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC

										)
								VALUES (	@mPrimaryId,
											@Remarks,
											@pUserId,
											@RequestDateTime,
											@RequestDateTimeUTC,
											@RequestStatus,
											'Submit',
											@pUserId,
											@CurrDate,
											@CurrDateUTC,
											@pUserId,
											@CurrDate,
											@CurrDateUTC
										)

     SET @mCRMReqId = ( SELECT CRMRequestId FROM CRMRequest WHERE CRMRequestId IN (SELECT ID FROM @Table))
	 SET @RequestDateTime  = ( SELECT RequestDateTime FROM CRMRequest WHERE CRMRequestId IN (SELECT ID FROM @Table))
	 SET @pRequiredCompletionDate  = ( SELECT TargetDate FROM CRMRequest WHERE CRMRequestId IN (SELECT ID FROM @Table))
---------------------------------------------------- T and C -------------------------------------
       if (isnull(@mCRMReqId, 0) > 0  )
	   begin

	       DECLARE @TandCTable TABLE (ID INT)
		   DECLARE @TandCDetTable TABLE (ID INT)
		   SET @pTandCDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pTandCDate)
		   SET @pPurchaseDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pPurchaseDate)
		   SET @pTandCCompletedDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pTandCCompletedDate)
		   SET @pHandoverDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pHandoverDate)
		   SET @pServiceStartDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceStartDate)
		   SET @pServiceEndDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceEndDate)
		   SET @pWarrantyEndDate		= DATEADD(MONTH, @pWarrantyDuration, @pWarrantyStartDate)
		   IF(ISNULL(@pTestingandCommissioningId,0)= 0 OR @pTestingandCommissioningId='')
	       BEGIN
		       DECLARE @pOutParamTandC NVARCHAR(50) 
			   EXEC [uspFM_GenerateDocumentNumber] @pFlag='TestingandCommissioning',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='TC',@pModuleName='BEMS',@pMonth=NULL,@pYear=NULL,@pOutParam=@pOutParamTandC out

               SELECT @pTandCDocumentNo=@pOutParamTandC

			   INSERT INTO EngTestingandCommissioningTxn(
											CustomerId,
											FacilityId,
											ServiceId,
											TandCDocumentNo,
											TandCDate,
											TandCDateUTC,
											AssetTypeCodeId,
											TandCStatus,						
											TandCCompletedDate,
											TandCCompletedDateUTC,
											HandoverDate,
											HandoverDateUTC,

											PurchaseCost,
											PurchaseDate,
											PurchaseDateUTC,
											ServiceStartDate,
											ServiceStartDateUTC,
											ContractLPONo,


											VariationStatus,
											TandCContractorRepresentative,
											CustomerRepresentativeUserId,
											FacilityRepresentativeUserId,
											UserAreaId,
											UserLocationId,
											Remarks,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC,

											WarrantyDuration,
											WarrantyStartDate,
											WarrantyStartDateUTC,
											WarrantyEndDate,
											WarrantyEndDateUTC,
											MainSupplierCode,
											MainSupplierName,
											ServiceEndDate,
											ServiceEndDateUTC,
											Status,
											VerifyRemarks,
											ApprovalRemarks,
											RejectRemarks,
											QRCode,
											
											AssetCategoryLovId, 
											ManufacturerId,     
											ModelId,											            
											AssetNoOld,         
											SerialNo,  
											
											        
											PONo ,
											RequiredCompletionDate,
											PurchaseOrderNo,
											ContractorId	,								
											CRMRequestId	,
											RequestDate,
											RequestDateUTC							              		                                                                                                           
                           )OUTPUT INSERTED.TestingandCommissioningId INTO @TandCTable
			  VALUES						(
											@CustomerId,
											@FacilityId,
											2,
											@pTandCDocumentNo,
											--(SELECT 'TC' +  ISNULL(CAST(MAX(RIGHT(TandCDocumentNo,4)) + 1 AS NVARCHAR(50)),1000) FROM EngTestingandCommissioningTxn) ,
											@pTandCDate,
											@pTandCDateUTC,
											@pAssetTypeCodeId,
											@pTandCStatus,																					
											@pTandCCompletedDate,
											@pTandCCompletedDateUTC,
											@pHandoverDate,
											@pHandoverDateUTC,



											@pPurchaseCost,
											@pPurchaseDate,
											@pPurchaseDateUTC,
											@pServiceStartDate,
											@pServiceStartDateUTC,
											@pContractLPONo,


											@pVariationStatus,
											@pTandCContractorRepresentative,
											@pFmsCustomerRepresentativeId,
											@pFmsFacilityRepresentativeId,
											@pUserAreaId,
											@pUserLocationId,				
											@pTandCRemarks,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE(),


											@pWarrantyDuration,
											@pWarrantyStartDate,
											@pWarrantyStartDateUTC,
											@pWarrantyEndDate,
											@pWarrantyEndDateUTC,
											@pMainSupplierCode,
											@pMainSupplierName,
											@pServiceEndDate,
											@pServiceEndDateUTC,
											290,
											@pVerifyRemarks,
											@pApprovalRemarks,
											@pRejectRemarks,
											@pQRCode,

											@pAssetCategoryLovId,
											@pManufacturerId,	
											@pModelId,														
											@pAssetNoOld,		
											@pSerialNo,	
											
													
											@pPONo,
											@pRequiredCompletionDate,
											@pPurchaseOrderNo,
											@pContractorId,
											@mCRMReqId,
											@RequestDateTime,
											@RequestDateTime
											)
				UPDATE CRMRequest SET RequestStatus = 142 WHERE CRMRequestId = @mCRMReqId

				DECLARE @mPrimaryIdTandC INT
				SELECT	@mPrimaryIdTandC	=  TestingandCommissioningId 
				FROM	EngTestingandCommissioningTxn
				WHERE	TestingandCommissioningId IN (SELECT ID FROM @TandCTable)

				DECLARE @pOutParam1 NVARCHAR(50) ,@pAssetPreRegistrationNo NVARCHAR(50)
				EXEC [uspFM_GenerateDocumentNumber] @pFlag='TestingandCommissioningDet',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='BEMS',@pModuleName='BEMS',@pMonth=NULL,@pYear=NULL,@pOutParam=@pOutParam1 out
				SELECT @pAssetPreRegistrationNo =@pOutParam1

				 INSERT INTO EngTestingandCommissioningTxnDet(
													CustomerId,
													FacilityId,
													ServiceId,
													TestingandCommissioningId,
													AssetPreRegistrationNo,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
                                                    )OUTPUT INSERTED.TestingandCommissioningDetId INTO @TandCDetTable												

				   SELECT							
													@CustomerId,
													@FacilityId,
													2,
													@mPrimaryIdTandC,
													@pAssetPreRegistrationNo,
													--(SELECT 'BEMS/TC/' +  ISNULL(CAST(MAX(RIGHT(AssetPreRegistrationNo,3)) + 1 AS NVARCHAR(50)),1000) FROM EngTestingandCommissioningTxnDet),	
													@pUserId,		
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				  
				  SET @mTestingandCommissioningDetId = (  SELECT	CommissioningTxnDet.TestingandCommissioningDetId
							
													FROM		EngTestingandCommissioningTxn	AS	CommissioningTxn	WITH(NOLOCK)
													INNER JOIN	EngTestingandCommissioningTxnDet	AS	CommissioningTxnDet	WITH(NOLOCK) ON	CommissioningTxn.TestingandCommissioningId	=	CommissioningTxnDet.TestingandCommissioningId
							
													WHERE	CommissioningTxn.TestingandCommissioningId IN (SELECT ID FROM @TandCTable))
				  
				  

				   

				   --  SELECT	CommissioningTxn.TestingandCommissioningId,
							--TandCDocumentNo,
							--CommissioningTxnDet.AssetPreRegistrationNo,
							--CASE
							--	WHEN CommissioningTxn.WarrantyEndDate >=	GETDATE()	THEN '99'
							--	WHEN CommissioningTxn.WarrantyEndDate <		GETDATE()	THEN '100'
							--	ELSE	NULL	
							--END																	AS WarrantyStatus,
							--CommissioningTxn.[Timestamp],							
							--'' ErrorMessage,
							--CommissioningTxn.QRCode,
							--LovActions.FieldValue				AS StatusName,
							--CommissioningTxn.GuId
				   --FROM		EngTestingandCommissioningTxn	AS	CommissioningTxn	WITH(NOLOCK)
							--INNER JOIN	EngTestingandCommissioningTxnDet	AS	CommissioningTxnDet	WITH(NOLOCK) ON	CommissioningTxn.TestingandCommissioningId	=	CommissioningTxnDet.TestingandCommissioningId
							--LEFT JOIN	FMLovMst							AS	LovActions	WITH(NOLOCK) ON	CommissioningTxn.Status	=	LovActions.LovId
				   --WHERE	CommissioningTxn.TestingandCommissioningId IN (SELECT ID FROM @Table)
----------------------------------------------- Asset Register --------------------------------------------------------------------

             if(isnull(@mTestingandCommissioningDetId, 0 ) > 0 )
			 begin
			        DECLARE @AssetTable TABLE (ID INT)	
					SET @pEffectiveDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pEffectiveDate)
					SET @pManufacturingDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pManufacturingDate)
					SET @pPurchaseDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pPurchaseDate)
					SET @pIsLoaner					=	ISNULL(@pIsLoaner,0)
				    DECLARE @pOutParam2 NVARCHAR(50),@mDefaultkey NVARCHAR(50),@mFacilityCode  NVARCHAR(50)
 	                IF(ISNULL(@pIsLoaner,0) = 0)
	                	BEGIN
	                		SET @mDefaultkey='H'
	                	END
	
				SET @mFacilityCode = (SELECT TOP 1 FacilityCode FROM MstLocationFacility WHERE FacilityId	=	@FacilityId)
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
					       EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngAsset',@pCustomerId=null,@pFacilityId=null,@Defaultkey=@mDefaultkey,@pService=null,@pMonth=null,@pYear=null,@pOutParam=@pOutParam2 OUTPUT
					  
					       SELECT @pAssetNo= @pOutParam2 
			
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

							
							)	OUTPUT INSERTED.AssetId INTO @AssetTable
							VALUES
							(
								@CustomerId,						
								@FacilityId,					
								@ServiceId,						
								@pAssetClassification,											
								@pIsAssetOld,												
								@pAssetPreRegistrationNo,	
								@pAssetNo,						
								null,						
								@pAssetDescription,				
								@pAssetTypeCodeId,				
								@pTandCDate,				
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
								@pManufacturerid,					
								@pModelId,	
														
								57,			
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
								
												
								@pPurchaseCost,					
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
								@mTestingandCommissioningDetId,	
								null,					
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

						UPDATE	TC	SET TC.AssetId	=	(SELECT ID FROM @AssetTable)
						FROM EngTestingandCommissioningTxn TC INNER JOIN EngTestingandCommissioningTxnDet TCDet ON TC.TestingandCommissioningId=TCDet.TestingandCommissioningId
						WHERE (TCDet.TestingandCommissioningDetId	=	@pTestingandCommissioningDetId OR TCDet.AssetPreRegistrationNo	= @pAssetPreRegistrationNo)
		                   INSERT INTO VmVariationTxn	(	CustomerId,
												FacilityId,
												ServiceId,
												SNFDocumentNo,
												SnfDate,
												AssetId,
												AssetClassification,
												VariationStatus,
												PurchaseProjectCost,
												VariationDate,
												VariationDateUTC,
												StartServiceDate,
												StartServiceDateUTC,
												ServiceStopDate,
												ServiceStopDateUTC,
												CommissioningDate,
												CommissioningDateUTC,
												WarrantyDurationMonth,
												WarrantyStartDate,
												WarrantyStartDateUTC,
												WarrantyEndDate,
												WarrantyEndDateUTC,
												VariationApprovedStatus,
												Remarks,
												AuthorizedStatus,
												VariationRaisedDate,
												VariationRaisedDateUTC,
												VariationWFStatus,
												PurchaseDate,
												PurchaseDateUTC,
												VariationPurchaseCost,
												ContractCost,
												ContractLpoNo,
												MainSupplierCode,
												MainSupplierName,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC                               
                           )
								

								SELECT
								
									Asset.CustomerId,									
									Asset.FacilityId,		
									Asset.ServiceId,
									TandC.TandCDocumentNo,									
									TandC.TandCDate,
									Asset.AssetId,
									Asset.AssetClassification,
									TandC.VariationStatus	,
									TandC.PurchaseCost		,
									TandC.TandCDate	,
									TandC.TandCDate	,
									TandC.ServiceStartDate,
									TandC.ServiceStartDate,	
									TandC.ServiceEndDate,
									TandC.ServiceEndDate,
									TandC.TandCDate,
									TandC.TandCDate,
									TandC.WarrantyDuration,
									TandC.WarrantyStartDate,
									TandC.WarrantyStartDate,	
									TandC.WarrantyEndDate,
									TandC.WarrantyEndDate,															
									CASE 
									WHEN TandC.Status=7 THEN 371
										ELSE 372
									END		AS	VariationApprovedStatusLovId,
									'' as remarks,

								vm.AuthorizedStatus,
								TandC.TandCDate,
								TandC.TandCDate,
								null,		
								Asset.PurchaseDate,
								Asset.PurchaseDate,
								TandC.PurchaseCost		,
								null,
								TandC.ContractLPONo,																						
								TandC.MainSupplierCode,
								TandC.MainSupplierName,
								@pUserId	,											
								GETDATE(), 
								GETUTCDATE(),
								@pUserId,													
								GETDATE(), 
								GETUTCDATE()
 						FROM	EngAsset										AS	Asset				WITH(NOLOCK)
						INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON Asset.AssetId						=	TandC.AssetId
						INNER JOIN	FMLovMst							AS	LovVariationStatus	WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVariationStatus.LovId
						OUTER APPLY (SELECT VariationId,AuthorizedStatus FROM VmVariationTxn AS Variation WHERE Asset.AssetId	=	Variation.AssetId AND TandC.VariationStatus=Variation.VariationStatus) VM
						WHERE	Asset.AssetId	in (select id from 	@AssetTable  )
						AND TandC.Status	=	290
						ORDER BY	Asset.AssetId ASC



					   select @mCRMReqId CRMRequestId , @mTestingandCommissioningDetId as TestingandCommissioningDetId
					  
					  
					  
					  
					  
					  END
				END 

			      
			 end 



		   END

	   end 
       
   
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
		   THROW;

END CATCH
GO
