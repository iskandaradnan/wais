USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Mobile_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequest_Save
Description			: If Request already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pCRMRequest udt_CRMRequest_Mobile
DECLARE @pCRMDet udt_CRMRequestDet_Mobile
declare @pguid nvarchar(max)
set @pguid = (select NEWID())
INSERT INTO @pCRMRequest (CRMRequestId,UserId,CustomerId,FacilityId,ServiceId,RequestNo,RequestDateTime,RequestDateTimeUTC,RequestStatus,RequestDescription,TypeOfRequest,Remarks,
ModelId,Manufacturerid,UserAreaId,UserLocationId,Flag,MasterGuid)
VALUES (0,2,1,2,2,null,'2018-07-13 10:49:18.990','2018-07-13 10:49:18.990',139,'DGDFG',136,'DFBDHB',1,1,1,1,'Submit',@pguid)
INSERT INTO @pCRMDet([CRMRequestDetId],[AssetId],[DetailGuid],[UserId])values
(0,1,@pguid,2)
EXEC [uspFM_CRMRequest_Mobile_Save] @pCRMRequest,@pCRMDet

SELECT * FROM CRMRequest
SELECT * FROM CRMRequestDet
select * from CRMRequestRemarksHistory
SELECT GETDATE()
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Mobile_Save]
			
			@pCRMRequest					udt_CRMRequest_Mobile	READONLY,
			@pCRMDet						udt_CRMRequestDet_Mobile	READONLY

				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT
	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT,RequestNo Nvarchar(500),userid int)
	declare @Table1 TABLE (ID INT)
	declare @TableNotification table (ID INT,UserId int)

	DECLARE @mLoopStart INT =0, @mLoopLimit INT
	DECLARE @pOutParam NVARCHAR(50) 
	DECLARE @MaintenanceWorkCategory INT 
	DECLARE @mMonth INT,@mYear INT
	DECLARE @MPorteringDate DATETIME
	DECLARE @RequestNo NVARCHAR(100)

	DECLARE @pCustomerId INT
	DECLARE @pFacilityId INT

SELECT * INTO #TEMPResultWo FROM @pCRMRequest WHERE (RequestNo IS NULL OR RequestNo = '')  AND (CRMRequestId=0 OR CRMRequestId IS NULL)

ALTER TABLE #TEMPResultWo ADD Portid INT IDENTITY(1,1) NOT NULL

