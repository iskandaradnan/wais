USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BEMS_OutSourcedServiceRegisterRpt_L2]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
Application Name : UE-Track  
Version    :  
File Name   :  
Procedure Name  : usp_BEMS_OutSourcedServiceRegisterRpt  
Author(s) Name(s) : Ganesan S  
Date    : 21/05/2018  
Purpose    : SP to Check Out Sourced Service Register  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
EXEC SPNAME Parameter  
  
EXEC usp_BEMS_OutSourcedServiceRegisterRpt @Facility_Id= '1', @From_Date='2015-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000',@ContractorCode = 25    
EXEC usp_BEMS_OutSourcedServiceRegisterRpt @Facility_Id= '1',@ContractorCode = 22, @From_Date='2015-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000'    
EXEC usp_BEMS_OutSourcedServiceRegisterRpt_L2 @Facility_Id= '1',@ContractorCode = 22, @From_Date='2015-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000'    
    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                 
Modification History                
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS                
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                   
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/               
CREATE PROCEDURE  [dbo].[usp_BEMS_OutSourcedServiceRegisterRpt_L2](          
            
       @Facility_Id  VARCHAR(10) = '',          
       @From_Date  VARCHAR(100) = '',          
       @To_Date   VARCHAR(100) = '',          
       @ContractorCode  VARCHAR(100) = '' ,    
    @WorkOrderno  VARCHAR(100) = ''     
       )          
AS          
BEGIN          
          
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
       
BEGIN TRY            
    
DECLARE @ContractorCodeParam NVARCHAR(100)        
IF(ISNULL(@ContractorCode,'') <> '')          
BEGIN           
 SELECT @ContractorCodeParam = SSMRegistrationCode FROM MstContractorandVendor WHERE SSMRegistrationCode = @ContractorCode          
        
END          

SELECT      
ECOR.ContractId, ECOR.ContractNo,    
MCV.SSMRegistrationCode ContractorCode,Mcv.ContractorName,ECOR.ScopeofWork,MLF.FacilityName, MC.CustomerName ,      
FORMAT(ECOR.ContractStartDate,'dd-MMM-yyyy') as ContractStartDate,      
FORMAT(  ECOR.ContractEndDate ,'dd-MMM-yyyy') as ContractEndDate,sum(ecord.ContractValue) ContractSumValue,     
(case when  ECOR.Status = 1 then 'Active' else 'Inactive'end )  as Status    
FROM EngContractOutRegister AS ECOR       
left JOIN EngContractOutRegisterDet AS ECORD ON ECOR.CONTRACTID = ECORD.CONTRACTID       
INNER JOIN MstLocationFacility AS MLF ON MLF.FacilityId = ECOR.FacilityId       
INNER JOIN MstCustomer AS MC ON MC.CustomerId = ECOR.CustomerId       
INNER JOIN MstContractorandVendor AS MCV ON MCV.ContractorId = ECOR.ContractorId       
WHERE 
--ECOR.STATUS = 1  AND 
((ECOR.FacilityId = @Facility_Id) OR (@Facility_Id IS NULL) OR (@Facility_Id = ''))       
AND ((MCV.SSMRegistrationCode = @ContractorCode) OR (@ContractorCode IS NULL) OR (@ContractorCode = '')) 
and ((CAST(ECOR.ContractStartDate AS DATE) between cast(@From_Date  as date ) and CAST(@To_Date  AS DATE) ) 
	or (CAST(ECOR.ContractEndDate AS DATE)  between cast(@From_Date  as date ) and CAST(@To_Date  AS DATE) )) 
	
	
----and ((cast(@To_Date  as date ) between CAST(ECOR.ContractStartDate AS DATE) and CAST(ECOR.ContractEndDate AS DATE) ) or
----CAST(@From_Date  AS DATE) between CAST(ECOR.ContractStartDate AS DATE) and CAST(ECOR.ContractEndDate AS DATE))

--AND (CAST(ECOR.CreatedDate AS DATE) BETWEEN CAST(@From_Date AS DATE) AND CAST(@To_Date AS DATE))       
--and cast(@To_Date  as date ) >=   CAST(ECOR.ContractStartDate AS DATE)
--and  CAST(ECOR.ContractStartDate AS DATE) > CAST(@From_Date  AS DATE) AND CAST(ECOR.ContractEndDate  AS DATE) < CAST(@To_Date AS DATE)    
--GROUP BY --ECOR.ContractId, ECOR.ContractNo,      
group by ECOR.ContractId, ECOR.ContractNo,MCV.SSMRegistrationCode ,Mcv.ContractorName,ECOR.ScopeofWork,      
MLF.FacilityName, MC.CustomerName , ECOR.ContractStartDate, ECOR.ContractEndDate,ECOR.Status       

  
END TRY            
BEGIN CATCH            
            
 insert into ErrorLog(Spname,ErrorMessage,createddate)            
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())            
          
END CATCH            
          
SET NOCOUNT OFF            
          
END
GO
