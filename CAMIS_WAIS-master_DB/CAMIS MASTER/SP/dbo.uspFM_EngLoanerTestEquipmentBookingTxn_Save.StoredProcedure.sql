USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Save]    Script Date: 20-09-2021 16:43:00 ******/
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

EXECUTE [uspFM_EngLoanerTestEquipmentBookingTxn_Save] @pLoanerTestEquipmentBookingId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pAssetId=1,@pWorkOrderId=NULL,
@pBookingStartFrom='2018-07-05 15:38:36.023',@pBookingEnd='2018-08-05 15:38:36.023',@pMovementCategory=239,@pToFacility=2,@pToBlock=1,@pToLevel=2,@pToUserArea=1,@pToUserLocation=1,
@pRequestorId=1,@pRequestType=243,@pBookingStatus=1,@pUserId=2

SELECT * FROM EngLoanerTestEquipmentBookingTxn
SELECT * FROM PorteringTransaction
SELECT * FROM uMuSERrEGISTRATION
SELECT GETDATE()

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Save]
		
		@pLoanerTestEquipmentBookingId		INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pServiceId							INT				= NULL,
		@pAssetId							INT				= NULL,
		@pWorkOrderId						INT				= NULL,
		@pBookingStartFrom					DATETIME		= NULL,
		@pBookingEnd						DATETIME		= NULL,
		@pMovementCategory					INT				= NULL,
		@pToFacility						INT				= NULL,
		@pToBlock							INT				= NULL,
		@pToLevel							INT				= NULL,
		@pToUserArea						INT				= NULL,
		@pToUserLocation					INT				= NULL,
		@pRequestorId						INT				= NULL,
		@pRequestType						INT				= NULL,
		@pBookingStatus						INT				= NULL,
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

	Declare @pBookingStartFromCount INT
	Declare @pBookingEndCount     INT

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.MwoCompletionInfo


IF(@pLoanerTestEquipmentBookingId = NULL OR @pLoanerTestEquipmentBookingId =0)

BEGIN

         SET @pBookingStartFromCount=(  SELECT count(1) FROM EngLoanerTestEquipmentBookingTxn WHERE AssetId = @pAssetId and CAST(@pBookingStartFrom AS date) between BookingStartFrom  and BookingEnd  AND @pLoanerTestEquipmentBookingId =0)
		 SET @pBookingEndCount=(  SELECT count(1) FROM EngLoanerTestEquipmentBookingTxn WHERE AssetId = @pAssetId and CAST(@pBookingEnd AS date) between BookingStartFrom  and BookingEnd  AND @pLoanerTestEquipmentBookingId =0)
          
		 if(@pBookingStartFromCount = 0 and  @pBookingEndCount = 0 ) 
		 begin
				INSERT INTO EngLoanerTestEquipmentBookingTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							AssetId,
							WorkOrderId,
							BookingStartFrom,
							BookingEnd,
							MovementCategory,
							ToFacility,
							ToBlock,
							ToLevel,
							ToUserArea,
							ToUserLocation,
							RequestorId,
							RequestType,
							BookingStatus,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.LoanerTestEquipmentBookingId INTO @Table							

			VALUES			
						(	
							@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pAssetId,
							@pWorkOrderId,
							@pBookingStartFrom,
							@pBookingEnd,
							@pMovementCategory,
							@pToFacility,
							@pToBlock,
							@pToLevel,
							@pToUserArea,
							@pToUserLocation,
							@pRequestorId,
							@pRequestType,
							@pBookingStatus,
							@pUserId,			
							GETDATE(), 
							GETUTCDATE(),
							@pUserId, 
							GETDATE(), 
							GETUTCDATE()
						)			
			SELECT	LoanerTestEquipmentBookingId,CreatedBy,
					'' ErrorMessage,
					[Timestamp],
					GuId
			FROM	EngLoanerTestEquipmentBookingTxn
			WHERE	LoanerTestEquipmentBookingId IN (SELECT ID FROM @Table)		
		 end 
		 else
		 begin
				SELECT		0 As LoanerTestEquipmentBookingId,0 as CreatedBy, 
							CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
							'Asset Cannot be booked. Already Booked for Other Facility' AS ErrorMessage,
							NULL AS GuId

		 end 
		  
		        
  
		--		IF EXISTS(SELECT 1 FROM EngLoanerTestEquipmentBookingTxn WHERE AssetId = @pAssetId AND CAST(BookingEnd AS date) > CAST(@pBookingStartFrom AS DATE) AND @pLoanerTestEquipmentBookingId =0 )

		--		BEGIN

					
		--		END
		--		ELSE
		--		BEGIN
							
		--		END 


