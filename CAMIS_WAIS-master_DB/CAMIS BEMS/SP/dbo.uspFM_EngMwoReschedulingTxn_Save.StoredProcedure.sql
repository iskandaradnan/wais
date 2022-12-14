USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoReschedulingTxn_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoReschedulingTxn_Save
Description			: If Planner Reschedule details already exists then update else insert.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngMwoReschedulingTxn_Save @pWorkOrderReschedulingId='',@CustomerId='1',@FacilityId='1',@ServiceId='2',@WorkOrderId=6,@RescheduleApprovedBy=24,@RescheduleDate='2018-04-20 19:17:53.793',@RescheduleDateUTC='2018-04-20 19:17:53.793',
@Reason=2468,@ImpactSchedulePlanner=0,@CreatedBy=2,@ModifiedBy=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMwoReschedulingTxn_Save]
	
		
		@pWorkOrderReschedulingId				INT,
		@CustomerId								INT,
		@FacilityId								INT,
		@ServiceId								INT,
		@RescheduleApprovedBy					INT,		
		@WorkOrderId							INT,	
		@RescheduleDate							DATETIME,
		@RescheduleDateUTC						DATETIME,
		@Reason									INT,
		@ImpactSchedulePlanner					BIT,
		@CreatedBy								INT,
		@ModifiedBy								INT

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	

-- Default Values


-- Execution
 

	IF EXISTS (SELECT 1 FROM EngMwoReschedulingTxn WITH(NOLOCK) WHERE WorkOrderReschedulingId=@pWorkOrderReschedulingId)

		BEGIN
			UPDATE EngMwoReschedulingTxn SET
							CustomerId									=@CustomerId,
							FacilityId									=@FacilityId,
							ServiceId									=@ServiceId,
							WorkOrderId									=@WorkOrderId,
							RescheduleApprovedBy						=@RescheduleApprovedBy,
							RescheduleDate								=@RescheduleDate,
							RescheduleDateUTC							=@RescheduleDateUTC,
							Reason										=@Reason,
							ImpactSchedulePlanner						=@ImpactSchedulePlanner,
							ModifiedBy									=@ModifiedBy,
							ModifiedDate								=GETDATE(),
							ModifiedDateUTC								=GETUTCDATE()						
					WHERE	WorkOrderReschedulingId=@pWorkOrderReschedulingId
		END

	ELSE

		BEGIN
			INSERT INTO EngMwoReschedulingTxn(
								CustomerId,	
								FacilityId,
								ServiceId,								
								WorkOrderId,
								RescheduleApprovedBy,
								RescheduleDate,
								RescheduleDateUTC,
								Reason,
								ImpactSchedulePlanner,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC																
							
							)	OUTPUT INSERTED.WorkOrderReschedulingId INTO @Table
							VALUES
							(
							 @CustomerId,
							 @FacilityId,
							 @ServiceId,	
							 @WorkOrderId,
							 @RescheduleApprovedBy,
							 @RescheduleDate,
							 @RescheduleDateUTC,
							 @Reason,
							 @ImpactSchedulePlanner,
							 @CreatedBy,
							 GETDATE(),
							 GETUTCDATE(),
							 @ModifiedBy,
							 GETDATE(),
							 GETUTCDATE()
							)
		END

		UPDATE EngMaintenanceWorkOrderTxn SET TargetDateTime = @RescheduleDate WHERE WorkOrderId = @WorkOrderId

		SELECT	WorkOrderReschedulingId,
				[Timestamp]
		FROM	EngMwoReschedulingTxn
		WHERE	WorkOrderReschedulingId IN (SELECT ID FROM @Table)


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
