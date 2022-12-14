USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoCompletionInfoTxn_Mobile_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoCompletionInfoTxn_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngMwoCompletionInfoTxn_Mobile			[dbo].[udt_EngMwoCompletionInfoTxn_Mobile]
DECLARE @EngMwoCompletionInfoTxnDet_Mobile		[dbo].[udt_EngMwoCompletionInfoTxnDet_Mobile]
insert into @EngMwoCompletionInfoTxn_Mobile([CompletionInfoId],[CustomerId],[FacilityId],[ServiceId],[WorkOrderId],[RepairDetails],[PPMAgreedDate],[PPMAgreedDateUTC],[StartDateTime],
[StartDateTimeUTC],[EndDateTime],[EndDateTimeUTC],[HandoverDateTime],[HandoverDateTimeUTC],[CompletedBy],[AcceptedBy],[Signature],
[ServiceAvailability],[LoanerProvision],[HandoverDelay],[DowntimeHoursMin],[CauseCode],[QCCode],[ResourceType],[LabourCost],[PartsCost],
[ContractorCost],[TotalCost],[ContractorId],[ContractorHours],[PartsRequired],[Approved],[AppType],[RepairHours],[ProcessStatus],
[ProcessStatusDate],[ProcessStatusReason],[UserId],[IsSubmitted],RunningHours)values
(0,1,1,2,25,'sdfsgg','2018-07-09 10:36:36.397','2018-07-09 10:36:36.397','2018-07-09 10:36:36.397','2018-07-09 10:36:36.397','2018-07-09 10:36:36.397','2018-07-09 10:36:36.397','2018-07-09 10:36:36.397'
,'2018-07-09 10:36:36.397',1,1,'saegeg',0,0,1,45,56,56,48,100,200,500,800,1,12,1,1,1,1,1,'2018-07-09 10:36:36.397',1,2,0,0)
INSERT INTO @EngMwoCompletionInfoTxnDet_Mobile (CompletionInfoDetId,CustomerId,FacilityId,ServiceId,StaffMasterId,StandardTaskDetId,StartDateTime,StartDateTimeUTC,EndDateTime,EndDateTimeUTC,UserId,WorkOrderId) values
(0,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597','2018-05-16 13:07:49.597','2018-05-17 13:07:49.597',2,25)

EXECUTE [uspFM_EngMwoCompletionInfoTxn_Mobile_Save] @EngMwoCompletionInfoTxn_Mobile,@EngMwoCompletionInfoTxnDet_Mobile,@pTimestamp=NULL

select * from EngMwoCompletionInfoTxn
select * from EngMwoCompletionInfoTxnDet
select getdate()

DROP PROC [uspFM_EngMwoCompletionInfoTxn_Mobile_Save]
DROP TYPE [udt_EngMwoCompletionInfoTxn_Mobile]
DROP TYPE [udt_EngMwoCompletionInfoTxnDet_Mobile]
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMwoCompletionInfoTxn_Mobile_Save]
		
		@EngMwoCompletionInfoTxn_Mobile		[dbo].[udt_EngMwoCompletionInfoTxn_Mobile]   READONLY,
		@EngMwoCompletionInfoTxnDet_Mobile		[dbo].[udt_EngMwoCompletionInfoTxnDet_Mobile]   READONLY,
		@pTimestamp					varbinary(200) = null
		
		
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
	DECLARE @Table1 TABLE (ID INT)	




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoCompletionInfoTxn

			IF EXISTS (SELECT 1 FROM @EngMwoCompletionInfoTxn_Mobile WHERE CompletionInfoId is NULL OR CompletionInfoId =0 )

