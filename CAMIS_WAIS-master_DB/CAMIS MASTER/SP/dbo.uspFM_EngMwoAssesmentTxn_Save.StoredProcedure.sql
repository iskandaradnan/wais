USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoAssesmentTxn_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_EngMwoAssesmentTxn_Save

Description			: If Assesment already exists then update else insert.

Authors				: Balaji M S

Date				: 09-April-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:



EXECUTE [uspFM_EngMwoAssesmentTxn_Save] @pAssesmentId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pWorkOrderId=134,@pStaffMasterId=1,@pJustification='sample',

@pResponseDateTime='2018-05-16 15:15:51.620',@pResponseDateTimeUTC='2018-05-16 15:15:51.620',@pResponseDuration=15,@pAssetRealtimeStatus=55,@pUserId=2





-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init :  Date       : Details

========================================================================================================*/



CREATE PROCEDURE  [dbo].[uspFM_EngMwoAssesmentTxn_Save]

		

		@pAssesmentId						INT				= NULL,

		@pCustomerId						INT				= NULL,

		@pFacilityId						INT				= NULL,

		@pServiceId							INT				= NULL,

		@pWorkOrderId						INT				= NULL,

		@pStaffMasterId						INT				= NULL,

		@pJustification						NVARCHAR(1000)	= NULL,

		@pResponseDateTime					DATETIME		= NULL,

		@pResponseDateTimeUTC				DATETIME		= NULL,

		@pResponseDuration					NVARCHAR(100)	= NULL,

		@pAssetRealtimeStatus				INT				= NULL,

		@pUserId							INT				= NULL,

		@pTimestamp							VARBINARY(200)	= NULL,

		@pIsChangeToVendor					INT				= NULL,

		@pAssignedVendor					INT				= NULL



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



--//1.MwoCompletionInfo



			IF(@pAssesmentId = NULL OR @pAssesmentId =0)



BEGIN

	

			INSERT INTO EngMwoAssesmentTxn

						(	

							CustomerId,

							FacilityId,

							ServiceId,

							WorkOrderId,

							UserId,

							Justification,

							ResponseDateTime,

							ResponseDateTimeUTC,

							ResponseDuration,

							CreatedBy,

							CreatedDate,

							CreatedDateUTC,

							ModifiedBy,

							ModifiedDate,

							ModifiedDateUTC,

							AssetRealtimeStatus,

							TargetDateTime,

							IsChangeToVendor,

							AssignedVendor

						)	OUTPUT INSERTED.AssesmentId INTO @Table							



			VALUES			

						(	

							@pCustomerId,

							@pFacilityId,

							@pServiceId,

							@pWorkOrderId,

							@pStaffMasterId,

							@pJustification,

							@pResponseDateTime,

							@pResponseDateTimeUTC,

							@pResponseDuration,

							@pUserId,			

							GETDATE(), 

							GETDATE(),

							@pUserId, 

							GETDATE(), 

							GETDATE(),

							@pAssetRealtimeStatus,

							[dbo].[udf_GetMalaysiaDateTime] (GETDATE()),

							@pIsChangeToVendor,

							@pAssignedVendor

						)			

			SELECT	AssesmentId,

					WorkOrderId,
					(select MaintenanceWorkNo from EngMaintenanceWorkOrderTxn a where a.WorkOrderId=b.WorkOrderId) as MaintenanceWorkNo,

					'' ErrorMessage,

					[Timestamp]

			FROM	EngMwoAssesmentTxn b

			WHERE	AssesmentId IN (SELECT ID FROM @Table)



			UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 193 WHERE WorkOrderId = @pWorkOrderId

		    INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)

			SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,WorkOrderStatus,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId

			

			UPDATE EngAsset SET RealTimeStatusLovId = @pAssetRealtimeStatus WHERE AssetId IN (SELECT AssetId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)



END



ELSE 

------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------



--1.MwoCompletionInfo UPDATE



			



