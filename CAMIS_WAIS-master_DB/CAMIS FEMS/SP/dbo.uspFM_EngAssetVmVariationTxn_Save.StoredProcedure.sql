USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetVmVariationTxn_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetVmVariationTxn_Save
Description			: If Variation already exists then update else insert.
Authors				: Dhilip V
Date				: 06-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @VmVariationTxnDet AS [dbo].[udt_VmVariationTxnDet]
 insert into  @VmVariationTxnDet()
 VALUES ()
DECLARE @VmVariationTxn AS [dbo].[udt_EngAssetVmVariationTxn]
 insert into  @VmVariationTxnDet()
 VALUES ()

EXEC [uspFM_EngAssetVmVariationTxn_Save] @VmVariationTxnDet,

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetVmVariationTxn_Save]

			--@VmVariationTxnDet  [dbo].[udt_VmVariationTxnDet] READONLY,	
			@VmVariationTxn		[dbo].[udt_EngAssetVmVariationTxn] READONLY,
			@pTimestamp						VARBINARY(200)		= NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT, AssetId INT,AuthorizedStatus bit,ServiceStopDate datetime)
	DECLARE @Table1 TABLE (ID INT, AssetId INT,AuthorizedStatus bit,ServiceStopDate datetime)
	DECLARE @pVariationId INT,@AssetId int
-- Default Values

	--SET @pVariationId = (SELECT top 1 ISNULL(VariationId,0) FROM @VmVariationTxn where VariationId=0)

	SELECT top 1   @AssetId= ISNULL(AssetId,0) FROM @VmVariationTxn --where VariationId=0

