USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsScheduledWorkOrderRpt_L4]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : ASIS                
Version       :                 
File Name      : Asis_BemsScheduledWorkOrderRpt_L4                
Procedure Name  : Asis_BemsScheduledWorkOrderRpt_L4  
Author(s) Name(s) : Praveen Kumar K  
Date       :   
Purpose       : SP For Work Order Report     Level 4 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC [Asis_BemsScheduledWorkOrderRpt_L4] @Level='national',@Level_Key='', @Hospital_Id='1',@Frequency='yearly',      
@Frequency_Key='',@year='2016', @From_Date='',@To_Date=''
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
  
exec Asis_BemsScheduledWorkOrderRpt_L4 '','85','1839'
exec Asis_BemsScheduledWorkOrderRpt_L4 '185','1822' 
exec Asis_BemsScheduledWorkOrderRpt_L4 '','85','35'
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
  
CREATE PROCEDURE [dbo].[Asis_BemsScheduledWorkOrderRpt_L4]                                      
(  
  @MenuName     Varchar(500) ,                                                
  @Hospital_Id  VARCHAR(20),   
 @Work_Order_Id VARCHAR(20)     
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY   
DECLARE @Query VARCHAR(4000),@SubQuery VARCHAR(4000),@Prev_Year INT,@table_name varchar(50), @TR int      
                    
  
   
   
 create table #final1           
 (    
  row_id int identity(1,1),  
 hospital_id varchar(50),
 hospital_name nvarchar(200),
 work_order_no nvarchar(100),
 work_order_type varchar(100),
 department nvarchar(300),
 location nvarchar(300),
 WO_details nvarchar(1000),
 asset_no nvarchar(100),
 asset_description nvarchar(1000),
 task_code nvarchar(50),
 task_Description nvarchar(300),
 Scheduled_Date datetime,
 target_date datetime,
 ppm_agreed_date datetime,
 Final_Reschedule_Date datetime,
 Start_Date datetime,
 completed_date datetime,
 Verified_Accepted_By nvarchar(300),
 Designation nvarchar(300),
 Downtime numeric(13,2),
 Repair_Hours numeric(13,2),
 Labour_Cost numeric(13,2),
 Contractor_Cost numeric(13,2),
 cause_code varchar(100),
 QC_code varchar(100),
 work_order_status varchar(100),
 reference_wo_no nvarchar(100),
 ActionTaken     Nvarchar(510) 
 )
    
   insert into #final1(hospital_name,work_order_no,work_order_type,department,location,--WO_details,
   asset_no,asset_description,task_code,task_Description,Scheduled_Date,
   target_date,ppm_agreed_date,Final_Reschedule_Date,Start_Date,completed_date,Verified_Accepted_By,Designation,Downtime,Labour_Cost,Contractor_Cost,cause_code,
   QC_code,work_order_status,--reference_wo_no,
   Repair_Hours)--,ActionTaken)    
   SELECT   a.FacilityName,b.MaintenanceWorkNo,b.TypeOfWorkOrder,case when b.TypeOfWorkOrder=2513 then g.BlockName else g.BlockName end,
     case when b.TypeOfWorkOrder=2513 then p.UserLocationName else p.UserLocationName end,--b.Details, 
	  case when b.TypeOfWorkOrder=2513 then '' else d.AssetNo end , case when b.TypeOfWorkOrder=2513 then  '' else d.AssetDescription end ,
	 case when b.TypeOfWorkOrder=2513 then l.TaskCode else l.TaskCode end, case when b.TypeOfWorkOrder=2513 then  l.TaskDescription else  l.TaskDescription end, 
	-- '''','''','''','''',
     b.MaintenanceWorkDateTime,b.TargetDateTime,h.PPMAgreedDate,r.RescheduleDate,
     h.StartDateTime,h.EndDateTime,t.StaffName,dbo.Fn_DisplayNameofLov(u.Designation),h.DowntimeHoursMin,
     h.LabourCost,h.ContractorCost,h.CauseCode,h.QCCode,dbo.Fn_DisplayNameofLov(b.WorkOrderStatus),--b.ReferenceWorkNo,
	(select sum(RepairHours) from EngMwoCompletionInfoTxnDet where h.CompletionInfoId=CompletionInfoId)
	--,h.ActionTaken
     FROM EngMaintenanceWorkOrderTxn b left join MstLocationFacility a on a.FacilityId=b.FacilityId and a.CustomerId = b.CustomerId    
     --left join EngPpmScheduleGenTxnDet j on b.PpmScheduleDetId=j.PpmScheduleDetId and j.IsDeleted=0
     left join EngPlannerTxn k on k.PlannerId = b.PlannerId --and k.IsDeleted=0
     left join EngAsset d on  b.AssetId = d.AssetId --and d.IsDeleted=0  and Type<>2513 
	 left join EngAsset ar on  b.UserLocationId = d.UserLocationId  and TypeOfWorkOrder=2513  --and d.IsDeleted=0 
     --left join EngUserLocationMst e on e.EngUserLocationId=isnull(d.EngUserLocationId,ar.EngUserLocationId) --and e.IsDeleted=0 	
     --left join EngUserLocationMst ul on d.EngUserLocationId=e.EngUserLocationId and e.IsDeleted=0 
     left join MstLocationUserLocation p on p.UserLocationId=isnull(d.UserLocationId,ar.UserLocationId)
	-- =e.UserLocationId and p.IsDeleted=0
     --left join EngUserAreaMst c on c.EngUserAreaId= e.EngUserAreaId and c.IsDeleted=0
     left join MstLocationUserArea f on f.UserAreaId= p.UserAreaId --and f.IsDeleted=0
     left join MstLocationBlock g on g.BlockId= f.BlockId --and g.IsDeleted=0
     left join EngMwoCompletionInfoTxn h on b.WorkOrderId=h.WorkOrderId --AND h.IsDeleted=0  
    -- left join EngMwoProcessStatusTxnDet i on i.CompletionInfoId = h.CompletionInfoId and i.IsDeleted=0 
     left join EngPpmRescheduleTxnDet r on b.WorkOrderId=r.PpmRescheduleDetId --and r.IsDeleted=0
     --left join AsisUserRegistration s on s.UserRegistrationId=h.AcceptedBy
     --left join FmsStaffMst t on t.UserRegistrationId=s.UserRegistrationId and t.IsDeleted=0
	 left join UMUserRegistration t on t.UserRegistrationId = h.AcceptedBy
     left join UserDesignation u on t.UserDesignationId=u.UserDesignationId 
	 left join EngMwoCompletionInfoTxnDet v on h.CompletionInfoId=v.CompletionInfoId
     left join EngAssetTypeCodeStandardTasksDet l on l.StandardTaskDetId=v.StandardTaskDetId --and l.IsDeleted=0
	 where b.FacilityId=@Hospital_Id and b.WorkOrderId=@Work_Order_Id
     --and b.IsDeleted=0   and b.ServiceId=2 and a.IsDeleted=0 AND  b.MaintenanceWorkCategory IN (2357,2358) and b.Type in (2513)
     --group by a.HospitalName,b.MaintenanceWorkNo,b.Type,case when b.Type=2513 then g.UserDepartmentName else g.UserDepartmentName end,
     --case when b.Type=2513 then p.UserLocationName else p.UserLocationName end,b.Details, l.TaskCode,l.TaskDescription,
     --b.MaintenanceWorkDateTime,b.TargetDateTime,h.PPMAgreedDate,r.RescheduleDate,
     --h.StartDateTime,h.EndDateTime,t.StaffName,u.CurrentPosition,h.DowntimeHoursMin,
     --h.LabourCost,h.ContractorCost,h.CauseCode,h.QCCode,dbo.Fn_DisplayNameofLov(b.WorkOrderStatus),b.ReferenceWorkNo,h.ActionTaken             
            
  
                   
