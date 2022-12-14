USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DeductionTransactionMappingMst_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_DeductionTransactionMappingMst_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @DeductionTransactionMappingMstDet		[dbo].[udt_DeductionTransactionMappingMstDet]
INSERT INTO @DeductionTransactionMappingMstDet (DedTxnMappingDetId,CustomerId,FacilityId,Date,DocumentNo,Details,DemeritPoint,IsValid,Remarks,DeductionValue,FinalDemeritPoint) values
(0,1,1,'2018-05-16 13:07:49.597','AAA','AAA',1,1,'BBB',10,10),
(0,1,1,'2018-05-16 13:07:49.597','AAA','AAA',1,1,'BBB',10,10)
EXECUTE [uspFM_DeductionTransactionMappingMst_Save] @DeductionTransactionMappingMstDet,@pDedTxnMappingId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pMonth=1,@pYear=2018,@pDedGenerationId=null,
@pIndicatorDetId =2 ,@pGroup=2,@pUserId=2

select * from DeductionTransactionMappingMst
select * from DeductionTransactionMappingMstDet


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_DeductionTransactionMappingMst_Save]
		
		@DeductionTransactionMappingMstDet		[dbo].[udt_DeductionTransactionMappingMstDet]   READONLY,
		@pDedTxnMappingId					INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pServiceId							INT				= NULL,
		@pMonth								INT				= NULL,
		@pYear								INT				= NULL,
		@pDedGenerationId					INT				= NULL,
		@pIndicatorDetId					INT				= NULL,
		@pGroup								INT				= NULL,
		@pUserId							INT				= NULL,
		@pTimestamp							VARBINARY(200)	= NULL

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

--//1.DeductionTransactionMappingMst

			IF(@pDedTxnMappingId = NULL OR @pDedTxnMappingId =0)

BEGIN
	
			INSERT INTO DeductionTransactionMappingMst
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							Month,
							Year,
							DedGenerationId,
							IndicatorDetId,
							[Group],
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.DedTxnMappingId INTO @Table							

			VALUES			
						(	
							
							@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pMonth,
							@pYear,
							@pDedGenerationId,
							@pIndicatorDetId,
							@pGroup,
							@pUserId,
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()
						)			

			SELECT	DedTxnMappingId,
					[Timestamp]
			FROM	DeductionTransactionMappingMst
			WHERE	DedTxnMappingId IN (SELECT ID FROM @Table)

			SET @PrimaryKeyId  = (SELECT ID FROM @Table)

--2.DeductionTransactionMappingMstDet
						
			INSERT INTO DeductionTransactionMappingMstDet
						(
							CustomerId,
							FacilityId,
							DedTxnMappingId,
							Date,
							DocumentNo,
							Details,
							DemeritPoint,
							IsValid,
							Remarks,
							DeductionValue,
							FinalDemeritPoint,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							AssetNo,
							AssetDescription,
							DisputedPendingResolution
						)

			SELECT			
							@pCustomerId,
							@pFacilityId,			
							@PrimaryKeyId,	
							ServiceWorkDateTime,
							ServiceWorkNo,
							ScreenName,
							DemeritPoint,
							IsValid,
							Remarks,
							DeductionValue,
							FinalDemerit,
							@pUserId,				
							GETDATE(),			
							GETUTCDATE(),
							@pUserId,			
							GETDATE(),			
							GETUTCDATE(),
							AssetNo,
							AssetDescription,
							DisputedPendingResolution
			FROM	@DeductionTransactionMappingMstDet
			WHERE   ISNULL(DedTxnMappingDetId,0)=0





		     

END

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.DeductionTransactionMappingMst UPDATE

			

