USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoCompletionInfoTxn_Save]    Script Date: 20-09-2021 16:56:53 ******/
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
DECLARE @EngMwoCompletionInfoTxnDet		[dbo].[udt_EngMwoCompletionInfoTxnDet]
INSERT INTO @EngMwoCompletionInfoTxnDet (CompletionInfoDetId,CustomerId,FacilityId,ServiceId,StaffMasterId,StandardTaskDetId,StartDateTime,StartDateTimeUTC,
EndDateTime,EndDateTimeUTC) values
(9,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597','2018-05-16 13:07:49.597','2018-05-17 13:07:49.597')--,
--(9,1,1,2,1,1,'2018-05-16 13:07:49.597','2018-05-16 13:07:49.597','2018-05-16 13:07:49.597','2018-05-16 13:07:49.597')
EXECUTE [uspFM_EngMwoCompletionInfoTxn_Save] @EngMwoCompletionInfoTxnDet,@pCompletionInfoId=57,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pWorkOrderId=134,@pRepairDetails='SAMPLE',@pPPMAgreedDate='2018-05-16 13:07:49.597',
@pPPMAgreedDateUTC='2018-05-16 13:07:49.597',@pStartDateTime='2018-05-16 13:07:49.597',@pStartDateTimeUTC='2018-05-16 13:07:49.597',@pEndDateTime='2018-05-16 13:07:49.597',
@pEndDateTimeUTC='2018-05-16 13:07:49.597',@pHandoverDateTime='2018-05-16 13:07:49.597',@pHandoverDateTimeUTC='2018-05-16 13:07:49.597',@pCompletedBy=1,@pAcceptedBy=1,@pSignature='SAMPLE',
@pServiceAvailability=1,@pLoanerProvision=1,@pHandoverDelay=1,@pDowntimeHoursMin=15.2,@pCauseCode=1,@pQCCode=1,@pResourceType=1,@pLabourCost=15,@pPartsCost=15,@pContractorCost=15,
@pTotalCost=45,@pContractorId=NULL,@pContractorHours=15,@pPartsRequired=1,@pApproved=1,@pAppType=1,@pRepairHours=0,@pUserId=2

select * from EngMwoCompletionInfoTxn
select * from EngMwoCompletionInfoTxnDet


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMwoCompletionInfoTxn_Save]
		
		@EngMwoCompletionInfoTxnDet		[dbo].[udt_EngMwoCompletionInfoTxnDet]   READONLY,
		@pCompletionInfoId					INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pServiceId							INT				= NULL,
		@pWorkOrderId						INT				= NULL,
		@pRepairDetails						NVARCHAR(1000)	= NULL,
		@pPPMAgreedDate						DATETIME	= NULL,
		@pPPMAgreedDateUTC					DATETIME		= NULL,
		@pStartDateTime						DATETIME	= NULL,
		@pStartDateTimeUTC					DATETIME		= NULL,
		@pEndDateTime						DATETIME	= NULL,
		@pEndDateTimeUTC					DATETIME		= NULL,
		@pHandoverDateTime					DATETIME	= NULL,
		@pHandoverDateTimeUTC				DATETIME		= NULL,
		@pCompletedBy						INT				= NULL,
		@pAcceptedBy						INT				= NULL,
		@pSignature							NVARCHAR(1000)	= NULL,
		@pServiceAvailability				BIT				= NULL,
		@pLoanerProvision					BIT				= NULL,
		@pHandoverDelay						INT				= NULL,
		@pDowntimeHoursMin					NUMERIC(24,2)	= NULL,
		@pCauseCode							INT				= NULL,
		@pQCCode							INT				= NULL,
		@pResourceType						INT				= NULL,
		@pLabourCost						NUMERIC(24,2)	= NULL,
		@pPartsCost							NUMERIC(24,2)	= NULL,
		@pContractorCost					NUMERIC(24,2)	= NULL,
		@pTotalCost							NUMERIC(24,2)	= NULL,
		@pContractorId						INT				= NULL,
		@pContractorHours					NUMERIC(24,2)	= NULL,
		@pPartsRequired						BIT				= NULL,
		@pApproved							BIT				= NULL,
		@pAppType							INT				= NULL,
		@pRepairHours						NUMERIC(24,2)	= NULL,
		@pProcessStatus						INT				= NULL,
		@pProcessStatusDate					DATETIME	= NULL,
		@pProcessStatusReason				INT				= NULL,
		@pUserId							INT				= NULL,
		@pIsSubmitted						BIT				= 0,
		@pTimestamp							VARBINARY(200)	= NULL,
		@pRunningHours						NVARCHAR(100)	= NULL,
		@pVendorCost						NUMERIC(24,2)	= NULL,
		@pDownTimeHours						NUMERIC(30,2)	= NULL,
		@pCustomerFeedback					INT				= NULL


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


