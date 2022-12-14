USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngStockAdjustmentTxn_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockAdjustmentTxn_Save
Description			: If staff already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @EngStockAdjustmentTxnDet		[dbo].[udt_EngStockAdjustmentTxnDet]
INSERT INTO @EngStockAdjustmentTxnDet (StockAdjustmentDetId,CustomerId,FacilityId,ServiceId,StockUpdateDetId,SparePartsId,PhysicalQuantity,Variance,AdjustedQuantity,Cost,
PurchaseCost,InvoiceNo,Remarks,UserId,VendorName) 
VALUES ('',1,1,2,79,1,25.52,25.5,69.2,110,456,'adfffeg','KJEWFJPWE',2,'Subramani')  
EXECUTE [uspFM_EngStockAdjustmentTxn_Save]  @EngStockAdjustmentTxnDet, @pStockAdjustmentId=0,@CustomerId='1',@FacilityId='1',@ServiceId='2',@StockAdjustmentNo='AAAA',
@AdjustmentDate='2018-04-09 20:04:04.457',@AdjustmentDateUTC='2018-04-09 20:04:04.457',@ApprovalStatus=2314,		
@ApprovedBy='BBBBB',@ApprovedDate='2018-04-09 20:04:04.457',@ApprovedDateUTC='2018-04-09 20:04:04.457',@pUserId=2

select * from EngStockAdjustmentTxn
select * from EngStockAdjustmentTxndET

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngStockAdjustmentTxn_Save]
		
		@EngStockAdjustmentTxnDet		[dbo].[udt_EngStockAdjustmentTxnDet]   READONLY,
		@pStockAdjustmentId				INT				=	NULL,
		@pUserId						INT,
		@CustomerId						INT,
		@FacilityId						INT,
		@ServiceId						INT				=	NULL,
		@StockAdjustmentNo				NVARCHAR(100)	=	NULL,
		@AdjustmentDate					DATETIME,
		@AdjustmentDateUTC				DATETIME,
		@ApprovalStatus					INT,
		@ApprovedBy						NVARCHAR(100)	=	NULL,
		@ApprovedDate					DATETIME=null,
		@ApprovedDateUTC				DATETIME=null,
		@Submitted						BIT		=0,
		@Approved						BIT		=0,
		@Rejected						BIT		=0

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
	DECLARE	@mMonth	 INT
	DECLARE	@mYear	 INT
	DECLARE @DuplicateCount INT
	SET @mMonth = MONTH(@AdjustmentDate)
	SET @mYear = YEAR(@AdjustmentDate)
	SET @ServiceId= (SELECT ISNULL(@ServiceId,2))


--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngStockAdjustmentTxn

--SET		@DuplicateCount=(SELECT  COUNT(*) FROM @EngStockAdjustmentTxnDet GROUP BY SparePartsId HAVING COUNT(*) > 1)
--IF (@DuplicateCount>0)
--BEGIN
--SELECT		0 As StockAdjustmentId,
--			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [Timestamp],
--			'Part No should be unique' AS ErrorMessage
--RETURN
--END
--ELSE IF EXISTS(SELECT  1 FROM EngStockAdjustmentTxnDet A INNER JOIN @EngStockAdjustmentTxnDet B ON A.StockAdjustmentId = B.StockAdjustmentId AND A.SparePartsId = B.SparePartsId 
--				INNER JOIN EngStockAdjustmentTxn C ON A.StockAdjustmentId=C.StockAdjustmentId WHERE C.AdjustmentDate= @AdjustmentDate
--				GROUP BY A.SparePartsId,A.InvoiceNo,C.AdjustmentDate
--				)
--BEGIN
--SELECT		0 As StockAdjustmentId,
--			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [Timestamp],
--			'Part No Already Available' AS ErrorMessage
--END

