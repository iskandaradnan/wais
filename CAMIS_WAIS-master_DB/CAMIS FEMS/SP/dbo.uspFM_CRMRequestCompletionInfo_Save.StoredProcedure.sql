USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestCompletionInfo_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestCompletionInfo_Save
Description			: If Assesment already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_CRMRequestCompletionInfo_Save] @pCRMCompletionInfoId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pCRMRequestWOId=78,@pStartDateTime='2018-05-25 16:33:21.400',
@pStartDateTimeUTC='2018-05-25 16:33:21.400',@pEndDateTime='2018-05-25 16:33:21.400',@pEndDateTimeUTC='2018-05-25 16:33:21.400',@pHandoverDateTime='2018-05-25 16:33:21.400',
@pHandoverDateTimeUTC='2018-05-25 16:33:21.400',@pHandoverDelay=10,@pAcceptedBy=1,@pSignature=NULL,@pRemarks='aaa',@pUserId=2


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestCompletionInfo_Save]
		
		@pCRMCompletionInfoId				INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pServiceId							INT				= NULL,
		@pCRMRequestWOId					INT				= NULL,
		@pStartDateTime						DATETIME		= NULL,
		@pStartDateTimeUTC					DATETIME		= NULL,
		@pEndDateTime						DATETIME		= NULL,
		@pEndDateTimeUTC					DATETIME		= NULL,
		@pHandoverDateTime					DATETIME		= NULL,
		@pHandoverDateTimeUTC				DATETIME		= NULL,
		@pHandoverDelay						INT				= NULL,
		@pAcceptedBy						INT				= NULL,
		@pSignature							VARBINARY(MAX)	= NULL,
		@pRemarks							NVARCHAR(1000)	= NULL,
		@pUserId							INT				= NULL,
		@pTimestamp							VARBINARY(200)	= NULL,
		@pCompletedBy						INT				= NULL,
		@pCompPositionId					INT				= NULL,
		@pCompletedRemarks					NVARCHAR(1000)	= NULL

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
	DECLARE @mAssignedUserId INT 

	IF(@pAcceptedBy IS NOT NULL OR @pAcceptedBy >0)
	BEGIN

			UPDATE B SET B.AssetWorkingStatus = NULL FROM CRMRequestWorkOrderTxn A INNER JOIN EngAsset B ON A.AssetId = B.AssetId
			WHERE A.CRMRequestWOId = @pCRMRequestWOId AND A.AssetId IS NOT NULL AND B.AssetWorkingStatus IN (136,137)


			UPDATE CRMRequestWorkOrderTxn SET Status = 142 WHERE CRMRequestWOId = @pCRMRequestWOId

			UPDATE B SET B.RequestStatus =142  FROM CRMRequestWorkOrderTxn A INNER JOIN CRMRequest B ON A.CRMRequestId = B.CRMRequestId
			WHERE A.CRMRequestWOId = @pCRMRequestWOId		     

	END


--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.MwoCompletionInfo

			IF(@pCRMCompletionInfoId = NULL OR @pCRMCompletionInfoId =0)

BEGIN
	
			INSERT INTO CRMRequestCompletionInfo
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							CRMRequestWOId,
							StartDateTime,
							StartDateTimeUTC,
							EndDateTime,
							EndDateTimeUTC,
							HandoverDateTime,
							HandoverDateTimeUTC,
							HandoverDelay,
							AcceptedBy,
							[Signature],
							Remarks,
							CompletedBy,
							CompletedbyRemarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.CRMCompletionInfoId INTO @Table							

			VALUES			
						(	
							@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pCRMRequestWOId,
							@pStartDateTime,
							@pStartDateTimeUTC,
							@pEndDateTime,
							@pEndDateTimeUTC,
							@pHandoverDateTime,
							@pHandoverDateTimeUTC,
							@pHandoverDelay,
							@pAcceptedBy,
							@pSignature,
							@pRemarks,
							@pCompletedBy,
							@pCompletedRemarks,
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()

						)		
						
							
			SELECT	CRMCompletionInfoId,
					R.CRMRequestWOId,
					CRMWorkOrderNo,
					cr.GuId,
					R.[Timestamp]
			FROM	CRMRequestCompletionInfo   R
					join    CRMRequestWorkOrderTxn    W   on R.CRMRequestWOId = w.CRMRequestWOId
					join CRMRequest cr on w.CRMRequestId = cr.CRMRequestId
			WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)

			DECLARE @mCRMWOId INT

			SELECT	@mCRMWOId	=	CRMRequestWOId
			FROM	CRMRequestCompletionInfo
			WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)

			UPDATE CRMRequestWorkOrderTxn SET Status = 141 WHERE CRMRequestWOId = @pCRMRequestWOId

			UPDATE B SET B.RequestStatus =141  FROM CRMRequestWorkOrderTxn A INNER JOIN CRMRequest B ON A.CRMRequestId = B.CRMRequestId
			WHERE A.CRMRequestWOId = @pCRMRequestWOId

			UPDATE CRMRequestWorkOrderTxn	SET	ModifiedBy		=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
			WHERE	CRMRequestWOId	=	@pCRMRequestWOId

			SELECT @mAssignedUserId	=	AssignedUserId
			FROM CRMRequestWorkOrderTxn WHERE	CRMRequestWOId	=	@pCRMRequestWOId

			INSERT INTO CRMRequestProcessStatus (	CustomerId,
													FacilityId,
													ServiceId,
													CRMRequestWOId,
													Status,
													DoneBy,
													DoneDate,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													AssignedUserId
												)
										VALUES	(
														@pCustomerId,
														@pFacilityId,
														@pServiceId,
														@mCRMWOId,
														141,
														@pUserId,
														GETUTCDATE(),
														@pUserId,			
														GETDATE(), 
														GETUTCDATE(),
														@pUserId, 
														GETDATE(), 
														GETUTCDATE(),
														@mAssignedUserId
												)
		     

