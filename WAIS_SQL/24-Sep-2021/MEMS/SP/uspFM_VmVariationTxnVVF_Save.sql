
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxnVVF_Save
Description			: Variation for VVF update
Authors				: Dhilip V
Date				: 05-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

ALTER PROCEDURE  [dbo].[uspFM_VmVariationTxnVVF_Save]

			--@VmVariationTxnDet 		[dbo].[udt_VmVariationTxnDet] READONLY,
			--@VmVariationTxnVVF 		[dbo].[udt_VmVariationTxnVVF] READONLY,
			@VmVariationTxnVVF 		[dbo].[udt_VmVariationTxnVVF_ForDocument] READONLY,
			@pCustomerId				INT,
			@pFacilityId				INT,
			@pUserId				INT,		
			@pTimestamp				VARBINARY(200)		= NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

	--select @pUserId = nullif(@pUserId,0)
-- Default Values


-- Execution

   -- IF(isnull(@pVariationId,0) = 0  OR @pVariationId = '')

	  --BEGIN
	     

		 UPDATE VMVVF SET	VMVVF.VariationWFStatus			=	case when udt_VMVVF.Action = 371 then 230 
																	 when udt_VMVVF.Action = 372 then 231 
																	 when  udt_VMVVF.Action = 373 then 0 
																	 else null end , --VMVVF.VariationWFStatus, --CASE WHEN udt_VMVVF.Action = 99 THEN udt_VMVVF.WorkFlowStatus ELSE VMVVF.VariationWFStatus		 END,
							VMVVF.Remarks					=	udt_VMVVF.Remarks,
							VMVVF.ProposedRateDW			=	udt_VMVVF.MaintenanceRateDW,
							VMVVF.ProposedRatePW			=	udt_VMVVF.MaintenanceRatePW,
							VMVVF.MonthlyProposedFeeDW		=	udt_VMVVF.MonthlyProposedFeeDW,
							VMVVF.MonthlyProposedFeePW		=	udt_VMVVF.MonthlyProposedFeePW,
							VMVVF.VariationApprovedStatus	=	case when udt_VMVVF.WorkFlowStatus = 230 then 230 
																	 when udt_VMVVF.WorkFlowStatus = 231 then 231
																else null end ,
							VMVVF.ModifiedBy				=	@pUserId,			
							VMVVF.ModifiedDate				=	GETDATE(),		
							VMVVF.ModifiedDateUTC			=	GETUTCDATE(),
							VMVVF.DocumentId			=	udt_VMVVF.DocumentId
							OUTPUT INSERTED.VariationId INTO @Table
FROM	VmVariationTxn	VMVVF	
INNER JOIN @VmVariationTxnVVF	udt_VMVVF	ON	VMVVF.VariationId	=	udt_VMVVF.VariationId


--Add By 24-09-2021

Update FMD set FMD.DocumentGuId=VMVVF.GuId,FMD.ModifiedBy=@pUserId,			
FMD.ModifiedDate=GETDATE(),		
FMD.ModifiedDateUTC=GETUTCDATE()

FROM FMDocument	FMD	
inner join VmVariationTxn	VMVVF ON	FMD.DocumentId	=	VMVVF.DocumentId
INNER JOIN @VmVariationTxnVVF	udt_VMVVF	ON	VMVVF.DocumentId	=	udt_VMVVF.DocumentId



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
	SELECT @pCustomerId,@pFacilityId,2,VVF.VariationId,
	case when VVF.Action = 371 then 230 
		 when VVF.Action = 372 then 231 
		 when  VVF.Action = 373 then 0 
		 else null end , 
	--VVF.WorkFlowStatus,	
	nullif(@pUserId,0),GETDATE()	AS	DoneDate,NULL AS DoneRemarks,NULL AS IsVerify,													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE() FROM @VmVariationTxnVVF AS VVF LEFT JOIN VmVariationTxnDet VMDet ON VVF.VariationId	=	VMDet.VariationId AND ISNULL(VVF.WorkFlowStatus,0)	=	ISNULL(VMDet.VariationWFStatus,0)
	WHERE	VMDet.VariationId  IS NULL AND ISNULL(VVF.WorkFlowStatus,0) <>0

	

			   	   SELECT				VariationId,
										[Timestamp],
										''	ErrorMessage
				   FROM					VmVariationTxn
				   WHERE				VariationId IN (SELECT ID FROM @Table)
	
		--END
  --ELSE
	 -- BEGIN

		--		DECLARE @mTimestamp varbinary(200);
		--		SELECT	@mTimestamp = Timestamp FROM	VmVariationTxn 
		--		WHERE	VariationId	=	@pVariationId

		--		IF (@mTimestamp=@pTimestamp)
				
				--BEGIN
	

		
			
           


--END
--				ELSE
--			BEGIN
--				SELECT	VariationId,
--						SNFDocumentNo,
--						[Timestamp],							
--						'Record Modified. Please Re-Select' AS ErrorMessage
--				FROM	VmVariationTxn
--				WHERE	VariationId =@pVariationId
--			END
--END

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


