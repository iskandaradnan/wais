USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ScheduledWorkOrderRpt_New]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-- =============================================
-- Author:		<Aravinda Raja>
-- Create date: <12/06/2018>
-- Description:	Screen fetch
-- =============================================   
EXEC [uspFM_ScheduledWorkOrderRpt_New] @Hospital_Id=2,@WO_Type='ppm',@From_Date='2017-04-05',@To_Date='2018-06-05'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     

  
CREATE PROCEDURE [dbo].[uspFM_ScheduledWorkOrderRpt_New]                                      
(                                             
  @Hospital_Id  VARCHAR(20),	-- like Facility_Id
  @WO_Type		varchar(20),  
  @From_Date    VARCHAR(200),
  @To_Date      VARCHAR(200)  
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
BEGIN TRY
 
 create table #final1           
 (          
  row_id int identity(1,1), 
  hospital_id varchar(50),
  hospital_name nvarchar(200),
  AssetRegisterId int,	
  work_order_id varchar(100),
  Work_Order_No nvarchar(100),
  Scheduled_Date datetime, 
  user_location_code nvarchar(100),
  user_location_name nvarchar(200),
  Asset_Number nvarchar(200),
  asset_description nvarchar(1000),             
  user_department_name nvarchar(200), 
  mainteinance_type varchar(200),  
  agreed_date datetime,
  Completed_Date datetime,
  Total_Down_Time numeric(13,2),
  Details varchar(1000),
  Status varchar(100)
 ) 

if(@WO_Type='' or @WO_Type='Others')

  insert into #final1(  hospital_id,AssetRegisterId,work_order_id,Work_Order_No,Scheduled_Date, user_location_code,user_location_name,Asset_Number,asset_description,user_department_name,
								mainteinance_type,  agreed_date,Completed_Date,Total_Down_Time,Details,Status) 

  SELECT  distinct b.FacilityId HospitalId,b.AssetId AssetRegisterId,b.WorkOrderId,b.MaintenanceWorkNo,b.MaintenanceWorkDateTime,o.UserLocationCode,o.UserLocationName,
  case when b.TypeOfWorkOrder=30 then '' else  p.AssetNo end , case when b.TypeOfWorkOrder=30 then '' else p.AssetDescription end ,
  case when b.TypeOfWorkOrder=30 then n.BlockName  else n.BlockName  end,b.MaintenanceWorkType Type,h.PPMAgreedDate,h.EndDateTime,h.DowntimeHoursMin,b.MaintenanceDetails Details,b.WorkOrderStatus	
  FROM   EngMaintenanceWorkOrderTxn b 	with(nolock)  
  inner join EngAsset p  with(nolock) on  p.AssetId=b.AssetId 
  left join EngMwoCompletionInfoTxn d   with(nolock) on b.WorkOrderId = d.WorkOrderID 
  left join EngMwoCompletionInfoTxn e with(nolock) on e.CompletionInfoId = d.CompletionInfoId 
  left join MstLocationUserLocation o  with(nolock) on o.UserLocationId=p.UserLocationId 
  left join MstLocationUserArea l on o.UserAreaId=l.UserAreaId 
  left join MstLocationBlock n on n.BlockId=l.BlockId 
  left join EngMwoCompletionInfoTxn h on b.WorkOrderId=h.WorkOrderId   
  where b.ServiceId=2  and   b.FacilityId = @Hospital_Id AND  b.MaintenanceWorkCategory  ='187' 
  AND  CAST(b.TargetDateTime AS DATE) Between @From_Date and @To_Date	 


 if(@WO_Type='PPM')

  insert into #final1(  hospital_id,AssetRegisterId,work_order_id,Work_Order_No,Scheduled_Date, user_location_code,user_location_name,Asset_Number,asset_description,user_department_name,
								mainteinance_type,  agreed_date,Completed_Date,Total_Down_Time,Details,Status) 

  SELECT  distinct b.FacilityId HospitalId,b.AssetId AssetRegisterId,b.WorkOrderId,b.MaintenanceWorkNo,b.MaintenanceWorkDateTime,o.UserLocationCode,o.UserLocationName,
  case when b.TypeOfWorkOrder=30 then '' else  p.AssetNo end , case when b.TypeOfWorkOrder=30 then '' else p.AssetDescription end ,
  case when b.TypeOfWorkOrder=30 then n.BlockName  else n.BlockName  end,b.MaintenanceWorkType Type,h.PPMAgreedDate,h.EndDateTime,h.DowntimeHoursMin,b.MaintenanceDetails Details,b.WorkOrderStatus	
  FROM   EngMaintenanceWorkOrderTxn b 	with(nolock)  
  inner join EngAsset p  with(nolock) on  p.AssetId=b.AssetId 
  left join EngMwoCompletionInfoTxn d   with(nolock) on b.WorkOrderId = d.WorkOrderID 
  left join EngMwoCompletionInfoTxn e with(nolock) on e.CompletionInfoId = d.CompletionInfoId 
  left join MstLocationUserLocation o  with(nolock) on o.UserLocationId=p.UserLocationId 
  left join MstLocationUserArea l on o.UserAreaId=l.UserAreaId 
  left join MstLocationBlock n on n.BlockId=l.BlockId 
  left join EngMwoCompletionInfoTxn h on b.WorkOrderId=h.WorkOrderId   
  where b.ServiceId=2  and   b.FacilityId = @Hospital_Id AND  b.MaintenanceWorkCategory  ='187' and b.TypeOfWorkOrder = 27
  AND  CAST(b.TargetDateTime AS DATE) Between @From_Date and @To_Date	 




 if(@WO_Type='RI')

   insert into #final1(  hospital_id,AssetRegisterId,work_order_id,Work_Order_No,Scheduled_Date, user_location_code,user_location_name,Asset_Number,asset_description,user_department_name,
								mainteinance_type,  agreed_date,Completed_Date,Total_Down_Time,Details,Status) 

  SELECT  distinct b.FacilityId HospitalId,b.AssetId AssetRegisterId,b.WorkOrderId,b.MaintenanceWorkNo,b.MaintenanceWorkDateTime,o.UserLocationCode,o.UserLocationName,
  case when b.TypeOfWorkOrder=30 then '' else  p.AssetNo end , case when b.TypeOfWorkOrder=30 then '' else p.AssetDescription end ,
  case when b.TypeOfWorkOrder=30 then n.BlockName  else n.BlockName  end,b.MaintenanceWorkType Type,h.PPMAgreedDate,h.EndDateTime,h.DowntimeHoursMin,b.MaintenanceDetails Details,b.WorkOrderStatus	
  FROM   EngMaintenanceWorkOrderTxn b 	with(nolock)  
  inner join EngAsset p  with(nolock) on  p.AssetId=b.AssetId 
  left join EngMwoCompletionInfoTxn d   with(nolock) on b.WorkOrderId = d.WorkOrderID 
  left join EngMwoCompletionInfoTxn e with(nolock) on e.CompletionInfoId = d.CompletionInfoId 
  left join MstLocationUserLocation o  with(nolock) on o.UserLocationId=p.UserLocationId 
  left join MstLocationUserArea l on o.UserAreaId=l.UserAreaId 
  left join MstLocationBlock n on n.BlockId=l.BlockId 
  left join EngMwoCompletionInfoTxn h on b.WorkOrderId=h.WorkOrderId   
  where b.ServiceId=2  and   b.FacilityId = @Hospital_Id AND  b.MaintenanceWorkCategory  ='187' and b.TypeOfWorkOrder = 30
  AND  CAST(b.TargetDateTime AS DATE) Between @From_Date and @To_Date	 