END 
------ UPDATE STATEMENT
ELSE 
BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	EngLoanerTestEquipmentBookingTxn 
			WHERE	LoanerTestEquipmentBookingId	=	@pLoanerTestEquipmentBookingId
			IF(@mTimestamp= @pTimestamp)
			BEGIN
					   UPDATE  LoanerTestEquipmentBooking	SET	
							
							LoanerTestEquipmentBooking.CustomerId					= @pCustomerId,
							LoanerTestEquipmentBooking.FacilityId					= @pFacilityId,
							LoanerTestEquipmentBooking.ServiceId					= @pServiceId,
							LoanerTestEquipmentBooking.AssetId						= @pAssetId,
							LoanerTestEquipmentBooking.WorkOrderId					= @pWorkOrderId,
							LoanerTestEquipmentBooking.BookingStartFrom				= @pBookingStartFrom,
							LoanerTestEquipmentBooking.BookingEnd					= @pBookingEnd,
							LoanerTestEquipmentBooking.MovementCategory				= @pMovementCategory,
							LoanerTestEquipmentBooking.ToFacility					= @pToFacility,
							LoanerTestEquipmentBooking.ToBlock						= @pToBlock,
							LoanerTestEquipmentBooking.ToLevel						= @pToLevel,
							LoanerTestEquipmentBooking.ToUserArea					= @pToUserArea,
							LoanerTestEquipmentBooking.ToUserLocation				= @pToUserLocation,
							LoanerTestEquipmentBooking.RequestorId					= @pRequestorId,
							LoanerTestEquipmentBooking.RequestType					= @pRequestType,
							LoanerTestEquipmentBooking.BookingStatus				= @pBookingStatus,
							LoanerTestEquipmentBooking.ModifiedBy					= @pUserId,
							LoanerTestEquipmentBooking.ModifiedDate					= GETDATE(),
							LoanerTestEquipmentBooking.ModifiedDateUTC				= GETUTCDATE()
							OUTPUT INSERTED.LoanerTestEquipmentBookingId INTO @Table
				FROM	EngLoanerTestEquipmentBookingTxn						AS LoanerTestEquipmentBooking
				WHERE	LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId= @pLoanerTestEquipmentBookingId 
						AND ISNULL(@pLoanerTestEquipmentBookingId,0)>0
		  
			SELECT	LoanerTestEquipmentBookingId,CreatedBy,
					[Timestamp],
					'' ErrorMessage,
					GuId
			FROM	EngLoanerTestEquipmentBookingTxn
			WHERE	LoanerTestEquipmentBookingId IN (SELECT ID FROM @Table)
			END 
			ELSE 
			BEGIN
						   SELECT	LoanerTestEquipmentBookingId,
							[Timestamp],CreatedBy,
							'Record Modified. Please Re-Select' ErrorMessage,
							GuId
				   FROM		EngLoanerTestEquipmentBookingTxn
				   WHERE	LoanerTestEquipmentBookingId =@pLoanerTestEquipmentBookingId

			END

END













																			
--IF EXISTS(SELECT 1 FROM EngLoanerTestEquipmentBookingTxn WHERE AssetId = @pAssetId AND CAST(BookingEnd AS date) > CAST(@pBookingStartFrom AS DATE) AND @pLoanerTestEquipmentBookingId =0 )

--BEGIN

--SELECT		0 As LoanerTestEquipmentBookingId,
--			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
--			'Asset Cannot be booked. Already Booked for Other Facility' AS ErrorMessage

--END



--ELSE
--BEGIN

--IF(@pLoanerTestEquipmentBookingId = NULL OR @pLoanerTestEquipmentBookingId =0)

--BEGIN
	
--			INSERT INTO EngLoanerTestEquipmentBookingTxn
--						(	
--							CustomerId,
--							FacilityId,
--							ServiceId,
--							AssetId,
--							WorkOrderId,
--							BookingStartFrom,
--							BookingEnd,
--							MovementCategory,
--							ToFacility,
--							ToBlock,
--							ToLevel,
--							ToUserArea,
--							ToUserLocation,
--							RequestorId,
--							RequestType,
--							BookingStatus,
--							CreatedBy,
--							CreatedDate,
--							CreatedDateUTC,
--							ModifiedBy,
--							ModifiedDate,
--							ModifiedDateUTC
--						)	OUTPUT INSERTED.LoanerTestEquipmentBookingId INTO @Table							

