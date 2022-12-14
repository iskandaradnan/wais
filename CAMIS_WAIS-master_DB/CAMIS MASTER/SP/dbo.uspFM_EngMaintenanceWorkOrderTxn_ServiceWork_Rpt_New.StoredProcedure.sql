USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt_New]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : UE-Track BEMS                
Version       :                 
File Name      : BemsServiceWorkOrderRpt_L3                
Procedure Name  : BemsServiceWorkOrderRpt_L3  
Author(s) Name(s) : Ganesan S  
Date       :   04/June/2018
Purpose       : SP For Service Work Report
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
exec uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt @Facility_Id=2, @From_Date='04/01/2015',@To_Date='06/05/2018'
,@Status=195
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
  
exec uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt_New @MenuName='',@Facility_Id=2, @From_Date='04/01/2015',@To_Date='06/05/2018'
,@Status=195
'85','S5_2','','2017','01','Aug/2016','All'  
exec uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt '','85','S2','','','','Sep / 2016' ,'All'
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    

CREATE PROCEDURE [dbo].[uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt_New]               
(                                                   
	@Facility_Id				VARCHAR(20), 
  --@Service_Group				varchar(20), 
	@From_Date					VARCHAR(200),
	@To_Date					VARCHAR(200),
  --@Month_Year					varchar(30),
  --@Service_Work_Type			varchar(30),
	@Status						Varchar(30)           
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
 
 create table #final           
 (          
  row_id int identity(1,1), 
  Facility varchar(50),
  Facility_name nvarchar(200),
  Request_Type varchar(10),
  [status] varchar(10),
  Requestor nvarchar(200),               
  user_location_name nvarchar(200),
  Asset_Number nvarchar(200),
  asset_description nvarchar(1000),
  date_of_Request datetime,
  works_requested nvarchar(510),
  work_order_id varchar(50),
  service_work_No nvarchar(200),
  received_date_time datetime,
  responded_date_Time datetime,
  response_time numeric(13,2),
  completed_date_time datetime,
  repair_hours numeric(13,2),  
  total_downtime numeric(13,2),
  StartDate   datetime,
  EndDate    datetime,
  AssetRealTimeStatus varchar(100),
  ServiceWorkStatus varchar(100),
  QCCode varchar(100),
  QCDescription varchar(300),
  RepairDetails varchar(500),
  Feedback varchar(500),
  WorkOrder_Category Varchar(100)
 ) 

 
  
          
                 
  --select @Service_Work_Type = case when @Service_Work_Type='all' then '0' else @Service_Work_Type end


BEGIN
insert into #final(facility,Requestor,user_location_name,Asset_Number,
asset_description,date_of_Request,works_requested,work_order_id,service_work_No,received_date_time,responded_date_Time,response_time,
completed_date_time,repair_hours,total_downtime,StartDate,EndDate,AssetRealTimeStatus,ServiceWorkStatus,QCCode,QCDescription,
RepairDetails,Feedback,WorkOrder_Category)
SELECT distinct  
		MWO.FacilityId, 
		UserReg.StaffName,
		UL.UserLocationName,
		Asset.AssetNo,
		Asset.AssetDescription,
		MWO.MaintenanceWorkDateTime,
		MWO.MaintenanceDetails as Details,
		MWO.WorkOrderId,
		MWO.MaintenanceWorkNo,
		MWO.MaintenanceWorkDateTime as ReceivedDate,
		Asst.ResponseDateTime, 
		Asst.ResponseDuration,
		td1.EndDateTime as EndDateTime,
		(select sum(RepairHours) from EngMwoCompletionInfoTxnDet where  comp.CompletionInfoId=compDet.CompletionInfoId) as RepairHours,
		Comp.DownTimeHoursMin,
		td2.StartDateTime,
		td3.EndDateTime,
		lov1.FieldValue as RealTimeStatus,
		lov2.FieldValue as WorkOrderStatus,
		lov.FieldValue as QCCode,
		lov.Remarks as QCDescrption,
		Comp.RepairDetails,
		Asst.Justification as AssesmentFeedback,
		lov3.FieldValue as WorkOrderCategory
		FROM EngMaintenanceWorkOrderTxn MWO 	
		inner join EngAsset Asset on  MWO.AssetId = Asset.AssetId 
		left join	MstLocationUserLocation UL WITH(NOLOCK) on MWO.UserLocationId=UL.UserLocationId
		left join  MstLocationUserArea UA WITH(NOLOCK) on UA.UserAreaId=UL.UserAreaId
		left join EngMwoCompletionInfoTxn Comp on MWO.WorkOrderId=Comp.WorkOrderId  
		left join UMUserRegistration UserReg on MWO.RequestorUserId= UserReg.UserRegistrationId
		left join EngMwoAssesmentTxn Asst on Asst.WorkOrderId=MWO.WorkOrderId
		left join EngMwoCompletionInfoTxnDet CompDet on CompDet.CompletionInfoId=Comp.CompletionInfoId
		outer apply ( select max(EndDateTime) as EndDateTime from  EngMwoCompletionInfoTxnDet  td where Comp.CompletionInfoId = td.CompletionInfoId ) td1
		outer apply ( select max(StartDateTime) as StartDateTime from  EngMwoCompletionInfoTxnDet  td where Comp.CompletionInfoId = td.CompletionInfoId) td2
		outer apply ( select max(EndDateTime) as EndDateTime from  EngMwoCompletionInfoTxnDet  td where Comp.CompletionInfoId = td.CompletionInfoId ) td3
		LEFT JOIN FMLovMst Lov on lov.lovid=Comp.QCCode
		LEFT JOIN FMLovMst lov1 on lov1.LovId=Asst.AssetRealtimeStatus
		LEFT JOIN FMLovMst Lov2 on lov2.LovId=MWO.WorkOrderStatus
		LEFT JOIN FMLovMst Lov3 on lov3.LovId=MWO.MaintenanceWorkCategory
		where MWO.FacilityId=@Facility_Id
		and  MWO.MaintenanceWorkCategory ='188' 
		--and MWO.WorkOrderStatus !=196
		--and  ( ( @Service_Work_Type='0' and MWO.Type in (2856,2857,2858,2859)) or  MWO.Type = @Service_Work_Type)	
		and CAST(MWO.MaintenanceWorkDateTime AS DATE) Between @From_Date and @To_Date
    

