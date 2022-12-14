USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_uspFM_EngAssesmentChangeToVendor_Save]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoAssesmentTxn_Save
Description			: If Assesment already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------
Unit Test:
EXECUTE [uspFM_uspFM_EngAssesmentChangeToVendor_Save] @pWorkOrderId=0,@pUserId = ,@ApproveStatus=

-----------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE  [dbo].[uspFM_uspFM_EngAssesmentChangeToVendor_Save]

@pWorkOrderId						INT				= NULL,
@pUserId							INT				= NULL,
@ApproveStatus						nvarchar(500)   = null,
@pFMvendorApproveStatus				nvarchar(500)   = null  output
as
begin


	IF @ApproveStatus ='Approve'
	begin
	update EngMaintenanceWorkOrderTxn  set  WorkOrderStatus= 386,
											ModifiedBy=@pUserId,
											ModifiedDate= getdate(),
											ModifiedDateUTC=getutcdate()	
	where  workorderid=@pWorkOrderId


	update EngMwoAssesmentTxn  set		  FMvendorApproveStatus= @ApproveStatus,
											ModifiedBy=@pUserId,
											ModifiedDate= getdate(),
											ModifiedDateUTC=getutcdate()	
	where  workorderid=@pWorkOrderId


			INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			SELECT CustomerId,FacilityId,ServiceId,@pWorkOrderId,386,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId


	END
	ELSE
	begin
			update EngMwoAssesmentTxn  set		  FMvendorApproveStatus= @ApproveStatus,
											ModifiedBy=@pUserId,
											ModifiedDate= getdate(),
											ModifiedDateUTC=getutcdate()	,
											AssignedVendor = NULL
						where  workorderid=@pWorkOrderId
	END

select @pFMvendorApproveStatus = @ApproveStatus

declare @FacilityId int,@CustomerId int,@mwono nvarchar(200),@AssignedUserId int


select @FacilityId =FacilityId ,@CustomerId=CustomerId,@mwono=MaintenanceWorkNo  from EngMaintenanceWorkOrderTxn  where WorkOrderId = @pWorkOrderId
select  @AssignedUserId = AssignedVendor  from EngMwoAssesmentTxn  where WorkOrderId = @pWorkOrderId


IF @ApproveStatus ='Approve'
	begin

 INSERT INTO QueueWebtoMobile (  TableName,    
        Tableprimaryid,    
        UserId    
         )    
        SELECT 'WorkOrderStatus',    
       @pWorkOrderId,    
       @AssignedUserId    
      



	  
 INSERT INTO WebNotification ( CustomerId,    
         FacilityId,    
           UserId,    
           NotificationAlerts,    
           Remarks,    
           HyperLink,    
           IsNew,    
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC ,    
           NotificationDateTime,    
           IsNavigate                                                                
          )    
     SELECT @FacilityId,@CustomerId,a.UserRegistrationId as UserRegistrationId,    
		isnull(@mwono,'')+   ' is assigned to vendor.  ' ,'',    
     '/bems/unscheduledworkorder?id='+CAST(@pWorkOrderId AS NVARCHAR(100)),    
     1,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),GETDATE(),0
       from UMUserRegistration a  
     WHERE  ContractorId = @AssignedUserId



	 
	 declare @TableNotificationdet table (id int,userid int)    
    
     INSERT INTO FENotification ( UserId,    
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
       SELECT a.UserRegistrationId ,    
     isnull(@mwono,'')+   ' is assigned to vendor.  ' ,'',    
     1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),    
     'UnScheduledWorkOrder',    
     @mwono,    
     1    
      from UMUserRegistration a  
     WHERE  ContractorId = @AssignedUserId
                    
          
       INSERT INTO QueueWebtoMobile (  TableName,    
        Tableprimaryid,    
        UserId    
         )    
        SELECT 'FENotification',    
       ID,    
       UserId    
        FROM @TableNotificationdet 


		         
     
 SELECT NotificationDeliveryId,    
   NotificationTemplateId,    
   UserRoleId,    
   UserRegistrationId,    
   FacilityId    
 INTO #Notification1    
 FROM NotificationDeliveryDet    
 WHERE NotificationTemplateId = 78    
    
    
      
 SELECT distinct A.UserRegistrationId,    
   b.FacilityId,    
   b.CustomerId      
  INTO #TempUserEmails_all1    
 FROM UMUserRegistration AS A     
   INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId    
 WHERE B.UserRoleId IN (SELECT DISTINCT UserRoleId FROM #Notification1)    
 AND B.FacilityId = @FacilityId   
    
  
 INSERT INTO WebNotification ( CustomerId,    
         FacilityId,    
           UserId,    
           NotificationAlerts,    
           Remarks,    
           HyperLink,    
           IsNew,    
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC ,    
           NotificationDateTime,    
           IsNavigate                                                                
          )    
     SELECT A.CustomerId,A.FacilityId,a.UserRegistrationId,    
     isnull(@mwono,'')+   ' is assigned to vendor.  ' ,'',    
     '/bems/unscheduledworkorder?id='+CAST(@pWorkOrderId AS NVARCHAR(100)),    
     1,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),GETDATE(),0  
     from  #TempUserEmails_all1 a  
      
         
    
    
  declare @TableNotificationdet1 table (id int,userid int)    
    
     INSERT INTO FENotification ( UserId,    
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
        ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotificationdet1    
       SELECT  a.UserRegistrationId,    
		 isnull(@mwono,'')+   ' is assigned to vendor.  ','',    
     1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),    
     'UnScheduledWorkOrder',    
	 @mwono,    
     1    
      from  #TempUserEmails_all1 a  
          
          
          
       INSERT INTO QueueWebtoMobile (  TableName,    
        Tableprimaryid,    
        UserId    
         )    
        SELECT 'FENotification',    
       ID,    
       UserId    
        FROM @TableNotificationdet1    
    

	declare @email  nvarchar(max)

	select @email =isnull(@email+',','') + a.email from  UMUserRegistration a  
     WHERE  ContractorId = @AssignedUserId

	 select @email as email,@ApproveStatus ApproveStatus , @mwono WorkorderNo
	 END
end
GO