--SELECT * FROM #TEMPResultWo


	SET  @mLoopStart = (SELECT MIN(Portid) FROM #TEMPResultWo)
	SET  @mLoopLimit = (SELECT MAX(Portid) FROM #TEMPResultWo)
	SELECT @mLoopLimit	=	COUNT(1) FROM #TEMPResultWo
	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN
	SET @MPorteringDate = (SELECT RequestDateTime FROM #TEMPResultWo WHERE Portid = @mLoopStart)
	SET @pCustomerId = (SELECT CustomerId FROM #TEMPResultWo WHERE Portid = @mLoopStart)
	SET @pFacilityId = (SELECT FacilityId FROM #TEMPResultWo WHERE Portid = @mLoopStart)
	SET @mMonth		 =	MONTH(@MPorteringDate)
	SET @mYear		 =	YEAR(@MPorteringDate)
	EXEC [uspFM_GenerateDocumentNumber] @pFlag='CRMRequest',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='CRM',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @RequestNo=@pOutParam
	UPDATE #TEMPResultWo SET RequestNo	= @RequestNo WHERE Portid	=	@mLoopStart
	SET @mLoopStart	=	@mLoopStart+1
	END

-- Default Values


-- Execution

IF EXISTS (SELECT 1 FROM #TEMPResultWo)
BEGIN


	          INSERT INTO CRMRequest(
											CustomerId,
											FacilityId,
											ServiceId,
											RequestNo,
											RequestDateTime,
											RequestDateTimeUTC,
											RequestStatus,
											RequestDescription,
											TypeOfRequest,
											Remarks,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC,
											IsWorkOrder	,
											ModelId,
											ManufacturerId,
											UserAreaId,
											UserLocationId,
											MobileGuid,
											TargetDate,
											RequestedPerson,
											Requester
                           )OUTPUT INSERTED.CRMRequestId,INSERTED.RequestNo,INSERTED.CreatedBy INTO @Table
							SELECT	
											CustomerId,
											FacilityId,
											ServiceId,
											RequestNo,
											RequestDateTime,
											RequestDateTimeUTC,
											RequestStatus,
											RequestDescription,
											TypeOfRequest,
											Remarks,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE(),
											0,
											ModelId,
											ManufacturerId,
											UserAreaId,
											UserLocationId,
											MasterGuid,
											TargetDate,
											RequestedPerson,
											RequestedPerson																								
							FROM #TEMPResultWo



					INSERT INTO CRMRequestDet (	
												CRMRequestId,
												AssetId,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC
											   )

								SELECT		B.CRMRequestId,
											AssetId,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM	@pCRMDet A INNER JOIN CRMRequest B ON A.DetailGuid = B.MobileGuid
								WHERE	ISNULL(CRMRequestDetId,0)=0

	INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,DoneDateUTC
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
										)
								SELECT  	B.CRMRequestId,
											a.Remarks,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											a.RequestStatus,
											'Submit',
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM #TEMPResultWo A INNER JOIN CRMRequest B ON A.MasterGuid = B.MobileGuid


			   	   SELECT				CRMRequestId,RequestNo,
										request.[Timestamp],
										request.GuId,
										request.MobileGuid,
										 ( select top 1 Email  from UMUserRegistration  where UserArea.CustomerUserId= UserRegistrationId ) as  CustomerUserEmail, 
										( select top 1 Email  from UMUserRegistration  where UserArea.FacilityUserId= UserRegistrationId ) as  FacilityUserEmail
				   FROM					CRMRequest request
				    LEFT JOIN MstLocationUserLocation    AS UserLocation   WITH(NOLOCK) ON Request.UserLocationId  = UserLocation.UserLocationId  
					LEFT JOIN MstLocationUserArea     AS UserArea    WITH(NOLOCK) ON UserLocation.UserAreaId  = UserArea.UserAreaId  
				   WHERE				CRMRequestId IN (SELECT ID FROM @Table)




				   SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 19

	
	
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
										)OUTPUT INSERTED.NotificationId INTO @Table1

										select  A.CustomerId,
												A.FacilityId,
												A.UserRegistrationId,
												isnull((select top 1 RequestNo from @Table ),'')+ ' ' + 'New CRM Request has been created',
												''		,
												 '/bems/crmrequest?id=' + cast(isnull((select top 1 ID from @Table ),'')as varchar(500))		,
												1		,
												isnull((select top 1 userid from @Table ),'')	,	
												GETDATE(),									
												GETUTCDATE(),
												isnull((select top 1 userid from @Table ),''),
												GETDATE(),
												GETUTCDATE()	,
												GETDATE(),
												0	
										from #TempUserEmails_all a




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
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification
						  SELECT UserRegistrationId,
							isnull((select top 1 RequestNo from @Table ),'')+ ' ' + 'New CRM Request has been created',
							'',
									isnull((select top 1 userid from @Table ),''),
							GETDATE(),
							GETUTCDATE(),
									isnull((select top 1 userid from @Table ),''),
							GETDATE(),
							GETUTCDATE(),
							'CRMRequestStatus',
							(select top 1 GuId from  CRMRequest  where  CRMRequestId = (select top 1 id from @Table )),
							1
						  FROM #TempUserEmails_all
      
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotification

							


			   	   SELECT	NotificationId,
							[Timestamp],
							NotificationAlerts,
							IsNew,
							'' as ErrorMessage
				   FROM		WebNotification
				   WHERE	NotificationId IN (SELECT ID FROM @Table1) 
				 
				   

	
		END
  ELSE
	  BEGIN

				UPDATE RMRequest SET
							RMRequest.CustomerId									= RMRequestudt.CustomerId,
							RMRequest.FacilityId									= RMRequestudt.FacilityId,
							RMRequest.ServiceId										= RMRequestudt.ServiceId,
							--RMRequest.RequestNo										= RMRequestudt.RequestNo,
							RMRequest.RequestDateTime								= RMRequestudt.RequestDateTime,
							RMRequest.RequestDateTimeUTC							= RMRequestudt.RequestDateTimeUTC,
							RMRequest.RequestStatus									= RMRequestudt.RequestStatus,
							RMRequest.RequestDescription							= RMRequestudt.RequestDescription,
							RMRequest.TypeOfRequest									= RMRequestudt.TypeOfRequest,
							RMRequest.Remarks										= RMRequestudt.Remarks,
							RMRequest.ModifiedBy									= RMRequestudt.UserId,
							RMRequest.ModifiedDate									= GETDATE(),
							RMRequest.ModifiedDateUTC								= GETUTCDATE(),
							RMRequest.ModelId										= RMRequestudt.ModelId,
							RMRequest.Manufacturerid								= RMRequestudt.Manufacturerid,
							RMRequest.UserAreaId									= RMRequestudt.UserAreaId,
							RMRequest.UserLocationId								= RMRequestudt.UserLocationId,
							RMRequest.MobileGuid									= RMRequestudt.MasterGuid,
							RMRequest.TargetDate									= RMRequestudt.TargetDate,
							RMRequest.RequestedPerson								= RMRequestudt.RequestedPerson
				
				FROM CRMRequest													AS RMRequest
				INNER JOIN @pCRMRequest											AS RMRequestudt			on RMRequest.CRMRequestId = RMRequestudt.CRMRequestId
			   WHERE ISNULL(RMRequestudt.CRMRequestId,0)>0


					INSERT INTO CRMRequestDet (	
												CRMRequestId,
												AssetId,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC
											   )

								SELECT		B.CRMRequestId,
											AssetId,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM	@pCRMDet A INNER JOIN CRMRequest B ON A.DetailGuid = B.MobileGuid
								WHERE	ISNULL(CRMRequestDetId,0)=0



IF EXISTS (SELECT 1 FROM @pCRMRequest WHERE Flag ='Reject')
	BEGIN
		UPDATE RMRequest SET	RMRequest.RequestStatus =142,
								RMRequest.ModifiedBy = RMRequestudt.UserId,
								RMRequest.ModifiedDate = getdate(),
								RMRequest.ModifiedDateUTC=GETUTCDATE(),
								RMRequest.StatusValue	=	'Reject'
		FROM CRMRequest													AS RMRequest
		INNER JOIN @pCRMRequest											AS RMRequestudt			on RMRequest.CRMRequestId = RMRequestudt.CRMRequestId
		WHERE RMRequestudt.Flag ='Reject' 

		IF NOT EXISTS (SELECT 1 FROM CRMRequestRemarksHistory A  INNER JOIN @pCRMRequest B ON A.CRMRequestId = B.CRMRequestId  WHERE  A.RequestStatusValue='Reject' AND A.Remarks = B.Remarks)

		BEGIN
	INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
										)
								SELECT  	CRMRequestId,
											Remarks,
											UserId,
											GETDATE(),
											142,
											Flag,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
							FROM @pCRMRequest WHERE CRMRequestId>0 AND Flag='Reject'
		END

	
	END

 ELSE 	IF EXISTS( SELECT 1 FROM @pCRMRequest WHERE Flag ='Approve')
	BEGIN
		UPDATE RMRequest SET	RMRequest.RequestStatus =140,
								RMRequest.ModifiedBy = RMRequestudt.UserId,
								RMRequest.ModifiedDate = getdate(),
								RMRequest.ModifiedDateUTC=GETUTCDATE(),
								RMRequest.StatusValue = 'Approve',
								RMRequest.AssigneeId = RMRequestudt.AssigneeId
		FROM CRMRequest													AS RMRequest
		INNER JOIN @pCRMRequest											AS RMRequestudt			on RMRequest.CRMRequestId = RMRequestudt.CRMRequestId
		WHERE RMRequestudt.Flag ='Approve'

	IF NOT EXISTS (SELECT 1 FROM CRMRequestRemarksHistory A  INNER JOIN @pCRMRequest B ON A.CRMRequestId = B.CRMRequestId  WHERE  A.RequestStatusValue='Approve' AND A.Remarks = B.Remarks)

	BEGIN
	INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
										)
								SELECT  	CRMRequestId,
											Remarks,
											UserId,
											GETDATE(),
											140,
											Flag,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM @pCRMRequest WHERE CRMRequestId>0 AND Flag='Approve'
		END


END

  ELSE 	IF EXISTS( SELECT 1 FROM @pCRMRequest WHERE Flag ='Verify')
	BEGIN
		UPDATE RMRequest SET	RMRequest.RequestStatus =142,
								RMRequest.ModifiedBy = RMRequestudt.UserId,
								RMRequest.ModifiedDate = getdate(),
								RMRequest.ModifiedDateUTC=GETUTCDATE(),
								RMRequest.StatusValue = 'Verify'
		FROM CRMRequest													AS RMRequest
		INNER JOIN @pCRMRequest											AS RMRequestudt			on RMRequest.CRMRequestId = RMRequestudt.CRMRequestId
		WHERE RMRequestudt.Flag ='Verify'


IF NOT EXISTS (SELECT 1 FROM CRMRequestRemarksHistory A  INNER JOIN @pCRMRequest B ON A.CRMRequestId = B.CRMRequestId  WHERE  A.RequestStatusValue='Verify' AND A.Remarks = B.Remarks)

		BEGIN
	INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,DoneDateUTC
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
										)
								SELECT  	CRMRequestId,
											Remarks,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											142,
											Flag,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM @pCRMRequest WHERE CRMRequestId>0 AND Flag='Verify'
		END


END


ELSE 	IF EXISTS( SELECT 1 FROM @pCRMRequest WHERE Flag ='Open')
	BEGIN
		UPDATE RMRequest SET	RMRequest.RequestStatus =139,
								RMRequest.ModifiedBy = RMRequestudt.UserId,
								RMRequest.ModifiedDate = getdate(),
								RMRequest.ModifiedDateUTC=GETUTCDATE(),
								RMRequest.StatusValue = 'Open'
		FROM CRMRequest													AS RMRequest
		INNER JOIN @pCRMRequest											AS RMRequestudt			on RMRequest.CRMRequestId = RMRequestudt.CRMRequestId
		WHERE RMRequestudt.Flag ='Open'



IF NOT EXISTS (SELECT 1 FROM CRMRequestRemarksHistory A  INNER JOIN @pCRMRequest B ON A.CRMRequestId = B.CRMRequestId  WHERE  A.RequestStatusValue='Open' AND A.Remarks = B.Remarks)

	BEGIN
	INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,DoneDateUTC
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
										)
								SELECT  	CRMRequestId,
											Remarks,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											139,
											Flag,
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM @pCRMRequest WHERE CRMRequestId>0 AND Flag='Open'
		END
		END

