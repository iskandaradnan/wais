USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestWorkOrderTxn_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestWorkOrderTxn_Save
Description			: CRM	RequestWorkOrder save
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_CRMRequestWorkOrderTxn_Save] @pCRMRequestWOId=256,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pCRMWorkOrderNo=NULL,@pCRMWorkOrderDateTime='2018-05-23 20:05:34.410',
@pStatus=139,@pDescription='tEST',@pTypeOfRequest=134,@pCRMRequestId=28,@pAssetId=1,@pManufacturerId=1,@pModelId=1,@pAssignedUserId=1,@pRemarks='tEST',@pUserId=1,@pTimestamp=NULL,
@pUserAreaId=null,@pUserLocationId=null

SELECT * FROM CRMRequest
SELECT * FROM CRMRequestWorkOrderTxn
SELECT * FROM CRMRequestProcessStatus
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestWorkOrderTxn_Save]
		@pCRMRequestWOId		INT,
		@pCustomerId			INT,
		@pFacilityId			INT,
		@pServiceId				INT,
		@pCRMWorkOrderNo		NVARCHAR(50)	=	NULL,
		@pCRMWorkOrderDateTime	DATETIME		=	NULL,
		@pStatus				INT,
		@pDescription			NVARCHAR(500),
		@pTypeOfRequest			INT,
		@pCRMRequestId			INT				= NULL,
		@pAssetId				INT				= NULL,
		@pManufacturerId		INT				= NULL,
		@pModelId				INT				= NULL,
		@pAssignedUserId		INT				= NULL,

		@pRemarks				NVARCHAR(500)	= NULL,
		@pUserId				INT				= NULL,
		@pTimestamp				VARBINARY(200)	= NULL,
		@pUserAreaId			INT				= NULL,
		@pUserLocationId		INT				= NULL

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
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @TableNotification TABLE (ID INT)
	declare @WebNotification TABLE (ID INT)
	declare @WebNotification1 TABLE (ID INT)
	DECLARE @pCRMWorkOrderDateTimeUTC	DATETIME

	SET @pCRMWorkOrderDateTimeUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pCRMWorkOrderDateTime)

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.FMLovMst

			IF(ISNULL(@pCRMRequestWOId,0) = 0)

BEGIN
	
	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT
	SET @mMonth	=	MONTH(GETDATE())
	SET @mYear	=	YEAR(GETDATE())

	EXEC [uspFM_GenerateDocumentNumber] @pFlag='CRMRequestWorkOrderTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='CRM/WO',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @pCRMWorkOrderNo=@pOutParam



			INSERT INTO CRMRequestWorkOrderTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							CRMWorkOrderNo,
							CRMWorkOrderDateTime,
							CRMWorkOrderDateTimeUTC,
							Status,
							Description,
							TypeOfRequest,
							CRMRequestId,
							AssetId,
							ManufacturerId,
							ModelId,
							AssignedUserId,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							UserAreaId,
							UserLocationId
						)	OUTPUT INSERTED.CRMRequestWOId INTO @Table
			VALUES			
						(	@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pCRMWorkOrderNo,
							GETDATE(), --@pCRMWorkOrderDateTime,
							--GETUTCDATE(), --@pCRMWorkOrderDateTimeUTC, 
							@pCRMWorkOrderDateTime,		 /*changed to get utc date time globally 26/11/2018 */
							139,
							@pDescription,
							@pTypeOfRequest,
							@pCRMRequestId,
							@pAssetId,
							@pManufacturerId,
							@pModelId,
							@pAssignedUserId,
							@pRemarks,
							@pUserId,			
							GETDATE(), 
							GETUTCDATE(),
							@pUserId, 
							GETDATE(), 
							GETUTCDATE(),
							@pUserAreaId,
							@pUserLocationId
						)

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
														(SELECT ID FROM @Table),
														139,
														@pUserId,
														GETDATE(), 
														@pUserId,			
														GETDATE(), 
														GETUTCDATE(),
														@pUserId, 
														GETDATE(), 
														GETUTCDATE(),
														@pAssignedUserId
												)
								
			SELECT	CRMRequestWOId,
					A.CRMRequestId,
					A.[Timestamp],
					'' AS	ErrorMessage,
					A.GuId,
					B.GuId AS RequestGuid,
					CRMWorkOrderNo,
					CRMWorkOrderDateTime
			FROM	CRMRequestWorkOrderTxn A
					inner join CRMRequest B on A.CRMRequestId = B.CRMRequestId
			WHERE	CRMRequestWOId IN (SELECT ID FROM @Table)
					

		    UPDATE CRMRequest SET IsWorkOrder =1 WHERE CRMRequestId = @pCRMRequestId

			UPDATE CRMRequest SET TypeOfRequest =@pTypeOfRequest WHERE CRMRequestId = @pCRMRequestId

			UPDATE CRMRequest SET RequestStatus =140 WHERE CRMRequestId = @pCRMRequestId

		
