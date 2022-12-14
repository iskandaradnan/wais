USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PorteringTransaction_Mobile_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PorteringTransaction_Mobile_Save
Description			: Portering Transaction save
Authors				: Dhilip V
Date				: 19-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
select * from PorteringTransaction order by PorteringId desc
declare @pPorteringTxn as udt_PorteringTransaction_Mobile
insert into @pPorteringTxn([PorteringId],[FromCustomerId],[FromFacilityId],[FromBlockId],[FromLevelId],[FromUserAreaId],[FromUserLocationId],[RequestorId],
[RequestTypeLovId],[MovementCategory],[SubCategory],[ModeOfTransport],[ToCustomerId],[ToFacilityId],[ToBlockId],[ToLevelId],[ToUserAreaId],[ToUserLocationId],[AssignPorterId],[ConsignmentNo],[PorteringStatus],[ReceivedBy],[CurrentWorkFlowId],[Remarks],
[AssetId],[PorteringDate],[PorteringNo],[WorkOrderId],[SupplierLovId],[SupplierId],[ScanAsset],[ConsignmentDate],[CourierName],
[WFStatusApprovedDate],[UserId]) values
(0,1,1,1,1,1,1,1,243,239,null,218,1,2,1,1,1,1,null,'211665',250,null,247,'dfhj',75,getdate(),'',null,null,null,null,'2018-06-27 00:00:00.000','st',null,2),
(0,1,1,1,1,1,1,1,243,239,null,218,1,2,1,1,1,1,null,'211665',250,null,247,'dfhj',75,getdate(),'',null,null,null,null,'2018-06-27 00:00:00.000','ST',null,2)

EXECUTE [uspFM_PorteringTransaction_Mobile_Save] @pPorteringTxn

declare @pPorteringTxn as udt_PorteringTransaction_Mobile
insert into @pPorteringTxn([PorteringId],[FromCustomerId],[FromFacilityId],[FromBlockId],[FromLevelId],[FromUserAreaId],[FromUserLocationId],[RequestorId],
[RequestTypeLovId],[MovementCategory],[SubCategory],[ModeOfTransport],[ToCustomerId],[ToFacilityId],[ToBlockId],[ToLevelId],[ToUserAreaId],[ToUserLocationId],[AssignPorterId],[ConsignmentNo],[PorteringStatus],[ReceivedBy],[CurrentWorkFlowId],[Remarks],
[AssetId],[PorteringDate],[PorteringNo],[WorkOrderId],[SupplierLovId],[SupplierId],[ScanAsset],[ConsignmentDate],[CourierName],
[WFStatusApprovedDate],[UserId]) values
(55,1,1,1,1,1,1,1,243,239,null,218,1,2,1,1,1,1,null,'211665',250,null,247,'dfhj',75,getdate(),'',null,null,null,null,'2018-06-27 00:00:00.000','st',null,2),
(54,1,1,1,1,1,1,1,243,239,null,218,1,2,1,1,1,1,null,'211665',250,null,247,'dfhj',75,getdate(),'',null,null,null,null,'2018-06-27 00:00:00.000','ST',null,2)

EXECUTE [uspFM_PorteringTransaction_Mobile_Save] @pPorteringTxn

select getdate()
SELECT * FROM PorteringTransaction
SELECT * FROM CRMRequestWorkOrderTxn

DELETE FROM PorteringTransaction WHERE PorteringNo=''

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_PorteringTransaction_Mobile_Save]
		
		@pPorteringTxn	 udt_PorteringTransaction_Mobile READONLY,
		@pUserId int	=	NULL

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

	DECLARE @mLoopStart INT =0, @mLoopLimit INT
	DECLARE @pOutParam NVARCHAR(50) 
	DECLARE @MaintenanceWorkCategory INT 
	DECLARE @mMonth INT,@mYear INT
	DECLARE @MPorteringDate DATETIME
	DECLARE @pPorteringNo NVARCHAR(100)

	DECLARE @pCustomerId INT
	DECLARE @pFacilityId INT

SELECT * INTO #TEMPResultWo FROM @pPorteringTxn WHERE (PorteringNo IS NULL OR PorteringNo = '')  AND (PorteringId=0 OR PorteringId IS NULL)

