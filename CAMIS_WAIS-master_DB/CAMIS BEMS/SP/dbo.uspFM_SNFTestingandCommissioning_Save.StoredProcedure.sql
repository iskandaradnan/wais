USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SNFTestingandCommissioning_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_SNFTestingandCommissioning_Save
Description			: If Testing and Commissioning already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:


EXEC [uspFM_SNFTestingandCommissioning_Save] @pTestingandCommissioningId=1,@pPurchaseDate='2018-04-01 00:00:00.000',@pPurchaseCost=10,@pContractLPONo=''
,@pServiceStartDate='2018-04-01 00:00:00.000',@pServiceEndDate='2019-04-01 00:00:00.000',@pMainSupplierCode='',@pMainSupplierName=''
,@pWarrantyStartDate='2018-04-01 00:00:00.000',@pWarrantyDuration=12,@pWarrantyEndDate='2019-04-01 00:00:00.000',@pVerifyRemarks='',@pApprovalRemarks='',@pRejectRemarks=''
,@pTimestamp='',@pStatus=7,@pUserId=1

SELECT Timestamp,* FROM EngTestingandCommissioningTxn WHERE TestingandCommissioningId=63
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_SNFTestingandCommissioning_Save]

			@pTestingandCommissioningId		INT							=	NULL,

			@pPurchaseDate					DATETIME					=	NULL,
			@pPurchaseCost					NUMERIC(24,2)				=	NULL,
			@pContractLPONo					NVARCHAR(100)				=	NULL,			
			@pServiceStartDate				DATETIME					=	NULL,
			@pServiceEndDate				DATETIME					=	NULL,
			@pMainSupplierCode				NVARCHAR(50)				=	NULL,
			@pMainSupplierName				NVARCHAR(100)				=	NULL,
			@pWarrantyStartDate				DATETIME					=	NULL,
			@pWarrantyDuration				INT							=	NULL,
			@pWarrantyEndDate				DATETIME					=	NULL,			
			@pVerifyRemarks					NVARCHAR(500)				=	NULL,
			@pApprovalRemarks				NVARCHAR(500)				=	NULL,
			@pRejectRemarks					NVARCHAR(500)				=	NULL,


			@pTimestamp						varbinary(200)				=	NULL,
			@pStatus						INT							=	NULL,
			@pUserId						INT							=	NULL,
			@pPurchaseOrderNo				NVARCHAR(100)				=	NULL,
			@pContractorId					INT							=	NULL

AS                                              

BEGIN TRY


	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @pWarrantyStartDateUTC DATETIME,@pPurchaseDateUTC DATETIME,@pServiceStartDateUTC DATETIME,@pServiceEndDateUTC DATETIME,@pWarrantyEndDateUTC  DATETIME
-- Default Values

	SET @pWarrantyStartDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pWarrantyStartDate)
	SET @pPurchaseDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pPurchaseDate)
	SET @pServiceStartDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceStartDate)
	SET @pServiceEndDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceEndDate)
	SET @pWarrantyEndDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pWarrantyEndDate)
	