BEGIN
	
			INSERT INTO EngMwoCompletionInfoTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							WorkOrderId,
							RepairDetails,
							PPMAgreedDate,
							PPMAgreedDateUTC,
							StartDateTime,
							StartDateTimeUTC,
							EndDateTime,
							EndDateTimeUTC,
							HandoverDateTime,
							HandoverDateTimeUTC,
							CompletedBy,
							AcceptedBy,
							[Signature],
							ServiceAvailability,
							LoanerProvision,
							HandoverDelay,
							DowntimeHoursMin,
							CauseCode,
							QCCode,
							ResourceType,
							LabourCost,
							PartsCost,
							ContractorCost,
							TotalCost,
							ContractorId,
							ContractorHours,
							PartsRequired,
							Approved,
							AppType,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							RepairHours,
							ProcessStatus,
							ProcessStatusDate,
							ProcessStatusReason,
							RunningHours,
							VendorCost,
							MobileGuid,
							DowntimeHours,
							WOSignature,
							CustomerFeedback
						)	OUTPUT INSERTED.CompletionInfoId INTO @Table							

			SELECT			
							
							CustomerId,
							FacilityId,
							ServiceId,
							WorkOrderId,
							RepairDetails,
							PPMAgreedDate,
							PPMAgreedDateUTC,
							StartDateTime,
							StartDateTimeUTC,
							EndDateTime,
							EndDateTimeUTC,
							HandoverDateTime,
							HandoverDateTimeUTC,
							CompletedBy,
							AcceptedBy,
							Signature,
							ServiceAvailability,
							LoanerProvision,
							HandoverDelay,
							DowntimeHoursMin,
							CauseCode,
							QCCode,
							ResourceType,
							LabourCost,
							PartsCost,
							ContractorCost,
							(ISNULL(LabourCost,0)+ISNULL(PartsCost,0)+ISNULL(ContractorCost,0)),
							ContractorId,
							ContractorHours,
							PartsRequired,
							Approved,
							AppType,
							UserId,			
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE(),
							(cast((DATEDIFF(MINUTE, StartDateTime, EndDateTime)) as numeric(24,2))/60),
							ProcessStatus,
							ProcessStatusDate,
							ProcessStatusReason,
							RunningHours,
							VendorCost,
							MobileGuid,
							DownTimeHours,
							WOSignature,
							CustomerFeedback
			FROM @EngMwoCompletionInfoTxn_Mobile WHERE CompletionInfoId is NULL OR CompletionInfoId =0

			--SELECT	CompletionInfoId,WorkOrderId,
			--		[Timestamp],
			--		'' as ErrorMessage
			--FROM	EngMwoCompletionInfoTxn
			--WHERE	CompletionInfoId IN (SELECT ID FROM @Table)

			INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
			SELECT 'WorkOrderStatus',c.WorkOrderId,c.CreatedBy FROM @Table A INNER JOIN EngMwoCompletionInfoTxn B ON A.ID = B.CompletionInfoId
			inner join EngMaintenanceWorkOrderTxn c on c.WorkOrderId = b.WorkOrderId

			UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 194 WHERE WorkOrderId  IN (SELECT WorkOrderId FROM @EngMwoCompletionInfoTxn_Mobile WHERE CompletionInfoId is NULL OR CompletionInfoId =0)

			INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			SELECT A.CustomerId,A.FacilityId,A.ServiceId,A.WorkOrderId,A.WorkOrderStatus,B.UserId,GETDATE(),GETUTCDATE(),B.UserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn A 
			INNER JOIN @EngMwoCompletionInfoTxn_Mobile B ON A.WorkOrderId = B.WorkOrderId WHERE A.WorkOrderId IN (SELECT WorkOrderId FROM @EngMwoCompletionInfoTxn_Mobile WHERE CompletionInfoId is NULL OR CompletionInfoId =0)


		INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
		 select 'WorkOrderStatus',TransferTable.WorkOrderId,WorkOrderTable.AssignedUserId    
		 from EngMWOHandOverHistoryTxn as WorkOrderTable
		 inner join @EngMwoCompletionInfoTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId
		 where ISNULL(TransferTable.WorkOrderId,0)>0
END
			--SET @PrimaryKeyId  = (SELECT ID FROM @Table)



--2.EngMwoCompletionInfoTxnDet
			IF EXISTS (SELECT 1 FROM @EngMwoCompletionInfoTxnDet_Mobile WHERE CompletionInfoDetId is NULL OR CompletionInfoDetId =0 )

BEGIN			

	
			INSERT INTO EngMwoCompletionInfoTxnDet
						(
							CustomerId,
							FacilityId,
							ServiceId,
							CompletionInfoId,
							UserId,
							StandardTaskDetId,
							StartDateTime,
							StartDateTimeUTC,
							EndDateTime,
							EndDateTimeUTC,
							RepairHours,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							MobileGuid
							
						)OUTPUT INSERTED.CompletionInfodetId INTO @Table1	

			SELECT			
							T.CustomerId,
							T.FacilityId,			
							T.ServiceId,			
							B.CompletionInfoId,
							T.StaffMasterId,		
							T.StandardTaskDetId,	
							T.StartDateTime,		
							T.StartDateTimeUTC,
							T.EndDateTime,			
							T.EndDateTimeUTC,
							(cast((DATEDIFF(MINUTE, T.StartDateTime, T.EndDateTime)) as numeric(24,2))/60),			
							T.UserId,				
							GETDATE(),			
							GETUTCDATE(),
							T.UserId,			
							GETDATE(),			
							GETUTCDATE(),
							T.MobileGuid
			FROM	@EngMwoCompletionInfoTxnDet_Mobile T INNER JOIN EngMwoCompletionInfoTxn B ON T.MobileGuid = b.MobileGuid
			WHERE   ISNULL(CompletionInfoDetId,0)=0


				SELECT	CompletionInfoDetId,CompletionInfoId,
					[Timestamp],
					'' as ErrorMessage
			FROM	EngMwoCompletionInfoTxnDet
			WHERE	CompletionInfoDetId IN (SELECT ID FROM @Table1)

			
		     