ALTER TABLE #TEMPResultWo ADD Portid INT IDENTITY(1,1) NOT NULL


	SET  @mLoopStart = (SELECT MIN(Portid) FROM #TEMPResultWo)
	SET  @mLoopLimit = (SELECT MAX(Portid) FROM #TEMPResultWo)
	SELECT @mLoopLimit	=	COUNT(1) FROM #TEMPResultWo
	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN
	SET @MPorteringDate = (SELECT PorteringDate FROM #TEMPResultWo WHERE Portid = @mLoopStart)
	SET @pCustomerId = (SELECT FromCustomerId FROM #TEMPResultWo WHERE Portid = @mLoopStart)
	SET @pFacilityId = (SELECT FromFacilityId FROM #TEMPResultWo WHERE Portid = @mLoopStart)
	SET @mMonth		 =	MONTH(@MPorteringDate)
	SET @mYear		 =	YEAR(@MPorteringDate)
	EXEC [uspFM_GenerateDocumentNumber] @pFlag='PorteringTransaction',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='AT',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @pPorteringNo=@pOutParam
	UPDATE #TEMPResultWo SET PorteringNo	= @pPorteringNo WHERE Portid	=	@mLoopStart
	SET @mLoopStart	=	@mLoopStart+1
	END
		
		
		
		--UPDATE  A SET A.PorteringNo = B.PorteringNo FROM @pPorteringTxn A INNER JOIN #TEMPResultWo B ON A.PorteringId = B.PorteringId
	
	


--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.FMLovMst

IF EXISTS (SELECT 1 FROM #TEMPResultWo)
BEGIN

declare @mAssignPorterId  int

select @mAssignPorterId = companystaffid		FROM #TEMPResultWo a  join  engasset b on a.assetid=b.assetid where ISNULL(PorteringId,0)=0
and   a.MovementCategory =239


			INSERT INTO PorteringTransaction
						(	
							FromCustomerId,
							FromFacilityId,
							FromBlockId,
							FromLevelId,
							FromUserAreaId,
							FromUserLocationId,
							RequestorId,						
							RequestTypeLovId,
							MovementCategory,
							SubCategory,
							ModeOfTransport,
							ToCustomerId,
							ToFacilityId,
							ToBlockId,
							ToLevelId,
							ToUserAreaId,
							ToUserLocationId,
							AssignPorterId,
							ConsignmentNo,
							PorteringStatus,
							ReceivedBy,
							CurrentWorkFlowId,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							AssetId,
							PorteringDate,
							PorteringNo,
                            WorkOrderId,
                            SupplierLovId,
                            SupplierId,
                            ScanAsset,
                            ConsignmentDate,
                            CourierName,
							WFStatusApprovedDate,
							MaintenanceWorkNo,
							MobileGuid,
							AssigneeLovId

                        
						)	OUTPUT INSERTED.PorteringId INTO @Table
	SELECT					FromCustomerId,
							FromFacilityId,
							FromBlockId,
							FromLevelId,
							FromUserAreaId,
							FromUserLocationId,
							RequestorId,						
							RequestTypeLovId,
							MovementCategory,
							SubCategory,
							ModeOfTransport,
							ToCustomerId,
							ToFacilityId,
							ToBlockId,
							ToLevelId,
							ToUserAreaId,
							ToUserLocationId,
							isnull(@mAssignPorterId,AssignPorterId),
							ConsignmentNo,
							case when @mAssignPorterId  is not null then 250 else PorteringStatus end ,
							ReceivedBy,
							CurrentWorkFlowId,
							Remarks,
							UserId,
							GETDATE(),
							GETUTCDATE(),
							UserId,
							GETDATE(),
							GETUTCDATE(),
							AssetId,
							PorteringDate,
							PorteringNo,
                            WorkOrderId,
                            SupplierLovId,
                            SupplierId,
                            ScanAsset,
                            ConsignmentDate,
                            CourierName,
							WFStatusApprovedDate,
							MaintenanceWorkNo,
							MobileGuid,
							case when @mAssignPorterId  is not null then 332  else null end
					FROM #TEMPResultWo where ISNULL(PorteringId,0)=0
								
			SELECT	PorteringId,
					[Timestamp],
					'' AS	ErrorMessage,
					PorteringNo
			FROM	PorteringTransaction
			WHERE	PorteringId IN (SELECT ID FROM @Table)

			
			declare @pPorteringId  int

			select @pPorteringId = id  from @Table


if  @mAssignPorterId  is not null 

BEgin

			DECLARE @PPrimaryKey INT
			SELECT @PPrimaryKey =  ID FROM @Table
			DECLARE @Table1 TABLE (ID INT)	

				

	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)


				Insert FEUserAssigned (Userid) values(@mAssignPorterId )
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
								) OUTPUT INSERTED.NotificationId INTO @Table1
					SELECT	@mAssignPorterId,
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

	SET @PrimaryKeyId = (SELECT top 1 ID FROM @Table1)

	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									VALUES
									(
											'FENotification',
											@PrimaryKeyId,
											@mAssignPorterId
									)
	
	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									VALUES
									(
											'PorteringTransaction',
											@pPorteringId,
											@mAssignPorterId
									)
	

	



END

			--IF(@pCurrentWorkFlowId IS NOT NULL) 
			--BEGIN
			--IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @PPrimaryKey AND WorkFlowStatusId = @pCurrentWorkFlowId)
			--BEGIN
			--INSERT INTO PorteringTransactionHistory (PorteringId,WorkFlowStatusId,WFDoneBy,WFDoneByDate,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			--VALUES (@PPrimaryKey,@pCurrentWorkFlowId,@pUserId,GETDATE(),@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())

			--END
			--END
			--IF(@pPorteringStatus IS NOT NULL AND @pCurrentWorkFlowId IS NOT NULL) 
			--BEGIN
			--IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @PPrimaryKey AND PorteringStatusLovId = @pPorteringStatus AND WorkFlowStatusId = @pCurrentWorkFlowId)
			--BEGIN
			--INSERT INTO PorteringTransactionHistory (PorteringId,PorteringStatusLovId,PorteringStatusDoneBy,PorteringStatusDoneByDate,IsMoment,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			--VALUES (@PPrimaryKey,@pPorteringStatus,@pUserId,GETDATE(),1,@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())
			--END
			--END
END



------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------
		
			IF EXISTS (SELECT 1 FROM @pPorteringTxn WHERE PorteringId >0)


BEGIN
					UPDATE  PorteringTran	SET		
							--PorteringTran.FromCustomerId				=  PorteringType.FromCustomerId,
							--PorteringTran.FromFacilityId				=  PorteringType.FromFacilityId,
							--PorteringTran.FromBlockId					=  PorteringType.FromBlockId,
							--PorteringTran.FromLevelId					=  PorteringType.FromLevelId,
							--PorteringTran.FromUserAreaId				=  PorteringType.FromUserAreaId,
							--PorteringTran.FromUserLocationId			=  PorteringType.FromUserLocationId,
							--PorteringTran.RequestorId					=  PorteringType.RequestorId,
							--PorteringTran.RequestTypeLovId				=  PorteringType.RequestTypeLovId,
							--PorteringTran.MovementCategory				=  PorteringType.MovementCategory,
							--PorteringTran.SubCategory					=  PorteringType.SubCategory,
							--PorteringTran.ModeOfTransport				=  PorteringType.ModeOfTransport,
							--PorteringTran.ToCustomerId					=  PorteringType.ToCustomerId,
							--PorteringTran.ToFacilityId					=  PorteringType.ToFacilityId,
							--PorteringTran.ToBlockId						=  PorteringType.ToBlockId,
							--PorteringTran.ToLevelId						=  PorteringType.ToLevelId,
							--PorteringTran.ToUserAreaId					=  PorteringType.ToUserAreaId,
							--PorteringTran.ToUserLocationId				=  PorteringType.ToUserLocationId,
							--PorteringTran.AssignPorterId				=  PorteringType.AssignPorterId,
							--PorteringTran.ConsignmentNo					=  PorteringType.ConsignmentNo,
							PorteringTran.PorteringStatus				=  PorteringType.PorteringStatus,
							PorteringTran.ReceivedBy					=  PorteringType.ReceivedBy,
							--PorteringTran.CurrentWorkFlowId				=  PorteringType.CurrentWorkFlowId,
							PorteringTran.Remarks						=  PorteringType.Remarks,
							SignImage									=	PorteringType.SignImage
							--PorteringTran.ModifiedBy					=  PorteringType.UserId,
							--PorteringTran.ModifiedDate					=  GETDATE(),
							--PorteringTran.ModifiedDateUTC				=  GETUTCDATE(),
							--PorteringTran.AssetId						=  PorteringType.AssetId,
							--PorteringTran.PorteringDate					=  PorteringType.PorteringDate,
							--PorteringTran.PorteringNo					=  PorteringType.PorteringNo,
							--PorteringTran.WorkOrderId					=  PorteringType.WorkOrderId,
							--PorteringTran.SupplierLovId					=  PorteringType.SupplierLovId,
							--PorteringTran.SupplierId					=  PorteringType.SupplierId,
							--PorteringTran.ScanAsset						=  PorteringType.ScanAsset,
							--PorteringTran.ConsignmentDate				=  PorteringType.ConsignmentDate,
							--PorteringTran.CourierName					=  PorteringType.CourierName,
							--PorteringTran.WFStatusApprovedDate			=  PorteringType.WFStatusApprovedDate,
							--PorteringTran.MobileGuid					=  PorteringType.MobileGuid

							OUTPUT INSERTED.PorteringId INTO @Table
				FROM	PorteringTransaction						AS PorteringTran
				INNER JOIN @pPorteringTxn							AS PorteringType		ON PorteringTran.PorteringId = PorteringType.PorteringId
				WHERE  ISNULL(PorteringType.PorteringId,0)>0

---  Clearnig UserId from Assigned table
DECLARE @PorteringId int
DECLARE @PorteringStatus int
DECLARE @AssingedUserId int
SET @PorteringId  = (select 1 PorteringId from @pPorteringTxn)
SELECT @PorteringStatus= PorteringStatus,@AssingedUserId= AssignPorterId from PorteringTransaction WHERE PorteringId = @PorteringId

IF (@PorteringStatus IN (363))
BEGIN
	DELETE FEUserAssigned where Userid=@AssingedUserId
END
---  Clearnig UserId from Assigned table - END
				INSERT	INTO QueueWebtoMobile (
								TableName, 
								Tableprimaryid, 
								UserId)  
						VALUES(	'PorteringTransaction', 
								(SELECT PorteringId FROM @pPorteringTxn), 
								(SELECT RequestorId FROM PorteringTransaction WHERE PorteringId =(SELECT PorteringId FROM @pPorteringTxn)))

				INSERT	INTO QueueWebtoMobile (
								TableName, 
								Tableprimaryid, 
								UserId)  
						VALUES(	'PorteringTransaction', 
								(SELECT PorteringId FROM @pPorteringTxn), 
								(SELECT AssignPorterId FROM PorteringTransaction WHERE PorteringId =(SELECT PorteringId FROM @pPorteringTxn)))

END


				SELECT	PorteringId,
					[Timestamp],
					'' AS	ErrorMessage,
					PorteringNo
			FROM	PorteringTransaction
			WHERE	PorteringId IN (SELECT ID FROM @Table)

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



-----------------------------------------------------------------------------------------------------------------------------------------------------------------

--DROP PROC [uspFM_PorteringTransaction_Mobile_Save]

--DROP TYPE [udt_PorteringTransaction_Mobile]



--CREATE TYPE [dbo].[udt_PorteringTransaction_Mobile] AS TABLE(
--	[PorteringId] [int] NULL,
--	[FromCustomerId] [int] NOT NULL,
--	[FromFacilityId] [int] NOT NULL,
--	[FromBlockId] [int] NOT NULL,
--	[FromLevelId] [int] NOT NULL,
--	[FromUserAreaId] [int] NOT NULL,
--	[FromUserLocationId] [int] NOT NULL,
--	[RequestorId] [int] NULL,
--	[RequestTypeLovId] [int] NULL,
--	[MovementCategory] [int] NULL,
--	[SubCategory] [int] NULL,
--	[ModeOfTransport] [int] NOT NULL,
--	[ToCustomerId] [int] NULL,
--	[ToFacilityId] [int] NULL,
--	[ToBlockId] [int] NULL,
--	[ToLevelId] [int] NULL,
--	[ToUserAreaId] [int] NULL,
--	[ToUserLocationId] [int] NULL,
--	[AssignPorterId] [int] NULL,
--	[ConsignmentNo] [nvarchar](250) NULL,
--	[PorteringStatus] [int] NULL,
--	[ReceivedBy] [int] NULL,
--	[CurrentWorkFlowId] [int] NULL,
--	[Remarks] [nvarchar](500) NULL,
--	[AssetId] [int] NULL,
--	[PorteringDate] [datetime] NULL,
--	[PorteringNo] [nvarchar](50) NULL,
--	[WorkOrderId] [int] NULL,
--	[SupplierLovId] [int] NULL,
--	[SupplierId] [int] NULL,
--	[ScanAsset] [nvarchar](100) NULL,
--	[ConsignmentDate] [datetime] NULL,
--	[CourierName] [nvarchar](200) NULL,
--	[WFStatusApprovedDate] [datetime] NULL,
--	[UserId] [int] NULL,
--	[MaintenanceWorkNo] [nvarchar](500) NULL,
--	[MobileGuid] nvarchar(max)
--)
--GO
GO
