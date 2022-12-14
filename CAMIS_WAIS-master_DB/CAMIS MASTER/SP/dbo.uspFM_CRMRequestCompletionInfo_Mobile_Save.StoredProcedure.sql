USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestCompletionInfo_Mobile_Save]    Script Date: 20-09-2021 16:43:00 ******/
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

DECLARE @pCRMRequestCompletionInfo  AS udt_CRMRequestCompletionInfo_Mobile

INSERT INTO @pCRMRequestCompletionInfo(CRMCompletionInfoId,CustomerId,FacilityId,ServiceId,CRMRequestWOId,StartDateTime,StartDateTimeUTC,EndDateTime,EndDateTimeUTC,
HandoverDateTime,HandoverDateTimeUTC,HandoverDelay,AcceptedBy,Signature,Remarks,UserId,CompletedBy,CompPositionId,CompletedRemarks)VALUES
(0,1,2,2,134,'2018-07-13 17:26:06.737','2018-07-13 17:26:06.737','2018-07-13 17:26:06.737','2018-07-13 17:26:06.737','2018-07-13 17:26:06.737','2018-07-13 17:26:06.737',10,1,NULL,
'WFDSFSDF',2,1,1,'DSGFDSG')

EXECUTE [uspFM_CRMRequestCompletionInfo_Mobile_Save] @pCRMRequestCompletionInfo

SELECT GETDATE()


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestCompletionInfo_Mobile_Save]
		
		@pCRMRequestCompletionInfo			udt_CRMRequestCompletionInfo_Mobile READONLY


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

	IF EXISTS (SELECT 1 FROM @pCRMRequestCompletionInfo WHERE AcceptedBy IS NOT NULL OR AcceptedBy >0)
	BEGIN
			UPDATE A SET Status = 142 
			FROM CRMRequestWorkOrderTxn A INNER JOIN @pCRMRequestCompletionInfo B ON A.CRMRequestWOId = B.CRMRequestWOId
			WHERE B.AcceptedBy IS NOT NULL OR B.AcceptedBy >0

			UPDATE B SET B.RequestStatus =142  FROM @pCRMRequestCompletionInfo C INNER JOIN CRMRequestWorkOrderTxn A ON A.CRMRequestWOId = C.CRMRequestWOId
			INNER JOIN CRMRequest B ON A.CRMRequestId = B.CRMRequestId
			WHERE C.AcceptedBy IS NOT NULL OR C.AcceptedBy >0		     

	END


--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.MwoCompletionInfo

	IF EXISTS ( SELECT 1 FROM @pCRMRequestCompletionInfo WHERE CRMCompletionInfoId = NULL OR CRMCompletionInfoId =0)

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

			SELECT			
							
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
							Signature,
							Remarks,
							CompletedBy,
							CompletedRemarks,
							UserId,			
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE()

			FROM 	@pCRMRequestCompletionInfo WHERE CRMCompletionInfoId = NULL OR CRMCompletionInfoId =0

			SELECT	CRMCompletionInfoId,
					[Timestamp]
			FROM	CRMRequestCompletionInfo
			WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)

				INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
				SELECT 'CRMRequestStatus',c.CRMRequestWOId,D.CreatedBy FROM @Table A INNER JOIN CRMRequestCompletionInfo B ON A.ID = B.CRMCompletionInfoId
				INNER JOIN CRMRequestWorkOrderTxn C ON B.CRMRequestWOId = C.CRMRequestWOId
				INNER JOIN CRMRequest D ON C.CRMRequestId = D.CRMRequestId

			DECLARE @mCRMWOId INT

			SELECT	@mCRMWOId	=	CRMRequestWOId
			FROM	CRMRequestCompletionInfo
			WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)

			UPDATE CRMRequestWorkOrderTxn SET Status = 141
			FROM CRMRequestWorkOrderTxn A INNER JOIN @pCRMRequestCompletionInfo B ON A.CRMRequestWOId = B.CRMRequestWOId
			WHERE B.CRMCompletionInfoId = NULL OR B.CRMCompletionInfoId =0

			UPDATE B SET B.RequestStatus =141  FROM @pCRMRequestCompletionInfo C INNER JOIN CRMRequestWorkOrderTxn A ON C.CRMRequestWOId = A.CRMRequestWOId 
			INNER JOIN CRMRequest B ON A.CRMRequestId = B.CRMRequestId
			WHERE C.CRMCompletionInfoId = NULL OR C.CRMCompletionInfoId =0

			UPDATE A	SET	ModifiedBy		=	B.UserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
			FROM    CRMRequestWorkOrderTxn A INNER JOIN @pCRMRequestCompletionInfo B ON A.CRMRequestWOId = B.CRMRequestWOId
			WHERE	B.CRMCompletionInfoId = NULL OR B.CRMCompletionInfoId =0



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
														A.ServiceId,
														A.CRMRequestWOId,
														141,
														A.UserId,
														GETDATE(), 
														A.UserId,			
														GETDATE(), 
														GETUTCDATE(),
														A.UserId, 
														GETDATE(), 
														GETUTCDATE(),
														B.AssignedUserId
							FROM @pCRMRequestCompletionInfo A INNER JOIN CRMRequestWorkOrderTxn B ON A.CRMRequestWOId = B.CRMRequestWOId WHERE A.CRMCompletionInfoId = NULL OR A.CRMCompletionInfoId =0
		     

