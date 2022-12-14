USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_FM_FmsContractDetailsAndDuration_L3_New]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name : ASIS                  
Version       :                   
File Name      : usp_FM_FmsContractDetailsAndDuration_L3                  
Procedure Name  : usp_FM_FmsContractDetailsAndDuration_L3   
Author(s) Name(s) : Balaji M S    
Date       :     
Purpose       : SP For Contract Details and Duration of Contract Report  Level 2    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        

EXEC [usp_FM_FmsContractDetailsAndDuration_L3] '1','2','1','2018'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                    
CREATE PROCEDURE [dbo].[usp_FM_FmsContractDetailsAndDuration_L3_New]                                        
(                                                    
  @Facility_Id varchar(5),
  @Service_Id varchar(5),
  @Contractor_Id varchar(MAX),         
  @Year varchar(5)    
 )                 
AS                                                    
BEGIN                                      
SET NOCOUNT ON                                         
DECLARE @Query VARCHAR(MAX),@SubQuery VARCHAR(MAX),@Prev_Year INT,@table_name varchar(MAX), @St_date varchar(12),@End_date varchar(12) ,@count int ,@contract_type varchar(MAX)         
 /***********************************************************************/            
      /*
   SET @St_date = DATEADD(month,cast(@Month as int)-1,DATEADD(year,cast(@Year as int)-1900,0)) /*First*/  
  --PRINT @St_date  
  set @St_date = convert(date,@St_date,106)  
  --print @st_date  
  SET @End_date = DATEADD(SS, -1, DATEADD(MONTH, cast(@Month as int), DATEADD(YEAR, cast(@Year as int)-1900, 0)))  
  --PRINT @End_date  
  set @End_date = convert(date,@End_date,106)  
  --PRINT @End_date  
         
set @contract_type =''         
 --SET @SubQuery = 'AND b.ContractStartDate >= '''+@St_date+''' and b.ContractEndDate <= '''+@End_date+'''' 
--SET @SubQuery = 'AND b.ContractStartDate >= '''+@St_date+''' and b.ContractEndDate <= '''+convert(varchar(12),convert(date,getdate(),103))+''''

SET @SubQuery = 'and  ( ( month(ContractStartDate) <= '+@Month+ ' and year(ContractStartDate) = '+@Year+ ' and month(ContractEndDate) >= '+@Month+ ' and year(ContractEndDate) ='+@Year +' ) OR ' 

SET @SubQuery = @SubQuery+' ( month(ContractStartDate) > '+@Month+ ' and year(ContractStartDate) < '+@Year+ ' and month(ContractEndDate) >= '+@Month+ ' and year(ContractEndDate) ='+@Year +' ) OR '

SET @SubQuery = @SubQuery+' ( month(ContractStartDate) <= '+@Month+ ' and year(ContractStartDate) <= '+@Year+ ' and month(ContractEndDate) >= '+@Month+ ' and year(ContractEndDate) >='+@Year +' ) OR '

SET @SubQuery = @SubQuery+' ( month(ContractStartDate) <= '+@Month+ ' and year(ContractStartDate) <= '+@Year+ ' and month(ContractEndDate) <= '+@Month+ ' and year(ContractEndDate) >='+@Year  +' ) ) '
*/

--SET @SubQuery = ' and  ( YEAR(ContractStartDate) = '+@Year+' OR YEAR(ContractEndDate) = '+@Year+')'
SET @SubQuery = ' and  ( '+ @Year  + ' between YEAR(ContractStartDate) and YEAR(ContractEndDate) '+')'
    
       
 CREATE TABLE  #final 
 (        
  row_id int identity(1,1),        
  hospital_id varchar(50),          
  hospital_name varchar(500),   
  contract_no nVarchar(100),
  contract_type varchar(100),
  contractor_name varchar(100),
  contract_start_date varchar(100),
  contract_end_date varchar(100) 
 )       
 
 
    if(@Service_Id = 2)
 BEGIN      
    SET @Query='SELECT   b.FacilityId,a.FacilityName,b.ContractNo,
       dbo.fn_DisplayNameOfLov(e.ContractType),  
	   d.ContractorName,
    convert(varchar,b.ContractStartDate,106), convert(varchar,b.ContractEndDate,106)
     FROM MstLocationFacility a   ,EngContractOutRegister b,   MstLocationFacility c,MstContractorandVendor d , EngContractOutRegisterDet e where a.FacilityId=b.FacilityId            
     and b.FacilityId='''+@Facility_Id+'''    '+@SubQuery+' and b.FacilityId = c.FacilityId and d.ContractorId = '+@Contractor_Id +'       
     and b.serviceid=2 and b.ContractorId = d.ContractorId   and   b.ContractId=e.ContractId 
      GROUP BY b.FacilityId, a.FacilityName,b.ContractNo,d.ContractorName,e.ContractType,b.ContractStartDate,b.ContractEndDate'               
  END 
   
   
     
 PRINT   @Query          
 insert into #final EXEC (@Query)       
 
  CREATE TABLE  #final1 
 (        
  row_id int identity(1,1),        
  hospital_id varchar(50),          
  hospital_name varchar(500),       
  contract_no nVarchar(100),
  contract_type varchar(100),
  contractor_name varchar(100),
  count int,
  contract_start_date varchar(100),
  contract_end_date varchar(100)
 )       
 
 
 insert into #final1(hospital_id,hospital_name,contract_no,count,contract_start_date,contract_end_date) 
 select distinct hospital_id,hospital_name,contract_no, COUNT (distinct contract_type),contract_start_date,contract_end_date 
 from #final group by hospital_id,hospital_name,contract_no,contract_start_date,contract_end_date
 
declare @cnt int =1

Select @count= COUNT(*) From #final1 
 Declare @No_of_Records INT
Select @No_of_Records= COUNT(*) From #final

while @cnt <= @count
begin

if @count > @cnt
begin
select @contract_type = @contract_type + contract_type +',' from #final where row_id=@cnt 
end
else
begin
select @contract_type = @contract_type + contract_type  from #final where row_id=@cnt 
end
set @cnt = @cnt+1

print '@contract_type'
print @contract_type
end
 
update #final1
set contract_type = @contract_type
 
 
 
       
  select
    
 -- hospital_id as 'Hospital_Id',          
  hospital_name as 'Hospital_Name',       
  contract_no as 'Contract_No',
  contractor_name  as 'Contract_Name',
  contract_type as 'Contract_Type',
  --CONVERT(VARCHAR(12),contract_start_date,106) as 'Contract_Start_Date',
  format(cast(contract_start_date as Date),'dd-MMM-yyyy') as Contract_Start_Date,
  format(cast(contract_end_date as Date),'dd-MMM-yyyy') as Contract_End_Date--,
  --CONVERT(VARCHAR(12),contract_end_date,106) as 'Contract_End_Date'
 -- @No_of_Records As 'Total_Records'
 -- ,dbo.Fn_GetLogo(hospital_id,'company') as 'Company_Logo',
-- dbo.Fn_GetLogo(hospital_id,'MOH') as 'MOH_Logo'
    from #final         

    DROP TABLE #final   


 SET NOCOUNT OFF  
                                                
END
GO
