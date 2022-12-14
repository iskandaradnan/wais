USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DedGenerationTxn_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoCompletionInfoTxn_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_DedGenerationTxn_Save] @pDedGenerationId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pMonth=5,@pYear=2018,@pGroup=null,@pDeductionStatus='G',@pDocumentNo=null,
@pRemarks=null,@pUserId=2

EXECUTE [uspFM_DedGenerationTxn_Save] @pDedGenerationId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pMonth=12,@pYear=2018,@pGroup=null,@pDeductionStatus='G',@pDocumentNo=null,
@pRemarks=null,@pUserId=1

select * from DedGenerationTxn
select * from DedGenerationTxnDet

--
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_DedGenerationTxn_Save]
		
		@pDedGenerationId					INT				=	0,
		@pCustomerId						INT				=	NULL,
		@pFacilityId						INT				=	NULL,
		@pServiceId							INT				=	NULL,
		@pMonth								INT				=	NULL,
		@pYear								INT				=	NULL,
		@pGroup								INT				=	NULL,
		@pDeductionStatus					CHAR			=	'G',
		@pDocumentNo						NVARCHAR(100)	=	NULL, --
		@pRemarks							NVARCHAR(1000)	=	NULL, --
		@pUserId							INT				=	NULL,
		@pTimestamp							VARBINARY(200)	= NULL    --

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


	CREATE TABLE #FindIndicatorId(ConfigId int,IndicatorDetId int)

	insert into #FindIndicatorId(ConfigId) 
	select ConfigKeyId from FMConfigCustomerValues where CustomerId = @pCustomerId and ConfigKeyId between 5 and 10 AND ConfigKeyLovId = 99

	Update #FindIndicatorId set IndicatorDetId = case 
	when ConfigId =5 then 1 
	when ConfigId =6 then 2 
	when ConfigId =7 then 3
	when ConfigId =8 then 4 
	when ConfigId =9 then 5 
	when ConfigId =10 then 6 
	else 0 end 



--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoCompletionInfoTxn

IF EXISTS (SELECT 1 FROM DedGenerationTxn WHERE FacilityId=@pFacilityId AND Month = @pMonth AND Year = @pYear)

BEGIN

SELECT 'Deduction Already Generated' AS ErrorMessage

END

ELSE

BEGIN

			IF(@pDedGenerationId = NULL OR @pDedGenerationId =0)

BEGIN
	
			INSERT INTO DedGenerationTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							Month,
							Year,
							[Group],
							MonthlyServiceFee,
							DeductionStatus,
							DocumentNo,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.DedGenerationId INTO @Table							

			VALUES			
						(	
							@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pMonth,
							@pYear,
							@pGroup,
							(SELECT isnull(BemsMSF,0) as BemsMSF FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE A.FacilityId = @pFacilityId AND
							A.CustomerId=@pCustomerId AND A.Year = @pYear AND B.Month = @pMonth),
							@pDeductionStatus,
							@pDocumentNo,
							@pRemarks,
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()
						)			

			SELECT	DedGenerationId,
					[Timestamp]
			FROM	DedGenerationTxn
			WHERE	DedGenerationId IN (SELECT ID FROM @Table)

			SET @PrimaryKeyId  = (SELECT ID FROM @Table)

--2.EngMwoCompletionInfoTxnDet
						
EXEC [uspFM_DedGenerationTxn_A] @pYear=@pYear,@pMonth=@pMonth, @pServiceId=@pServiceId,@pFacilityId=@pFacilityId


			INSERT INTO DedGenerationTxnDet
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							DedGenerationId,
							IndicatorDetId,
							TotalParameter,
							DeductionValue,
							DeductionPercentage,
							TransactionDemeritPoint,
							NcrDemeritPoint,
							SubParameterDetId,
							PostTransactionDemeritPoint,
							PostNcrDemeritPoint,
							Remarks,
							keyIndicatorValue,
							Ringittequivalent,
							GearingRatio,
							PostDeductionValue,
							PostDeductionPercentage,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC						
						)

			SELECT			
							@pCustomerId,
							@pFacilityId,			
							@pServiceId,			
							@PrimaryKeyId,	
							IndicatorDetId,		
							0,	
							DeductionValue,		
							DeductionPer,
							TransDemeritPoints,			
							0,
							null,
							null,
							null,
							null,
							null,
							null,			
							null,
							0,
							0,
							@pUserId,				
							GETDATE(),			
							GETUTCDATE(),
							@pUserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	DedgenerationResult where IndicatorDetId in (select IndicatorDetId from #FindIndicatorId)
			
			EXEC [uspFM_KpiGenerationTxn_Popup_Save] @pYear=@pYear,@pMonth=@pMonth, @pServiceId=@pServiceId,@pFacilityId=@pFacilityId

END

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	DedGenerationTxn 
			WHERE	DedGenerationId	=	@pDedGenerationId
			
			IF(@mTimestamp = @pTimestamp)
			BEGIN
	    UPDATE  DedGeneration	SET	
							DedGeneration.CustomerId						= @pCustomerId,
							DedGeneration.FacilityId						= @pFacilityId,
							DedGeneration.ServiceId							= @pServiceId,
							DedGeneration.Month								= @pMonth,
							DedGeneration.Year								= @pYear,
							DedGeneration.[Group]							= @pGroup,
							DedGeneration.MonthlyServiceFee					= (SELECT isnull(BemsMSF,0) FROM FinMonthlyFeeTxn A INNER JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId WHERE A.FacilityId = @pFacilityId AND
																			   A.CustomerId=@pCustomerId AND A.Year = @pYear AND B.Month = @pMonth),
							DedGeneration.DeductionStatus					= @pDeductionStatus,
							DedGeneration.DocumentNo						= @pDocumentNo,
							DedGeneration.Remarks							= @pRemarks,
							DedGeneration.ModifiedBy						= @pUserId,
							DedGeneration.ModifiedDate						= GETDATE(),
							DedGeneration.ModifiedDateUTC					= GETUTCDATE()
							OUTPUT INSERTED.DedGenerationId INTO @Table
				FROM	DedGenerationTxn						AS DedGeneration
				WHERE	DedGeneration.DedGenerationId= @pDedGenerationId
						AND ISNULL(@pDedGenerationId,0)>0

				--2.EngStockUpdateRegisterTxnDet UPDATE

	    UPDATE  DedGenerationDet	SET	
																		   	
									DedGenerationDet.DeductionValue				=   generationResult.DeductionValue,
									DedGenerationDet.DeductionPercentage		=   generationResult.DeductionPer,
									DedGenerationDet.TransactionDemeritPoint	=   generationResult.TransDemeritPoints,
									DedGenerationDet.ModifiedBy					=   @pUserId,			
									DedGenerationDet.ModifiedDate				=   GETDATE(),
									DedGenerationDet.ModifiedDateUTC			=   GETUTCDATE()

		FROM	   DedGenerationTxnDet				    AS DedGenerationDet 
		INNER JOIN DedgenerationResult					AS generationResult on DedGenerationDet.IndicatorDetId=generationResult.IndicatorDetId
				  
			SELECT	DedGenerationId,
					[Timestamp]
			FROM	DedGenerationTxn
			WHERE	DedGenerationId IN (SELECT ID FROM @Table)

		
END   
	ELSE
		BEGIN
				   SELECT	DedGenerationId,
							[Timestamp],
							'Record Modified. Please Re-Select' ErrorMessage
				   FROM		DedGenerationTxn
				   WHERE	DedGenerationId =@pDedGenerationId
		END
END

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
