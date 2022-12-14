USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestAssessment_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestAssessment_Save
Description			: If Assesment already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_CRMRequestAssessment_Save] @pCRMAssesmentId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pCRMRequestWOId=2,@pStaffMasterId=1,@pFeedBack='AAA',
@pAssessmentStartDateTime='2018-05-25 16:04:31.183',@pAssessmentStartDateTimeUTC='2018-05-25 16:04:31.183',@pAssessmentEndDateTime='2018-05-25 16:04:31.183',
@pAssessmentEndDateTimeUTC='2018-05-25 16:04:31.183',@pResponseDuration=10,@pUserId=2


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestAssessment_Save]
		
		@pCRMAssesmentId					INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pServiceId							INT				= NULL,
		@pCRMRequestWOId					INT				= NULL,
		@pStaffMasterId						INT				= NULL,
		@pFeedBack							NVARCHAR(1000)	= NULL,
		@pAssessmentStartDateTime			DATETIME		= NULL,
		@pAssessmentStartDateTimeUTC		DATETIME		= NULL,
		@pAssessmentEndDateTime				DATETIME		= NULL,
		@pAssessmentEndDateTimeUTC			DATETIME		= NULL,
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
	DECLARE @mAssignedUserId INT 



--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.MwoCompletionInfo

			IF(@pCRMAssesmentId = NULL OR @pCRMAssesmentId =0)

BEGIN
	
			INSERT INTO CRMRequestAssessment
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							CRMRequestWOId,
							UserId,
							FeedBack,
							AssessmentStartDateTime,
							AssessmentStartDateTimeUTC,
							AssessmentEndDateTime,
							AssessmentEndDateTimeUTC,
							ResponseDuration,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
					)	OUTPUT INSERTED.CRMAssesmentId INTO @Table							

			VALUES			
						(	
							@pCustomerId,
							@pFacilityId,
							2,
							@pCRMRequestWOId,
							@pStaffMasterId,
							@pFeedBack,
							@pAssessmentStartDateTime,
							@pAssessmentStartDateTimeUTC,
							@pAssessmentEndDateTime,
							@pAssessmentEndDateTimeUTC,
							0.00,  --(cast((DATEDIFF(MINUTE, @pAssessmentStartDateTime, @pAssessmentEndDateTime)) as numeric(24,2))/60.00),
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()

						)			
			SELECT	CRMAssesmentId,
					a.[Timestamp],
					b.GuId ,
					b.CRMWorkOrderNo
			FROM	CRMRequestAssessment a 
					join CRMRequestWorkOrderTxn b on a.CRMRequestWOId = b.CRMRequestWOId
			WHERE	CRMAssesmentId IN (SELECT ID FROM @Table)

			DECLARE @mCRMWOId INT
			SELECT	@mCRMWOId	=	CRMRequestWOId
			FROM	CRMRequestAssessment
			WHERE	CRMAssesmentId IN (SELECT ID FROM @Table)

			UPDATE CRMRequestWorkOrderTxn SET Status = 140 WHERE CRMRequestWOId = @pCRMRequestWOId

			UPDATE B SET B.RequestStatus =140  FROM CRMRequestWorkOrderTxn A INNER JOIN CRMRequest B ON A.CRMRequestId = B.CRMRequestId
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
														2,
														@mCRMWOId,
														140,
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
			SELECT	@mTimestamp = Timestamp FROM	CRMRequestAssessment 
			WHERE	CRMAssesmentId	=	@pCRMAssesmentId
			
			IF(@mTimestamp= @pTimestamp)
			BEGIN
	    UPDATE  RequestAssessment	SET	
							RequestAssessment.CustomerId					= @pCustomerId,
							RequestAssessment.FacilityId					= @pFacilityId,
							RequestAssessment.ServiceId						= 2,
							RequestAssessment.CRMRequestWOId				= @pCRMRequestWOId,
							RequestAssessment.UserId					= @pStaffMasterId,
							RequestAssessment.FeedBack						= @pFeedBack,
							RequestAssessment.AssessmentStartDateTime		= @pAssessmentStartDateTime,
							RequestAssessment.AssessmentStartDateTimeUTC	= @pAssessmentStartDateTimeUTC,
							RequestAssessment.AssessmentEndDateTime			= @pAssessmentEndDateTime,
							RequestAssessment.AssessmentEndDateTimeUTC		= @pAssessmentEndDateTimeUTC,
							RequestAssessment.ResponseDuration				= 0.00, --(cast((DATEDIFF(MINUTE, @pAssessmentStartDateTime, @pAssessmentEndDateTime)) as numeric(24,2))/60.00),
							RequestAssessment.ModifiedBy					= @pUserId,
							RequestAssessment.ModifiedDate					= GETDATE(),
							RequestAssessment.ModifiedDateUTC				= GETUTCDATE()
							OUTPUT INSERTED.CRMAssesmentId INTO @Table
				FROM	CRMRequestAssessment						AS RequestAssessment
				WHERE	RequestAssessment.CRMAssesmentId= @pCRMAssesmentId 
						AND ISNULL(@pCRMAssesmentId,0)>0
		  
		  UPDATE CRMRequestWorkOrderTxn	SET	ModifiedBy		=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
				WHERE	CRMRequestWOId	=	@pCRMRequestWOId


			SELECT	CRMAssesmentId,
					a.[Timestamp],
					b.GuId ,
					b.CRMWorkOrderNo
			FROM	CRMRequestAssessment a
					join CRMRequestWorkOrderTxn b on a.CRMRequestWOId = b.CRMRequestWOId
			WHERE	CRMAssesmentId IN (SELECT ID FROM @Table)

			DECLARE @CNT INT=0 
			SELECT @CNT = COUNT(1)	FROM CRMRequestProcessStatus
							WHERE	CRMRequestWOId	=	@pCRMRequestWOId
									AND Status		=	140
	
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
														2,
														@pCRMRequestWOId,
														140,
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
					
					UPDATE CRMRequestProcessStatus SET Status = 140,
														DoneDate=GETDATE(),
														DoneBy=@pUserId
													WHERE CRMRequestWOId	=	@pCRMRequestWOId
													AND STATUS=140
				END
				


END   
	ELSE
		BEGIN
				   SELECT	CRMAssesmentId,
							a.[Timestamp],
							b.GuId ,
							b.CRMWorkOrderNo,
							'Record Modified. Please Re-Select' ErrorMessage
				   FROM		CRMRequestAssessment a
							join CRMRequestWorkOrderTxn b on a.CRMRequestWOId = b.CRMRequestWOId
				   WHERE	CRMAssesmentId =@pCRMAssesmentId
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
