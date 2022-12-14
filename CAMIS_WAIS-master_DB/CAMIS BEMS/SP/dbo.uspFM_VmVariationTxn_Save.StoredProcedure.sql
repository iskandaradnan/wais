USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxn_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxn_Save
Description			: If Variation already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @VmVariationTxnDet AS [dbo].[udt_VmVariationTxnDet]
 insert into  @VmVariationTxnDet(VariationDetId,CustomerId,FacilityId,ServiceId,VariationWFStatus,DoneBy,DoneDate,DoneRemarks,IsVerify)VALUES
(0,'1','1','2','1','1','2018-04-06 12:36:20.410','JJJJ','1')

EXEC [uspFM_VmVariationTxn_Save] @VmVariationTxnDet,
@pUserId =2,@pVariationId =0 ,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pSNFDocumentNo='fjfdjgpgliogir',@pSnfDate='2018-04-27 14:24:58.133',@pAssetId=1,
@pAssetClassification=1,@pVariationStatus=1,@pPurchaseProjectCost=2.5,@pVariationDate='2018-04-27 14:24:58.133',@pVariationDateUTC='2018-04-27 14:24:58.133'
,@pStartServiceDate='2018-04-27 14:24:58.133',@pStartServiceDateUTC='2018-04-27 14:24:58.133',@pServiceStopDate='2018-04-27 14:24:58.133',
@pServiceStopDateUTC='2018-04-27 14:24:58.133',@pCommissioningDate='2018-04-27 14:24:58.133',@pCommissioningDateUTC='2018-04-27 14:24:58.133',
@pWarrantyDurationMonth=12,@pWarrantyStartDate='2018-04-27 14:24:58.133',@pWarrantyStartDateUTC='2018-04-27 14:24:58.133',
@pWarrantyEndDate='2018-04-27 14:24:58.133',@pWarrantyEndDateUTC='2018-04-27 14:24:58.133',@pClosingMonth=2,@pClosingYear=2018,
@pVariationApprovedStatus=1,@pOldUsage='AAA',@pNewUsage='BBB',@pUserLocation='CCCC',@pJustification='DDDD',@pApprovedDate='2018-04-27 14:24:58.133'
,@pApprovedDateUTC='2018-04-27 14:24:58.133',@pApprovedAmount=100.5,@pRemarks='HHHH',@pAuthorizedStatus=1,@pIsMonthClosed=1,@pPeriod=5,@pPaymentStartDate='2018-04-27 14:24:58.133',
@pPaymentStartDateUTC='2018-04-27 14:24:58.133',@pPWPaymentStartDate='2018-04-27 14:24:58.133',@pPWPaymentStartDateUTC='2018-04-27 14:24:58.133',
@pProposedRateDW=50.5,@pProposedRatePW=65,@pMonthlyProposedFeeDW=85,@pMonthlyProposedFeePW=78,@pCalculatedFeePW=786,@pCalculatedFeeDW=45,@pVariationRaisedDate='2018-04-27 14:24:58.133'
,@pVariationRaisedDateUTC='2018-04-27 14:24:58.133',@pAssetOldVariationData=1,@pVariationWFStatus=5,@pDoneBy=1,@pDoneDate='2018-04-27 14:24:58.133'
,@pDoneDateUTC='2018-04-27 14:24:58.133',@pDoneRemarks='JJJJ',@pIsVerify=1,@pDWCalulatedFee=56,@pGovernmentAssetNo='gsdg',@pGovernmentAssetNoDescription='rgreh',
@pPurchaseDate='2018-04-27 14:24:58.133',@pPurchaseDateUTC='2018-04-27 14:24:58.133',@pVariationPurchaseCost=56,@pContractCost=66,@pContractLpoNo='dsgg',@pCompanyAssetPraId=null,
@pCompanyAssetRegId=null,@pWarrantyProvision=null,@pUserAreaId=null,@pAOId=null,@pAODate='2018-04-27 14:24:58.133',@pAODateUTC='2018-04-27 14:24:58.133',
@pJOHNId=null,@pJOHNDate=null,@pJOHNDateUTC=null,@pHosDirectorId=null,@pHosDirectorDate=null,@pHosDirectorDateUTC=null,@pAvailableCost=2400,
@pMainSupplierCode='DEFjrgorj',@pMainSupplierName='ekojregpogm'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxn_Save]

			@VmVariationTxnDet AS [dbo].[udt_VmVariationTxnDet] READONLY,			
			@pUserId						INT					= NULL,
			@pVariationId					INT					= NULL,
			@pCustomerId					INT					= NULL,
			@pFacilityId					INT					= NULL,
			@pServiceId						INT					= NULL,
			@pSNFDocumentNo					NVARCHAR(100)		= NULL,
			@pSnfDate						DATE				= NULL,
			@pAssetId						INT					= NULL,
			@pAssetClassification			INT					= NULL,
			@pVariationStatus				INT					= NULL,
			@pPurchaseProjectCost			NUMERIC(24,2)		= NULL,
			@pVariationDate					DATETIME			= NULL,
			@pVariationDateUTC				DATETIME			= NULL,
			@pStartServiceDate				DATETIME			= NULL,
			@pStartServiceDateUTC			DATETIME			= NULL,
			@pServiceStopDate				DATETIME			= NULL,
			@pServiceStopDateUTC			DATETIME			= NULL,
			@pCommissioningDate				DATETIME			= NULL,
			@pCommissioningDateUTC			DATETIME			= NULL,
			@pWarrantyDurationMonth			INT					= NULL,
			@pWarrantyStartDate				DATETIME			= NULL,
			@pWarrantyStartDateUTC			DATETIME			= NULL,
			@pWarrantyEndDate				DATETIME			= NULL,
			@pWarrantyEndDateUTC			DATETIME			= NULL,
			@pClosingMonth					INT					= NULL,
			@pClosingYear					INT					= NULL,
			@pVariationApprovedStatus		INT					= NULL,
			@pOldUsage						NVARCHAR(300)		= NULL,
			@pNewUsage						NVARCHAR(300)		= NULL,
			@pUserLocation					NVARCHAR(300)		= NULL,
			@pJustification					NVARCHAR(1000)		= NULL,
			@pApprovedDate					DATETIME			= NULL,
			@pApprovedDateUTC				DATETIME			= NULL,
			@pApprovedAmount				NUMERIC(24,2)		= NULL,
			@pRemarks						NVARCHAR(1000)		= NULL,
			@pAuthorizedStatus				BIT					= NULL,
			@pIsMonthClosed					BIT					= NULL,
			@pPeriod						INT					= NULL,
			@pPaymentStartDate				DATETIME			= NULL,
			@pPaymentStartDateUTC			DATETIME			= NULL,
			@pPWPaymentStartDate			DATETIME			= NULL,
			@pPWPaymentStartDateUTC			DATETIME			= NULL,
			@pProposedRateDW				NUMERIC(24,2)		= NULL,
			@pProposedRatePW				NUMERIC(24,2)		= NULL,
			@pMonthlyProposedFeeDW			NUMERIC(24,2)		= NULL,
			@pMonthlyProposedFeePW			NUMERIC(24,2)		= NULL,
			@pCalculatedFeePW				NUMERIC(24,2)		= NULL,
			@pCalculatedFeeDW				NUMERIC(24,2)		= NULL,
			@pVariationRaisedDate			DATETIME			= NULL,
			@pVariationRaisedDateUTC		DATETIME			= NULL,
			@pAssetOldVariationData			BIT					= NULL,
			@pVariationWFStatus				INT					= NULL,
			@pDoneBy						INT					= NULL,
			@pDoneDate						DATETIME			= NULL,
			@pDoneDateUTC					DATETIME			= NULL,
			@pDoneRemarks					NVARCHAR(1000)		= NULL,
			@pIsVerify						BIT					= NULL,
			@pDWCalulatedFee				NUMERIC(24,2)		= NULL,
			@pGovernmentAssetNo				NVARCHAR(100)		= NULL,
			@pGovernmentAssetNoDescription	NVARCHAR(500)		= NULL,
			@pPurchaseDate					DATETIME			= NULL,
			@pPurchaseDateUTC				DATETIME 			= NULL,
			@pVariationPurchaseCost			NUMERIC(24,2)		= NULL,
			@pContractCost					NUMERIC(24,2)		= NULL,
			@pContractLpoNo					NVARCHAR(200)		= NULL,
			@pCompanyAssetPraId				INT					= NULL,
			@pCompanyAssetRegId				INT					= NULL,
			@pWarrantyProvision				INT					= NULL,
			@pUserAreaId					INT					= NULL,
			@pAOId							INT					= NULL,
			@pAODate						DATETIME			= NULL,
			@pAODateUTC						DATETIME			= NULL,
			@pJOHNId						INT					= NULL,
			@pJOHNDate						DATETIME			= NULL,
			@pJOHNDateUTC					DATETIME			= NULL,
			@pHosDirectorId					INT					= NULL,
			@pHosDirectorDate				DATETIME			= NULL,
			@pHosDirectorDateUTC			DATETIME			= NULL,
			@pAvailableCost					NUMERIC(24,2)		= NULL,
			@pMainSupplierCode				NVARCHAR(50)		= NULL,
			@pMainSupplierName				NVARCHAR(150)		= NULL,
			@pTimestamp						VARBINARY(200)		= NULL

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

    IF(isnull(@pVariationId,0) = 0  OR @pVariationId = '')

	  BEGIN
	          INSERT INTO VmVariationTxn			(
													CustomerId,
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
													ClosingMonth,
													ClosingYear,
													VariationApprovedStatus,
													OldUsage,
													NewUsage,
													UserLocation,
													Justification,
													ApprovedDate,
													ApprovedDateUTC,
													ApprovedAmount,
													Remarks,
													AuthorizedStatus,
													IsMonthClosed,
													Period,
													PaymentStartDate,
													PaymentStartDateUTC,
													PWPaymentStartDate,
													PWPaymentStartDateUTC,
													ProposedRateDW,
													ProposedRatePW,
													MonthlyProposedFeeDW,
													MonthlyProposedFeePW,
													CalculatedFeePW,
													CalculatedFeeDW,
													VariationRaisedDate,
													VariationRaisedDateUTC,
													AssetOldVariationData,
													VariationWFStatus,
													DoneBy,
													DoneDate,
													DoneDateUTC,
													DoneRemarks,
													IsVerify,
													GovernmentAssetNo,
													GovernmentAssetNoDescription,
													PurchaseDate,
													PurchaseDateUTC,
													VariationPurchaseCost,
													ContractCost,
													ContractLpoNo,
													CompanyAssetPraId,
													CompanyAssetRegId,
													WarrantyProvision,
													UserAreaId,
													AOId,
													AODate,
													AODateUTC,
													JOHNId,
													JOHNDate,
													JOHNDateUTC,
													HosDirectorId,
													HosDirectorDate,
													HosDirectorDateUTC,
													AvailableCost,
													MainSupplierCode,
													MainSupplierName,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC                               
                           )OUTPUT INSERTED.VariationId INTO @Table
			  VALUES								(
													@pCustomerId,
													@pFacilityId,
													@pServiceId,
													@pSNFDocumentNo,
													@pSnfDate,
													@pAssetId,
													@pAssetClassification,
													@pVariationStatus,
													@pPurchaseProjectCost,
													@pVariationDate,
													@pVariationDateUTC,
													@pStartServiceDate,
													@pStartServiceDateUTC,
													@pServiceStopDate,
													@pServiceStopDateUTC,
													@pCommissioningDate,
													@pCommissioningDateUTC,
													@pWarrantyDurationMonth,
													@pWarrantyStartDate,
													@pWarrantyStartDateUTC,
													@pWarrantyEndDate,
													@pWarrantyEndDateUTC,
													@pClosingMonth,
													@pClosingYear,
													@pVariationApprovedStatus,
													@pOldUsage,
													@pNewUsage,
													@pUserLocation,
													@pJustification,
													@pApprovedDate,
													@pApprovedDateUTC,
													@pApprovedAmount,
													@pRemarks,
													@pAuthorizedStatus,
													@pIsMonthClosed,
													@pPeriod,
													@pPaymentStartDate,
													@pPaymentStartDateUTC,
													@pPWPaymentStartDate,
													@pPWPaymentStartDateUTC,
													@pProposedRateDW,
													@pProposedRatePW,
													@pMonthlyProposedFeeDW,
													@pMonthlyProposedFeePW,
													@pCalculatedFeePW,
													@pCalculatedFeeDW,
													@pVariationRaisedDate,
													@pVariationRaisedDateUTC,
													@pAssetOldVariationData,
													@pVariationWFStatus,
													@pDoneBy,
													@pDoneDate,
													@pDoneDateUTC,
													@pDoneRemarks,
													@pIsVerify,
													@pGovernmentAssetNo,
													@pGovernmentAssetNoDescription,
													@pPurchaseDate,
													@pPurchaseDateUTC,
													@pVariationPurchaseCost,
													@pContractCost,
													@pContractLpoNo,
													@pCompanyAssetPraId,
													@pCompanyAssetRegId,
													@pWarrantyProvision,
													@pUserAreaId,
													@pAOId,
													@pAODate,
													@pAODateUTC,
													@pJOHNId,
													@pJOHNDate,
													@pJOHNDateUTC,
													@pHosDirectorId,
													@pHosDirectorDate,
													@pHosDirectorDateUTC,
													@pAvailableCost,
													@pMainSupplierCode,
													@pMainSupplierName,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE()
													)
			Declare @mPrimaryId int= (select VariationId from VmVariationTxn WHERE	VariationId IN (SELECT ID FROM @Table))





			  INSERT INTO VmVariationTxnDet(													
													CustomerId,
													FacilityId,
													ServiceId,
													VariationId,
													VariationWFStatus,
													DoneBy,
													DoneDate,
													DoneRemarks,
													IsVerify,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC						
                                                    )
				   SELECT							CustomerId,
													FacilityId,
													ServiceId,
													@mPrimaryId,
													VariationWFStatus,
													DoneBy,
													DoneDate,
													DoneRemarks,
													IsVerify,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM		@VmVariationTxnDet	AS VariationType
				   WHERE	ISNULL(VariationType.VariationDetId,0)=0








			   	   SELECT				VariationId,
										[Timestamp],
										''	ErrorMessage
				   FROM					VmVariationTxn
				   WHERE				VariationId IN (SELECT ID FROM @Table)
	
		END
  ELSE
	  BEGIN

				DECLARE @mTimestamp varbinary(200);
				SELECT	@mTimestamp = Timestamp FROM	VmVariationTxn 
				WHERE	VariationId	=	@pVariationId

				IF (@mTimestamp=@pTimestamp)
				
				BEGIN
				UPDATE VmVariationTxn SET 
									CustomerId									=@pCustomerId,
									FacilityId									=@pFacilityId,
									ServiceId									=@pServiceId,
									SNFDocumentNo								=@pSNFDocumentNo,
									SnfDate										=@pSnfDate,
									AssetId										=@pAssetId,
									AssetClassification							=@pAssetClassification,
									VariationStatus								=@pVariationStatus,
									PurchaseProjectCost							=@pPurchaseProjectCost,
									VariationDate								=@pVariationDate,
									VariationDateUTC							=@pVariationDateUTC,
									StartServiceDate							=@pStartServiceDate,
									StartServiceDateUTC							=@pStartServiceDateUTC,
									ServiceStopDate								=@pServiceStopDate,
									ServiceStopDateUTC							=@pServiceStopDateUTC,
									CommissioningDate							=@pCommissioningDate,
									CommissioningDateUTC						=@pCommissioningDateUTC,
									WarrantyDurationMonth						=@pWarrantyDurationMonth,
									WarrantyStartDate							=@pWarrantyStartDate,
									WarrantyStartDateUTC						=@pWarrantyStartDateUTC,
									WarrantyEndDate								=@pWarrantyEndDate,
									WarrantyEndDateUTC							=@pWarrantyEndDateUTC,
									ClosingMonth								=@pClosingMonth,
									ClosingYear									=@pClosingYear,
									VariationApprovedStatus						=@pVariationApprovedStatus,
									OldUsage									=@pOldUsage,
									NewUsage									=@pNewUsage,
									UserLocation								=@pUserLocation,
									Justification								=@pJustification,
									ApprovedDate								=@pApprovedDate,
									ApprovedDateUTC								=@pApprovedDateUTC,
									ApprovedAmount								=@pApprovedAmount,
									Remarks										=@pRemarks,
									AuthorizedStatus							=@pAuthorizedStatus,
									IsMonthClosed								=@pIsMonthClosed,
									Period										=@pPeriod,
									PaymentStartDate							=@pPaymentStartDate,
									PaymentStartDateUTC							=@pPaymentStartDateUTC,
									PWPaymentStartDate							=@pPWPaymentStartDate,
									PWPaymentStartDateUTC						=@pPWPaymentStartDateUTC,
									ProposedRateDW								=@pProposedRateDW,
									ProposedRatePW								=@pProposedRatePW,
									MonthlyProposedFeeDW						=@pMonthlyProposedFeeDW,
									MonthlyProposedFeePW						=@pMonthlyProposedFeePW,
									CalculatedFeePW								=@pCalculatedFeePW,
									CalculatedFeeDW								=@pCalculatedFeeDW,
									VariationRaisedDate							=@pVariationRaisedDate,
									VariationRaisedDateUTC						=@pVariationRaisedDateUTC,
									AssetOldVariationData						=@pAssetOldVariationData,
									VariationWFStatus							=@pVariationWFStatus,
									DoneBy										=@pDoneBy,
									DoneDate									=@pDoneDate,
									DoneDateUTC									=@pDoneDateUTC,
									DoneRemarks									=@pDoneRemarks,
									IsVerify									=@pIsVerify,
									GovernmentAssetNo							=@pGovernmentAssetNo,
									GovernmentAssetNoDescription				=@pGovernmentAssetNoDescription,
									PurchaseDate								=@pPurchaseDate,
									PurchaseDateUTC								=@pPurchaseDateUTC,
									VariationPurchaseCost						=@pVariationPurchaseCost,
									ContractCost								=@pContractCost,
									ContractLpoNo								=@pContractLpoNo,
									CompanyAssetPraId							=@pCompanyAssetPraId,
									CompanyAssetRegId							=@pCompanyAssetRegId,
									WarrantyProvision							=@pWarrantyProvision,
									UserAreaId									=@pUserAreaId,
									AOId										=@pAOId,
									AODate										=@pAODate,
									AODateUTC									=@pAODateUTC,
									JOHNId										=@pJOHNId,
									JOHNDate									=@pJOHNDate,
									JOHNDateUTC									=@pJOHNDateUTC,
									HosDirectorId								=@pHosDirectorId,
									HosDirectorDate								=@pHosDirectorDate,
									HosDirectorDateUTC							=@pHosDirectorDateUTC,
									AvailableCost								=@pAvailableCost,
									MainSupplierCode							=@pMainSupplierCode,
									MainSupplierName							=@pMainSupplierName,
									ModifiedBy									=@pUserId,
									ModifiedDate								=GETDATE(),
									ModifiedDateUTC								=GETUTCDATE()
									OUTPUT INSERTED.VariationId INTO @Table
			   WHERE VariationId=@pVariationId

			   	   SELECT				VariationId,
										[Timestamp]
				   FROM					VmVariationTxn
				   WHERE				VariationId IN (SELECT ID FROM @Table)


			    UPDATE Variation SET	
									Variation.CustomerId				= VariationType.CustomerId,
									Variation.FacilityId				= VariationType.FacilityId,
									Variation.ServiceId					= VariationType.ServiceId,
									Variation.VariationWFStatus			= VariationType.VariationWFStatus,
									Variation.DoneBy					= VariationType.DoneBy,
									Variation.DoneDate					= VariationType.DoneDate,
									Variation.DoneRemarks				= VariationType.DoneRemarks,
									Variation.IsVerify					= VariationType.IsVerify,
									Variation.ModifiedBy				= @pUserId,			
									Variation.ModifiedDate				= GETDATE(),		
									Variation.ModifiedDateUTC			= GETUTCDATE()	
									--OUTPUT INSERTED.StockUpdateDetId INTO @Table
					FROM	VmVariationTxnDet AS Variation 
							INNER JOIN @VmVariationTxnDet AS VariationType ON Variation.VariationDetId	=	VariationType.VariationDetId
					WHERE ISNULL(VariationType.VariationDetId,0)>0
			
           
			  INSERT INTO VmVariationTxnDet(													
													CustomerId,
													FacilityId,
													ServiceId,
													VariationId,
													VariationWFStatus,
													DoneBy,
													DoneDate,
													DoneRemarks,
													IsVerify,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC						
                                                    )
				   SELECT							CustomerId,
													FacilityId,
													ServiceId,
													@pVariationId,
													VariationWFStatus,
													DoneBy,
													DoneDate,
													DoneRemarks,
													IsVerify,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM		@VmVariationTxnDet	AS VariationType
				   WHERE	ISNULL(VariationType.VariationDetId,0)=0


END
				ELSE
			BEGIN
				SELECT	VariationId,
						SNFDocumentNo,
						[Timestamp],							
						'Record Modified. Please Re-Select' AS ErrorMessage
				FROM	VmVariationTxn
				WHERE	VariationId =@pVariationId
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
		   THROW;

END CATCH


------------------------------------------------------------------------- UDT Creation --------------------------------------------------------------

--drop proc [uspFM_VmVariationTxn_Save]

--drop type [udt_VmVariationTxnDet]


--CREATE TYPE [dbo].[udt_VmVariationTxnDet] AS TABLE(

--VariationDetId			INT,
--CustomerId				INT,
--FacilityId				INT,
--ServiceId				INT,
--VariationWFStatus		INT,
--DoneBy					INT,
--DoneDate				DATETIME,
--DoneRemarks				NVARCHAR(1000),
--IsVerify				BIT
--)
--GO
GO
