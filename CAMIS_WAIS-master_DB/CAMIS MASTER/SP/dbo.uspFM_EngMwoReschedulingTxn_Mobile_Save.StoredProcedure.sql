USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoReschedulingTxn_Mobile_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoReschedulingTxn_Save
Description			: If Planner Reschedule details already exists then update else insert.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngMwoReschedulingTxn		[dbo].[udt_EngMwoReschedulingTxn_Mobile]
INSERT INTO @EngMwoReschedulingTxn (WorkOrderReschedulingId,CustomerId,FacilityId,ServiceId,RescheduleApprovedBy,WorkOrderId,RescheduleDate,RescheduleDateUTC,Reason,
ImpactSchedulePlanner,UserId) values
(583,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597',1,1,2),
(584,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597',1,1,2)
EXECUTE [uspFM_EngMwoReschedulingTxn_Mobile_Save] @EngMwoReschedulingTxn

select * from EngMwoReschedulingTxn
SELECT * FROM QueueWebtoMobile
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[uspFM_EngMwoReschedulingTxn_Mobile_Save]
	
		@EngMwoReschedulingTxn					[dbo].[udt_EngMwoReschedulingTxn_Mobile]   READONLY

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @UpdateTable TABLE (ID INT)	
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @TableAcknowledge TABLE (ID INT)
	DECLARE @mWorkOrderReschedulingId INT,@mMaintenanceWorkNo NVARCHAR(50),	@mLoopStart		INT =1,	@mLoopLimit		INT,@mRescheduleDate DATETIME,@mUserId INT
-- Default Values


-- Execution
 

	IF EXISTS (SELECT 1 FROM EngMwoReschedulingTxn	A  INNER JOIN @EngMwoReschedulingTxn B ON A.WorkOrderReschedulingId = B.WorkOrderReschedulingId)

		BEGIN
			UPDATE EngMwoReschedulingTxn SET
							CustomerId									=MwoReschedulingType.CustomerId,
							FacilityId									=MwoReschedulingType.FacilityId,
							ServiceId									=MwoReschedulingType.ServiceId,
							WorkOrderId									=MwoReschedulingType.WorkOrderId,
							RescheduleApprovedBy						=MwoReschedulingType.RescheduleApprovedBy,
							RescheduleDate								=MwoReschedulingType.RescheduleDate,
							RescheduleDateUTC							=MwoReschedulingType.RescheduleDateUTC,
							Reason										=MwoReschedulingType.Reason,
							ImpactSchedulePlanner						=MwoReschedulingType.ImpactSchedulePlanner,
							ModifiedBy									=MwoReschedulingType.UserId,
							ModifiedDate								=GETDATE(),
							ModifiedDateUTC								=GETUTCDATE(),
							AcceptedBy									= MwoReschedulingType.AcceptedBy,
							Signature 									= MwoReschedulingType.Signature 
							OUTPUT INSERTED.WorkOrderReschedulingId INTO @UpdateTable
			FROM EngMwoReschedulingTxn 					AS MwoRescheduling
			INNER JOIN 		@EngMwoReschedulingTxn		AS MwoReschedulingType		ON	MwoRescheduling.WorkOrderReschedulingId = MwoReschedulingType.WorkOrderReschedulingId



			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'EngMwoReschedulingTxn' as TableName,
									a.ID as Tableprimaryid,
									b.CreatedBy from @UpdateTable a inner join EngMwoReschedulingTxn b on a.ID = b.WorkOrderReschedulingId
							


			INSERT INTO	FEAcknowledge(	ScreenName,
										Documentid,
										DocumentNo,
										Description,
										Userid,
										Remarks,
										Acknowledge,
										Signatureimage
										) OUTPUT INSERTED.AcknowledgeId INTO @TableAcknowledge
			SELECT	'Reschduling Work Order',
									A.ID ,
									C.MaintenanceWorkNo,
									'The following work order - ' + C.MaintenanceWorkNo +' has been rescheduled to date - ' + CAST(B.RescheduleDate AS NVARCHAR(100)) AS RescheduleDate,
									B.CreatedBy,
									null,
									null,
									null	
			from 	@UpdateTable A	INNER JOIN EngMwoReschedulingTxn B ON A.ID = B.WorkOrderReschedulingId
			INNER JOIN EngMaintenanceWorkOrderTxn C ON C.WorkOrderId = B.WorkOrderId

			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'FEAcknowledge',
									ID,
									B.Userid
							FROM @TableAcknowledge A INNER JOIN FEAcknowledge B ON A.ID = B.AcknowledgeId

		SELECT	WorkOrderReschedulingId,
				[Timestamp]
		FROM	EngMwoReschedulingTxn
		WHERE	WorkOrderReschedulingId IN (SELECT ID FROM @UpdateTable)
			
		END

	IF EXISTS (SELECT 1 FROM  @EngMwoReschedulingTxn where ISNULL(WorkOrderReschedulingId,0)=0)

		BEGIN
			INSERT INTO EngMwoReschedulingTxn(
								CustomerId,	
								FacilityId,
								ServiceId,								
								WorkOrderId,
								RescheduleApprovedBy,
								RescheduleDate,
								RescheduleDateUTC,
								Reason,
								ImpactSchedulePlanner,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC,
								AcceptedBy,
								Signature 													
							
							)	OUTPUT INSERTED.WorkOrderReschedulingId INTO @Table
							SELECT 
							
							 CustomerId,
							 FacilityId,
							 ServiceId,	
							 WorkOrderId,
							 RescheduleApprovedBy,
							 RescheduleDate,
							 RescheduleDateUTC,
							 Reason,
							 ImpactSchedulePlanner,
							 UserId,
							 GETDATE(),
							 GETUTCDATE(),
							 UserId,
							 GETDATE(),
							 GETUTCDATE(),
							 AcceptedBy,
							 Signature 
						FROM @EngMwoReschedulingTxn WHERE ISNULL(WorkOrderReschedulingId,0) = 0
		SELECT	WorkOrderReschedulingId,
				[Timestamp]
		FROM	EngMwoReschedulingTxn
		WHERE	WorkOrderReschedulingId IN (SELECT ID FROM @Table)
		END

		UPDATE A SET TargetDateTime = RescheduleDate FROM EngMaintenanceWorkOrderTxn A INNER JOIN @EngMwoReschedulingTxn B ON A.WorkOrderId = B.WorkOrderId



	SELECT	WorkOrderReschedulingId,FacilityId,WorkOrderId,RescheduleDate,RescheduleApprovedBy
	INTO #TmpResInsert
	FROM EngMwoReschedulingTxn 
	WHERE WorkOrderReschedulingId IN (SELECT ID FROM @Table)

	


			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'EngMwoReschedulingTxn',
									A.ID,
									B.CreatedBy FROM @Table A INNER JOIN EngMwoReschedulingTxn B ON A.ID = B.WorkOrderReschedulingId


			INSERT INTO	FEAcknowledge(	ScreenName,
										Documentid,
										DocumentNo,
										Description,
										Userid,
										Remarks,
										Acknowledge,
										Signatureimage
										) OUTPUT INSERTED.AcknowledgeId INTO @TableAcknowledge
							SELECT	'Reschduling Work Order',
									B.WorkOrderReschedulingId,
									C.MaintenanceWorkNo,
									'The following work order - ' + C.MaintenanceWorkNo +' has been rescheduled to date - ' + CAST(B.RescheduleDate AS NVARCHAR(100)) AS RescheduleDate,
									B.CreatedBy,
									null,
									null,
									null	
			FROM @Table A	INNER JOIN EngMwoReschedulingTxn B ON A.ID = B.WorkOrderReschedulingId
			INNER JOIN EngMaintenanceWorkOrderTxn C ON C.WorkOrderId = B.WorkOrderId
				
							
			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'FEAcknowledge',
									ID,
									B.Userid
							FROM @TableAcknowledge A INNER JOIN FEAcknowledge B ON A.ID = B.AcknowledgeId

	
	


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

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_EngMwoReschedulingTxn_Mobile_Save]
--drop proc [uspFM_EngMwoReschedulingTxn_Mobile_Save_Backup]
--drop type udt_EngMwoReschedulingTxn_Mobile


--CREATE TYPE [dbo].[udt_EngMwoReschedulingTxn_Mobile] AS TABLE(
--	[WorkOrderReschedulingId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[RescheduleApprovedBy] [int] NULL,
--	[WorkOrderId] [int] NULL,
--	[RescheduleDate] [datetime] NULL,
--	[RescheduleDateUTC] [datetime] NULL,
--	[Reason] [int] NULL,
--	[ImpactSchedulePlanner] [bit] NULL,
--	[UserId] [int] NULL,
--	[AcceptedBy]  [int] NULL,
--	[Signature] [varbinary] (max) null
--)
--GO
GO