IF(ISDATE(@pHandoverDateTime)=0) 
	BEGIN
	SET @pHandoverDateTime=NULL 
	SET @pHandoverDateTimeUTC=NULL ;
	END
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoCompletionInfoTxn

			IF(@pCompletionInfoId is NULL OR @pCompletionInfoId =0)

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
							DownTimeHours,
							CustomerFeedback
						)	OUTPUT INSERTED.CompletionInfoId INTO @Table							

			VALUES			
						(	
							@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pWorkOrderId,
							@pRepairDetails,
							CAST(@pPPMAgreedDate AS datetime),
							@pPPMAgreedDateUTC,
							CAST(@pStartDateTime AS datetime),
							@pStartDateTimeUTC,
							CAST(@pEndDateTime AS datetime),
							@pEndDateTimeUTC,
							CAST(@pHandoverDateTime AS datetime),
							@pHandoverDateTimeUTC,
							@pCompletedBy,
							@pAcceptedBy,
							@pSignature,
							@pServiceAvailability,
							@pLoanerProvision,
							@pHandoverDelay,
							@pDowntimeHoursMin,
							@pCauseCode,
							@pQCCode,
							@pResourceType,
							@pLabourCost,
							@pPartsCost,
							@pContractorCost,
							(ISNULL(@pLabourCost,0)+ISNULL(@pPartsCost,0)+ISNULL(@pContractorCost,0)),
							@pContractorId,
							@pContractorHours,
							@pPartsRequired,
							@pApproved,
							@pAppType,
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE(),
							right('000'+cast((DATEDIFF(MINUTE, @pStartDateTime, @pEndDateTime)) /60 as varchar(50)),2) +'.'+ right('000'+cast((DATEDIFF(MINUTE, @pStartDateTime,  @pEndDateTime)) %60 as varchar(50)),2),
							--(cast((DATEDIFF(MINUTE, @pStartDateTime, @pEndDateTime)) as numeric(24,2))/60.00),
							@pProcessStatus,
							CAST(@pProcessStatusDate AS datetime),
							@pProcessStatusReason,
							@pRunningHours,
							@pVendorCost,
							@pDownTimeHours,
							@pCustomerFeedback
						)			

			SELECT	CompletionInfoId,WorkOrderId,
					[Timestamp],
					'' as ErrorMessage
			FROM	EngMwoCompletionInfoTxn
			WHERE	CompletionInfoId IN (SELECT ID FROM @Table)


			INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
			SELECT 'EngMaintenanceWorkOrderTxn',c.WorkOrderId,c.AssignedUserId FROM @Table A INNER JOIN EngMwoCompletionInfoTxn B ON A.ID = B.CompletionInfoId
			inner join EngMaintenanceWorkOrderTxn c on c.WorkOrderId = b.WorkOrderId
			and c.AssignedUserId is not null

			UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 194 WHERE WorkOrderId = @pWorkOrderId

			INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,WorkOrderStatus,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId

			SET @PrimaryKeyId  = (SELECT ID FROM @Table)