--ELSE
--BEGIN


	
	if exists  (select sparepartsid from  @EngStockAdjustmentTxnDet  group by sparepartsid having count(1)>1 )
	begin
				SELECT	StockAdjustmentdetId as StockAdjustmentId,
					cast(''  as timestamp) as[timestamp] ,
					'Duplicate  Part No Not allowed' ErrorMessage
			FROM	@EngStockAdjustmentTxnDet
			
	END

	IF(@pStockAdjustmentId = NULL OR @pStockAdjustmentId =0)

	BEGIN

	DECLARE @pOutParam NVARCHAR(50) 
	  EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngStockAdjustmentTxn',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='BEMS',@pModuleName=NULL,@pService=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam output
	SELECT @StockAdjustmentNo=@pOutParam

			INSERT INTO EngStockAdjustmentTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							StockAdjustmentNo,
							AdjustmentDate,
							AdjustmentDateUTC,
							ApprovalStatus,
							ApprovedBy,
							ApprovedDate,
							ApprovedDateUTC,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.StockAdjustmentId INTO @Table							

			VALUES			
						(	@CustomerId,			
							@FacilityId,			
							@ServiceId,			
							@StockAdjustmentNo,	
							@AdjustmentDate,		
							@AdjustmentDateUTC,	
							@ApprovalStatus,		
							@ApprovedBy,			
							@ApprovedDate,		
							@ApprovedDateUTC,	
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()   
						)			
			SELECT	StockAdjustmentId,
					[Timestamp],
					'' ErrorMessage
			FROM	EngStockAdjustmentTxn
			WHERE	StockAdjustmentId IN (SELECT ID FROM @Table)


		     SET @PrimaryKeyId  = (SELECT ID FROM @Table)

--//2.EngStockAdjustmentTxnDet

		INSERT INTO EngStockAdjustmentTxnDet
						(
							CustomerId,
							FacilityId,
							ServiceId,
							StockAdjustmentId,
							StockUpdateDetId,
							SparePartsId,
							PhysicalQuantity,
							Variance,
							AdjustedQuantity,
							Cost,
							PurchaseCost,
							InvoiceNo,
							Remarks,
							VendorName,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)

			SELECT
							CustomerId,			
							FacilityId,		
							ServiceId,			
							@PrimaryKeyId,	
							StockUpdateDetId,	
							SparePartsId,		
							PhysicalQuantity,	
							Variance,			
							AdjustedQuantity,	
							Cost,				
							PurchaseCost,		
							InvoiceNo,			
							Remarks,
							VendorName,
							@pUserId,				
							GETDATE(),			
							GETUTCDATE(),
							@pUserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@EngStockAdjustmentTxnDet
			WHERE   ISNULL(StockAdjustmentDetId,0)=0


end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.EngStockAdjustmentTxn UPDATE

			

BEGIN
	
	    UPDATE  StockAdjustment	SET									
								StockAdjustment.CustomerId				= @CustomerId,			 
								StockAdjustment.FacilityId				= @FacilityId,			 
								StockAdjustment.ServiceId				= @ServiceId,			 
								--StockAdjustment.StockAdjustmentNo		= @StockAdjustmentNo,	 
								StockAdjustment.AdjustmentDate			= @AdjustmentDate,		 
								StockAdjustment.AdjustmentDateUTC		= @AdjustmentDateUTC,	 
								StockAdjustment.ApprovalStatus			= @ApprovalStatus,		 
								StockAdjustment.ApprovedBy				= @ApprovedBy,			 
								StockAdjustment.ApprovedDate			= @ApprovedDate,		 
								StockAdjustment.ApprovedDateUTC			= @ApprovedDateUTC,	 
								StockAdjustment.ModifiedBy				= @pUserId,
								StockAdjustment.ModifiedDate			= GETDATE(),
								StockAdjustment.ModifiedDateUTC			= GETUTCDATE()
									OUTPUT INSERTED.StockAdjustmentId INTO @Table
				FROM	EngStockAdjustmentTxn						AS StockAdjustment
				WHERE	StockAdjustment.StockAdjustmentId= @pStockAdjustmentId 
						AND ISNULL(@pStockAdjustmentId,0)>0
		  SET @PrimaryKeyId  = (SELECT ID FROM @Table) 