end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN

	    UPDATE  RequestCompletionInfo	SET	
																			
							RequestCompletionInfo.CustomerId				= RequestCompletionInfoudt.CustomerId,
							RequestCompletionInfo.FacilityId				= RequestCompletionInfoudt.FacilityId,
							RequestCompletionInfo.ServiceId					= RequestCompletionInfoudt.ServiceId,
							RequestCompletionInfo.CRMRequestWOId			= RequestCompletionInfoudt.CRMRequestWOId,
							--RequestCompletionInfo.StartDateTime				= RequestCompletionInfoudt.StartDateTime,
							--RequestCompletionInfo.StartDateTimeUTC			= RequestCompletionInfoudt.StartDateTimeUTC,
							--RequestCompletionInfo.EndDateTime				= RequestCompletionInfoudt.EndDateTime,
							--RequestCompletionInfo.EndDateTimeUTC			= RequestCompletionInfoudt.EndDateTimeUTC,
							--RequestCompletionInfo.HandoverDateTime			= RequestCompletionInfoudt.HandoverDateTime,
							--RequestCompletionInfo.HandoverDateTimeUTC		= RequestCompletionInfoudt.HandoverDateTimeUTC,
							--RequestCompletionInfo.HandoverDelay				= RequestCompletionInfoudt.HandoverDelay,
							RequestCompletionInfo.AcceptedBy				= RequestCompletionInfoudt.AcceptedBy,
							--RequestCompletionInfo.Signature					= RequestCompletionInfoudt.Signature,
							RequestCompletionInfo.Remarks					= RequestCompletionInfoudt.Remarks,

							--RequestCompletionInfo.CompletedBy				= RequestCompletionInfoudt.CompletedBy,
							--RequestCompletionInfo.CompletedbyRemarks		= RequestCompletionInfoudt.CompletedRemarks,

							RequestCompletionInfo.ModifiedBy				= RequestCompletionInfoudt.UserId,
							RequestCompletionInfo.ModifiedDate				= GETDATE(),
							RequestCompletionInfo.ModifiedDateUTC			= GETUTCDATE()
							OUTPUT INSERTED.CRMCompletionInfoId INTO @Table
				FROM	CRMRequestCompletionInfo						AS RequestCompletionInfo
				INNER JOIN @pCRMRequestCompletionInfo					AS RequestCompletionInfoudt ON RequestCompletionInfo.CRMCompletionInfoId = RequestCompletionInfoudt.CRMCompletionInfoId
				WHERE	ISNULL(RequestCompletionInfoudt.CRMCompletionInfoId,0)>0
		  
			--SELECT	CRMCompletionInfoId,
			--		[Timestamp]
			--FROM	CRMRequestCompletionInfo
			--WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)


			SELECT	A.CRMCompletionInfoId,
					B.CRMWorkOrderNo,
					D.Email				
			FROM	CRMRequestCompletionInfo A
			INNER JOIN CRMRequestWorkOrderTxn B ON A.CRMRequestWOId = B.CRMRequestWOId
			INNER JOIN CRMRequest C ON B.CRMRequestId = C.CRMRequestId
			LEFT JOIN UMUserRegistration D ON C.Requester = D.UserRegistrationId
			WHERE	CRMCompletionInfoId IN (SELECT ID FROM @Table)
		

		  UPDATE A	SET	A.ModifiedBy		=	B.UserId,
											A.ModifiedDate		=	GETDATE(),
											A.ModifiedDateUTC	=	GETUTCDATE()
				FROM CRMRequestWorkOrderTxn A INNER JOIN @pCRMRequestCompletionInfo B ON A.CRMRequestWOId = B.CRMRequestWOId
				WHERE	ISNULL(B.CRMCompletionInfoId,0)>0


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
							'CRM Work Order has been Closed - ' + A.CRMWorkOrderNo,
							'CRM Work Order Closed' AS Remarks,
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
			INNER JOIN @pCRMRequestCompletionInfo C ON A.CRMRequestWOId = C.CRMRequestWOId
			WHERE	ISNULL(C.CRMCompletionInfoId,0)>0
      
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
							'CRM Work Order has been Closed - ' + A.CRMWorkOrderNo,
							'CRM Work Order Closed' AS Remarks,
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
			INNER JOIN @pCRMRequestCompletionInfo C ON A.CRMRequestWOId = C.CRMRequestWOId
			WHERE	ISNULL(C.CRMCompletionInfoId,0)>0

	

	

	SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 66

	declare @FacilityId  int

	select  top 1 @FacilityId  = FacilityId from CRMRequestCompletionInfo a 
	where  CRMCompletionInfoId   in (select CRMCompletionInfoId from @pCRMRequestCompletionInfo)

	
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


-------------------------------------------------------------------------------------udt creation ----------------------------------------------------------------------

--drop proc [uspFM_CRMRequestCompletionInfo_Mobile_Save]
--drop type udt_CRMRequestCompletionInfo_Mobile

--CREATE TYPE udt_CRMRequestCompletionInfo_Mobile AS TABLE
--(
--CRMCompletionInfoId				INT				 NULL,
--CustomerId						INT				 NULL,
--FacilityId						INT				 NULL,
--ServiceId							INT				 NULL,
--CRMRequestWOId					INT				 NULL,
--StartDateTime						DATETIME		 NULL,
--StartDateTimeUTC					DATETIME		 NULL,
--EndDateTime						DATETIME		 NULL,
--EndDateTimeUTC					DATETIME		 NULL,
--HandoverDateTime					DATETIME		 NULL,
--HandoverDateTimeUTC				DATETIME		 NULL,
--HandoverDelay						INT				 NULL,
--AcceptedBy						INT				 NULL,
--Signature							VARBINARY(MAX)	 NULL,
--Remarks							NVARCHAR(1000)	 NULL,
--UserId							INT				 NULL,
--CompletedBy						INT				 NULL,
--CompPositionId					INT				 NULL,
--CompletedRemarks					NVARCHAR(1000)	 NULL
--)
GO
