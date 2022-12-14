USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSparePartPurchaseRequest_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSparePartPurchaseRequest_GetById
Description			: Spare Parts Purchase Request
Authors				: Dhilip V
Date				: 21-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_EngSparePartPurchaseRequest_GetById] @pWorkOrderId =1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngSparePartPurchaseRequest_GetById]
		
		@pWorkOrderId INT


AS                                              

BEGIN TRY



-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT




					SELECT 	SparePartsRequsetId
							,PurchaseReq.SparePartsId
							,SparePart.PartNo
							,SparePart.PartDescription
							,Item.ItemNo	as ItemCode
							,Item.ItemDescription
							,PurchaseReq.WorkOrderId
							,MWO.MaintenanceWorkNo
							,PurchaseReq.Quantity
							,PurchaseReq.Remarks
							,PurchaseReq.CreatedBy			
							,PurchaseReq.CreatedDate
							,PurchaseReq.CreatedDateUTC
							,PurchaseReq.ModifiedBy
							,PurchaseReq.ModifiedDate
							,PurchaseReq.ModifiedDateUTC
					FROM	EngSparePartPurchaseRequest				AS	PurchaseReq		WITH(NOLOCK)
							INNER JOIN	EngSpareParts				AS	SparePart		WITH(NOLOCK)	ON	PurchaseReq.SparePartsId	=	SparePart.SparePartsId
							INNER JOIN	FMItemMaster				AS	Item			WITH(NOLOCK)	ON	SparePart.ItemId			=	Item.ItemId
							INNER JOIN	EngMaintenanceWorkOrderTxn	AS	MWO				WITH(NOLOCK)	ON	PurchaseReq.WorkOrderId		=	MWO.WorkOrderId
					WHERE	PurchaseReq.WorkOrderId = @pWorkOrderId



	--END


END TRY

BEGIN CATCH


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