ELSE 	IF EXISTS( SELECT 1 FROM @pCRMRequest WHERE Flag ='Closed')
	BEGIN
		UPDATE RMRequest SET	RMRequest.RequestStatus =141,
								RMRequest.ModifiedBy = RMRequestudt.UserId,
								RMRequest.ModifiedDate = getdate(),
								RMRequest.ModifiedDateUTC=GETUTCDATE(),
								RMRequest.StatusValue = 'Closed'
		FROM CRMRequest													AS RMRequest
		INNER JOIN @pCRMRequest											AS RMRequestudt			on RMRequest.CRMRequestId = RMRequestudt.CRMRequestId
		WHERE RMRequestudt.Flag ='Closed'

	IF NOT EXISTS (SELECT 1 FROM CRMRequestRemarksHistory A  INNER JOIN @pCRMRequest B ON A.CRMRequestId = B.CRMRequestId  WHERE  A.RequestStatusValue='Closed' AND A.Remarks = B.Remarks)

		BEGIN
	INSERT INTO CRMRequestRemarksHistory (	CRMRequestId
											,Remarks
											,DoneBy
											,DoneDate
											,RequestStatus
											,RequestStatusValue
											,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
										)
								SELECT  	CRMRequestId,
											Remarks,
											UserId,
											GETDATE(),
											141,
											'Closed',
											UserId,
											GETDATE(),
											GETUTCDATE(),
											UserId,
											GETDATE(),
											GETUTCDATE()
								FROM @pCRMRequest WHERE CRMRequestId>0
		
	END
	END
				   	   SELECT			CRMRequestId,RequestNo,
										[Timestamp],
										GuId,
										MobileGuid
				   FROM					CRMRequest
				   WHERE				CRMRequestId IN (SELECT CRMRequestId FROM @pCRMRequest)

