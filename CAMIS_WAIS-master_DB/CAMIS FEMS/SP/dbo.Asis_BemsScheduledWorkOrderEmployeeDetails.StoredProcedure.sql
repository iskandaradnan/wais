USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsScheduledWorkOrderEmployeeDetails]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : ASIS                
Version       :                 
File Name      : BemsScheduledWorkOrderEmployeeDetails                
Procedure Name  : BemsScheduledWorkOrderEmployeeDetails  
Author(s) Name(s) : Praveen Kumar K  
Date       :   
Purpose       : SP For Work Order Report     Level 5 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC [BemsScheduledWorkOrderEmployeeDetails] @Level='national',@Level_Key='', @Hospital_Id='1',@Frequency='yearly',      
@Frequency_Key='',@year='2016', @From_Date='',@To_Date='',@PageNumber=1,@PageSize=50  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
  drop proc FemsWorkOrderRpt_L6
exec Asis_BemsScheduledWorkOrderEmployeeDetails '1','2305'
exec Asis_BemsScheduledWorkOrderEmployeeDetails '1','2305','SMW/FEMS/A_H/16/08/000038' 
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
  
CREATE PROCEDURE [dbo].[Asis_BemsScheduledWorkOrderEmployeeDetails]                                      
(                                                  
  @Hospital_Id  VARCHAR(20)     
  ,@Work_Order_Id VARCHAR(20)
    
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY   
DECLARE @Query VARCHAR(4000),@SubQuery VARCHAR(4000),@Prev_Year INT,@table_name varchar(50), @TR int      
                    
  
SET @Query=''  
SET @SubQuery=''  
  


   
   create table #final1           
 (          
  row_id int identity(1,1),               
  Work_Order_no nvarchar(100),            
  employee_name nvarchar(200),    
  employee_id nvarchar(100), 
 -- task_code nvarchar(20),
 -- task_description nvarchar(300), 
  start_date_time datetime,  
  end_date_time datetime,  
  repair_hours numeric(13,2)  
 )   
     insert into #final1(Work_Order_no,employee_name,--employee_id,
	 start_date_time,end_date_time,repair_hours)
	 SELECT  b.MaintenanceWorkNo,c.StaffName,--c.StaffEmployeeId,
	 d.StartDateTime,d.EndDateTime,d.RepairHours   
     FROM EngMaintenanceWorkOrderTxn b left join MstLocationFacility a on a.FacilityId=b.FacilityId and a.CustomerId = b.CustomerId    
     left join EngMwoCompletionInfoTxn d on  b.WorkOrderId = d.WorkOrderId --and d.IsDeleted=0  
     --left join EngMwoCompletionInfoTxnDet e on d.CompletionInfoId=e.CompletionInfoId and e.IsDeleted=0 
     left join UMUserRegistration c on c.UserRegistrationId= d.AcceptedBy --and c.IsDeleted=0  
     where b.FacilityId=@Hospital_Id and b.WorkOrderId=@Work_Order_Id 
     --and b.IsDeleted=0   
	 and b.ServiceId=2 
	 --and a.IsDeleted=0              
            
  
           
 
   
    

 select           
    -- dbo.Fn_GetCompStateName(@Hospital_Id,'Company') as 'Company_Name',
 --dbo.Fn_GetCompStateName(@Hospital_Id,'State') as 'State_Name',  
-- dbo.Fn_DisplayHospitalName(@Hospital_Id) as 'Hospital_Name',                     
  employee_name as 'Employee_Name',           
  employee_id as 'Employee_Id' , 
   ISNULL(FORMAT(start_date_time,'dd-MMM-yyyy HH:MM'),'') as 'Start_Date_Time',   
    ISNULL(FORMAT(end_date_time,'dd-MMM-yyyy HH:MM'),'') as 'End_Date_Time',           
  repair_hours as 'Repair_Hours' ,     
  convert(varchar(20),@TR) as 'Total_Records'
  --,dbo.Fn_GetLogo(@Hospital_Id,'company') as 'Company_Logo'
--, dbo.Fn_GetLogo(@Hospital_Id,'MOH') as 'MOH_Logo'    
 from #final1     
    
 drop table #final1 

  
  
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                             
END
GO