-- Execution

   -- IF(isnull(@pVariationId,0) = 0  OR @pVariationId = '')

	  --BEGIN

	 
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
                           )OUTPUT INSERTED.VariationId , INSERTED.AssetId,inserted.AuthorizedStatus,inserted.ServiceStopDate INTO @Table
								 SELECT		VariationType.CustomerId,
											VariationType.FacilityId,
											VariationType.ServiceId,
											VariationType.SNFDocumentNo,
											VariationType.SnfDate,
											VariationType.AssetId,
											VariationType.AssetClassification,
											VariationType.VariationStatus,
											VariationType.PurchaseProjectCost,
											VariationType.VariationDate,
											VariationType.VariationDateUTC,
											VariationType.StartServiceDate,
											VariationType.StartServiceDateUTC,
											VariationType.ServiceStopDate,
											VariationType.ServiceStopDateUTC,
											VariationType.CommissioningDate,
											VariationType.CommissioningDateUTC,
											VariationType.WarrantyDurationMonth,
											VariationType.WarrantyStartDate,
											VariationType.WarrantyStartDateUTC,
											VariationType.WarrantyEndDate,
											VariationType.WarrantyEndDateUTC,
											VariationType.VariationApprovedStatus,
											VariationType.Remarks,
											VariationType.AuthorizedStatus,
											VariationType.VariationRaisedDate,
											VariationType.VariationRaisedDateUTC,
											VariationType.VariationWFStatus,
											VariationType.PurchaseDate,
											VariationType.PurchaseDateUTC,
											VariationType.VariationPurchaseCost,
											VariationType.ContractCost,
											VariationType.ContractLpoNo,
											VariationType.MainSupplierCode,
											VariationType.MainSupplierName,
											VariationType.UserId,													
											GETDATE(), 
											GETUTCDATE(),
											VariationType.UserId,													
											GETDATE(), 
											GETUTCDATE()
								FROM	@VmVariationTxn AS VariationType
								LEFT JOIN VmVariationTxn AS Variation  ON Variation.VariationId	=	VariationType.VariationId		
								WHERE	ISNULL(VariationType.VariationId,0)=0
								AND Variation.VariationId IS NULL

					update Variation set Variation.IsMonthClosed		=	1
					FROM	VmVariationTxn AS Variation 
					INNER JOIN @Table AS VariationType ON Variation.VariationId	=	VariationType.ID
					WHERE ISNULL(VariationType.ID,0)>0
					AND  isnull(IsMonthClosed,0) !=1 
					AND	 isnull(Variation.AuthorizedStatus,0) = 1

					
					UPDATE Asset SET	Asset.[Authorization]	=	199									
					FROM	EngAsset						AS Asset						
					INNER JOIN @Table		AS t	ON	Asset.AssetId	=	t.AssetId
					where isnull(Asset.[Authorization],0)	!=	199	
					AND	 isnull(t.AuthorizedStatus,0) = 1
						
					UPDATE Asset SET	AssetStatusLovId  = 	case when t.ServiceStopDate is not null then 0 
										else AssetStatusLovId end 	
					FROM	EngAsset						AS Asset						
					INNER JOIN @Table		AS t	ON	Asset.AssetId	=	t.AssetId						
					AND	 isnull(t.AuthorizedStatus,0) = 1
   											   			

		--END
		--ELSE
		--BEGIN

	

					UPDATE Variation SET	Variation.ServiceStopDate			= VariationType.ServiceStopDate,
											Variation.AuthorizedStatus			= VariationType.AuthorizedStatus,
											Variation.Remarks					= VariationType.Remarks,
											Variation.ModifiedBy				= UserId,			
											Variation.ModifiedDate				= GETDATE(),		
											Variation.ModifiedDateUTC			= GETUTCDATE()
											OUTPUT INSERTED.VariationId, INSERTED.AssetId ,inserted.AuthorizedStatus,inserted.ServiceStopDate INTO @Table1
					FROM	VmVariationTxn AS Variation 
							INNER JOIN @VmVariationTxn AS VariationType ON Variation.VariationId	=	VariationType.VariationId
					WHERE ISNULL(VariationType.VariationId,0)>0
			
					update Variation set Variation.IsMonthClosed		=	1
					FROM	VmVariationTxn AS Variation 
							INNER JOIN @Table1 AS VariationType ON Variation.VariationId	=	VariationType.ID
					WHERE ISNULL(VariationType.ID,0)>0
					AND  isnull(IsMonthClosed,0) !=1 
					AND	 isnull(Variation.AuthorizedStatus,0) = 1

						
					UPDATE Asset SET	Asset.[Authorization]	=	199									
					FROM	EngAsset						AS Asset						
					INNER JOIN @Table1		AS t	ON	Asset.AssetId	=	t.AssetId
					where isnull(Asset.[Authorization],0)	!=	199	
					AND	 isnull(t.AuthorizedStatus,0) = 1

					
						
					UPDATE Asset SET	AssetStatusLovId  = 	case when t.ServiceStopDate is not null then 0 
										else AssetStatusLovId end 	
					FROM	EngAsset						AS Asset						
					INNER JOIN @Table1		AS t	ON	Asset.AssetId	=	t.AssetId						
					AND	 isnull(t.AuthorizedStatus,0) = 1

				

					declare @active bit

					select @active = AssetStatusLovId from EngAsset  a where Assetid= @AssetId

			   	   SELECT				VariationId,
										[Timestamp],
										''	ErrorMessage,
										@active as Active
				   FROM					VmVariationTxn
				   WHERE			(	VariationId IN (SELECT ID FROM @Table)	
				   or VariationId IN (SELECT ID FROM @Table1)	)


				   
			   		update Variation set  ContractType = a.ContractType, PurchaseDate= a.PurchaseDate,	PurchaseDateUTC=a.PurchaseDateUTC,
						WarrantyStartDate=a.WarrantyStartDate,WarrantyStartDateUTC=a.WarrantyStartDateUTC,WarrantyEndDate=a.WarrantyEndDate,
						WarrantyEndDateUTC=a.WarrantyEndDateUTC
					From VmVariationTxn AS Variation 
					INNER JOIN @Table  AS t ON Variation.VariationId	=	t.ID
					join engasset A on t.AssetId = a.AssetId	

					
			   		update Variation set  ContractType = a.ContractType, PurchaseDate= a.PurchaseDate,	PurchaseDateUTC=a.PurchaseDateUTC,
						WarrantyStartDate=a.WarrantyStartDate,WarrantyStartDateUTC=a.WarrantyStartDateUTC,WarrantyEndDate=a.WarrantyEndDate,
						WarrantyEndDateUTC=a.WarrantyEndDateUTC
					From VmVariationTxn AS Variation 
					INNER JOIN @Table1  AS t ON Variation.VariationId	=	t.ID	
					join engasset A on t.AssetId = a.AssetId	
					

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

--drop proc [uspFM_EngAssetVmVariationTxn_Save]

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
--GO
GO