--2.EngStockUpdateRegisterTxnDet UPDATE

	    UPDATE  StockAdjustmentDet	SET	
									StockAdjustmentDet.CustomerId					=   StockAdjustmentDetudt.CustomerId,			
									StockAdjustmentDet.FacilityId					=   StockAdjustmentDetudt.FacilityId,			
									StockAdjustmentDet.ServiceId					=   StockAdjustmentDetudt.ServiceId,			
									StockAdjustmentDet.StockAdjustmentId			=   StockAdjustmentDetudt.StockAdjustmentId,			
									StockAdjustmentDet.StockUpdateDetId				=   StockAdjustmentDetudt.StockUpdateDetId,		
									StockAdjustmentDet.SparePartsId					=   StockAdjustmentDetudt.SparePartsId,			
									StockAdjustmentDet.PhysicalQuantity				=   StockAdjustmentDetudt.PhysicalQuantity,		
									StockAdjustmentDet.Variance						=   StockAdjustmentDetudt.Variance,				
									StockAdjustmentDet.AdjustedQuantity				=   StockAdjustmentDetudt.AdjustedQuantity,		
									StockAdjustmentDet.Cost							=   StockAdjustmentDetudt.Cost,					
									StockAdjustmentDet.PurchaseCost					=   StockAdjustmentDetudt.PurchaseCost,			
									StockAdjustmentDet.InvoiceNo					=   StockAdjustmentDetudt.InvoiceNo,		
									StockAdjustmentDet.Remarks						=   StockAdjustmentDetudt.Remarks,
									StockAdjustmentDet.VendorName					=	StockAdjustmentDetudt.VendorName,			
									StockAdjustmentDet.ModifiedBy					=   @pUserId,			
									StockAdjustmentDet.ModifiedDate					=   GETDATE(),
									StockAdjustmentDet.ModifiedDateUTC				=   GETUTCDATE()

		FROM	EngStockAdjustmentTxnDet								AS StockAdjustmentDet 
				INNER JOIN @EngStockAdjustmentTxnDet					AS StockAdjustmentDetudt on StockAdjustmentDet.StockAdjustmentDetId=StockAdjustmentDetudt.StockAdjustmentDetId
		WHERE	ISNULL(StockAdjustmentDetudt.StockAdjustmentDetId,0)>0
	    

		IF(@Submitted = 1)
		BEGIN
		UPDATE EngStockAdjustmentTxn SET ApprovalStatus = 75 WHERE StockAdjustmentId = @pStockAdjustmentId
		END

		IF(@Approved = 1)
		BEGIN
		UPDATE EngStockAdjustmentTxn SET ApprovalStatus = 76 WHERE StockAdjustmentId = @pStockAdjustmentId
		END

		IF(@Rejected = 1)
		BEGIN
		UPDATE EngStockAdjustmentTxn SET ApprovalStatus = 77 WHERE StockAdjustmentId = @pStockAdjustmentId
		END


--//2.EngStockAdjustmentTxnDet

		

		INSERT INTO EngStockAdjustmentTxnDet
						(
							CustomerId,
							FacilityId,
							ServiceId,
							StockAdjustmentId,
							StockUpdateDetId,
							SparePartsId,
							PhysicalQuantity,
							Variance,
							AdjustedQuantity,
							Cost,
							PurchaseCost,
							InvoiceNo,
							Remarks,
							VendorName,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)

			SELECT
							CustomerId,			
							FacilityId,		
							ServiceId,			
							ISNULL(NULLIF(StockAdjustmentId,0),	@PrimaryKeyId),	
							StockUpdateDetId,	
							SparePartsId,		
							PhysicalQuantity,	
							Variance,			
							AdjustedQuantity,	
							Cost,				
							PurchaseCost,		
							InvoiceNo,			
							Remarks,
							VendorName,
							@pUserId,				
							GETDATE(),			
							GETUTCDATE(),
							@pUserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@EngStockAdjustmentTxnDet AS EngStockAdjustmentTxnDetType
			WHERE   ISNULL(EngStockAdjustmentTxnDetType.StockAdjustmentDetId,0)=0

END   
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



-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_EngStockAdjustmentTxn_Save]
--drop type udt_EngStockAdjustmentTxnDet


--CREATE TYPE [dbo].[udt_EngStockAdjustmentTxnDet] AS TABLE
--(
--StockAdjustmentDetId				INT,
--CustomerId							INT,
--FacilityId							INT,
--ServiceId							INT,
--StockAdjustmentId					int,
--StockUpdateId						INT,
--StockUpdateDetId					INT,
--SparePartsId						INT,
--PhysicalQuantity					NUMERIC(24,2),
--Variance							NUMERIC(24,2),
--AdjustedQuantity					NUMERIC(24,2),
--Cost								NUMERIC(24,2),
--PurchaseCost						NUMERIC(24,2),
--InvoiceNo							NVARCHAR(50),
--Remarks								NVARCHAR(1000),
--VendorName							NVARCHAR(200)
--)
GO
