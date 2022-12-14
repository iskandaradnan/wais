USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxnSNF_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTestingandCommissioningTxnSNF_Save
Description			: If Testing and Commissioning already exists then update else insert.
Authors				: Dhilip V
Date				: 01-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:


EXEC [uspFM_EngTestingandCommissioningTxnSNF_Save] @pUserId=1,@pTestingandCommissioningId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pTandCDocumentNo=NULL,
@pTandCDate='2018-01-01',@pVariationStatus=1,@pContractLPONo='113',@pPurchaseDate='2018-01-01',@pPurchaseCost='10',@pServiceStartDate='2018-01-01',@pServiceEndDate=NULL,
@pMainSupplierCode='CODE1',@pMainSupplierName='nAME',@pWarrantyStartDate='2018-01-01',@pWarrantyDuration=12,@pWarrantyEndDate='2019-01-01',@pTimestamp=NULL

SELECT Timestamp,* FROM EngTestingandCommissioningTxn WHERE TestingandCommissioningId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTestingandCommissioningTxnSNF_Save]

			@pUserId						INT							=	NULL,	
			@pTestingandCommissioningId		INT							=	NULL,
			@pCustomerId					INT							=	NULL,
			@pFacilityId					INT							=	NULL,
			@pServiceId						INT							=	NULL,

			@pTandCDate						DATETIME,
			@pVariationStatus				INT,


			@pPurchaseDate					DATETIME					=	NULL,			
			@pPurchaseCost					NUMERIC(24,2)				=	NULL,					
			@pServiceStartDate				DATETIME					=	NULL,			
			@pServiceEndDate				DATETIME					=	NULL,			
			@pAssetId						INT,

			@pRemarks						NVARCHAR(500)				=	NULL,
			@pStatus						INT							=	NULL,
			@pTimestamp						varbinary(200)				=	NULL,
			@pIsSNF							BIT							=	NULL
AS                                              

BEGIN TRY


--DECLARE @pOutParam NVARCHAR(50) 
--	  EXEC [uspFM_GenerateDocumentNumber] @pFlag='TestingandCommissioning',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@pWeek=NULL,
--@Defaultkey='TC',@pModuleName='BEMS',@pScreenName=NULL,@pService=NULL,@pMonth=4,@pYear=2018,@pOutParam=@pOutParam output
--SELECT @pTandCDocumentNo=@pOutParam
----select @pTandCDocumentNo


	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE	@pTandCType						INT							=	73
	DECLARE	@pAssetTypeCodeId				INT							=	NULL
	DECLARE	@pTandCStatus					INT							=	71
	DECLARE	@pTandCCompletedDate			DATETIME					=	NULL
	DECLARE	@pTandCCompletedDateUTC			DATETIME					=	NULL
	DECLARE	@pHandoverDate					DATETIME					=	NULL
	DECLARE	@pHandoverDateUTC				DATETIME					=	NULL
	DECLARE	@pTandCContractorRepresentative	NVARCHAR(100)				=	''
	DECLARE	@pCustomerRepresentativeUserId	INT							=	NULL
	DECLARE	@pFacilityRepresentativeUserId	INT							=	NULL
	DECLARE @pTandCDateUTC					DATETIME					=	NULL
	DECLARE	@pUserAreaId					INT							=	NULL
	DECLARE	@pUserLocationId				INT							=	NULL
	DECLARE @pServiceStartDateUTC			DATETIME					=	NULL
	DECLARE @pServiceEndDateUTC				DATETIME					=	NULL
	DECLARE @pWarrantyStartDateUTC			DATETIME					=	NULL
	DECLARE @pWarrantyEndDateUTC			DATETIME					=	NULL
	DECLARE @pPurchaseDateUTC				DATETIME					=	NULL
-- Default Values

	SET @pTandCDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pTandCDate)
	SET @pPurchaseDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pPurchaseDate)
	SET @pTandCCompletedDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pTandCCompletedDate)
	SET @pHandoverDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pHandoverDate)
	SET @pServiceStartDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceStartDate)
	SET @pServiceEndDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceEndDate)

