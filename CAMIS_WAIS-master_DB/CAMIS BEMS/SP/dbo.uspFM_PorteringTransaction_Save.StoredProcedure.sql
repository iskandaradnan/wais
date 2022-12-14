USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PorteringTransaction_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PorteringTransaction_Save
Description			: Portering Transaction save
Authors				: Balaji M S
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_PorteringTransaction_Save] @pPorteringId=38,@pFromCustomerId=1,@pFromFacilityId=2,@pFromBlockId=1,@pFromLevelId=1,@pFromUserAreaId=1,@pFromUserLocationId=1,@pRequestorId=1,
@pRequestTypeLovId=1,@pMovementCategory=68,@pSubCategory=69,@pModeOfTransport=1,@pToCustomerId=1,@pToFacilityId=1,@pToBlockId=1,@pToLevelId=1,
@pToUserAreaId=1,@pToUserLocationId=1,@pAssignPorterId=1,@pConsignmentNo='AAAA',@pPorteringStatus=5,@pReceivedBy=1,@pCurrentWorkFlowId=2,@pRemarks='LLL',
@pAssetId=1,@pPorteringDate='2018-05-28 17:02:26.510',@pPorteringNo=null,@pUserId=2

select getdate()
SELECT * FROM PorteringTransaction
SELECT * FROM CRMRequestWorkOrderTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_PorteringTransaction_Save]
		
		@pPorteringId				INT				= NULL,
		@pFromCustomerId			INT				= NULL,
		@pFromFacilityId			INT				= NULL,
		@pFromBlockId				INT				= NULL,
		@pFromLevelId				INT				= NULL,
		@pFromUserAreaId			INT				= NULL,
		@pFromUserLocationId		INT				= NULL,
		@pRequestorId				INT				= NULL,
		
		@pRequestTypeLovId			INT				= NULL,
		@pMovementCategory			INT				= NULL,
		@pSubCategory				INT				= NULL,
		@pModeOfTransport			INT				= NULL,
		@pToCustomerId				INT				= NULL,
		@pToFacilityId				INT				= NULL,
		@pToBlockId					INT				= NULL,
		@pToLevelId					INT				= NULL,
		@pToUserAreaId				INT				= NULL,
		@pToUserLocationId			INT				= NULL,
		@pAssignPorterId			INT				= NULL,
		@pConsignmentNo				NVARCHAR(500)	= NULL,
		@pPorteringStatus			INT				= NULL,
		@pReceivedBy				INT				= NULL,
		@pCurrentWorkFlowId			INT				= NULL,
		@pRemarks					NVARCHAR(1000)	= NULL,
		@pAssetId					INT				= NULL,
		@pPorteringDate				DATETIME		= NULL,
		@pPorteringNo				NVARCHAR(100)	= NULL,
		@pUserId					INT				= NULL,
		@pTimestamp					VARBINARY(200)	= NULL,
		@pWorkOrderId				INT				= NULL,
		@pSupplierId				INT				= NULL,
		@pSupplierLovId				INT				= NULL,
		@pScanAsset					NVARCHAR(1000)	= NULL,
		@pConsignmentDate			DATETIME        = NULL,
		@pCourierName				NVARCHAR(1000)	= NULL,
	    @pApprovedDate				DATETIME        = NULL,
		@pLoanerTestEquipmentBookingId	INT			= NULL
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
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @TableNotification TABLE (ID INT)

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.FMLovMst

IF(ISNULL(@pPorteringId,0) = 0)

