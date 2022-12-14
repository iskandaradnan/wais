USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SmartAssign_GetAvailableFieldEngineers_test]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_SmartAssign_GetAvailableFieldEngineers]
Description			: Assign the staff for work order
Authors				: Dhilip V
Date				: 06-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_SmartAssign_GetAvailableFieldEngineers] @pWorkOrderId=40,@pSourceLatitude='12.800884',@pSourceLongitude='80.22403'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_SmartAssign_GetAvailableFieldEngineers_test]

	@pWorkOrderId		INT		=	NULL,
	@pSourceLatitude	NUMERIC(24,11), 
	@pSourceLongitude	NUMERIC(24,11)



AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

--1) Get the asset with Competency details based on work order
	SELECT	IDENTITY(INT, 1,1) ID,
			WO.FacilityId,
			WO.WorkOrderId,
			WO.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			Asset.AssetTypeCodeId,
			Classify.AssetClassificationId,
			Classify.AssetClassificationDescription AS AssetClassification
	INTO	#TempAssetDet
	FROM	EngMaintenanceWorkOrderTxn			AS	WO			WITH(NOLOCK)
			INNER JOIN EngAsset					AS	Asset		WITH(NOLOCK)	ON WO.AssetId					=	Asset.AssetId
			INNER JOIN EngAssetClassification	AS	Classify	WITH(NOLOCK)	ON Asset.AssetClassification	=	Classify.AssetClassificationId
	WHERE	WO.WorkOrderId	=	@pWorkOrderId

	--SELECT * FROM #TempAssetDet

--2) User with Competency bassed on asset
	SELECT	UserReg.UserRegistrationId,
			Comp.Competency,
			UserReg.UserGradeId,
			Grade.UserGrade,
			CAST(0  AS NUMERIC(24,11)) AS DistanceInKms,
			CAST(0  AS NUMERIC(24,11)) AS Latitude,
			CAST(0  AS NUMERIC(24,11)) AS Longitude
	INTO	#CompetencyUser
	FROM	UMUserRegistration	AS	UserReg
			OUTER APPLY dbo.SplitString (UserReg.UserCompetencyId,',') AS SplitComp
			LEFT JOIN UserCompetency	AS Comp		WITH(NOLOCK)	ON Comp.UserCompetencyId	= SplitComp.Item
			LEFT JOIN UserGrade			AS Grade	WITH(NOLOCK)	ON UserReg.UserGradeId		= Grade.UserGradeId
	WHERE	UserReg.UserCompetencyId IS NOT NULL --AND ISNULL(UserReg.IsUserEngaged,0) = 0
			--AND Comp.Competency 
			--	IN	(	SELECT AssetClassification 
			--			FROM #TempAssetDet
			--		)
			AND UserReg.UserRegistrationId not in(select Userid from FEUserAssigned) 
			--AND UserReg.UserRegistrationId 
			--	IN	(	SELECT	UserRegistrationId
			--			FROM	FEClock	
			--			WHERE	CAST([DateTime] AS DATE) = CAST(GETDATE() AS DATE)
			--		)
	ORDER BY Grade.UserGradeId ASC