--2.EngMwoCompletionInfoTxnDet
						
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
							ModifiedDateUTC
							
						)

			SELECT			
							CustomerId,
							FacilityId,			
							ServiceId,			
							@PrimaryKeyId,	
							StaffMasterId,		
							StandardTaskDetId,	
							StartDateTime,		
							StartDateTimeUTC,
							EndDateTime,			
							EndDateTimeUTC,
							right('000'+cast((DATEDIFF(MINUTE, StartDateTime, EndDateTime)) /60 as varchar(50)),2) +'.'+ right('000'+cast((DATEDIFF(MINUTE,StartDateTime, EndDateTime)) %60 as varchar(50)),2),
						--	(cast((DATEDIFF(MINUTE, StartDateTime, EndDateTime)) as numeric(24,2))/60),			
							@pUserId,				
							GETDATE(),			
							GETUTCDATE(),
							@pUserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@EngMwoCompletionInfoTxnDet
			WHERE   ISNULL(CompletionInfoDetId,0)=0


	    UPDATE  MwoComInfoDet	SET MwoComInfoDet.LabourCost = (MwoComInfoDet.RepairHours	* UserReg.LabourCostPerHour)
		FROM	EngMwoCompletionInfoTxnDet			AS MwoComInfoDet 
				INNER JOIN UMUserRegistration		AS UserReg ON MwoComInfoDet.UserId	=	UserReg.UserRegistrationId
		WHERE	MwoComInfoDet.CompletionInfoId= @PrimaryKeyId

		update  a set StartDateTime=b.startdate,EndDateTime=b.EndDateTime  
		from EngMwoCompletionInfoTxn  a join (select  @PrimaryKeyId as CompletionInfoId,min(StartDateTime) as startdate, max(EndDateTime)  as EndDateTime  from @EngMwoCompletionInfoTxnDet)b
		on a.CompletionInfoId=b.CompletionInfoId
		where a.CompletionInfoId in (select 1 id from @table)
		     

