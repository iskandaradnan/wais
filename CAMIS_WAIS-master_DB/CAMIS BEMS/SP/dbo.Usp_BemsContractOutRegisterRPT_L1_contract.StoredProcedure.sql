USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Usp_BemsContractOutRegisterRPT_L1_contract]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name : UETRACK BEMS                  
Version       :                   
File Name      : Usp_BemsContractOutRegisterRPT_L1_contract                
Procedure Name  : Usp_BemsContractOutRegisterRPT_L1_contract   
Author(s) Name(s) : 
Date       :     
Purpose       : SP For Contract Details and Duration of Contract Report  Level 2    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        

EXEC Usp_BemsContractOutRegisterRPT_L1_contract   '','225','127','2017-01-01','2017-04-30'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                    
              
CREATE PROCEDURE [dbo].[Usp_BemsContractOutRegisterRPT_L1_contract]                                        
( 
        @MenuName                         Varchar(200) , 
		@Hospital_Id					  VARCHAR(10),
		@Status							  INT,                                                                      
		@From_Date						  VARCHAR(20),
		@To_Date						  VARCHAR(20)  
 )                 
AS                                                    
BEGIN                                 
                                

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
					
--IF(@Status = 127)
--set @SubqueryStatus							= ' AND b.Status in (''127'')'  
 
--IF(@Status = 128)               
--set @SubqueryStatus							= ' AND b.Status in (''128'')' 

--IF(@Status = 129)               
--set @SubqueryStatus							= ' AND b.Status in (''127'',''128'')' 

 if(@From_Date = '')
 BEGIN
 SET @From_Date = DATEADD(month,cast('01' as int)-1,DATEADD(year,cast('1900' as int)-1900,0))
 print @From_Date
 END
  if(@To_Date = '')
 BEGIN
 SET @To_Date = DATEADD(SS, -1, DATEADD(MONTH, cast('12' as int), DATEADD(YEAR, cast('2099' as int)-1900, 0)))
 print @To_Date
 END

CREATE TABLE #RESULT   
 (  
		RowId                               INT IDENTITY(1,1),
		ContractNo							NVARCHAR(100),
		ContractorName						NVARCHAR(200),
		Status								INT,
		ContractStartDate                   DATETIME,
		ContractEndDate                     DATETIME,
		count                               varchar(50),
		ContractorId                        Varchar(50)
	
 ) 
    
INSERT	INTO #RESULT
(
		
		ContractorName,
		count,
		ContractorId,
		Status
)
select	a.ContractorName,		
		count(DISTINCT b.ContractId) as 'total_count',	
		a.ContractorId,
		case when @Status = 129  then 129 else b.Status end Status
From	MstContractorandVendor a 
JOIN	EngContractOutRegister b with (Nolock) on a.ContractorId	= b.ContractorId
left join EngContractOutRegisterDet c with (Nolock) on c.ContractId=b.ContractId 
where	b.FacilityId				= @Hospital_Id
AND		
		--(CAST(b.ContractStartDate AS DATETIME)			BETWEEN '''+@From_Date+''' AND '''+@To_Date+'''
  --       OR CAST(b.ContractEndDate	AS DATETIME)		BETWEEN '''+@From_Date+''' AND '''+@To_Date+''')
		 ( (@From_Date BETWEEN ContractStartDate AND ContractEndDate
          OR @To_Date BETWEEN ContractStartDate AND ContractEndDate
		 ) 
		 or 
		 (ContractStartDate  BETWEEN    @From_Date AND @To_Date
          OR ContractEndDate  BETWEEN   @From_Date AND @To_Date
		 ) 
	)
AND		b.ServiceId					= 2
AND     b.Status IN (CASE WHEN @Status = 1 THEN '1' 
                          WHEN @Status = 2  THEN '2'
						  WHEN @Status = 129  THEN b.Status --'127,128'
					 END)
group by 
		a.ContractorName,
		a.ContractorId,
		case when @Status = 129  then 129 else b.Status end 
order by a.ContractorName



--Declare @No_of_Records			INT
--Select	@No_of_Records			= COUNT(*) 
--From	#RESULT

Select  RowId as 'Sl.No',
        ContractorId as 'ContractorId',
		--dbo.Fn_GetCompStateName(@Hospital_Id,'Company') as 'Company_Name',
		--dbo.Fn_GetCompStateName(@Hospital_Id,'State') as 'State_Name',
		--dbo.Fn_DisplayHospitalName(@Hospital_Id) as 'Hospital_Name',
		ContractNo												AS 'Contract_Out_Register_No',
		ContractorName											AS 'Contractor_Name',
		count                                                   AS 'Total',
		Status as StatusID,
		case when Status=127 then 'Valid' else 'Expired' end	AS 'Status',		
		format(cast(ContractStartDate as Date),'dd-MMM-yyyy')	AS 'Start_Date',
	    format(cast(ContractEndDate as Date),'dd-MMM-yyyy')AS 'Expiry_Date'
	 --   dbo.Fn_GetLogo(@Hospital_Id,'company') as 'Company_Logo',  
		--dbo.Fn_GetLogo(@Hospital_Id,'MOH') as 'MOH_Logo', 
	 --   @No_of_Records											AS 'Total_Records'
From	#RESULT     

END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF

END
GO