-- Execution

    IF(ISNULL(@pTestingandCommissioningId,0)= 0 OR @pTestingandCommissioningId='')
	  BEGIN


	  
DECLARE @pOutParam NVARCHAR(50) ,@pTandCDocumentNo NVARCHAR(50)	
EXEC [uspFM_GenerateDocumentNumber] @pFlag='TestingandCommissioning',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='TC',@pModuleName='BEMS',@pMonth=NULL,@pYear=NULL,@pOutParam=@pOutParam out

SELECT @pTandCDocumentNo=@pOutParam

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
											ServiceEndDate,
											ServiceEndDateUTC,
											Status,
											AssetId	,
											IsSNF		                                                                                                           
                           )OUTPUT INSERTED.TestingandCommissioningId INTO @Table
			  VALUES						(
											@pCustomerId,
											@pFacilityId,
											@pServiceId,
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
											@pVariationStatus,
											@pTandCContractorRepresentative,
											@pCustomerRepresentativeUserId,
											@pFacilityRepresentativeUserId,
											@pUserAreaId,
											@pUserLocationId,
											@pRemarks,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE(),

											@pServiceEndDate,
											@pServiceEndDateUTC,
											290,--@pStatus,
											@pAssetId,
											@pIsSNF
											)


			   	  SELECT	CommissioningTxn.TestingandCommissioningId,
							TandCDocumentNo		AS SNFDocumentNo,
							CommissioningTxn.[Timestamp],							
							'' ErrorMessage
				   FROM		EngTestingandCommissioningTxn	AS	CommissioningTxn	WITH(NOLOCK)
				   WHERE	CommissioningTxn.TestingandCommissioningId IN (SELECT ID FROM @Table)
	
		END
  ELSE

		BEGIN



				UPDATE EngTestingandCommissioningTxn SET
									TandCDate									=	@pTandCDate,
									TandCDateUTC								=	@pTandCDateUTC,
									AssetTypeCodeId								=	@pAssetTypeCodeId,
									TandCStatus									=	@pTandCStatus,
									TandCCompletedDate							=	@pTandCCompletedDate,
									TandCCompletedDateUTC						=	@pTandCCompletedDateUTC,
									HandoverDate								=	@pHandoverDate,
									HandoverDateUTC								=	@pHandoverDateUTC,
									PurchaseCost								=	@pPurchaseCost,
									PurchaseDate								=	@pPurchaseDate,
									PurchaseDateUTC								=	@pPurchaseDateUTC,
									ServiceStartDate							=	@pServiceStartDate,
									ServiceStartDateUTC							=	@pServiceStartDateUTC,
									VariationStatus								=	@pVariationStatus,
									TandCContractorRepresentative				=	@pTandCContractorRepresentative,
									CustomerRepresentativeUserId				=	@pCustomerRepresentativeUserId,
									FacilityRepresentativeUserId				=	@pFacilityRepresentativeUserId,
									UserAreaId									=	@pUserAreaId,
									UserLocationId								=	@pUserLocationId,
									Remarks										=	@pRemarks,
									ModifiedBy									=	@pUserId,
									ModifiedDate								=	GETDATE(),
									ModifiedDateUTC								=	GETUTCDATE(),
									ServiceEndDate								=	@pServiceEndDate,
									ServiceEndDateUTC							=	@pServiceEndDateUTC,
									Status										=	290, --@pStatus,
									AssetId										=	@pAssetId,
									IsSNF										=	@pIsSNF
			   WHERE TestingandCommissioningId =   @pTestingandCommissioningId


			   SELECT	CommissioningTxn.TestingandCommissioningId,
						TandCDocumentNo		AS SNFDocumentNo,
						CommissioningTxn.[Timestamp],							
						'' ErrorMessage
				FROM	EngTestingandCommissioningTxn					AS	CommissioningTxn	WITH(NOLOCK)
				WHERE	CommissioningTxn.TestingandCommissioningId = @pTestingandCommissioningId

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
