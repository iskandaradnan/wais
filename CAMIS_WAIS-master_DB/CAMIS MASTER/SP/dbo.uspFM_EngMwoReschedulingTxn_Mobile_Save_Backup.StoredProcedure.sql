USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoReschedulingTxn_Mobile_Save_Backup]    Script Date: 20-09-2021 16:43:01 ******/
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
(0,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597',1,1,2),
(0,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597',1,1,2)
EXECUTE [uspFM_EngMwoReschedulingTxn_Mobile_Save] @EngMwoReschedulingTxn

select * from EngMwoReschedulingTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[uspFM_EngMwoReschedulingTxn_Mobile_Save_Backup]
	
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
							ModifiedDateUTC								=GETUTCDATE()
			FROM EngMwoReschedulingTxn 					AS MwoRescheduling
			INNER JOIN 		@EngMwoReschedulingTxn		AS MwoReschedulingType		ON	MwoRescheduling.WorkOrderReschedulingId = MwoReschedulingType.WorkOrderReschedulingId

	


	SELECT	IDENTITY(INT ,1,1) AS ID,*
	INTO #TmpRes
	FROM @EngMwoReschedulingTxn where ISNULL(WorkOrderReschedulingId,0)>0

	SELECT @mLoopLimit	=	COUNT(1) FROM #TmpRes
	
	WHILE (@mLoopStart<=@mLoopLimit)

	SET @mWorkOrderReschedulingId	= (SELECT TOP 1 WorkOrderReschedulingId FROM #TmpRes WHERE id=@mLoopStart)
	SET @mMaintenanceWorkNo			= (SELECT TOP 1 MaintenanceWorkNo FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId	in (SELECT TOP 1 WorkOrderId FROM #TmpRes WHERE id=@mLoopStart))
	SET @mRescheduleDate			= (SELECT TOP 1 RescheduleDate FROM  #TmpRes WHERE id=@mLoopStart)
	SET @mUserId					= (SELECT TOP 1 UserId FROM  #TmpRes WHERE id=@mLoopStart)

	BEGIN
		IF NOT EXISTS (SELECT 1 FROM QueueWebtoMobile WHERE TableName='EngMwoReschedulingTxn' AND Tableprimaryid=@mWorkOrderReschedulingId AND UserId=(SELECT COALESCE(@mUserId,@mUserId)))
		BEGIN
			--SELECT @mDateFmt = b.FieldValue	 
			--FROM	FMConfigCustomerValues a 
			--		INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
			--WHERE	A.KeyName='DATE'
			--		AND CustomerId in (SELECT CustomerId FROM @EngMwoReschedulingTxn)

			--IF (@mDateFmt='DD-MMM-YYYY')
			--	BEGIN
			--		SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')
			--	END
			--ELSE IF (@mDateFmt='DD/MMM/YYYY')
			--	BEGIN
			--		SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')
			--	END

			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'EngMwoReschedulingTxn',
									@mWorkOrderReschedulingId,
									COALESCE(@mUserId,@mUserId)


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
									@mWorkOrderReschedulingId,
									@mMaintenanceWorkNo,
									'The following work order - ' + @mMaintenanceWorkNo +' has been rescheduled to date - ' + @mRescheduleDate,
									COALESCE(@mUserId,@mUserId),
									null,
									null,
									null	
							
			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'FEAcknowledge',
									ID,
									COALESCE(@mUserId,@mUserId)
							FROM @TableAcknowledge

		END
	SET @mLoopStart	=	@mLoopStart+1
	END
			
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
								ModifiedDateUTC																
							
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
							 GETUTCDATE()
						FROM @EngMwoReschedulingTxn WHERE ISNULL(WorkOrderReschedulingId,0) = 0
		END

		UPDATE A SET TargetDateTime = RescheduleDate FROM EngMaintenanceWorkOrderTxn A INNER JOIN @EngMwoReschedulingTxn B ON A.WorkOrderId = B.WorkOrderId

		SELECT	WorkOrderReschedulingId,
				[Timestamp]
		FROM	EngMwoReschedulingTxn
		WHERE	WorkOrderReschedulingId IN (SELECT ID FROM @Table)

	SELECT	WorkOrderReschedulingId,FacilityId,WorkOrderId,RescheduleDate,RescheduleApprovedBy
	INTO #TmpResInsert
	FROM EngMwoReschedulingTxn 
	WHERE WorkOrderReschedulingId IN (SELECT ID FROM @Table)

	ALTER TABLE #TmpResInsert ADD ID INT 
	SELECT  ROW_NUMBER() OVER (ORDER BY WorkOrderReschedulingId) AS ID,WorkOrderReschedulingId INTO #ID FROM EngMwoReschedulingTxn WHERE WorkOrderReschedulingId IN (SELECT ID FROM @Table)
	
	UPDATE A SET A.ID=B.ID FROM #TmpResInsert A INNER JOIN #ID B ON A.WorkOrderReschedulingId=B.WorkOrderReschedulingId


	SELECT @mLoopLimit	=	COUNT(1) FROM #TmpResInsert

	WHILE (@mLoopStart<=@mLoopLimit)

	SET @mWorkOrderReschedulingId = (SELECT TOP 1 WorkOrderReschedulingId FROM #TmpResInsert WHERE id=@mLoopStart)
	SET @mMaintenanceWorkNo		= (SELECT TOP 1 MaintenanceWorkNo FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId	in (SELECT TOP 1 WorkOrderId FROM #TmpResInsert WHERE id=@mLoopStart))
	SET @mRescheduleDate		= (SELECT TOP 1 RescheduleDate FROM  #TmpResInsert WHERE id=@mLoopStart)

	BEGIN
		IF NOT EXISTS (SELECT 1 FROM QueueWebtoMobile WHERE TableName='EngMwoReschedulingTxn' AND Tableprimaryid=@mWorkOrderReschedulingId AND UserId=(SELECT COALESCE(@mUserId,@mUserId)))
		BEGIN
			--SELECT @mDateFmt = b.FieldValue	 
			--FROM	FMConfigCustomerValues a 
			--		INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
			--WHERE	A.KeyName='DATE'
			--		AND CustomerId in (SELECT CustomerId FROM @EngMwoReschedulingTxn)

			--IF (@mDateFmt='DD-MMM-YYYY')
			--	BEGIN
			--		SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')
			--	END
			--ELSE IF (@mDateFmt='DD/MMM/YYYY')
			--	BEGIN
			--		SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')
			--	END

			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'EngMwoReschedulingTxn',
									@mWorkOrderReschedulingId,
									COALESCE(@mUserId,@mUserId)


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
									@mWorkOrderReschedulingId,
									@mMaintenanceWorkNo,
									'The following work order - ' + @mMaintenanceWorkNo +' has been rescheduled to date - ' + @mRescheduleDate,
									COALESCE(@mUserId,@mUserId),
									null,
									null,
									null	
							
			INSERT INTO QueueWebtoMobile	(		TableName,
													Tableprimaryid,
													UserId
											)
							SELECT	'FEAcknowledge',
									ID,
									COALESCE(@mUserId,@mUserId)
							FROM @TableAcknowledge

		END
	SET @mLoopStart	=	@mLoopStart+1
	END
	


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
--drop type udt_EngMwoReschedulingTxn_Mobile


--CREATE TYPE [dbo].[udt_EngMwoReschedulingTxn_Mobile] AS TABLE
--(

--		WorkOrderReschedulingId					INT,
--		CustomerId								INT,
--		FacilityId								INT,
--		ServiceId								INT,
--		RescheduleApprovedBy					INT,		
--		WorkOrderId								INT,	
--		RescheduleDate							DATETIME,
--		RescheduleDateUTC						DATETIME,
--		Reason									INT,
--		ImpactSchedulePlanner					BIT,
--		UserId									INT


--)
GO
