USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WorkOrderAssigne_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WorkOrderAssigne_Save
Description			: Assign the staff for work order
Authors				: Dhilip V
Date				: 14-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_WorkOrderAssigne_Save @pWorkOrderId=554,@pAssignedUserId=1,@pAssigneeLovId=331

SELECT * FROM FENotification

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WorkOrderAssigne_Save]
		
		@pWorkOrderId  INT,
		@pAssignedUserId INT,
		@pAssigneeLovId INT
		--@pFlag NVARCHAR(50)

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @PrimaryKeyId int

-- Default Values


-- Execution

IF (@pAssigneeLovId=331) 
	BEGIN
		UPDATE EngMaintenanceWorkOrderTxn SET	EngineerUserId  =	@pAssignedUserId,
												AssignedUserId	=	@pAssignedUserId,
												AssigneeLovId	=	@pAssigneeLovId
		WHERE WorkOrderId =	@pWorkOrderId
		
		Insert FEUserAssigned (Userid) values(@pAssignedUserId )

	SELECT @mDateFmt = b.FieldValue	 
	FROM	FMConfigCustomerValues a 
			INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
	WHERE	A.KeyName='DATE'
			AND CustomerId in (select CustomerId from EngMaintenanceWorkOrderTxn  WHERE WorkOrderId =	@pWorkOrderId)

	IF (@mDateFmt='DD-MMM-YYYY')
		BEGIN
			SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')
		END
	ELSE IF (@mDateFmt='DD/MMM/YYYY')
		BEGIN
			SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')
		END

		
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
								) OUTPUT INSERTED.NotificationId INTO @Table
					SELECT	@pAssignedUserId,
							'UnScheduled Work Order has been assinged to you - ' + MaintenanceWorkNo + ' Dt '+ @mDateFmtValue,
							'Smart Assigned' AS Remarks,
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							'EngMaintenanceWorkOrderTxn',
							MaintenanceWorkNo,
							1
					FROM	EngMaintenanceWorkOrderTxn
					WHERE WorkOrderId =	@pWorkOrderId

	SET @PrimaryKeyId = (SELECT ID FROM @Table)

	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									VALUES
									(
											'FENotification',
											@PrimaryKeyId,
											@pAssignedUserId
									)
	
	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									VALUES
									(
											'EngMaintenanceWorkOrderTxn',
											@pWorkOrderId,
											@pAssignedUserId
									)
	END

ELSE IF (@pAssigneeLovId=332) 
	BEGIN
		UPDATE EngMaintenanceWorkOrderTxn SET	EngineerUserId  =	@pAssignedUserId,
												AssignedUserId	=	@pAssignedUserId,
												AssigneeLovId	=	@pAssigneeLovId
		WHERE WorkOrderId =	@pWorkOrderId
		
select @mDateFmt = b.FieldValue	 from FMConfigCustomerValues a inner join FMLovMst b on a.ConfigKeyLovId=b.LovId
where A.KeyName='DATE'
AND CustomerId in (select CustomerId from EngMaintenanceWorkOrderTxn  WHERE WorkOrderId =	@pWorkOrderId)
	IF (@mDateFmt='DD-MMM-YYYY')
		BEGIN
			SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')
		END
	ELSE IF (@mDateFmt='DD/MMM/YYYY')
		BEGIN
			SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')
		END

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
								) OUTPUT INSERTED.NotificationId INTO @Table
					SELECT	@pAssignedUserId,
							'UnScheduled Work Order has been assinged to you - ' + MaintenanceWorkNo + ' Dt '+ @mDateFmtValue,
							'Manual Assigned' AS Remarks,
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							'EngMaintenanceWorkOrderTxn',
							MaintenanceWorkNo,
							1
					FROM	EngMaintenanceWorkOrderTxn
					WHERE WorkOrderId =	@pWorkOrderId


		SET @PrimaryKeyId = (SELECT ID FROM @Table)

	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									VALUES
									(
											'FENotification',
											@PrimaryKeyId,
											@pAssignedUserId
									)
	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									VALUES
									(
											'EngMaintenanceWorkOrderTxn',
											@pWorkOrderId,
											@pAssignedUserId
									)

	END



	SELECT	top 1 WorkOrderId,
			AssignedUserId,
			Email as AssigneEmail,
			MaintenanceWorkNo as MaintenanceWorkNo,
			@mDateFmtValue as AssignDate,
			WO.FacilityId as FacilityId,
			R.StaffName as AssigneeName
	FROM EngMaintenanceWorkOrderTxn WO
	left join UMUserRegistration R on WO.AssignedUserId= R.UserRegistrationId
	WHERE WorkOrderId =	@pWorkOrderId


	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
 --       END   


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
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
GO