END

IF EXISTS (SELECT 1 FROM @EngMwoCompletionInfoTxn_Mobile WHERE CompletionInfoId >0)
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN

			

	    UPDATE  MwoCompletionInfo	SET		
							MwoCompletionInfo.CustomerId					= MwoCompletionInfoType.CustomerId,
							MwoCompletionInfo.FacilityId					= MwoCompletionInfoType.FacilityId,
							MwoCompletionInfo.ServiceId						= MwoCompletionInfoType.ServiceId,
							MwoCompletionInfo.WorkOrderId					= MwoCompletionInfoType.WorkOrderId,
							MwoCompletionInfo.RepairDetails					= MwoCompletionInfoType.RepairDetails,
							MwoCompletionInfo.PPMAgreedDate					= MwoCompletionInfoType.PPMAgreedDate,
							MwoCompletionInfo.PPMAgreedDateUTC				= MwoCompletionInfoType.PPMAgreedDateUTC,
							MwoCompletionInfo.StartDateTime					= MwoCompletionInfoType.StartDateTime,
							MwoCompletionInfo.StartDateTimeUTC				= MwoCompletionInfoType.StartDateTimeUTC,
							MwoCompletionInfo.EndDateTime					= MwoCompletionInfoType.EndDateTime,
							MwoCompletionInfo.EndDateTimeUTC				= MwoCompletionInfoType.EndDateTimeUTC,
							MwoCompletionInfo.HandoverDateTime				= MwoCompletionInfoType.HandoverDateTime,
							MwoCompletionInfo.HandoverDateTimeUTC			= MwoCompletionInfoType.HandoverDateTimeUTC,
							MwoCompletionInfo.CompletedBy					= MwoCompletionInfoType.CompletedBy,
							MwoCompletionInfo.AcceptedBy					= MwoCompletionInfoType.AcceptedBy,
							MwoCompletionInfo.[Signature]					= MwoCompletionInfoType.Signature,
							MwoCompletionInfo.ServiceAvailability			= MwoCompletionInfoType.ServiceAvailability,
							MwoCompletionInfo.LoanerProvision				= MwoCompletionInfoType.LoanerProvision,
							MwoCompletionInfo.HandoverDelay					= MwoCompletionInfoType.HandoverDelay,
							MwoCompletionInfo.DowntimeHoursMin				= MwoCompletionInfoType.DowntimeHoursMin,
							MwoCompletionInfo.CauseCode						= MwoCompletionInfoType.CauseCode,
							MwoCompletionInfo.QCCode						= MwoCompletionInfoType.QCCode,
							MwoCompletionInfo.ResourceType					= MwoCompletionInfoType.ResourceType,
							MwoCompletionInfo.LabourCost					= MwoCompletionInfoType.LabourCost,
							MwoCompletionInfo.PartsCost						= MwoCompletionInfoType.PartsCost,
							MwoCompletionInfo.ContractorCost				= MwoCompletionInfoType.ContractorCost,
							MwoCompletionInfo.TotalCost						= (ISNULL(MwoCompletionInfoType.LabourCost,0)+ISNULL(MwoCompletionInfoType.PartsCost,0)+ISNULL(MwoCompletionInfoType.ContractorCost,0)),
							MwoCompletionInfo.ContractorId					= MwoCompletionInfoType.ContractorId,
							MwoCompletionInfo.ContractorHours				= MwoCompletionInfoType.ContractorHours,
							MwoCompletionInfo.PartsRequired					= MwoCompletionInfoType.PartsRequired,
							MwoCompletionInfo.Approved						= MwoCompletionInfoType.Approved,
							MwoCompletionInfo.AppType						= MwoCompletionInfoType.AppType,
							MwoCompletionInfo.ModifiedBy					= MwoCompletionInfoType.UserId,
							MwoCompletionInfo.ModifiedDate					= GETDATE(),
							MwoCompletionInfo.ModifiedDateUTC				= GETUTCDATE(),
							MwoCompletionInfo.RepairHours					= (cast((DATEDIFF(MINUTE, MwoCompletionInfoType.StartDateTime, MwoCompletionInfoType.EndDateTime)) as numeric(24,2))/60),
							MwoCompletionInfo.ProcessStatus					= MwoCompletionInfoType.ProcessStatus,
							MwoCompletionInfo.ProcessStatusDate				= MwoCompletionInfoType.ProcessStatusDate,
							MwoCompletionInfo.ProcessStatusReason			= MwoCompletionInfoType.ProcessStatusReason,
							MwoCompletionInfo.RunningHours					= MwoCompletionInfoType.RunningHours,
							MwoCompletionInfo.VendorCost					= MwoCompletionInfoType.VendorCost,
							MwoCompletionInfo.MobileGuid					= MwoCompletionInfoType.MobileGuid,
							MwoCompletionInfo.DowntimeHours					= MwoCompletionInfoType.DowntimeHours,
							MwoCompletionInfo.WOSignature					= MwoCompletionInfoType.WOSignature,
							MwoCompletionInfo.CustomerFeedback				= MwoCompletionInfoType.CustomerFeedback
							OUTPUT INSERTED.CompletionInfoId INTO @Table
				FROM	EngMwoCompletionInfoTxn						AS MwoCompletionInfo
				INNER JOIN @EngMwoCompletionInfoTxn_Mobile			AS MwoCompletionInfoType on MwoCompletionInfo.CompletionInfoId	= MwoCompletionInfoType.CompletionInfoId
				WHERE	ISNULL(MwoCompletionInfoType.CompletionInfoId,0)>0

			INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
		 select 'WorkOrderStatus',TransferTable.WorkOrderId,WorkOrderTable.AssignedUserId    
		 from EngMWOHandOverHistoryTxn as WorkOrderTable
		 inner join @EngMwoCompletionInfoTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId
		 where ISNULL(TransferTable.WorkOrderId,0)>0

			SELECT	CompletionInfoId,WorkOrderId,
					[Timestamp],
					'' as ErrorMessage
			FROM	EngMwoCompletionInfoTxn
			WHERE	CompletionInfoId IN (SELECT ID FROM @Table1)
	
	
	 IF EXISTS( SELECT 1 FROM @EngMwoCompletionInfoTxn_Mobile WHERE IsSubmitted =1)
	 BEGIN
	 UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 195 WHERE WorkOrderId in	(select WorkOrderId from @EngMwoCompletionInfoTxn_Mobile)
	 END