BEGIN

			DECLARE @mTimestamp varbinary(200);

			SELECT	@mTimestamp = Timestamp FROM	EngMwoAssesmentTxn 

			WHERE	AssesmentId	=	@pAssesmentId

			

			IF(@mTimestamp= @pTimestamp)

			BEGIN



	IF NOT EXISTS (SELECT 1 FROM EngMwoAssesmentFeedbackHistory WHERE FeedBack = @pJustification AND AssesmentId = @pAssesmentId)

		BEGIN

		INSERT INTO EngMwoAssesmentFeedbackHistory (	AssesmentId,

														WorkOrderId,

														FeedBack,

														ResponseDateTime,

														ResponseDuration,

														DoneBy,

														DoneDate,

														CreatedBy,

														CreatedDate,

														CreatedDateUTC,

														ModifiedBy,

														ModifiedDate,

														ModifiedDateUTC

													)



												SELECT 	AssesmentId,

														WorkOrderId,

														Justification	AS FeedBack,

														ResponseDateTime,

														ResponseDuration,

														@pUserId,

														--dbo.udf_GetMalaysiaDateTime(GETDATE()),
														GETDATE(),

														CreatedBy,

														--dbo.udf_GetMalaysiaDateTime(GETDATE()),
														GETDATE(),

														--dbo.udf_GetMalaysiaDateTime(GETUTCDATE()),
														GETUTCDATE(),

														ModifiedBy,

														--dbo.udf_GetMalaysiaDateTime(GETDATE()),
														GETDATE(),

														--dbo.udf_GetMalaysiaDateTime(GETUTCDATE())
														GETUTCDATE()

												FROM	EngMwoAssesmentTxn

												WHERE	AssesmentId	=	@pAssesmentId

		

						END





	    UPDATE  MwoAssesment	SET	

							MwoAssesment.CustomerId					= @pCustomerId,
							MwoAssesment.FacilityId					= @pFacilityId,
							MwoAssesment.ServiceId					= @pServiceId,
							MwoAssesment.WorkOrderId				= @pWorkOrderId,
							MwoAssesment.UserId						= @pStaffMasterId,
							MwoAssesment.Justification				= @pJustification,
							MwoAssesment.ResponseDateTime			= @pResponseDateTime,
							MwoAssesment.ResponseDateTimeUTC		= @pResponseDateTimeUTC,
							MwoAssesment.ResponseDuration			= @pResponseDuration,
							MwoAssesment.AssetRealtimeStatus		= @pAssetRealtimeStatus,
							MwoAssesment.ModifiedBy					= @pUserId,
							MwoAssesment.ModifiedDate				= GETDATE(),
							MwoAssesment.ModifiedDateUTC			= GETUTCDATE(),
							MwoAssesment.TargetDateTime				= [dbo].[udf_GetMalaysiaDateTime] (GETDATE()),
							IsChangeToVendor						= @pIsChangeToVendor,
							AssignedVendor							= @pAssignedVendor,
							FMvendorApproveStatus					= NULL
							
							OUTPUT INSERTED.AssesmentId INTO @Table

				FROM	EngMwoAssesmentTxn						AS MwoAssesment

				WHERE	MwoAssesment.AssesmentId= @pAssesmentId 

						AND ISNULL(@pAssesmentId,0)>0



		UPDATE EngAsset SET RealTimeStatusLovId = @pAssetRealtimeStatus WHERE AssetId IN (SELECT AssetId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)





		  

			SELECT	AssesmentId,

					[Timestamp],

					WorkOrderId,
					(select MaintenanceWorkNo from EngMaintenanceWorkOrderTxn a where a.WorkOrderId=b.WorkOrderId) as MaintenanceWorkNo,
					'' ErrorMessage

			FROM	EngMwoAssesmentTxn b

			WHERE	AssesmentId IN (SELECT ID FROM @Table)



END   

	ELSE

		BEGIN

				   SELECT	AssesmentId,

							[Timestamp],

							WorkOrderId,
								(select MaintenanceWorkNo from EngMaintenanceWorkOrderTxn a where a.WorkOrderId=b.WorkOrderId) as MaintenanceWorkNo,

							'Record Modified. Please Re-Select' ErrorMessage

				   FROM		EngMwoAssesmentTxn b

				   WHERE	AssesmentId =@pAssesmentId

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