END

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	EngMwoCompletionInfoTxn 
			WHERE	CompletionInfoId	=	@pCompletionInfoId
			
		--	IF(@mTimestamp = @pTimestamp)
		--	BEGIN
	    UPDATE  MwoCompletionInfo	SET		
							MwoCompletionInfo.CustomerId					= @pCustomerId,
							MwoCompletionInfo.FacilityId					= @pFacilityId,
							MwoCompletionInfo.ServiceId						= @pServiceId,
							MwoCompletionInfo.WorkOrderId					= @pWorkOrderId,
							MwoCompletionInfo.RepairDetails					= @pRepairDetails,
							MwoCompletionInfo.PPMAgreedDate					= CAST(@pPPMAgreedDate AS datetime),
							MwoCompletionInfo.PPMAgreedDateUTC				= @pPPMAgreedDateUTC,
							MwoCompletionInfo.StartDateTime					= CAST(@pStartDateTime AS datetime),
							MwoCompletionInfo.StartDateTimeUTC				= @pStartDateTimeUTC,
							MwoCompletionInfo.EndDateTime					= CAST(@pEndDateTime AS datetime),
							MwoCompletionInfo.EndDateTimeUTC				= @pEndDateTimeUTC,
							MwoCompletionInfo.HandoverDateTime				= CAST(@pHandoverDateTime AS datetime),
							MwoCompletionInfo.HandoverDateTimeUTC			= @pHandoverDateTimeUTC,
							MwoCompletionInfo.CompletedBy					= @pCompletedBy,
							MwoCompletionInfo.AcceptedBy					= @pAcceptedBy,
							MwoCompletionInfo.[Signature]					= @pSignature,
							MwoCompletionInfo.ServiceAvailability			= @pServiceAvailability,
							MwoCompletionInfo.LoanerProvision				= @pLoanerProvision,
							MwoCompletionInfo.HandoverDelay					= @pHandoverDelay,
							MwoCompletionInfo.DowntimeHoursMin				= @pDowntimeHoursMin,
							MwoCompletionInfo.CauseCode						= @pCauseCode,
							MwoCompletionInfo.QCCode						= @pQCCode,
							MwoCompletionInfo.ResourceType					= @pResourceType,
							MwoCompletionInfo.LabourCost					= @pLabourCost,
							MwoCompletionInfo.PartsCost						= @pPartsCost,
							MwoCompletionInfo.ContractorCost				= @pContractorCost,
							MwoCompletionInfo.TotalCost						= (ISNULL(@pLabourCost,0)+ISNULL(@pPartsCost,0)+ISNULL(@pContractorCost,0)),
							MwoCompletionInfo.ContractorId					= @pContractorId,
							MwoCompletionInfo.ContractorHours				= @pContractorHours,
							MwoCompletionInfo.PartsRequired					= @pPartsRequired,
							MwoCompletionInfo.Approved						= @pApproved,
							MwoCompletionInfo.AppType						= @pAppType,
							MwoCompletionInfo.ModifiedBy					= @pUserId,
							MwoCompletionInfo.ModifiedDate					= GETDATE(),
							MwoCompletionInfo.ModifiedDateUTC				= GETUTCDATE(),
							MwoCompletionInfo.RepairHours					= 	right('000'+cast((DATEDIFF(MINUTE, @pStartDateTime, @pEndDateTime)) /60 as varchar(50)),2) +'.'+ right('000'+cast((DATEDIFF(MINUTE, @pStartDateTime,  @pEndDateTime)) %60 as varchar(50)),2),
							--(cast((DATEDIFF(MINUTE, @pStartDateTime, @pEndDateTime)) as numeric(24,2))/60),
							MwoCompletionInfo.ProcessStatus					= @pProcessStatus,
							MwoCompletionInfo.ProcessStatusDate				= CAST(@pProcessStatusDate AS datetime),
							MwoCompletionInfo.ProcessStatusReason			= @pProcessStatusReason,
							MwoCompletionInfo.RunningHours					= @pRunningHours,
							MwoCompletionInfo.VendorCost					= @pVendorCost,
							MwoCompletionInfo.DownTimeHours					= @pDownTimeHours,
							MwoCompletionInfo.CustomerFeedback				= @pCustomerFeedback
							OUTPUT INSERTED.CompletionInfoId INTO @Table
				FROM	EngMwoCompletionInfoTxn						AS MwoCompletionInfo
				WHERE	MwoCompletionInfo.CompletionInfoId= @pCompletionInfoId 
						AND ISNULL(@pCompletionInfoId,0)>0


			INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,195,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId

			
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
									MwoCompletionInfoDet.RepairHours				=   right('000'+cast((DATEDIFF(MINUTE,MwoCompletionInfoudt.StartDateTime, MwoCompletionInfoudt.EndDateTime)) /60 as varchar(50)),2) +'.'+ right('000'+cast((DATEDIFF(MINUTE,MwoCompletionInfoudt.StartDateTime, MwoCompletionInfoudt.EndDateTime)) %60 as varchar(50)),2),
									--(cast((DATEDIFF(MINUTE, MwoCompletionInfoudt.StartDateTime, MwoCompletionInfoudt.EndDateTime)) as numeric(24,2))/60),	
									MwoCompletionInfoDet.ModifiedBy					=   @pUserId,			
									MwoCompletionInfoDet.ModifiedDate				=   GETDATE(),
									MwoCompletionInfoDet.ModifiedDateUTC			=   GETUTCDATE()

		FROM	EngMwoCompletionInfoTxnDet								AS MwoCompletionInfoDet 
				INNER JOIN @EngMwoCompletionInfoTxnDet					AS MwoCompletionInfoudt on MwoCompletionInfoDet.CompletionInfoDetId=MwoCompletionInfoudt.CompletionInfoDetId
		WHERE	ISNULL(MwoCompletionInfoudt.CompletionInfoDetId,0)>0


		update  a set StartDateTime=b.startdate,EndDateTime=b.EndDateTime  
		from EngMwoCompletionInfoTxn  a join (select  @pCompletionInfoId as CompletionInfoId,min(StartDateTime) as startdate, max(EndDateTime)  as EndDateTime  from @EngMwoCompletionInfoTxnDet)b
		on a.CompletionInfoId=b.CompletionInfoId
		WHERE	a.CompletionInfoId= @pCompletionInfoId 

	    UPDATE  MwoComInfoDet	SET MwoComInfoDet.LabourCost = (MwoComInfoDet.RepairHours	* UserReg.LabourCostPerHour)
		FROM	EngMwoCompletionInfoTxnDet			AS MwoComInfoDet 
				INNER JOIN UMUserRegistration		AS UserReg ON MwoComInfoDet.UserId	=	UserReg.UserRegistrationId
		WHERE	MwoComInfoDet.CompletionInfoId= @pCompletionInfoId
				  
			SELECT	CompletionInfoId,WorkOrderId,
					[Timestamp],
					'' as ErrorMessage
			FROM	EngMwoCompletionInfoTxn
			WHERE	CompletionInfoId IN (SELECT ID FROM @Table)

		INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
		SELECT 'EngMaintenanceWorkOrderTxn',c.WorkOrderId,c.AssignedUserId FROM @Table A INNER JOIN EngMwoCompletionInfoTxn B ON A.ID = B.CompletionInfoId
		inner join EngMaintenanceWorkOrderTxn c on c.WorkOrderId = b.WorkOrderId
		and c.AssignedUserId is not null

	 IF(@pIsSubmitted =1 AND ISNULL(@pProcessStatus,0)=0)
	 BEGIN
	 UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 195 WHERE WorkOrderId = @pWorkOrderId
	 DELETE FROM FEUserAssigned WHERE Userid IN (SELECT AssignedUserId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)
	 END
	 ELSE IF(@pIsSubmitted =1 AND ISNULL(@pProcessStatus,0)<>0)
	 BEGIN
	 UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 197 WHERE WorkOrderId = @pWorkOrderId
	 DELETE FROM FEUserAssigned WHERE Userid IN (SELECT AssignedUserId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)
	 END


	 IF isnull(@pAcceptedBy,0)>0
	 BEGIN
	 UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 195 WHERE WorkOrderId = @pWorkOrderId
	 DELETE FROM FEUserAssigned WHERE Userid IN (SELECT AssignedUserId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)
	 END
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
							ModifiedDateUTC
							
						)

			SELECT			
							CustomerId,
							FacilityId,			
							ServiceId,			
							@pCompletionInfoId,	
							StaffMasterId,		
							StandardTaskDetId,	
							StartDateTime,		
							StartDateTimeUTC,
							EndDateTime,			
							EndDateTimeUTC,
							--(cast((DATEDIFF(MINUTE, StartDateTime, EndDateTime)) as numeric(24,2))/60),			
							right('000'+cast((DATEDIFF(MINUTE, StartDateTime, EndDateTime)) /60 as varchar(50)),2) +'.'+ right('000'+cast((DATEDIFF(MINUTE,StartDateTime, EndDateTime)) %60 as varchar(50)),2),
							@pUserId,				
							GETDATE(),			
							GETUTCDATE(),
							@pUserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@EngMwoCompletionInfoTxnDet
			WHERE   ISNULL(CompletionInfoDetId,0)=0



