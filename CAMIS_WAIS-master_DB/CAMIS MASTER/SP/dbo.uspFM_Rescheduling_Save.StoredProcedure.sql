USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Rescheduling_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Rescheduling_Save
Description			: Rescheduling the work order
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pRescheduling  [dbo].[udt_Rescheduling]
INSERT INTO @pRescheduling ([WorkOrderId],[AssetId],[AssignedUserId],[RescheduleDate],[CustomerId],[FacilityId],[UserId],[Remarks])
VALUES (544,97,1,'31-Jul-2018',1,2,1,NULL)

EXEC uspFM_Rescheduling_Save @pRescheduling=@pRescheduling

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_Rescheduling_Save]
	
		
		@pRescheduling  [dbo].[udt_Rescheduling] READONLY

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @PrimaryKeyId int
	DECLARE @TableNotification TABLE (ID INT)
-- Default Values


-- Execution
 
 	update WO set	WO.PreviousTargetDateTime = WO.TargetDateTime
	FROM EngMaintenanceWorkOrderTxn AS WO inner join @pRescheduling udt_Reschd on WO.WorkOrderId = udt_Reschd.WorkOrderId

	update WO set	WO.TargetDateTime		= udt_Reschd.[RescheduleDate],
					WO.AssignedUserId		= udt_Reschd.AssignedUserId,
					WO.EngineerUserId		= udt_Reschd.AssignedUserId,
					WO.RescheduleRemarks	= udt_Reschd.Remarks,
					wo.ModifiedBy			= udt_Reschd.UserId,
					wo.ModifiedDate			= GETDATE(),
					wo.ModifiedDateUTC		= GETUTCDATE()
	FROM EngMaintenanceWorkOrderTxn AS WO inner join @pRescheduling udt_Reschd on WO.WorkOrderId = udt_Reschd.WorkOrderId

	INSERT INTO EngMwoReschedulingTxn (	CustomerId,
										FacilityId,
										ServiceId,
										WorkOrderId,
										RescheduleDate,
										RescheduleDateUTC,
										Remarks,
										ImpactSchedulePlanner,
										CreatedBy,
										CreatedDate,
										CreatedDateUTC,
										ModifiedBy,
										ModifiedDate,
										ModifiedDateUTC
										)
				SELECT	udt_Res.CustomerId,
						udt_Res.FacilityId,
						2,
						udt_Res.WorkOrderId,
						udt_Res.[RescheduleDate],
						udt_Res.[RescheduleDate],
						udt_Res.Remarks,
						1,
						udt_Res.UserId,
						GETDATE(),
						GETUTCDATE(),
						udt_Res.UserId,
						GETDATE(),
						GETUTCDATE()
				FROM @pRescheduling AS udt_Res 
				--		LEFT JOIN EngMwoReschedulingTxn AS Reschd ON udt_Res.WorkOrderId = Reschd.WorkOrderId AND udt_Res.RescheduleDate = Reschd.RescheduleDate
				--WHERE	Reschd.WorkOrderId IS NULL






---------- Notification Alerts------------

	DECLARE @mUserId INT
	SET @mUserId = (SELECT TOP 1 UserId FROM @pRescheduling)

	SELECT WorkOrderId,UserId  INTO #Temp FROM @pRescheduling WHERE	ISNULL(WorkOrderId,0) > 0

	SELECT UserId,COUNT(UserId) as CNT INTO #TempUserGroupBy FROM #Temp group by UserId

	SELECT @mDateFmt = b.FieldValue	 
	FROM	FMConfigCustomerValues a 
			INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
	WHERE	A.KeyName='DATE'
			AND CustomerId IN (SELECT DISTINCT TOP 1  CustomerId FROM @pRescheduling)

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
GO