BEGIN
	
	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT
	SET @mMonth	=	MONTH(@pPorteringDate)
	SET @mYear	=	YEAR(@pPorteringDate)

	EXEC [uspFM_GenerateDocumentNumber] @pFlag='PorteringTransaction',@pCustomerId=@pFromCustomerId,@pFacilityId=@pFromFacilityId,@Defaultkey='AT',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @pPorteringNo=@pOutParam

	        

			declare @bookingalreadyDone int = (select count(1) from PorteringTransaction where LoanerTestEquipmentBookingId = @pLoanerTestEquipmentBookingId)

			if(@bookingalreadyDone > 0 )
			begin
			       SELECT	 0 PorteringId, 0  EngineerId,
							
							'Portering Already Initiated for this record' ErrorMessage,
							null as GuId
				 
			    
			end 
			else 
			begin


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
							LoanerTestEquipmentBookingId
                        
						)	OUTPUT INSERTED.PorteringId INTO @Table
			VALUES			
						(	

							@pFromCustomerId,
							@pFromFacilityId,
							@pFromBlockId,
							@pFromLevelId,
							@pFromUserAreaId,
							@pFromUserLocationId,
							@pRequestorId,
						
							@pRequestTypeLovId,
							@pMovementCategory,
							@pSubCategory,
							@pModeOfTransport,
							@pToCustomerId,
							@pToFacilityId,
							@pToBlockId,
							@pToLevelId,
							@pToUserAreaId,
							@pToUserLocationId,
							@pAssignPorterId,
							@pConsignmentNo,
							@pPorteringStatus,
							@pReceivedBy,
							@pCurrentWorkFlowId,
							@pRemarks,
							@pUserId,			
							GETDATE(), 
							GETUTCDATE(),
							@pUserId, 
							GETDATE(), 
							GETUTCDATE(),
							@pAssetId,
							@pPorteringDate,
							@pPorteringNo,
						    @pWorkOrderId,
						    @pSupplierLovId,
						    @pSupplierId,
						    @pScanAsset,
						    @pConsignmentDate,
							@pCourierName, 
							@pApprovedDate,
							@pLoanerTestEquipmentBookingId
						
						) 
								
			SELECT	PorteringId, a.RequestorId EngineerId,
					a.[Timestamp],
					'' AS	ErrorMessage,
					a.GuId
			FROM	PorteringTransaction a
			inner join Umuserregistration usere  on a.RequestorId= usere.UserRegistrationId
			WHERE	PorteringId IN (SELECT ID FROM @Table)

			INSERT INTO QueueWebtoMobile	(		
												TableName,
												Tableprimaryid,
												UserId
											)
											VALUES
											(
												'PorteringTransactionRequest',
												(SELECT ID FROM @Table),
												@pRequestorId
											)
								


			DECLARE @PPrimaryKey INT
			SELECT @PPrimaryKey =  ID FROM @Table


			IF (@pMovementCategory = 327)   --- TEMPORARY MOVEMENT
			BEGIN
			      	 UPDATE EngAsset  SET 
				      UserLocationId = @pToUserLocationId,
					  UserAreaId= @pUserId
					WHERE AssetId = @pAssetId


			END 



			IF(@pCurrentWorkFlowId IS NOT NULL) 
			BEGIN
			IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @PPrimaryKey AND WorkFlowStatusId = @pCurrentWorkFlowId)
			BEGIN
			INSERT INTO PorteringTransactionHistory (PorteringId,WorkFlowStatusId,WFDoneBy,WFDoneByDate,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			VALUES (@PPrimaryKey,@pCurrentWorkFlowId,@pUserId,GETDATE(),@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())

			END
			END
			IF(@pPorteringStatus IS NOT NULL AND @pCurrentWorkFlowId IS NOT NULL) 
			BEGIN
			IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @PPrimaryKey AND PorteringStatusLovId = @pPorteringStatus AND WorkFlowStatusId = @pCurrentWorkFlowId)
			BEGIN
			INSERT INTO PorteringTransactionHistory (PorteringId,PorteringStatusLovId,PorteringStatusDoneBy,PorteringStatusDoneByDate,IsMoment,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			VALUES (@PPrimaryKey,@pPorteringStatus,@pUserId,GETDATE(),1,@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())
			END
			END
			end 
end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------
		

BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	PorteringTransaction 
			WHERE	PorteringId	=	@pPorteringId
			
			IF(@mTimestamp= @pTimestamp)
			BEGIN
	        UPDATE  PorteringTransaction	SET		
												AssignPorterId						= @pAssignPorterId,
												ConsignmentNo						= @pConsignmentNo,
												PorteringStatus						= @pPorteringStatus,
												ReceivedBy							= @pReceivedBy,
												CurrentWorkFlowId					= @pCurrentWorkFlowId,
												Remarks								= @pRemarks,		
												ModifiedDate						= GETDATE(),
												ModifiedDateUTC						= GETUTCDATE(),
												SupplierLovId						= @pSupplierLovId,
												SupplierId							= @pSupplierId,
											    ScanAsset							= @pScanAsset,
												ConsignmentDate						= @pConsignmentDate,
											    CourierName							= @pCourierName,
												WFStatusApprovedDate				= @pApprovedDate,
												LoanerTestEquipmentBookingId		= @pLoanerTestEquipmentBookingId
									OUTPUT INSERTED.PorteringId INTO @Table
				 WHERE	PorteringId= @pPorteringId
						--AND ISNULL(@pPorteringId,0)>0
		  




			IF(ISNULL( @pCurrentWorkFlowId,0) <> 0) 
			BEGIN
			IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @pPorteringId AND WorkFlowStatusId = @pCurrentWorkFlowId)
			BEGIN
			INSERT INTO PorteringTransactionHistory (PorteringId,WorkFlowStatusId,WFDoneBy,WFDoneByDate,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			VALUES (@pPorteringId,@pCurrentWorkFlowId,@pUserId,GETDATE(),@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())
			END
			END
			IF(@pPorteringStatus IS NOT NULL AND @pCurrentWorkFlowId IS NOT NULL) 
			BEGIN
			IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @pPorteringId AND PorteringStatusLovId = @pPorteringStatus AND  WorkFlowStatusId = @pCurrentWorkFlowId)
			BEGIN
			INSERT INTO PorteringTransactionHistory (PorteringId,WorkFlowStatusId,WFDoneBy,WFDoneByDate,PorteringStatusLovId,PorteringStatusDoneBy,PorteringStatusDoneByDate,IsMoment,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			VALUES (@pPorteringId,@pCurrentWorkFlowId,@pUserId,GETDATE(),@pPorteringStatus,@pUserId,GETDATE(),1,@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())
			END
			END

			IF(@pPorteringStatus =249 AND (@pMovementCategory =239 OR @pMovementCategory=240 ))
			BEGIN

			UPDATE EngAsset SET FacilityId=@pToFacilityId,UserAreaId=@pToUserAreaId,UserLocationId=@pToUserLocationId
			WHERE AssetId = @pAssetId

			END

			SELECT	PorteringId, a.RequestorId EngineerId,
					a.[Timestamp],
					'' AS	ErrorMessage,
					a.GuId 
			FROM	PorteringTransaction a
			inner join Umuserregistration usere  on a.RequestorId= usere.UserRegistrationId
			WHERE	PorteringId =@pPorteringId

SET @pPorteringNo = (SELECT PorteringNo FROM	PorteringTransaction
			WHERE	PorteringId =@pPorteringId)
								


if @pCurrentWorkFlowId in ( 247,248)
begin


declare  @lstatus  nvarchar(50)
select @lstatus = case when  @pCurrentWorkFlowId  = 247  then 'Approved'  else 'Rejected' end
declare @TableNotificationdet table (ID int,UserId int)
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
									) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotificationdet
						SELECT	RequestorId,
								'Asset Tracker request has been ' + isnull(@lstatus,'')+' - ' + PorteringNo ,
								'Asset Tracker' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'PorteringTransaction',
								PorteringNo,
								1
								FROM	PorteringTransaction
								WHERE	PorteringId =@pPorteringId
						--FROM	#Temp
						
		INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								UserId
						FROM @TableNotificationdet
	
		
