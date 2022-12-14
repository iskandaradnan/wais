USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PorteringAssigne_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PorteringAssigne_Save
Description			: Assign the staff for portering
Authors				: Dhilip V
Date				: 09-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_PorteringAssigne_Save @pPorteringId=303,@pAssignedUserId=1,@pAssigneeLovId=331

SELECT * FROM FENotification
SELECT * FROM PorteringTransaction
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_PorteringAssigne_Save]
		
		@pPorteringId  INT,
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
		UPDATE		PorteringTransaction 
		SET			AssignPorterId	=	@pAssignedUserId,
					AssigneeLovId	=	@pAssigneeLovId,
					PorteringStatus = 250
		WHERE		PorteringId =	@pPorteringId

			Insert FEUserAssigned (Userid) values(@pAssignedUserId)
	SELECT @mDateFmt = b.FieldValue	 
	FROM	FMConfigCustomerValues a 
			INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
	WHERE	A.KeyName='DATE'
			AND CustomerId in (select CustomerId from PorteringTransaction  WHERE PorteringId =	@pPorteringId)

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
							'Asset Tracker  request has been assigned to you - ' + PorteringNo + ' Dt '+ @mDateFmtValue,
							'Smart Assigned' AS Remarks,
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							'PorteringTransaction',
							PorteringNo,
							1
					FROM	PorteringTransaction
					WHERE PorteringId =	@pPorteringId

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
											'PorteringTransaction',
											@pPorteringId,
											@pAssignedUserId
									)
	END

ELSE IF (@pAssigneeLovId=332) 
	BEGIN
		UPDATE	PorteringTransaction 
		SET		AssignPorterId	=	@pAssignedUserId,
				AssigneeLovId	=	@pAssigneeLovId,
				PorteringStatus = 250
		WHERE	PorteringId =	@pPorteringId

		Insert FEUserAssigned (Userid) values(@pAssignedUserId )
	SELECT @mDateFmt = b.FieldValue	 
	FROM	FMConfigCustomerValues a 
			INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
	WHERE	A.KeyName='DATE'
			AND CustomerId in (select CustomerId from PorteringTransaction  WHERE PorteringId =	@pPorteringId)

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
							'Asset Tracker request has been assigned to you - ' + PorteringNo + ' Dt '+ @mDateFmtValue,
							'Manual Assigned' AS Remarks,
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							CreatedBy,
							GETDATE(),
							GETUTCDATE(),
							'PorteringTransaction',
							PorteringNo,
							1
					FROM	PorteringTransaction
					WHERE PorteringId =	@pPorteringId

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
											'PorteringTransaction',
											@pPorteringId,
											@pAssignedUserId
									)
	END



	SELECT	WorkOrderId,
			AssignedUserId
	FROM EngMaintenanceWorkOrderTxn
	WHERE WorkOrderId =	@pPorteringId


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