END

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


--------------------------------------------------------------------UDT CREATION---------------------------------------------------------------------------
			
			--drop proc [uspFM_CRMRequest_Mobile_Save]
			--drop type [udt_CRMRequest_Mobile]
			--drop type [udt_CRMRequestDet_Mobile]

--CREATE TYPE [dbo].[udt_CRMRequest_Mobile] AS TABLE(
--	[CRMRequestId] [int] NULL,
--	[UserId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[RequestNo] [nvarchar](100) NULL,
--	[RequestDateTime] [datetime] NULL,
--	[RequestDateTimeUTC] [datetime] NULL,
--	[RequestStatus] [int] NULL,
--	[RequestDescription] [nvarchar](1000) NULL,
--	[TypeOfRequest] [int] NULL,
--	[Remarks] [nvarchar](1000) NULL,
--	[ModelId] [int] NULL,
--	[Manufacturerid] [int] NULL,
--	[UserAreaId] [int] NULL,
--	[UserLocationId] [int] NULL,
--	[Flag] [nvarchar](200) NULL,
--	[MasterGuid] [nvarchar](max) NOT NULL,
--	[TargetDate] [datetime] NULL,
--	[RequestedPerson] [int] null,
--	[AssigneeId] [int] null
--)


--CREATE TYPE [dbo].[udt_CRMRequestDet_Mobile] AS TABLE(
--	[CRMRequestDetId] [int] NULL,
--	[AssetId] [int] NULL,
--	[DetailGuid] [nvarchar](max) NULL,
--	[UserId] [int] NULL
--)
GO