END


---------- Notification Alerts------------

IF(ISNULL(@pAssignPorterId,0)<>0)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM QueueWebtoMobile WHERE TableName='PorteringTransaction' AND Tableprimaryid=@pPorteringId AND UserId=@pAssignPorterId)
	BEGIN
		SELECT @mDateFmt = b.FieldValue	 
		FROM	FMConfigCustomerValues a 
				INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId
		WHERE	A.KeyName='DATE'
				AND CustomerId = @pFromCustomerId

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
						SELECT	'PorteringTransaction',
								@pPorteringId,
								@pAssignPorterId


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
									) OUTPUT INSERTED.NotificationId INTO @TableNotification
						SELECT	@pAssignPorterId,
								'Asset Tracker request has been assigned to you - ' + @pPorteringNo + ' Dt '+ @mDateFmtValue,
								'Manual Assigned' AS Remarks,
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								@pUserId,
								GETDATE(),
								GETUTCDATE(),
								'PorteringTransaction',
								@pPorteringNo,
								1
						--FROM	#Temp
						
		INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								@pAssignPorterId
						FROM @TableNotification
	END
END   

END
	ELSE
		BEGIN
				   SELECT	PorteringId,  a.RequestorId EngineerId,
							a.[Timestamp],
							'Record Modified. Please Re-Select' ErrorMessage,
							a.GuId
				   FROM		PorteringTransaction a
				   inner join Umuserregistration usere  on a.RequestorId= usere.UserRegistrationId
				   WHERE	PorteringId= @pPorteringId
		END
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
GO