-- Execution

			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	EngTestingandCommissioningTxn 
			WHERE	TestingandCommissioningId	=	@pTestingandCommissioningId

			IF (@mTimestamp=@pTimestamp)
			
			BEGIN


				UPDATE EngTestingandCommissioningTxn SET

									PurchaseCost								=	@pPurchaseCost,
									PurchaseDate								=	@pPurchaseDate,
									PurchaseDateUTC								=	@pPurchaseDateUTC,
									ServiceStartDate							=	@pServiceStartDate,
									ServiceStartDateUTC							=	@pServiceStartDateUTC,
									ContractLPONo								=	@pContractLPONo,
									ModifiedBy									=	@pUserId,
									ModifiedDate								=	GETDATE(),
									ModifiedDateUTC								=	GETUTCDATE(),
									WarrantyDuration							=	@pWarrantyDuration,
									WarrantyStartDate							=	@pWarrantyStartDate,
									WarrantyStartDateUTC						=	@pWarrantyStartDateUTC,
									WarrantyEndDate								=	@pWarrantyEndDate,
									WarrantyEndDateUTC 							=	@pWarrantyEndDateUTC,
									MainSupplierCode							=	@pMainSupplierCode,
									MainSupplierName							=	@pMainSupplierName,
									ServiceEndDate								=	@pServiceEndDate,
									ServiceEndDateUTC							=	@pServiceEndDateUTC,
									Status										=	@pStatus,
									PurchaseOrderNo								=	@pPurchaseOrderNo,
									ContractorId								=	@pContractorId
			   WHERE TestingandCommissioningId =   @pTestingandCommissioningId

			   IF (@pStatus=289)
			   BEGIN
				UPDATE EngTestingandCommissioningTxn SET	VerifyRemarks=@pVerifyRemarks	WHERE TestingandCommissioningId =   @pTestingandCommissioningId
			   END							
			   IF (@pStatus=290)
			   BEGIN
				UPDATE EngTestingandCommissioningTxn SET	ApprovalRemarks=@pApprovalRemarks	WHERE TestingandCommissioningId =   @pTestingandCommissioningId
			   END			   
			   IF (@pStatus=291)
			   BEGIN
			    Declare @lCRMRequestId  int

				UPDATE EngTestingandCommissioningTxn SET	RejectRemarks=@pRejectRemarks	WHERE TestingandCommissioningId =   @pTestingandCommissioningId
				select @lCRMRequestId = CRMRequestId from EngTestingandCommissioningTxn WHERE TestingandCommissioningId =   @pTestingandCommissioningId
				
				UPDATE CRMRequest SET RequestStatus = 140 WHERE CRMRequestId = @lCRMRequestId

			   END	

			   SELECT	CommissioningTxn.TestingandCommissioningId,
						TandCDocumentNo,
						CommissioningTxnDet.AssetPreRegistrationNo,
						CASE
							WHEN CommissioningTxn.WarrantyEndDate >=	GETDATE()	THEN '99'
							WHEN CommissioningTxn.WarrantyEndDate <		GETDATE()	THEN '100'
							ELSE	NULL	
						END																	AS WarrantyStatus,
						CommissioningTxn.[Timestamp],							
						'' ErrorMessage,
						CommissioningTxn.QRCode,
						CASE WHEN CommissioningTxn.Status = 290 THEN 'Approved'
							 WHEN CommissioningTxn.Status = 291 THEN 'Rejected'
							 WHEN CommissioningTxn.Status = 289 THEN 'Verified'
							 WHEN ISNULL(CommissioningTxn.Status,0) = 286 THEN 'Submitted'
							 WHEN ISNULL(CommissioningTxn.Status,0) = 287 THEN 'Cancelled'
						END StatusName
				FROM	EngTestingandCommissioningTxn					AS	CommissioningTxn	WITH(NOLOCK)
						INNER JOIN	EngTestingandCommissioningTxnDet	AS	CommissioningTxnDet	WITH(NOLOCK) ON	CommissioningTxn.TestingandCommissioningId	=	CommissioningTxnDet.TestingandCommissioningId
				WHERE	CommissioningTxn.TestingandCommissioningId = @pTestingandCommissioningId

		END
		ELSE
			BEGIN
			   	  SELECT	CommissioningTxn.TestingandCommissioningId,
							TandCDocumentNo,
							CommissioningTxnDet.AssetPreRegistrationNo,
							CASE
								WHEN CommissioningTxn.WarrantyEndDate >=	GETDATE()	THEN '99'
								WHEN CommissioningTxn.WarrantyEndDate <		GETDATE()	THEN '100'
								ELSE	NULL	
							END																	AS WarrantyStatus,
							CommissioningTxn.[Timestamp],
							'Record Modified. Please Re-Select' AS ErrorMessage,
							CommissioningTxn.QRCode,
							CASE WHEN CommissioningTxn.Status = 290 THEN 'Approved'
							 WHEN CommissioningTxn.Status = 291 THEN 'Rejected'
							 WHEN CommissioningTxn.Status = 289 THEN 'Verified'
							 WHEN ISNULL(CommissioningTxn.Status,0) = 286 THEN 'Submitted'
							 WHEN ISNULL(CommissioningTxn.Status,0) = 287 THEN 'Cancelled'
							END StatusName
				   FROM		EngTestingandCommissioningTxn					AS	CommissioningTxn	WITH(NOLOCK)
							INNER JOIN	EngTestingandCommissioningTxnDet	AS	CommissioningTxnDet	WITH(NOLOCK) ON	CommissioningTxn.TestingandCommissioningId	=	CommissioningTxnDet.TestingandCommissioningId
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
