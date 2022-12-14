USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BemsContractOutRegisterRPT_L2]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: usp_BemsContractOutRegisterRPT_L2 
Author(s) Name(s)	:  
Date				:  
Purpose				: SP to Check Contract Out Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC [usp_BemsContractOutRegisterRPT_L2]  '@Hospital_Id','@Status','@FromDate','@ToDate'   
EXEC [usp_BemsContractOutRegisterRPT_L2] '1','1','15-may-2016','30-june-2018'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   
 			          
CREATE PROCEDURE  [dbo].[usp_BemsContractOutRegisterRPT_L2]                            
(      	--@ContractorId                     VARCHAR(10) ,
		@Hospital_Id                     VARCHAR(10),
		@Status                           VARCHAR(10),
		--@ContractNo                       VARCHAR(100) 
		@From_Date						  VARCHAR(20) ,
		@To_Date						  VARCHAR(20)  
 )           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                  


CREATE TABLE #RESULT   
 (  
		RowId								INT IDENTITY(1,1),
		ContractNo							NVARCHAR(100),
		ContractorCode						NVARCHAR(200),
		ContractorName						NVARCHAR(200),
		ContractorType						INT,
		Scope								NVARCHAR(400),
		ContractSum							NUMERIC(24,2),
		Status								INT,
		Contract_Start_Date					DATETIME,
	    Contract_Expiry_Date				DATETIME,
		HospitalID							VARCHAR(10)
 ) 
    

INSERT	INTO #RESULT
(
		ContractNo,
		ContractorCode,
		ContractorName,
		ContractorType,
		Scope,
		ContractSum,
		Status,
		Contract_Start_Date,
		Contract_Expiry_Date,
		HospitalID
)
select	b.ContractNo,
		a.SSMRegistrationCode,
		a.ContractorName,
		a.ContractorType,
		b.ScopeOfWork,
		sum(c.ContractValue),
		b.Status,
		b.ContractStartDate,
		b.ContractEndDate,
		b.FacilityId as HospitalId 		
From	MstContractorandVendor a 
JOIN	EngContractOutRegister b on a.ContractorId	= b.ContractorId
left join EngContractOutRegisterDet c with (Nolock) on c.ContractId=b.ContractId  
where B.Status                  = @Status 
AND   b.FacilityId	            = @Hospital_Id
AND		(
		 (ContractStartDate  BETWEEN @From_Date AND @From_Date OR ContractStartDate  BETWEEN @To_Date AND @To_Date) 
		 or 
		 (ContractEndDate  BETWEEN  @From_Date AND @To_Date OR ContractEndDate  BETWEEN   @From_Date AND @To_Date) 
		)
group by b.ContractNo,
		a.SSMRegistrationCode,
		a.ContractorName,
		a.ContractorType,
		b.ScopeOfWork,
		b.Status,
		b.ContractStartDate,
		b.ContractEndDate,
		b.FacilityId 

order by ContractorName



Select  RowId as 'Sl. No',
		ContractNo												AS 'Contract_Out_Register_No',
		ContractorCode											AS 'Contractor_Code',
		ContractorName											AS 'Contractor_Name',
		dbo.Fn_DisplayNameofLov(ContractorType)					AS 'Contractor_Type',
		Scope													AS 'Scope_Of_Work',
		ContractSum												AS 'Contract_Sum_RM',
		case when Status=1 then 'Valid' else 'Expired' end	AS 'Status',		
		format(cast(Contract_Start_Date as Date),'dd-MMM-yyyy')	AS 'Start_Date',
	    format(cast(Contract_Expiry_Date as Date),'dd-MMM-yyyy')AS 'Expiry_Date'
From	#RESULT     

END TRY
BEGIN CATCH

--throw
insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF

END
GO