if @pAssignedUserId is not null
begin		
		
				INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'CRMRequestWorkOrderTxn',
								id,
								@pAssignedUserId
						from @Table

		INSERT INTO	FENotification (	UserId,
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
									) OUTPUT INSERTED.NotificationId INTO @TableNotification
						SELECT	@pAssignedUserId,
								@pCRMWorkOrderNo+' CRM Work Order has been Assigned to you',
								'CRM Work Order' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'CRMRequestWorkOrderTxn',
								@pCRMWorkOrderNo,
								1
						--FROM	#Temp


						
		INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								@pAssignedUserId
						FROM @TableNotification

	

			
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
								VALUES  (	@pCustomerId,
											@pFacilityId,
											@pAssignedUserId,
											@pCRMWorkOrderNo+' CRM Work Order has been Assigned to you',
											'',
											'/bems/crmworkorder?id='+CAST((select top 1 id from @Table) AS NVARCHAR(100)),
											1,
											@pUserId,			
											GETDATE(), 
											GETUTCDATE(),
											@pUserId, 
											GETDATE(), 
											GETUTCDATE(),
											GETDATE(),
											0
										)


END		

					declare @TableNotification1 table (id int, userid int)

						INSERT INTO	FENotification (	UserId,
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
									) OUTPUT INSERTED.NotificationId , INSERTED.UserId INTO @TableNotification1
						SELECT
								isnull(( select top 1 Requester from CRMRequest  where CRMRequestId= @pCRMRequestId),''),
								@pCRMWorkOrderNo +' CRM Work Order has been generated',
								'CRM Work Order' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'CRMRequestStatus',
								isnull(( select top 1 GuId from CRMRequest  where CRMRequestId= @pCRMRequestId),''),
								1

									INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								userid
						FROM @TableNotification1


						
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
										)OUTPUT INSERTED.NotificationId INTO @WebNotification1
								VALUES  (	@pCustomerId,
											@pFacilityId,
											isnull(( select top 1 Requester from CRMRequest  where CRMRequestId= @pCRMRequestId),''),
											@pCRMWorkOrderNo +' CRM Work Order has been generated',
											'',
											'/bems/crmworkorder?id='+CAST((select top 1 id from @Table) AS NVARCHAR(100)),
											1,
											@pUserId,			
											GETDATE(), 
											GETUTCDATE(),
											@pUserId, 
											GETDATE(), 
											GETUTCDATE(),
											GETDATE(),
											0
										)






	SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 39

	
		
	SELECT	distinct A.UserRegistrationId,
			b.FacilityId,
			b.CustomerId		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	= @pFacilityId
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
										


				declare @TableNotificationdet1 table (id int,userid int)

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
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotificationdet1
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
						  FROM @TableNotificationdet1



SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification1
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 18

	
		
	SELECT	distinct A.UserRegistrationId,
			A.FacilityId,
			A.CustomerId		
		INTO	#TempUserEmails_all1
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	= @pFacilityId
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
										from #TempUserEmails_all1 a  cross join   WebNotification  b
										where b.NotificationId  in (select top 1 id  from @WebNotification1 ) 
										


				declare @TableNotificationdet2 table (id int,userid int)

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
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotificationdet2
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
						from #TempUserEmails_all1 a  cross join   FENotification  b
										where b.NotificationId  in (select top 1 id  from @TableNotification1 ) 
					 
					 
					 
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotificationdet2





end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------
		

BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	CRMRequestWorkOrderTxn 
			WHERE	CRMRequestWOId	=	@pCRMRequestWOId
			
			IF(@mTimestamp= @pTimestamp)
			BEGIN

		DECLARE @CNT1 INT=0 
		SELECT @CNT1 = COUNT(1)	FROM CRMRequestWorkOrderTxn
		WHERE	CRMRequestWOId	=	@pCRMRequestWOId
				AND AssignedUserId		=	@pAssignedUserId

	IF (@CNT1=0)

	  BEGIN
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
														251,
														@pUserId,
														GETDATE(),
														@pUserId,			
														GETDATE(), 
														GETUTCDATE(),
														@pUserId, 
														GETDATE(), 
														GETUTCDATE(),
														@pAssignedUserId
												)
		END
									


	    UPDATE  CRMRequestWorkOrderTxn	SET		
												--CustomerId				= @pCustomerId,
												--FacilityId				= @pFacilityId,
												--ServiceId				= @pServiceId,
												--CRMWorkOrderNo			= @pCRMWorkOrderNo,
												--CRMWorkOrderDateTime	= @pCRMWorkOrderDateTime,
												--CRMWorkOrderDateTimeUTC	= @pCRMWorkOrderDateTimeUTC,
												Status					= @pStatus,
												Description				= @pDescription,
												TypeOfRequest			= @pTypeOfRequest,
												CRMRequestId			= @pCRMRequestId,
												AssetId					= @pAssetId,
												ManufacturerId			= @pManufacturerId,
												ModelId					= @pModelId,
												AssignedUserId			= @pAssignedUserId,
												Remarks					= @pRemarks,
												ModifiedBy				= @pUserId,
												ModifiedDate			= GETDATE(),
												ModifiedDateUTC			= GETUTCDATE()
									OUTPUT INSERTED.CRMRequestWOId INTO @Table
				WHERE	CRMRequestWOId= @pCRMRequestWOId
						AND ISNULL(@pCRMRequestWOId,0)>0

			UPDATE CRMRequest SET TypeOfRequest =@pTypeOfRequest WHERE CRMRequestId = @pCRMRequestId


			DECLARE @CNT INT=0 
			SELECT @CNT = COUNT(1)	FROM CRMRequestProcessStatus
							WHERE	CRMRequestWOId	=	@pCRMRequestWOId
									AND Status		=	@pStatus
	
	IF (@CNT=0)

	  BEGIN

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
														@pStatus,
														@pUserId,
														GETDATE(),
														@pUserId,			
														GETDATE(), 
														GETUTCDATE(),
														@pUserId, 
														GETDATE(), 
														GETUTCDATE(),
														@pAssignedUserId
												)

			
	END
					  
			SELECT	CRMRequestWOId,
					A.CRMRequestId,
					A.[Timestamp],
					'' AS	ErrorMessage,
					A.GuId,
					B.GuId AS RequestGuid,
					CRMWorkOrderNo,
					CRMWorkOrderDateTime
			FROM	CRMRequestWorkOrderTxn A
					inner join CRMRequest B on A.CRMRequestId = B.CRMRequestId
			WHERE	CRMRequestWOId IN (SELECT ID FROM @Table)



SET @pCRMWorkOrderNo = (SELECT CRMWorkOrderNo FROM	CRMRequestWorkOrderTxn
			WHERE	CRMRequestWOId =@pCRMRequestWOId)


---------- Notification Alerts------------

IF(ISNULL(@pAssignedUserId,0)<>0)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM QueueWebtoMobile WHERE TableName='CRMRequestWorkOrderTxn' AND Tableprimaryid=@pCRMRequestWOId AND UserId=@pAssignedUserId)
	BEGIN
		SELECT @mDateFmt = b.FieldValue	 
		FROM	FMConfigCustomerValues a 
				INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
		WHERE	A.KeyName='DATE'
				AND CustomerId = @pCustomerId

		IF (@mDateFmt='DD-MMM-YYYY')
			BEGIN
				SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')
			END
		ELSE IF (@mDateFmt='DD/MMM/YYYY')
			BEGIN
				SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')
			END

		INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'CRMRequestWorkOrderTxn',
								@pCRMRequestWOId,
								@pAssignedUserId


		INSERT INTO	FENotification (	UserId,
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
									) OUTPUT INSERTED.NotificationId INTO @TableNotification
						SELECT	@pAssignedUserId,
								@pCRMWorkOrderNo +' CRM Work Order has been Assinged to you',
								'CRM Work Order' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'CRMRequestWorkOrderTxn',
								@pCRMWorkOrderNo,
								1
						--FROM	#Temp
						
		INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								@pAssignedUserId
						FROM @TableNotification
	END
END   



	END   
	ELSE
		BEGIN
				   SELECT	CRMRequestWOId,
							A.CRMRequestId,
							A.[Timestamp],
							'Record Modified. Please Re-Select' ErrorMessage,
							A.GuId,
							B.GuId AS RequestGuid,
							CRMWorkOrderNo,
							CRMWorkOrderDateTime
				   FROM		CRMRequestWorkOrderTxn A
							inner join CRMRequest B on A.CRMRequestId = B.CRMRequestId
				   WHERE	CRMRequestWOId= @pCRMRequestWOId
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