declare @referenceworkno  VArchar(200)
  select  @referenceworkno = txn.MaintenanceWorkNo 
  from EngMaintenanceWorkOrderTxn txn,
  #final1 det  WHERE det.reference_wo_no = txn.WorkOrderId
   
        
 select           
  
 --h.CompanyName as 'Company_Name',
 --h.StateName as 'State_Name',
 hospital_name as 'Hospital',
 work_order_no as 'Work_Order_No',
 dbo.Fn_DisplayNameofLov(work_order_type) as 'Work_Order_Type',
 department as 'Department',
 location as 'Location',
 WO_details as 'WO_Details',
 asset_no as 'Asset_No',
 asset_description as 'Asset_Description',
 task_code as 'Task_Code',
 task_Description as 'Task_Description',
 ISNULL(FORMAT(Scheduled_Date,'dd-MMM-yyyy'),'') as 'Scheduled_Date',
 ISNULL(FORMAT(target_date,'dd-MMM-yyyy'),'') as 'Target_Date',
 ISNULL(FORMAT(ppm_agreed_date,'dd-MMM-yyyy'),'') as 'PPM_Agreed_Date',
 ISNULL(FORMAT(Final_Reschedule_Date,'dd-MMM-yyyy HH:mm'),'') as 'Final_Reschedule_Date',
 ISNULL(FORMAT(Start_Date,'dd-MMM-yyyy HH:mm'),'') as 'Start_Date',
 ISNULL(FORMAT(completed_date,'dd-MMM-yyyy'),'') as 'Completed_Date',
 Verified_Accepted_By as 'Verified_Accepted_By',
 Designation as 'Designation',
 Downtime as 'Downtime_hrs',
 Repair_Hours as 'Repair_Hours',
 Labour_Cost as 'Labour_Cost',
 Contractor_Cost as 'Contractor_Cost',
 dbo.Fn_DisplayNameofLov(cause_code) as 'Cause_Code',
 dbo.Fn_DisplayNameofLov(QC_code) as 'QC_Code',
 work_order_status as 'Work_Order_Status',
 reference_wo_no as 'Reference_Work_Order_No',
 ActionTaken   AS 'ActionTaken' 

 from #final1    T    
    
 
 drop table #final1  

       

  
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                            
END
GO
