USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestWorkOrderTxn_Asset_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestWorkOrderTxn_Asset_Save
Description			: CRM	RequestWorkOrder save
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pCRMDet udt_CRMRequestDet
INSERT INTO @pCRMDet (CRMRequestDetId,CRMRequestId,AssetId)
VALUES (0,40,1),(0,40,4),(0,40,9),(0,40,80)

EXECUTE [uspFM_CRMRequestWorkOrderTxn_Asset_Save] @pCRMDet=@pCRMDet,@pCRMRequestWOId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pCRMWorkOrderNo=NULL,@pCRMWorkOrderDateTime='2018-05-23 20:05:34.410',
@pStatus=139,@pDescription='tEST',@pTypeOfRequest=134,@pCRMRequestId=40,@pAssetId=1,@pManufacturerId=1,@pModelId=1,@pAssignedUserId=1,@pRemarks='tEST',@pUserId=1,@pTimestamp=NULL,@pUserAreaId=NULL,@pUserLocationId=NULL

SELECT * FROM CRMRequest
SELECT * FROM CRMRequestWorkOrderTxn WHERE CRMRequestId=40
SELECT * FROM CRMRequestProcessStatus
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestWorkOrderTxn_Asset_Save]
		@pCRMDet						udt_CRMRequestDet	READONLY,
		@pCRMRequestWOId		INT=	NULL,
		@pCustomerId			INT,
		@pFacilityId			INT,
		@pServiceId				INT,
		@pCRMWorkOrderNo		NVARCHAR(50)	=	NULL,
		@pCRMWorkOrderDateTime	DATETIME		=	NULL,
		@pStatus				INT=	NULL,
		@pDescription			NVARCHAR(500)=	NULL,
		@pTypeOfRequest			INT=	NULL,
		@pCRMRequestId			INT				= NULL,
		@pAssetId				INT				= NULL,
		@pManufacturerId		INT				= NULL,
		@pModelId				INT				= NULL,
		@pAssignedUserId		INT				= NULL,
		@pRemarks				NVARCHAR(500)	= NULL,
		@pUserId				INT				= NULL,
		@pTimestamp				VARBINARY(200)	= NULL,
		@pUserAreaId			INT				= NULL,
		@pUserLocationId		INT				= NULL,
		@pRequesterId		INT				= NULL
		

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @Table1 TABLE (ID INT)
	declare @Notification TABLE (ID INT)
	declare @TableNotificationdet1 table (id int,userid int)
	declare @TableNotificationdet table (id int,userid int)
	DECLARE	@PrimaryKeyId	 INT
	DECLARE	@mLoopLimit	 INT,@mLoopStart INT 

	DECLARE @pCRMWorkOrderDateTimeUTC	DATETIME

	SET @pCRMWorkOrderDateTimeUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), GETDATE())

	CREATE TABLE #CRMRequestdETAsset (	ID INT IDENTITY(1,1)
										,CRMRequestDetId INT
										,CRMRequestId INT
										,AssetId INT
								    )

	INSERT INTO #CRMRequestdETAsset (	CRMRequestDetId,
										CRMRequestId,
										AssetId
									)
	SELECT DISTINCT CRMRequestDetId,
					CRMRequestId,
					AssetId	
	FROM @pCRMDet

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.FMLovMst
	SET @mLoopStart=1
	SELECT @mLoopLimit	=	COUNT(1) FROM #CRMRequestdETAsset

	
										SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification1
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 18

	
	
	SELECT	distinct A.UserRegistrationId,
			b.FacilityId,
			b.CustomerId		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification1)
	AND B.FacilityId	= @pFacilityId
	--IN (SELECT DISTINCT FacilityId FROM #Notification)
	

	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN
		
			SET @pAssetId =(SELECT AssetId FROM #CRMRequestdETAsset WHERE ID = @mLoopStart)
			IF NOT EXISTS (SELECT * FROM CRMRequestWorkOrderTxn WHERE CRMRequestId	=@pCRMRequestId AND AssetId	=	@pAssetId	)

	BEGIN
	
	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT
	DECLARE @mCRMRequestWOId INT
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
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							UserAreaId,
							UserLocationId,
							AssignedUserId
						)	OUTPUT INSERTED.CRMRequestWOId INTO @Table
			VALUES			
						(	@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pCRMWorkOrderNo,
							GETDATE(), --@pCRMWorkOrderDateTime,
							--GETUTCDATE(),--@pCRMWorkOrderDateTimeUTC,
							@pCRMWorkOrderDateTime,
							139,
							@pDescription,
							@pTypeOfRequest,
							@pCRMRequestId,
							@pAssetId,
							@pManufacturerId,
							@pModelId,
							@pRemarks,
							@pUserId,			
							GETDATE(), 
							GETUTCDATE(),
							@pUserId, 
							GETDATE(), 
							GETUTCDATE(),
							@pUserAreaId,
							@pUserLocationId,
							@pAssignedUserId
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
													ModifiedDateUTC
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
														GETUTCDATE()
												)



			  SET @mCRMRequestWOId = (SELECT ID FROM @Table)


			  	INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'CRMRequestWorkOrderTxn',
								@mCRMRequestWOId,
								@pAssignedUserId
					

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
								VALUES  (	@pCustomerId,
											@pFacilityId,
											--@pUserId,
											isnull(( select top 1 Requester from CRMRequest  where CRMRequestId= @pCRMRequestId),''),
											@pCRMWorkOrderNo +' '+ 'CRM Work Order has been generated',
											@pRemarks,
											'/bems/crmworkorder?id='+CAST(@mCRMRequestWOId AS NVARCHAR(100)),
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
									) OUTPUT INSERTED.NotificationId , INSERTED.UserId INTO @TableNotificationdet
						SELECT
								isnull(( select top 1 Requester from CRMRequest  where CRMRequestId= @pCRMRequestId),''),
								@pCRMWorkOrderNo +' '+ 'CRM Work Order has been generated',
								'CRM Work Order' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'CRMRequestStatus',
								@pCRMWorkOrderNo,
								1



						INSERT INTO QueueWebtoMobile	(		
												TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								userid
						FROM @TableNotificationdet

						
			
						

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
										select  A.CustomerId,
												A.FacilityId,
												A.UserRegistrationId,
												@pCRMWorkOrderNo +' '+ 'CRM Work Order has been generated ' ,
												@pRemarks		,
												'/bems/crmworkorder?id='+CAST(@mCRMRequestWOId AS NVARCHAR(100)),
												1		,
												@pUserId	,	
												GETDATE(),									
												GETUTCDATE(),
												@pUserId,
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
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotificationdet1
						  SELECT  
						  A.UserRegistrationId,
						 	@pCRMWorkOrderNo +' '+ 'CRM Work Order has been generated' ,
						 'CRM Work Order' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'CRMRequestStatus',
								@pCRMWorkOrderNo,
								1
						from #TempUserEmails_all a  
					 
					 
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotificationdet1




				







								
			--SELECT	CRMRequestWOId,
			--		CRMRequestId,
			--		[Timestamp],
			--		'' AS	ErrorMessage,
			--		GuId,
			--		CRMWorkOrderNo,
			--		CRMWorkOrderDateTime
			--FROM	CRMRequestWorkOrderTxn
			--WHERE	CRMRequestWOId IN (SELECT ID FROM @Table)
					

			UPDATE B SET B.AssetWorkingStatus = @pTypeOfRequest FROM @pCRMDet A INNER JOIN EngAsset B ON A.AssetId = b.AssetId
			where @pTypeOfRequest in (136,137)

		    UPDATE CRMRequest SET IsWorkOrder =1 WHERE CRMRequestId = @pCRMRequestId

			UPDATE CRMRequest SET TypeOfRequest =@pTypeOfRequest WHERE CRMRequestId = @pCRMRequestId

			UPDATE CRMRequest SET RequestStatus =140 WHERE CRMRequestId = @pCRMRequestId

			insert into @Table1
			select id from @Table

			DELETE  @Table
			delete from @TableNotificationdet1
			delete from @TableNotificationdet


end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------
BEGIN
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
			WHERE	A.CRMRequestId = @pCRMRequestId	AND AssetId = @pAssetId
END


	SET @mLoopStart	=	@mLoopStart+1
	END

	SELECT	CRMRequestWOId,
					b.CRMRequestId,
					b.[Timestamp],
					'' AS	ErrorMessage,
					b.GuId,
					c.GuId AS RequestGuid,
					CRMWorkOrderNo,
					CRMWorkOrderDateTime
			FROM	@Table1 a inner join 
					CRMRequestWorkOrderTxn b on a.ID = b.CRMRequestWOId
					inner join CRMRequest c on b.CRMRequestId = c.CRMRequestId
			WHERE	CRMRequestWOId IN (SELECT ID FROM @Table1)

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