--END   
--	ELSE
--		BEGIN
--				   SELECT	CompletionInfoId,WorkOrderId,
--							[Timestamp],
--							'Record Modified. Please Re-Select' ErrorMessage
--				   FROM		EngMwoCompletionInfoTxn
--				   WHERE	CompletionInfoId =@pCompletionInfoId
--		END
END


declare @MaintenanceWorkDateTime  datetime, @EndDateTime   datetime,@CompletionInfoId  int


select @MaintenanceWorkDateTime = MaintenanceWorkDateTime  
from EngMaintenanceWorkOrderTxn where WorkOrderId = @pWorkOrderId

select TOP 1 @EndDateTime = CDET.EndDateTime , @CompletionInfoId = c.CompletionInfoId
from EngMwoCompletionInfoTxn  C 
join EngMwoCompletionInfoTxndet CDET on c.CompletionInfoId=cdet.CompletionInfoId
WHERE WorkOrderId = @pWorkOrderId
ORDER BY CompletionInfoDetId DESC

if @EndDateTime is not null
begin 

select @MaintenanceWorkDateTime = DATEadd(ss,-datepart(ss,@MaintenanceWorkDateTime),@MaintenanceWorkDateTime)
select @EndDateTime = DATEadd(ss,-datepart(ss,@EndDateTime),@EndDateTime) 
update EngMwoCompletionInfoTxn set DownTimeHours=datediff(MINUTE,@MaintenanceWorkDateTime,@EndDateTime) ,DowntimeHoursMin=datediff(mm,@MaintenanceWorkDateTime,@EndDateTime)   where CompletionInfoId = @CompletionInfoId

end
ELSE
IF @EndDateTime is null
BEGIN

select @MaintenanceWorkDateTime = DATEadd(ss,-datepart(ss,@MaintenanceWorkDateTime),@MaintenanceWorkDateTime)
select @EndDateTime = DATEadd(ss,-datepart(ss,@EndDateTime),@EndDateTime) 

update EngMwoCompletionInfoTxn set DownTimeHours=null ,DowntimeHoursMin=null   where CompletionInfoId = @CompletionInfoId
and  DownTimeHours is not null

END




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

--drop proc [uspFM_EngMwoCompletionInfoTxn_Save]
--drop type udt_EngMwoCompletionInfoTxnDet


--CREATE TYPE [dbo].[udt_EngMwoCompletionInfoTxnDet] AS TABLE
--(

--CompletionInfoDetId					INT,
--CustomerId							INT,
--FacilityId							INT,
--ServiceId							INT,
--StaffMasterId						INT,
--StandardTaskDetId					INT,
--StartDateTime						DATETIME,
--StartDateTimeUTC					DATETIME,
--EndDateTime							DATETIME,
--EndDateTimeUTC						DATETIME


--)
GO
