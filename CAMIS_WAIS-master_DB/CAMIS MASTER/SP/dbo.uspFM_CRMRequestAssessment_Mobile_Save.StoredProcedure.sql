USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestAssessment_Mobile_Save]    Script Date: 20-09-2021 16:43:00 ******/
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

DECLARE @pCRMRequestAssessment udt_CRMRequestAssessment_Mobile

INSERT INTO @pCRMRequestAssessment(CRMAssesmentId,CustomerId,FacilityId,ServiceId,CRMRequestWOId,StaffMasterId,FeedBack,AssessmentStartDateTime,AssessmentStartDateTimeUTC,
AssessmentEndDateTime,AssessmentEndDateTimeUTC,UserId)VALUES
(0,1,2,2,142,1,'HIGIFIS','2018-07-13 12:26:18.383','2018-07-13 12:26:18.383','2018-07-13 12:26:18.383','2018-07-13 12:26:18.383',2)
EXECUTE [uspFM_CRMRequestAssessment_Mobile_Save] @pCRMRequestAssessment

SELECT * FROM CRMRequestProcessStatus
SELECT GETDATE()


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestAssessment_Mobile_Save]
		
		@pCRMRequestAssessment				udt_CRMRequestAssessment_Mobile READONLY


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

			IF EXISTS(SELECT 1 FROM @pCRMRequestAssessment WHERE CRMAssesmentId = NULL OR CRMAssesmentId =0)

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

			SELECT			
						
							CustomerId,
							FacilityId,
							2,
							CRMRequestWOId,
							StaffMasterId,
							FeedBack,
							AssessmentStartDateTime,
							AssessmentStartDateTimeUTC,
							AssessmentEndDateTime,
							AssessmentEndDateTimeUTC,
							0.00,  --(cast((DATEDIFF(MINUTE, @pAssessmentStartDateTime, @pAssessmentEndDateTime)) as numeric(24,2))/60.00),
							UserId,			
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE()

			FROM @pCRMRequestAssessment	 WHERE ISNULL(CRMAssesmentId,0)=0

			SELECT	A.CRMAssesmentId,
					B.CRMWorkOrderNo,
					A.[Timestamp],
					D.Email
			FROM	CRMRequestAssessment A
			INNER JOIN CRMRequestWorkOrderTxn B ON B.CRMRequestWOId = A.CRMRequestWOId
			INNER JOIN CRMRequest C ON C.CRMRequestId = B.CRMRequestId
			INNER JOIN UMUserRegistration D ON D.UserRegistrationId = C.Requester
			WHERE	CRMAssesmentId IN (SELECT ID FROM @Table)

				INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
				SELECT 'CRMRequestStatus',c.CRMRequestWOId,D.CreatedBy FROM @Table A INNER JOIN CRMRequestAssessment B ON A.ID = B.CRMAssesmentId
				INNER JOIN CRMRequestWorkOrderTxn C ON B.CRMRequestWOId = C.CRMRequestWOId
				INNER JOIN CRMRequest D ON C.CRMRequestId = D.CRMRequestId

			DECLARE @mCRMWOId INT
			SELECT	@mCRMWOId	=	CRMRequestWOId
			FROM	CRMRequestAssessment
			WHERE	CRMAssesmentId IN (SELECT ID FROM @Table)

				UPDATE	CRMWO SET MasterGuid = CRMR.MobileGuid

				FROM	CRMRequestWorkOrderTxn AS CRMWO WITH(NOLOCK)
				INNER JOIN CRMRequest AS CRMR ON CRMWO.CRMRequestId	=	CRMR.CRMRequestId

			UPDATE CRMRequestWorkOrderTxn SET Status = 140 WHERE CRMRequestWOId IN (SELECT CRMRequestWOId FROM @pCRMRequestAssessment WHERE ISNULL(CRMAssesmentId,0)=0)

			UPDATE B SET B.RequestStatus =140  FROM CRMRequestWorkOrderTxn A INNER JOIN CRMRequest B ON A.CRMRequestId = B.CRMRequestId
			WHERE A.CRMRequestWOId IN (SELECT CRMRequestWOId FROM @pCRMRequestAssessment WHERE ISNULL(CRMAssesmentId,0)=0)

			UPDATE A	SET					ModifiedBy		=	B.UserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
			FROM  CRMRequestWorkOrderTxn A INNER JOIN @pCRMRequestAssessment B ON A.CRMRequestWOId = B.CRMRequestWOId
			WHERE ISNULL(B.CRMAssesmentId,0)=0




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
										SELECT
														A.CustomerId,
														A.FacilityId,
														2,
														A.CRMRequestWOId,
														140,
														A.UserId,
														GETDATE(), 
														A.UserId,			
														GETDATE(), 
														GETUTCDATE(),
														A.UserId, 
														GETDATE(), 
														GETUTCDATE(),
														B.AssignedUserId
										FROM 		@pCRMRequestAssessment A INNER JOIN CRMRequestWorkOrderTxn B ON A.CRMRequestWOId = B.CRMRequestWOId WHERE ISNULL(A.CRMAssesmentId,0)=0 




										-- Notification --
			declare   @TableNotification table (id int, UserId int)
			declare   @TableNotification2 table (id int, UserId int)
			INSERT INTO FENotification 
			(			  UserId,
						  NotificationAlerts,
						  Remarks,
						  CreatedBy,
						  CreatedDate,
						  CreatedDateUTC,
						  ModifiedBy,
						  ModifiedDate,
						  ModifiedDateUTC,
						  ScreenName,
						  DocumentId,
						  SingleRecord
			 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification
		  SELECT 
						    B.Requester,
							'CRM Work Order Assessment is completed - ' + A.CRMWorkOrderNo,
							'CRM Work Order Assessment' AS Remarks,
							B.Requester,
							GETDATE(),
							GETUTCDATE(),
							B.Requester,
							GETDATE(),
							GETUTCDATE(),
							'CRMRequestStatus',
							B.GuId,
							1
			from CRMRequestWorkOrderTxn A  
			INNER JOIN CRMRequest B on A.CRMRequestId = B.CRMRequestId
			INNER JOIN @pCRMRequestAssessment C ON A.CRMRequestWOId = C.CRMRequestWOId
			--WHERE	ISNULL(C.CRMCompletionInfoId,0)>0
      
			  INSERT INTO QueueWebtoMobile (  
						TableName,
						Tableprimaryid,
						UserId
					  )
				  SELECT 
						'FENotification',
						ID,
						UserId
				  FROM @TableNotification



		declare @WebNotification table (id   int )
			
			INSERT INTO WebNotification (	CustomerId,
									FacilityId,
									UserId,
									NotificationAlerts,
									Remarks,
									HyperLink,
									IsNew,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC	,
									NotificationDateTime,
									IsNavigate							                                                                                                           
								)OUTPUT INSERTED.NotificationId INTO @WebNotification
		  SELECT 

							B.CustomerId,
							B.FacilityId,
						    B.Requester,
							'CRM Work Order Assessment is completed - ' + A.CRMWorkOrderNo,
							'CRM Work Order Assessment' AS Remarks,
							'/bems/crmworkorder?id=' + cast(A.CRMRequestWOId as varchar(500)),
							1,
							B.Requester,
							GETDATE(),
							GETUTCDATE(),
							B.Requester,
							GETDATE(),
							GETUTCDATE(),
							GETDATE(),
							0
			from CRMRequestWorkOrderTxn A  
			INNER JOIN CRMRequest B on A.CRMRequestId = B.CRMRequestId
			INNER JOIN @pCRMRequestAssessment C ON A.CRMRequestWOId = C.CRMRequestWOId
			--WHERE	ISNULL(C.CRMCompletionInfoId,0)>0

	

	SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 77

	declare @FacilityId  int

	select  top 1 @FacilityId  = FacilityId from @pCRMRequestAssessment

	
	SELECT	distinct A.UserRegistrationId,
			b.FacilityId,
			b.CustomerId		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	= @FacilityId
	--IN (SELECT DISTINCT FacilityId FROM #Notification)
	
	
	
					INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)

										select  	b.CustomerId,
													b.FacilityId,
													a.UserRegistrationId,
													b.NotificationAlerts,
													b.Remarks,
													b.HyperLink,
													b.IsNew,
													b.CreatedBy,
													b.CreatedDate,
													b.CreatedDateUTC,
													b.ModifiedBy,
													b.ModifiedDate,
													b.ModifiedDateUTC	,
													b.NotificationDateTime,
													b.IsNavigate		
										from #TempUserEmails_all a  cross join   WebNotification  b
										where b.NotificationId  in (select top 1 id  from @WebNotification ) 
										




					INSERT INTO FENotification ( UserId,
							  NotificationAlerts,
							  Remarks,
							  CreatedBy,
							  CreatedDate,
							  CreatedDateUTC,
							  ModifiedBy,
							  ModifiedDate,
							  ModifiedDateUTC,
							  ScreenName,
							  DocumentId,
							  SingleRecord
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification2
						  SELECT  
						  a.UserRegistrationId,
						  NotificationAlerts,
						  Remarks,
						  CreatedBy,
						  CreatedDate,
						  CreatedDateUTC,
						  ModifiedBy,
						  ModifiedDate,
						  ModifiedDateUTC,
						  ScreenName,
						  DocumentId,
						  SingleRecord
						from #TempUserEmails_all a  cross join   FENotification  b
										where b.NotificationId  in (select top 1 id  from @TableNotification ) 
					 
					 
					 
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotification2


end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN

	    UPDATE  RequestAssessment	SET	
							RequestAssessment.CustomerId					= RequestAssessmentUDT.CustomerId,
							RequestAssessment.FacilityId					= RequestAssessmentUDT.FacilityId,
							RequestAssessment.ServiceId						= 2,
							RequestAssessment.CRMRequestWOId				= RequestAssessmentUDT.CRMRequestWOId,
							RequestAssessment.UserId						= RequestAssessmentUDT.StaffMasterId,
							RequestAssessment.FeedBack						= RequestAssessmentUDT.FeedBack,
							RequestAssessment.AssessmentStartDateTime		= RequestAssessmentUDT.AssessmentStartDateTime,
							RequestAssessment.AssessmentStartDateTimeUTC	= RequestAssessmentUDT.AssessmentStartDateTimeUTC,
							RequestAssessment.AssessmentEndDateTime			= RequestAssessmentUDT.AssessmentEndDateTime,
							RequestAssessment.AssessmentEndDateTimeUTC		= RequestAssessmentUDT.AssessmentEndDateTimeUTC,
							RequestAssessment.ResponseDuration				= 0.00, --(cast((DATEDIFF(MINUTE, @pAssessmentStartDateTime, @pAssessmentEndDateTime)) as numeric(24,2))/60.00),
							RequestAssessment.ModifiedBy					= RequestAssessmentUDT.UserId,
							RequestAssessment.ModifiedDate					= GETDATE(),
							RequestAssessment.ModifiedDateUTC				= GETUTCDATE()
							OUTPUT INSERTED.CRMAssesmentId INTO @Table
				FROM	CRMRequestAssessment						AS RequestAssessment
				INNER JOIN @pCRMRequestAssessment					AS RequestAssessmentUDT			ON RequestAssessment.CRMAssesmentId = RequestAssessmentUDT.CRMAssesmentId
				WHERE ISNULL(RequestAssessmentUDT.CRMAssesmentId,0)>0
			
			UPDATE A	SET					ModifiedBy		=	B.UserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
			FROM  CRMRequestWorkOrderTxn A INNER JOIN @pCRMRequestAssessment B ON A.CRMRequestWOId = B.CRMRequestWOId
			WHERE ISNULL(B.CRMAssesmentId,0)>0
		  



			SELECT	CRMAssesmentId,
					[Timestamp]
			FROM	CRMRequestAssessment
			WHERE	CRMAssesmentId IN (SELECT ID FROM @Table)


	
	
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

---------------------------------------------------------------------------------UDT CREATION ----------------------------------------------------------------------------
--CREATE TYPE [dbo].[udt_CRMRequestAssessment_Mobile] AS TABLE(
--CRMAssesmentId					INT				 NULL,
--CustomerId						INT				 NULL,
--FacilityId						INT				 NULL,
--ServiceId							INT			 NULL,
--CRMRequestWOId					INT				 NULL,
--StaffMasterId						INT				 NULL,
--FeedBack							NVARCHAR(1000)	 NULL,
--AssessmentStartDateTime			DATETIME		 NULL,
--AssessmentStartDateTimeUTC		DATETIME		 NULL,
--AssessmentEndDateTime				DATETIME	 NULL,
--AssessmentEndDateTimeUTC			DATETIME	 NULL,
--UserId							INT				 NULL
--)
GO
