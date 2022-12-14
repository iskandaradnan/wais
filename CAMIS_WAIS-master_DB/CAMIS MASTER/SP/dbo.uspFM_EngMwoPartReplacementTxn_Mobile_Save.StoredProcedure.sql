USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoPartReplacementTxn_Mobile_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoPartReplacementTxn_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pEngMwoPartReplacementTxn		[dbo].[udt_EngMwoPartReplacementTxn]
INSERT INTO @pEngMwoPartReplacementTxn ([PartReplacementId],[CustomerId],[FacilityId],[ServiceId],[WorkOrderId],[SparePartStockRegisterId],[Quantity],[Cost],
[LabourCost],[StockUpdateDetId],[ActualQuantityinStockUpdate],[UserId]) 
VALUES (1,1,1,2,139,1,10,50,100,NULL,100,1),
('',1,1,2,139,1,10,50,100,NULL,100,1)  
EXECUTE [uspFM_EngMwoPartReplacementTxn_Save]  139,@pEngMwoPartReplacementTxn

[PartReplacementId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[WorkOrderId] [int] NULL,
--	[SparePartStockRegisterId] [int] NULL,
--	[Quantity] [int] NULL,
--	[Cost] [numeric](24, 2) NULL,
--	[LabourCost] [numeric](24, 2) NULL,
--	[StockUpdateDetId] [int] NULL,
--	[ActualQuantityinStockUpdate] [int] NULL,
--	[UserId] [int] NULL

select * from EngMwoPartReplacementTxn
delete from EngMwoPartReplacementTxn where PartReplacementId in (69,70)
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

Create PROCEDURE  [dbo].[uspFM_EngMwoPartReplacementTxn_Mobile_Save]
		
		@pWorkOrderId						 int,---Nothing
		@pEngMwoPartReplacementTxn_Mobile			 [dbo].[udt_EngMwoPartReplacementTxn_Mobile]   READONLY


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




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoPartReplacementTxn

			IF EXISTS(SELECT 1 FROM @pEngMwoPartReplacementTxn_Mobile WHERE PartReplacementId = NULL OR PartReplacementId =0)

BEGIN
	
			INSERT INTO EngMwoPartReplacementTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							WorkOrderId,
							SparePartStockRegisterId,
							Quantity,
							Cost,
							TotalPartsCost,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							LabourCost,
							TotalCost,
							StockUpdateDetId,
							ActualQuantityinStockUpdate,
							SparePartRunningHours, 
							PartReplacementCost 
							,MobileGuid
			
						)	OUTPUT INSERTED.PartReplacementId INTO @Table							

						
						SELECT 	
							CustomerId,
							FacilityId,
							ServiceId,
							WorkOrderId,
							SparePartStockRegisterId,
							Quantity,
							Cost,
							(Quantity * Cost),
							UserId,			
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE(),
							LabourCost,
							(Quantity * Cost)+LabourCost,
							StockUpdateDetId,
							ActualQuantityinStockUpdate,
							SparePartRunningHours, 
							PartReplacementCost,
							MobileGuid
						FROM @pEngMwoPartReplacementTxn_Mobile		AS MwoPartReplacementType
						WHERE 	MwoPartReplacementType.PartReplacementId =0

			SELECT	PartReplacementId,
					[Timestamp], MobileGuid
			FROM	EngMwoPartReplacementTxn
			WHERE	PartReplacementId IN (SELECT ID FROM @Table)

			--SET @PrimaryKeyId  = (SELECT ID FROM @Table)
		     

END

IF EXISTS(SELECT 1 FROM @pEngMwoPartReplacementTxn_Mobile WHERE PartReplacementId >0) 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.EngMwoPartReplacementTxn UPDATE

			

BEGIN

	    UPDATE  MwoPartReplacement	SET	
							
							MwoPartReplacement.CustomerId					= MwoPartReplacementudt.CustomerId,
							MwoPartReplacement.FacilityId					= MwoPartReplacementudt.FacilityId,
							MwoPartReplacement.ServiceId					= MwoPartReplacementudt.ServiceId,
							MwoPartReplacement.WorkOrderId					= MwoPartReplacementudt.WorkOrderId,
							MwoPartReplacement.SparePartStockRegisterId		= MwoPartReplacementudt.SparePartStockRegisterId,
							MwoPartReplacement.Quantity						= MwoPartReplacementudt.Quantity,
							MwoPartReplacement.Cost							= MwoPartReplacementudt.Cost,
							MwoPartReplacement.TotalPartsCost				= (MwoPartReplacementudt.Quantity * MwoPartReplacementudt.Cost),
							MwoPartReplacement.LabourCost					= MwoPartReplacementudt.LabourCost,
							MwoPartReplacement.StockUpdateDetId				= MwoPartReplacementudt.StockUpdateDetId,
							MwoPartReplacement.ActualQuantityinStockUpdate	= MwoPartReplacementudt.ActualQuantityinStockUpdate,
							MwoPartReplacement.TotalCost					= ((MwoPartReplacementudt.Quantity * MwoPartReplacementudt.Cost)+MwoPartReplacementudt.LabourCost),
							MwoPartReplacement.ModifiedBy					= MwoPartReplacementudt.UserId,
							MwoPartReplacement.ModifiedDate					= GETDATE(),
							MwoPartReplacement.ModifiedDateUTC				= GETUTCDATE(),
							MwoPartReplacement.SparePartRunningHours		=	MwoPartReplacementudt.SparePartRunningHours, 
							MwoPartReplacement.PartReplacementCost			=	MwoPartReplacementudt.PartReplacementCost
				OUTPUT INSERTED.PartReplacementId INTO @Table
				FROM	EngMwoPartReplacementTxn	AS MwoPartReplacement INNER JOIN @pEngMwoPartReplacementTxn_Mobile		AS MwoPartReplacementudt
				ON	MwoPartReplacement.PartReplacementId= MwoPartReplacementudt.PartReplacementId 
						AND ISNULL(MwoPartReplacementudt.PartReplacementId,0)>0


	

END



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