else

  insert into #final1(  hospital_id,AssetRegisterId,work_order_id,Work_Order_No,Scheduled_Date, user_location_code,user_location_name,Asset_Number,asset_description,user_department_name,
								mainteinance_type,  agreed_date,Completed_Date,Total_Down_Time,Details,Status) 

  SELECT  distinct b.FacilityId HospitalId,b.AssetId AssetRegisterId,b.WorkOrderId,b.MaintenanceWorkNo,b.MaintenanceWorkDateTime,o.UserLocationCode,o.UserLocationName,
  case when b.TypeOfWorkOrder=30 then '' else  p.AssetNo end , case when b.TypeOfWorkOrder=30 then '' else p.AssetDescription end ,
  case when b.TypeOfWorkOrder=30 then n.BlockName  else n.BlockName  end,b.MaintenanceWorkType Type,h.PPMAgreedDate,h.EndDateTime,h.DowntimeHoursMin,b.MaintenanceDetails Details,b.WorkOrderStatus	
  FROM   EngMaintenanceWorkOrderTxn b 	with(nolock)  
  inner join EngAsset p  with(nolock) on  p.AssetId=b.AssetId 
  left join EngMwoCompletionInfoTxn d   with(nolock) on b.WorkOrderId = d.WorkOrderID 
  left join EngMwoCompletionInfoTxn e with(nolock) on e.CompletionInfoId = d.CompletionInfoId 
  left join MstLocationUserLocation o  with(nolock) on o.UserLocationId=p.UserLocationId 
  left join MstLocationUserArea l on o.UserAreaId=l.UserAreaId 
  left join MstLocationBlock n on n.BlockId=l.BlockId 
  left join EngMwoCompletionInfoTxn h on b.WorkOrderId=h.WorkOrderId   
  where b.ServiceId=2  and   b.FacilityId = @Hospital_Id 


 select              