--3) Calculate the distance for the users
	-- hindustan university Padur, Kelambakam  Lat - '12.800884' , Long - '80.22403'

	SELECT	UserRegistrationId,			
			DistanceBtPoints,
			Latitude,
			Longitude
	INTO	#CompetencyUserUp
	FROM (
		SELECT	GPSPos.UserRegistrationId,
				GPSPos.[DateTime] [DateTime],
				dbo.udf_DistanceBtPoints (@pSourceLatitude, @pSourceLongitude, GPSPos.Latitude,GPSPos.Longitude) AS DistanceBtPoints,
				GPSPos.Latitude,
				GPSPos.Longitude,
				--dbo.udf_DistanceBtPoints ('12.800884', '80.22403', GPSPos.Latitude,GPSPos.Longitude) AS DistanceBtPoints,
				ROW_NUMBER() OVER (PARTITION BY GPSPos.UserRegistrationId ORDER BY GPSPos.[DateTime] DESC) Rnk
		FROM	FEGPSPositionHistory		AS GPSPos WITH(NOLOCK)
				INNER JOIN #CompetencyUser	AS CompUser			ON GPSPos.UserRegistrationId	=	CompUser.UserRegistrationId
				INNER JOIN FEClock			AS Clock			ON CompUser.UserRegistrationId=Clock.UserRegistrationId AND CAST(Clock.ClockIn AS DATE) = CAST(GETDATE() AS DATE)  AND Clock.ClockOut IS NULL
		--WHERE	CAST(GPSPos.[DateTime] AS DATE) = CAST(GETDATE() AS DATE)
		) SUB
	WHERE Rnk=1

	UPDATE B SET	B.DistanceInKms	=	A.DistanceBtPoints,
					B.Latitude	=	A.Latitude,
					B.Longitude	=	A.Longitude
	FROM #CompetencyUserUp A INNER JOIN #CompetencyUser B ON A.UserRegistrationId = B.UserRegistrationId

	--SELECT * FROM #CompetencyUser

	SELECT distinct	ComUser.UserRegistrationId,
			ComUser.UserGradeId,
			ComUser.UserGrade,
			ComUser.DistanceInKms,
			ComUser.Latitude,
			ComUser.Longitude,
			CAST(0  AS NUMERIC(24,11)) AS DistanceInRoad
	INTO	#AssignUser
	FROM	#CompetencyUser	AS 	ComUser
	WHERE	DistanceInKms > 0
	--		LEFT JOIN EngMaintenanceWorkOrderTxn	AS	WO ON WO.AssignedUserId = ComUser.UserRegistrationId AND WorkOrderStatus NOT IN (193)


	--UPDATE	EngMaintenanceWorkOrderTxn SET	AssignedUserId	=	(	SELECT TOP 1 UserRegistrationId 
	--																FROM #AssignUser 
	--																WHERE ISNULL(UserGradeId,0)<>0 
	--																ORDER BY UserGradeId ASC , DistanceInKms ASC
	--															)
	--		WHERE	WorkOrderId	=	@pWorkOrderId 

	--SELECT	WorkOrderId,
	--		AssignedUserId
	--FROM	EngMaintenanceWorkOrderTxn
	--WHERE	WorkOrderId	=	@pWorkOrderId

	--SELECT * FROM FEClock

	--SELECT * FROM FEGPSPositionHistory



	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRAN
 --       END


	if not exists (select 1 from #AssignUser)
	begin
				
	SELECT	distinct WorkOrderId,
			WorkOrder.CustomerId,
			Facility.FacilityId,
			Facility.Latitude,
			Facility.Longitude,
			MaintenanceWorkNo
		into #WO	
	FROM	EngMaintenanceWorkOrderTxn AS WorkOrder
			INNER JOIN	[dbo].[MstLocationFacility] Facility ON	WorkOrder.FacilityId = Facility.FacilityId
	WHERE	MaintenanceWorkCategory	=	188 AND (AssigneeLovId = 330 OR AssigneeLovId IS NULL) 
	and DATEADD(mi,10,WorkOrder.CreatedDate) >=getdate() and  DATEADD(mi,5,WorkOrder.CreatedDate) <=getdate()
	and	WorkOrder.WorkOrderId = @pWorkOrderId

		
		SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 41
	
	SELECT	DISTINCT
		IDENTITY(INT ,1,1) AS ID,
		a.FacilityId,
		A.CustomerId,
		ltrim(rtrim(Email)) as EMAIL		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	in (select FacilityId from  #WO )
	--IN (SELECT DISTINCT FacilityId FROM #Notification)
	
	
	select IDENTITY(INT ,1,1) AS ID,
		FacilityId,
		CustomerId,
		Email
	INTO	#TempUserEmails
	from 
	
	(
	select
	distinct
		A.FacilityId,
		A.CustomerId,
		CAST(STUFF((SELECT ',' + RTRIM(AA.Email ) FROM #TempUserEmails_all AA where A.FacilityId = AA.FacilityId and A.CustomerId = AA.CustomerId -- AA.FacilityId=b.FacilityId 
		FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
	
	 from #TempUserEmails_all a) a



	INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,
	QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
	SELECT A.CustomerId,A.FacilityId,isnull(c.Email,'') as Email,null,NULL,NULL,b.Subject,B.NotificationTemplateId,
	A.MaintenanceWorkNo,
	REPLACE([Definition],'{0}',A.MaintenanceWorkNo),1,1,3,NULL,NULL,GETDATE(),
	NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #WO A cross join  NotificationTemplate B
	left join #TempUserEmails c on a.CustomerId= c.CustomerId	 and a.FacilityId = c.FacilityId
	WHERE B.NotificationTemplateId = 41	
	--and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 41	and  TemplateVars =a.MaintenanceWorkNo)
	and len(isnull(c.Email,''))>5

	
	
	SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification1
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 41


		
	SELECT	distinct A.UserRegistrationId,
			a.FacilityId,
			A.CustomerId		
		INTO	#TempUserEmails_all1
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification1)
	AND B.FacilityId	in (select FacilityId from  #WO )

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
					SELECT A.CustomerId,A.FacilityId,isnull(c.UserRegistrationId,'') as UserRegistrationId,
					'UnScheduled Work Order Not Assigned -  ' + isnull(A.MaintenanceWorkNo,''),'',
					'/bems/unscheduledworkorder?id='+CAST(@pWorkOrderId AS NVARCHAR(100)),
					1,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),GETDATE(),0 FROM #WO A cross join  NotificationTemplate B
					left join #TempUserEmails_all1 c on a.CustomerId= c.CustomerId	 and a.FacilityId = c.FacilityId
					WHERE B.NotificationTemplateId = 41	
					--and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 41	and  TemplateVars =a.MaintenanceWorkNo)
					and len(isnull(c.UserRegistrationId,'') )>0
					


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
							SELECT isnull(c.UserRegistrationId,'') as UserRegistrationId,
					'UnScheduled Work Order Not Assigned -  ' + isnull(A.MaintenanceWorkNo,''),'',
					1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),
					'UnScheduledWorkOrder',
					A.MaintenanceWorkNo,
					1
					 FROM #WO A cross join  NotificationTemplate B
					left join #TempUserEmails_all1 c on a.CustomerId= c.CustomerId	 and a.FacilityId = c.FacilityId
					WHERE B.NotificationTemplateId = 41	
					--and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 41	and  TemplateVars =a.MaintenanceWorkNo)
					and len(isnull(c.UserRegistrationId,'') )>0
					 
					 
					 
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotificationdet1


	END

END TRY


BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   );
		   THROW;

END CATCH
GO
