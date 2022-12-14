USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsScheduledWorkOrderSparePartDetails]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : ASIS                
Version       :                 
File Name      : BemsScheduledWorkOrderSparePartDetails                
Procedure Name  : BemsScheduledWorkOrderSparePartDetails  
Author(s) Name(s) : Praveen Kumar K  
Date       :   
Purpose       : SP For Work Order Report     Level 6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC [Asis_BemsScheduledWorkOrderSparePartDetails] @Level='national',@Level_Key='', @Hospital_Id='1',@Frequency='yearly',      
@Frequency_Key='',@year='2016', @From_Date='',@To_Date='',@PageNumber=1,@PageSize=50  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
  
exec Asis_BemsScheduledWorkOrderSparePartDetails '1','2305'
exec Asis_BemsScheduledWorkOrderSparePartDetails '1','2305','SMW/FEMS/A_H/16/08/000038' 
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
  
CREATE PROCEDURE [dbo].[Asis_BemsScheduledWorkOrderSparePartDetails]                                      
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
  create table #final           
 (          
  row_id int identity(1,1),               
  PART_no nvarchar(100),            
  part_description nvarchar(200),    
  item_no nvarchar(300),  
  quantity numeric(13,2),    
  cost numeric(13,2)  
 )   

 
  insert into #final(PART_no,part_description,item_no,quantity,cost)
    SELECT  e.PartNo,e.PartDescription,f.ItemDescription,d.Quantity,d.Cost   
     FROM EngMaintenanceWorkOrderTxn b left join MstLocationFacility a on a.FacilityId=b.FacilityId and a.CustomerId = b.CustomerId    
     left join EngMwoPartReplacementTxn d on  b.WorkOrderId = d.WorkOrderId --and d.IsDeleted=0  
     left join EngSpareParts e on d.SparePartStockRegisterId=e.SparePartsId --and e.IsDeleted=0  
	 join FMItemMaster f on f.ItemId = e.ItemId
     where b.FacilityId=@Hospital_Id  and b.WorkOrderId=@Work_Order_Id 
     --and b.IsDeleted=0   
	 and b.ServiceId=2 --and a.IsDeleted=0               
            
  
           
         
         
  
   
     
 select     
    -- dbo.Fn_GetCompStateName(@Hospital_Id,'Company') as 'Company_Name',
 --dbo.Fn_GetCompStateName(@Hospital_Id,'State') as 'State_Name',  
-- dbo.Fn_DisplayHospitalName(@Hospital_Id) as 'Hospital_Name',                           
  PART_no as 'Part_No.',           
  part_description as 'Part_Description' ,  
   item_no as 'Item_No',   
  quantity as 'Quantity',           
  cost as 'Cost_RM'      
 -- convert(varchar(20),@TR) as 'Total_Records'
  --,dbo.Fn_GetLogo(@Hospital_Id,'company') as 'Company_Logo'
--, dbo.Fn_GetLogo(@Hospital_Id,'MOH') as 'MOH_Logo'    
 from #final          
    
  
     
drop table #final  
  
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                              
END
GO