BEGIN
			--DECLARE @mTimestamp varbinary(200);
			--SELECT	@mTimestamp = Timestamp FROM	DeductionTransactionMappingMst 
			--WHERE	DedTxnMappingId	=	@pDedTxnMappingId
			
			--IF(@mTimestamp = @pTimestamp)
			--BEGIN
	    UPDATE  TransactionMappingMst	SET		
							TransactionMappingMst.CustomerId				= @pCustomerId,
							TransactionMappingMst.FacilityId				= @pFacilityId,
							TransactionMappingMst.ServiceId					= @pServiceId,
							TransactionMappingMst.Month						= @pMonth,
							TransactionMappingMst.Year						= @pYear,
							TransactionMappingMst.DedGenerationId			= @pDedGenerationId,
							TransactionMappingMst.IndicatorDetId			= @pIndicatorDetId,
							TransactionMappingMst.[Group]					= @pGroup,
							TransactionMappingMst.ModifiedBy				= @pUserId,
							TransactionMappingMst.ModifiedDate				= GETDATE(),
							TransactionMappingMst.ModifiedDateUTC			= GETUTCDATE()

							OUTPUT INSERTED.DedTxnMappingId INTO @Table
				FROM	DeductionTransactionMappingMst						AS TransactionMappingMst
				WHERE	TransactionMappingMst.DedTxnMappingId= @pDedTxnMappingId 
						AND ISNULL(@pDedTxnMappingId,0)>0

				--2.EngStockUpdateRegisterTxnDet UPDATE

	    UPDATE  TransactionMappingMstDet	SET												   	
									TransactionMappingMstDet.Date						=   TransactionMappingMstDetudt.ServiceWorkDateTime,
									TransactionMappingMstDet.DocumentNo					=   TransactionMappingMstDetudt.ServiceWorkNo,
									TransactionMappingMstDet.Details					=   TransactionMappingMstDetudt.ScreenName,
									TransactionMappingMstDet.DemeritPoint				=   TransactionMappingMstDetudt.DemeritPoint,
									TransactionMappingMstDet.IsValid					=   TransactionMappingMstDetudt.IsValid,
									TransactionMappingMstDet.Remarks					=   TransactionMappingMstDetudt.Remarks,
									TransactionMappingMstDet.DeductionValue				=   TransactionMappingMstDetudt.DeductionValue,
									TransactionMappingMstDet.FinalDemeritPoint			=   TransactionMappingMstDetudt.FinalDemerit,
									TransactionMappingMstDet.AssetNo					=	TransactionMappingMstDetudt.AssetNo	,				
									TransactionMappingMstDet.AssetDescription			=	TransactionMappingMstDetudt.AssetDescription,
									TransactionMappingMstDet.DisputedPendingResolution	=	TransactionMappingMstDetudt.DisputedPendingResolution,
									TransactionMappingMstDet.ModifiedBy					=   @pUserId,			
									TransactionMappingMstDet.ModifiedDate				=   GETDATE(),
									TransactionMappingMstDet.ModifiedDateUTC			=   GETUTCDATE()

		FROM	DeductionTransactionMappingMstDet								AS TransactionMappingMstDet 
				INNER JOIN @DeductionTransactionMappingMstDet					AS TransactionMappingMstDetudt on TransactionMappingMstDet.DedTxnMappingDetId=TransactionMappingMstDetudt.DedTxnMappingDetId
		WHERE	ISNULL(TransactionMappingMstDetudt.DedTxnMappingDetId,0)>0
		  
			SELECT	DedTxnMappingId,
					[Timestamp]
			FROM	DeductionTransactionMappingMst
			WHERE	DedTxnMappingId IN (SELECT ID FROM @Table)


--END   
--	ELSE
--		BEGIN
--				   SELECT	DedTxnMappingId,
--							[Timestamp],
--							'Record Modified. Please Re-Select' ErrorMessage
--				   FROM		DeductionTransactionMappingMst
--				   WHERE	DedTxnMappingId =@pDedTxnMappingId
--		END
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

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_DeductionTransactionMappingMst_Save]
--drop type udt_DeductionTransactionMappingMstDet


--CREATE TYPE [dbo].[udt_DeductionTransactionMappingMstDet] AS TABLE
--(

--DedTxnMappingDetId				INT ,
--ServiceWorkDateTime				DATETIME ,
--ServiceWorkNo						NVARCHAR(200) ,
--AssetNo							NVARCHAR(100) ,
--AssetDescription					NVARCHAR(500),
--ScreenName							NVARCHAR(2000) ,
--DemeritPoint					INT ,
--IsValid							BIT ,
--DisputedPendingResolution			INT,
--Remarks							NVARCHAR(1000) ,
--DeductionValue					INT ,
--FinalDemerit				INT 


--)
GO