END                      

select 
 F.CustomerName as 'Customer_Name',
 F.FacilityName as 'Facility_Name',
 F.FacilityId as 'Facility_Id',  
 WorkOrder_Category as 'Service_Work_Type',
 Requestor as 'Requestor',
 user_location_name as 'Location_Of_Fault',
 Asset_Number as 'Asset_Number',
 asset_description as 'Asset_Description',
 ISNULL(FORMAT(date_of_Request,'dd-MMM-yyyy HH:mm'),'') as 'Date_of_Request',
 works_requested as 'Works_Requested',
 work_order_id as 'Work_Order_Id',
 service_work_No as 'Service_Work_No',
 ISNULL(FORMAT(received_date_time,'dd-MMM-yyyy HH:mm'),'') as 'Received_Date_Time',
 ISNULL(FORMAT(responded_date_Time,'dd-MMM-yyyy HH:mm'),'') as 'Responded_Date_Time',
 response_time as 'Response_Time_Hrs',
 format(completed_date_time,'dd-MMM-yyyy HH:mm') as 'Completed_Date_Time',
 repair_hours as 'Works_Carried_Out_Man_Hours_Total_Repair_Hours',
 total_downtime as 'Total_Down_Time',
   --@Service_Work_Type as 'WO_Type',
     ISNULL(FORMAT(StartDate,'dd-MMM-yyyy'),'') as StartDate,
  ISNULL(FORMAT(EndDate,'dd-MMM-yyyy'),'')    as Endate
  ,AssetRealTimeStatus,
  ServiceWorkStatus,
  QCCode ,
  QCDescription ,
  RepairDetails,
  Feedback  
 from #final  T   join V_MstLocationFacility F on T.Facility = F.FacilityId  
 order by  F.CustomerName,F.FacilityName,T.Service_Work_No

   drop table #final 
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                               
END
GO