--			VALUES			
--						(	
--							@pCustomerId,
--							@pFacilityId,
--							@pServiceId,
--							@pAssetId,
--							@pWorkOrderId,
--							@pBookingStartFrom,
--							@pBookingEnd,
--							@pMovementCategory,
--							@pToFacility,
--							@pToBlock,
--							@pToLevel,
--							@pToUserArea,
--							@pToUserLocation,
--							@pRequestorId,
--							@pRequestType,
--							@pBookingStatus,
--							@pUserId,			
--							GETDATE(), 
--							GETUTCDATE(),
--							@pUserId, 
--							GETDATE(), 
--							GETUTCDATE()
--						)			
--			SELECT	LoanerTestEquipmentBookingId,
--					'' ErrorMessage,
--					[Timestamp]
--			FROM	EngLoanerTestEquipmentBookingTxn
--			WHERE	LoanerTestEquipmentBookingId IN (SELECT ID FROM @Table)


--end

--ELSE 
-------------------------------------------------------------------- UPDATE STATEMENT ----------------------------------------------------

----1.MwoCompletionInfo UPDATE

			

--BEGIN
--			DECLARE @mTimestamp varbinary(200);
--			SELECT	@mTimestamp = Timestamp FROM	EngMwoAssesmentTxn 
--			WHERE	AssesmentId	=	@pLoanerTestEquipmentBookingId
			
--			IF(@mTimestamp= @pTimestamp)
--			BEGIN
--	    UPDATE  LoanerTestEquipmentBooking	SET	
							
--							LoanerTestEquipmentBooking.CustomerId					= @pCustomerId,
--							LoanerTestEquipmentBooking.FacilityId					= @pFacilityId,
--							LoanerTestEquipmentBooking.ServiceId					= @pServiceId,
--							LoanerTestEquipmentBooking.AssetId						= @pAssetId,
--							LoanerTestEquipmentBooking.WorkOrderId					= @pWorkOrderId,
--							LoanerTestEquipmentBooking.BookingStartFrom				= @pBookingStartFrom,
--							LoanerTestEquipmentBooking.BookingEnd					= @pBookingEnd,
--							LoanerTestEquipmentBooking.MovementCategory				= @pMovementCategory,
--							LoanerTestEquipmentBooking.ToFacility					= @pToFacility,
--							LoanerTestEquipmentBooking.ToBlock						= @pToBlock,
--							LoanerTestEquipmentBooking.ToLevel						= @pToLevel,
--							LoanerTestEquipmentBooking.ToUserArea					= @pToUserArea,
--							LoanerTestEquipmentBooking.ToUserLocation				= @pToUserLocation,
--							LoanerTestEquipmentBooking.RequestorId					= @pRequestorId,
--							LoanerTestEquipmentBooking.RequestType					= @pRequestType,
--							LoanerTestEquipmentBooking.BookingStatus				= @pBookingStatus,
--							LoanerTestEquipmentBooking.ModifiedBy					= @pUserId,
--							LoanerTestEquipmentBooking.ModifiedDate					= GETDATE(),
--							LoanerTestEquipmentBooking.ModifiedDateUTC				= GETUTCDATE()
--							OUTPUT INSERTED.LoanerTestEquipmentBookingId INTO @Table
--				FROM	EngLoanerTestEquipmentBookingTxn						AS LoanerTestEquipmentBooking
--				WHERE	LoanerTestEquipmentBooking.LoanerTestEquipmentBookingId= @pLoanerTestEquipmentBookingId 
--						AND ISNULL(@pLoanerTestEquipmentBookingId,0)>0
		  
--			SELECT	LoanerTestEquipmentBookingId,
--					[Timestamp],
--					'' ErrorMessage
--			FROM	EngLoanerTestEquipmentBookingTxn
--			WHERE	LoanerTestEquipmentBookingId IN (SELECT ID FROM @Table)

--END   
--ELSE
--		BEGIN
--				   SELECT	LoanerTestEquipmentBookingId,
--							[Timestamp],
--							'Record Modified. Please Re-Select' ErrorMessage
--				   FROM		EngLoanerTestEquipmentBookingTxn
--				   WHERE	LoanerTestEquipmentBookingId =@pLoanerTestEquipmentBookingId
--		END
--END



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END
--END	
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