END

IF EXISTS (SELECT 1 FROM @EngMwoCompletionInfoTxnDet_Mobile WHERE CompletionInfoDetId >0)
BEGIN
				--2.EngStockUpdateRegisterTxnDet UPDATE

	    UPDATE  MwoCompletionInfoDet	SET												   	
									
									MwoCompletionInfoDet.CustomerId					=   MwoCompletionInfoudt.CustomerId,			
									MwoCompletionInfoDet.FacilityId					=   MwoCompletionInfoudt.FacilityId,			
									MwoCompletionInfoDet.ServiceId					=   MwoCompletionInfoudt.ServiceId,				
									MwoCompletionInfoDet.UserId						=   MwoCompletionInfoudt.StaffMasterId,	
									MwoCompletionInfoDet.StandardTaskDetId			=   MwoCompletionInfoudt.StandardTaskDetId,
									MwoCompletionInfoDet.StartDateTime				=   MwoCompletionInfoudt.StartDateTime,	
									MwoCompletionInfoDet.StartDateTimeUTC			=   MwoCompletionInfoudt.StartDateTimeUTC,
									MwoCompletionInfoDet.EndDateTime				=   MwoCompletionInfoudt.EndDateTime,
									MwoCompletionInfoDet.EndDateTimeUTC				=   MwoCompletionInfoudt.EndDateTimeUTC,
									MwoCompletionInfoDet.RepairHours				=   (cast((DATEDIFF(MINUTE, MwoCompletionInfoudt.StartDateTime, MwoCompletionInfoudt.EndDateTime)) as numeric(24,2))/60),	
									MwoCompletionInfoDet.ModifiedBy					=   MwoCompletionInfoudt.UserId,			
									MwoCompletionInfoDet.ModifiedDate				=   GETDATE(),
									MwoCompletionInfoDet.ModifiedDateUTC			=   GETUTCDATE(),
									MwoCompletionInfoDet.MobileGuid					=   MwoCompletionInfoudt.MobileGuid

		FROM	EngMwoCompletionInfoTxnDet								AS MwoCompletionInfoDet 
				INNER JOIN @EngMwoCompletionInfoTxnDet_Mobile			AS MwoCompletionInfoudt on MwoCompletionInfoDet.CompletionInfoDetId=MwoCompletionInfoudt.CompletionInfoDetId
		WHERE	ISNULL(MwoCompletionInfoudt.CompletionInfoDetId,0)>0
		  