end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	CRMRequestCompletionInfo 
			WHERE	CRMCompletionInfoId	=	@pCRMCompletionInfoId
			
			IF(@mTimestamp= @pTimestamp)
			BEGIN
	    UPDATE  RequestCompletionInfo	SET	
																			
							RequestCompletionInfo.CustomerId				= @pCustomerId,
							RequestCompletionInfo.FacilityId				= @pFacilityId,
							RequestCompletionInfo.ServiceId					= @pServiceId,
							RequestCompletionInfo.CRMRequestWOId			= @pCRMRequestWOId,
							RequestCompletionInfo.StartDateTime				= @pStartDateTime,
							RequestCompletionInfo.StartDateTimeUTC			= @pStartDateTimeUTC,
							RequestCompletionInfo.EndDateTime				= @pEndDateTime,
							RequestCompletionInfo.EndDateTimeUTC			= @pEndDateTimeUTC,
							RequestCompletionInfo.HandoverDateTime			= @pHandoverDateTime,
							RequestCompletionInfo.HandoverDateTimeUTC		= @pHandoverDateTimeUTC,
							RequestCompletionInfo.HandoverDelay				= @pHandoverDelay,
							RequestCompletionInfo.AcceptedBy				= @pAcceptedBy,
							RequestCompletionInfo.Signature					= @pSignature,
							RequestCompletionInfo.Remarks					= @pRemarks,

							RequestCompletionInfo.CompletedBy				= @pCompletedBy,
							RequestCompletionInfo.CompletedbyRemarks					= @pCompletedRemarks,

							RequestCompletionInfo.ModifiedBy				= @pUserId,
							RequestCompletionInfo.ModifiedDate				= GETDATE(),
							RequestCompletionInfo.ModifiedDateUTC			= GETUTCDATE()
							OUTPUT INSERTED.CRMCompletionInfoId INTO @Table
				FROM	CRMRequestCompletionInfo						AS RequestCompletionInfo
				WHERE	RequestCompletionInfo.CRMCompletionInfoId= @pCRMCompletionInfoId
						AND ISNULL(@pCRMCompletionInfoId,0)>0
		  
			SELECT	CRMCompletionInfoId,
					R.CRMRequestWOId,
					CRMWorkOrderNo,
					cr.GuId,
					R.[Timestamp]	
			FROM	CRMRequestCompletionInfo   R
					join    CRMRequestWorkOrderTxn    W   on R.CRMRequestWOId = w.CRMRequestWOId
					join CRMRequest cr on w.CRMRequestId = cr.CRMRequestId
			WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)

		  UPDATE CRMRequestWorkOrderTxn	SET	ModifiedBy		=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
				WHERE	CRMRequestWOId	=	@pCRMRequestWOId

			DECLARE @CNT INT=0 
			SELECT @CNT = COUNT(1)	FROM CRMRequestProcessStatus
							WHERE	CRMRequestWOId	=	@pCRMRequestWOId
									AND Status		=	142
	
	IF (@CNT=0)

	  BEGIN

			SELECT @mAssignedUserId	=	AssignedUserId
			FROM CRMRequestWorkOrderTxn WHERE	CRMRequestWOId	=	@pCRMRequestWOId

			INSERT INTO CRMRequestProcessStatus (	CustomerId,
													FacilityId,
													ServiceId,
													CRMRequestWOId,
													Status,
													DoneBy,
													DoneDate,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													AssignedUserId
												)
										VALUES	(
														@pCustomerId,
														@pFacilityId,
														@pServiceId,
														@pCRMRequestWOId,
														142,
														@pUserId,
														GETUTCDATE(),
														@pUserId,			
														GETDATE(), 
														GETUTCDATE(),
														@pUserId, 
														GETDATE(), 
														GETUTCDATE(),
														@mAssignedUserId
												)
			END
			ELSE
				BEGIN
					
					UPDATE CRMRequestProcessStatus SET Status = 142,
														DoneDate=GETDATE(),
														DoneBy=@pUserId
													WHERE CRMRequestWOId	=	@pCRMRequestWOId
													AND STATUS=142
				END
					 


END   
	ELSE
		BEGIN
				   SELECT	CRMCompletionInfoId,
							R.CRMRequestWOId,
							CRMWorkOrderNo,
							cr.GuId,
							r.[Timestamp],
							'Record Modified. Please Re-Select' ErrorMessage				   
				   FROM	CRMRequestCompletionInfo   R
				  join    CRMRequestWorkOrderTxn    W   on R.CRMRequestWOId = w.CRMRequestWOId
				  join CRMRequest cr on w.CRMRequestId = cr.CRMRequestId
				   WHERE	CRMCompletionInfoId =@pCRMCompletionInfoId
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
