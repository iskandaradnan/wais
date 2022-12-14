USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPMLoadBalancing_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PPMLoadBalancing_Save
Description			: Get the Work orders for PPMLoadBalancing
Authors				: Dhilip V
Date				: 30-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @PPMLoadBalancing		[dbo].[udt_PPMLoadBalancing]
INSERT INTO @PPMLoadBalancing (WorkOrderId,TargetDateTime,UserId,[Timestamp])
VALUES (1,'2018-01-01',1,'00')
EXEC [uspFM_PPMLoadBalancing_Save] @PPMLoadBalancing=@PPMLoadBalancing
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_PPMLoadBalancing_Save]   
                        
		@PPMLoadBalancing		[dbo].[udt_PPMLoadBalancing]	READONLY
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	DECLARE @Table TABLE (ID INT)
	DECLARE	@pTimestamp varbinary(200)
	DECLARE @mTimestamp varbinary(200);
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @PrimaryKeyId int
	DECLARE @TableNotification TABLE (ID INT)

-- Default Values
	DECLARE @mCnt	INT
	DECLARE @mloopStart	INT
	DECLARE @mloopMax	INT
	SET @mloopStart= 1
	SELECT @mloopMax	= COUNT(1)	FROM @PPMLoadBalancing

CREATE TABLE #Timestamp
(
ID INT IDENTITY(1,1),
IsTimestampAltered BIT
)


CREATE TABLE #MWO
(
ID INT IDENTITY(1,1),
WorkOrderId INT
)

INSERT INTO #MWO (WorkOrderId)
SELECT WorkOrderId FROM @PPMLoadBalancing

-- Execution

	WHILE @mloopStart <= @mloopMax
	BEGIN 
		
		SELECT	@pTimestamp = [Timestamp] FROM	@PPMLoadBalancing 
		WHERE	WorkOrderId	=(	SELECT WorkOrderId FROM #MWO WHERE ID = @mloopStart  )
		SELECT	@mTimestamp = [Timestamp] FROM	EngMaintenanceWorkOrderTxn 
		WHERE	WorkOrderId =(	SELECT WorkOrderId FROM #MWO WHERE ID = @mloopStart  )

		IF (@mTimestamp= @pTimestamp)
			BEGIN
				INSERT INTO #Timestamp (IsTimestampAltered)
				SELECT 0 AS IsTimestampAltered
			END
		ELSE
			BEGIN
				INSERT INTO #Timestamp (IsTimestampAltered)
				SELECT 1 AS IsTimestampAltered
			END
	SET @mloopStart = @mloopStart + 1
	END

	SET @mCnt=0;
	SELECT @mCnt = COUNT(1) FROM #Timestamp WHERE IsTimestampAltered=1;

	IF (@mCnt=0)
		BEGIN

		SELECT * INTO #PPMLoadBalancing FROM @PPMLoadBalancing

		--IF EXISTS (SELECT 1 FROM #PPMLoadBalancing WHERE ISNULL(NewAssigneeId,0) =0)
		--BEGIN
			UPDATE	MWO SET	MWO.AssignedUserId	=	udtMWO.NewAssigneeId,
							MWO.EngineerUserId	=	udtMWO.NewAssigneeId,
							MWO.ModifiedBy		=	udtMWO.UserId,
							MWO.ModifiedDate	=	GETDATE(),	
							MWO.ModifiedDateUTC	=	GETUTCDATE()
							OUTPUT INSERTED.WorkOrderId INTO @Table
			FROM	EngMaintenanceWorkOrderTxn		AS	MWO 
					INNER JOIN #PPMLoadBalancing	AS	udtMWO	ON	MWO.WorkOrderId	=	udtMWO.WorkOrderId
			WHERE	ISNULL(udtMWO.NewAssigneeId,0) > 0
		--END

		--IF NOT EXISTS (SELECT 1 FROM #PPMLoadBalancing WHERE (TargetDateTime ='1900-01-01' OR TargetDateTime IS NULL  OR ISNULL(TargetDateTime,'')='') )
		--BEGIN
			UPDATE	MWO SET	MWO.TargetDateTime	=	udtMWO.TargetDateTime,
							MWO.ModifiedBy		=	udtMWO.UserId,
							MWO.ModifiedDate	=	GETDATE(),	
							MWO.ModifiedDateUTC	=	GETUTCDATE()
							OUTPUT INSERTED.WorkOrderId INTO @Table
			FROM	EngMaintenanceWorkOrderTxn		AS	MWO 
					INNER JOIN #PPMLoadBalancing	AS	udtMWO	ON	MWO.WorkOrderId	=	udtMWO.WorkOrderId
					WHERE	(udtMWO.TargetDateTime IS NOT NULL)
			--WHERE	(udtMWO.TargetDateTime !='1900-01-01' OR udtMWO.TargetDateTime IS NOT NULL)
		--END

			SELECT	WorkOrderId,
					[Timestamp],
					'' ErrorMessage
			FROM	EngMaintenanceWorkOrderTxn
			WHERE	WorkOrderId IN (SELECT ID FROM @Table)


---------- Notification Alerts------------

	DECLARE @mUserId INT
	SET @mUserId = (SELECT TOP 1 UserId FROM @PPMLoadBalancing)

	SELECT WorkOrderId,UserId  INTO #Temp FROM @PPMLoadBalancing WHERE	ISNULL(WorkOrderId,0) > 0

	SELECT UserId,COUNT(UserId) as CNT INTO #TempUserGroupBy FROM #Temp group by UserId

	SELECT @mDateFmt = b.FieldValue	 
	FROM	FMConfigCustomerValues a 
			INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
	WHERE	A.KeyName='DATE'
			AND CustomerId IN (SELECT DISTINCT TOP 1  CustomerId FROM EngMaintenanceWorkOrderTxn  WHERE WorkOrderId IN (SELECT ID FROM @Table))

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
					SELECT	'EngMaintenanceWorkOrderTxn',
							WorkOrderId,
							UserId
					FROM #Temp
		
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
									SingleRecord
								) OUTPUT INSERTED.NotificationId INTO @TableNotification
					SELECT	UserId,
							cast(CNT as nvarchar(10)) + ' Scheduled Work Order has been assinged to you on Dt '+ @mDateFmtValue,
							'Scheduled work order' AS Remarks,
							UserId,
							GETDATE(),
							GETUTCDATE(),
							UserId,
							GETDATE(),
							GETUTCDATE(),
							'EngMaintenanceWorkOrderTxn',							
							0
					FROM	#TempUserGroupBy
					
	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
					SELECT	'FENotification',
							ID,
							@mUserId
					FROM @TableNotification






		END
	ELSE
		BEGIN
			SELECT	WorkOrderId,
					[Timestamp],
					'Record Modified. Please Re-Select' ErrorMessage
			FROM	EngMaintenanceWorkOrderTxn
			WHERE	WorkOrderId IN (SELECT WorkOrderId FROM @PPMLoadBalancing)
		END


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
