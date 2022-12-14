USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSparePartPurchaseRequest_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSparePartPurchaseRequest_Save
Description			: Spare Parts Purchase Request
Authors				: Dhilip V
Date				: 21-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pSparePartPurchaseRequest		[dbo].[udt_EngSparePartPurchaseRequest]
INSERT INTO @pSparePartPurchaseRequest (SparePartsRequsetId,SparePartsId,WorkOrderId,Quantity,Remarks,UserId)
VALUES (0,1,1,10,'dd',1)
EXECUTE [uspFM_EngSparePartPurchaseRequest_Save] @pSparePartPurchaseRequest = @pSparePartPurchaseRequest

SELECT * FROM EngSpareParts
SELECT * FROM EngSparePartPurchaseRequest
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngSparePartPurchaseRequest_Save]
		
		@pSparePartPurchaseRequest		[dbo].[udt_EngSparePartPurchaseRequest] READONLY


AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT



--			IF EXISTS(SELECT 1 FROM @pSparePartPurchaseRequest WHERE	ISNULL(SparePartsRequsetId,0)=0)

--BEGIN
	
			INSERT INTO EngSparePartPurchaseRequest
						(	SparePartsId
							,WorkOrderId
							,Quantity
							,Remarks
							,CreatedBy
							,CreatedDate
							,CreatedDateUTC
							,ModifiedBy
							,ModifiedDate
							,ModifiedDateUTC
						)	OUTPUT INSERTED.SparePartsRequsetId INTO @Table	
					SELECT 	SparePartsId
							,WorkOrderId
							,Quantity
							,Remarks
							,UserId			
							,GETDATE()
							,GETUTCDATE()
							,UserId
							,GETDATE()
							,GETUTCDATE()
					FROM	@pSparePartPurchaseRequest
					WHERE	ISNULL(SparePartsRequsetId,0)=0


			UPDATE	PurchaseReq	SET PurchaseReq.SparePartsId	= udt_PurchaseReq.SparePartsId,
									PurchaseReq.Quantity		= udt_PurchaseReq.Quantity,
									PurchaseReq.Remarks			= udt_PurchaseReq.Remarks,
									PurchaseReq.ModifiedBy		= udt_PurchaseReq.UserId,
									PurchaseReq.ModifiedDate	= GETDATE(),
									PurchaseReq.ModifiedDateUTC = GETUTCDATE()
							OUTPUT INSERTED.SparePartsRequsetId INTO @Table	
			FROM	EngSparePartPurchaseRequest AS PurchaseReq
					INNER JOIN @pSparePartPurchaseRequest AS udt_PurchaseReq ON PurchaseReq.SparePartsRequsetId= udt_PurchaseReq.SparePartsRequsetId
			WHERE	ISNULL(udt_PurchaseReq.SparePartsRequsetId,0)>0


			SELECT	SparePartsRequsetId,
					SparePartsId,
					WorkOrderId,
					(select MaintenanceWorkNo from EngMaintenanceWorkOrderTxn a where a.WorkOrderId=b.WorkOrderId) as MaintenanceWorkNo,
					'' ErrorMessage,
					[Timestamp]
			FROM	EngSparePartPurchaseRequest b
			WHERE	SparePartsRequsetId IN (SELECT ID FROM @Table)
			
	--END



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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