END

---  Clearnig UserId from Assigned table

--DECLARE @workOrderid int
--DECLARE @WorkOrderStatus int
--DECLARE @AssingedUserId int

--SET @workOrderid  = (select 1 WorkOrderId from @EngMwoCompletionInfoTxn_Mobile)
--SELECT @WorkOrderStatus= WorkOrderStatus,@AssingedUserId= AssignedUserId from EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @workOrderid

--IF (@WorkOrderStatus IN (194,195))
--BEGIN
--	DELETE FEUserAssigned where Userid=@AssingedUserId
--END

---  Clearnig UserId from Assigned table - END


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

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_EngMwoCompletionInfoTxn_Mobile_Save]
--drop type [udt_EngMwoCompletionInfoTxn_Mobile]
--drop type [udt_EngMwoCompletionInfoTxndET_Mobile]



--CREATE TYPE [dbo].[udt_EngMwoCompletionInfoTxn_Mobile] AS TABLE(
--	[CompletionInfoId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[WorkOrderId] [int] NULL,
--	[RepairDetails] [nvarchar](1000) NULL,
--	[PPMAgreedDate] [datetime] NULL,
--	[PPMAgreedDateUTC] [datetime] NULL,
--	[StartDateTime] [datetime] NULL,
--	[StartDateTimeUTC] [datetime] NULL,
--	[EndDateTime] [datetime] NULL,
--	[EndDateTimeUTC] [datetime] NULL,
--	[HandoverDateTime] [datetime] NULL,
--	[HandoverDateTimeUTC] [datetime] NULL,
--	[CompletedBy] [int] NULL,
--	[AcceptedBy] [int] NULL,
--	[Signature] [nvarchar](1000) NULL,
--	[ServiceAvailability] [bit] NULL,
--	[LoanerProvision] [bit] NULL,
--	[HandoverDelay] [int] NULL,
--	[DowntimeHoursMin] [numeric](24, 2) NULL,
--	[CauseCode] [int] NULL,
--	[QCCode] [int] NULL,
--	[ResourceType] [int] NULL,
--	[LabourCost] [numeric](24, 2) NULL,
--	[PartsCost] [numeric](24, 2) NULL,
--	[ContractorCost] [numeric](24, 2) NULL,
--	[TotalCost] [numeric](24, 2) NULL,
--	[ContractorId] [int] NULL,
--	[ContractorHours] [numeric](24, 2) NULL,
--	[PartsRequired] [bit] NULL,
--	[Approved] [bit] NULL,
--	[AppType] [int] NULL,
--	[RepairHours] [numeric](24, 2) NULL,
--	[ProcessStatus] [int] NULL,
--	[ProcessStatusDate] [datetime] NULL,
--	[ProcessStatusReason] [int] NULL,
--	[UserId] [int] NULL,
--	[IsSubmitted] [bit] NULL DEFAULT ((0)),
--	[RunningHours] [nvarchar](100) NULL,
--	[VendorCost] [numeric](24, 2) NULL,
--	[MobileGuid] [NVARCHAR] (MAX) NULL
--)

--CREATE TYPE [dbo].[udt_EngMwoCompletionInfoTxnDet_Mobile] AS TABLE(
--	[CompletionInfoDetId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[StaffMasterId] [int] NULL,
--	[StandardTaskDetId] [int] NULL,
--	[StartDateTime] [datetime] NULL,
--	[StartDateTimeUTC] [datetime] NULL,
--	[EndDateTime] [datetime] NULL,
--	[EndDateTimeUTC] [datetime] NULL,
--	[UserId] [int] NULL,
--	[WorkOrderId] [int] NULL,
--	[MobileGuid] [NVARCHAR] (MAX) NULL
--)
--GO
GO