v.CustomerName as 'Company_Name',
'' as 'State_Name',
v.FacilityName as 'Hospital_Name',
v.FacilityId as 'Hospital_Id',
work_order_id as 'Work_Order_Id', 
Work_Order_No as 'Work_Order_No',
ISNULL(FORMAT(Scheduled_Date,'dd-MMM-yyyy HH:mm'),'') as 'Scheduled_Date', 
user_location_code as 'User_Location_Code',
user_location_name as 'User_Location_Name',
case when t.mainteinance_type='RI'  then '' else Asset_Number END as 'Asset_Number',
case when t.mainteinance_type='RI'  then '' else asset_description END as 'Asset_Description',             
user_department_name as 'Department', 
dbo.Fn_DisplayNameofLov(mainteinance_type) as 'Maintenance_Type',  
ISNULL(FORMAT(agreed_date,'dd-MMM-yyyy'),'') as 'Agreed_Date',
ISNULL(FORMAT(Completed_Date,'dd-MMM-yyyy'),'') as 'Completed_Date',
Total_Down_Time as 'Total_Down_Time_Hrs',
Details as 'Details',
(select fieldvalue from FMLovMst where lovid=t.Status) as 'Status' ,
case when t.mainteinance_type='RI' then '' else	cast((DATEDIFF(m, EAR.PurchaseDate, GETDATE())/12) as varchar) + '.' + 
CASE WHEN DATEDIFF(m, EAR.PurchaseDate, GETDATE())%12 = 0 THEN '0' 
ELSE cast((DATEDIFF(m, EAR.PurchaseDate, GETDATE())%12) as varchar) END  END as AssetAge ,
case when t.mainteinance_type='RI'  then '' else  	EATC.AssetTypeCode END as TypeCode,
GWGDM.WorkGroupCode  AS WorkGroup	
from #final1 T 
Inner join V_MstLocationFacility v on v.FacilityId	= t.hospital_id  
left JOIN DBO.EngAsset  EAR	  with(nolock) on EAR.AssetId	 = t.AssetRegisterId  
left JOIN DBO.EngAssetTypeCode EATC   with(nolock) on EATC.AssetTypeCodeId	 = EAR.AssetTypeCodeId   
left JOIN DBO.EngAssetWorkGroup  GWGDM  with(nolock) on GWGDM.WorkGroupId		 = EAR.WorkGroupId       



END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                               
END       
     


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
