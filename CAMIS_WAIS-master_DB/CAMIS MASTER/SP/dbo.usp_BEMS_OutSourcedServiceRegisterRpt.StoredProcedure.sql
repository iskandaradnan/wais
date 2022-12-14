USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BEMS_OutSourcedServiceRegisterRpt]    Script Date: 20-09-2021 16:43:00 ******/
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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                     
Modification History                    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS                    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                   
CREATE PROCEDURE  [dbo].[usp_BEMS_OutSourcedServiceRegisterRpt](              
       @Level   VARCHAR(20) = NULL,              
       @Facility_Id  VARCHAR(10) = '',              
       @From_Date  VARCHAR(100) = '',              
       @To_Date   VARCHAR(100) = '',              
       @ContractorCode  INT   = NULL              
       )              
AS              
BEGIN              
              
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
           
BEGIN TRY                
              
DECLARE @@OutSourcedServiceRegisterRpt TABLE(              
ID    INT IDENTITY(1,1),            
FacilityName NVARCHAR(512),            
CustomerName NVARCHAR(512),            
ContractId  INT,            
ContractNo  NVARCHAR(512),            
NoOfExpiredContracts INT,            
NoOfValidContracts  INT,            
TotalNoOfContracts  INT,          
ContractorCode  NVARCHAR(512),    
ContractorId INT         
)            
          
--EXEC usp_BEMS_OutSourcedServiceRegisterRpt @Facility_Id= '1', @From_Date = '2018-6-15 00:00:00.000', @To_Date = '2018-12-06 00:00:00.000'            
            
INSERT INTO @@OutSourcedServiceRegisterRpt( --ContractId, ContractNo,           
FacilityName, CustomerName, ContractorCode, ContractorId, NoOfValidContracts, NoOfExpiredContracts)            
            
SELECT --ECOR.ContractId, ECOR.ContractNo,         
--distinct          
MLF.FacilityName, MC.CustomerName, MCV.SSMRegistrationCode, ECOR.ContractorId,           
SUM(CASE WHEN CAST(ECOR.ContractStartDate AS DATE) >= CAST(@From_Date  AS DATE) AND CAST(ECOR.ContractEndDate  AS DATE) <= CAST(@To_Date AS DATE) THEN 1       
  WHEN CAST(ECOR.ContractStartDate AS DATE) <= CAST(@From_Date  AS DATE) AND CAST(ECOR.ContractEndDate  AS DATE) <= CAST(@To_Date AS DATE) THEN 1      
  WHEN CAST(ECOR.ContractStartDate AS DATE) <= CAST(@From_Date  AS DATE) AND CAST(ECOR.ContractEndDate  AS DATE) >= CAST(@To_Date AS DATE) THEN 1 ELSE 0 END ) AS NoOfExpiredContracts,             
SUM(CASE WHEN CAST(ECOR.ContractStartDate AS DATE) > CAST(@From_Date  AS DATE) AND CAST(ECOR.ContractEndDate  AS DATE) > CAST(@To_Date AS DATE) THEN 1 ELSE 0 END) AS NoOfValidContracts            
          
FROM EngContractOutRegister AS ECOR                   
INNER JOIN MstLocationFacility AS MLF ON MLF.FacilityId = ECOR.FacilityId            
INNER JOIN MstCustomer AS MC ON MC.CustomerId = ECOR.CustomerId            
INNER JOIN MstContractorandVendor AS MCV ON MCV.ContractorId = ECOR.ContractorId        
WHERE   
--ECOR.STATUS = 1   AND    
((ECOR.FacilityId = @Facility_Id) OR (@Facility_Id IS NULL) OR (@Facility_Id = ''))            
AND  ((ECOR.ContractorId = @ContractorCode) OR (@ContractorCode IS NULL) OR (@ContractorCode = ''))     
and ((CAST(ECOR.ContractStartDate AS DATE) between cast(@From_Date  as date ) and CAST(@To_Date  AS DATE) )   
 or (CAST(ECOR.ContractEndDate AS DATE)  between cast(@From_Date  as date ) and CAST(@To_Date  AS DATE) ))    
GROUP BY       MLF.FacilityName, MC.CustomerName, MCV.SSMRegistrationCode , ECOR.ContractorId          



DECLARE @FacilityNameParam NVARCHAR(256)              
DECLARE @CustomerNameParam NVARCHAR(256)              
DECLARE @ContractorCodeParam NVARCHAR(100)              
              
IF(ISNULL(@Facility_Id,'') <> '')              
BEGIN               
 SELECT @FacilityNameParam = FacilityName FROM mstlocationfacility WHERE FacilityId = @Facility_Id              
END              
            
IF(ISNULL(@ContractorCode,'') <> '')              
BEGIN               
 SELECT @ContractorCodeParam = SSMRegistrationCode FROM MstContractorandVendor WHERE ContractorId = @ContractorCode              
            
END              
          
  --select * from @@OutSourcedServiceRegisterRpt        
          
SELECT ContractId, ContractNo, FacilityName, CustomerName, NoOfExpiredContracts, NoOfValidContracts, ContractorCode          
, ISNULL(NoOfExpiredContracts,0) + ISNULL(NoOfValidContracts,0) AS TotalNoOfContracts            
, ISNULL(@From_Date,'') AS FromDateParam            
, ISNULL(@To_Date,'') AS ToDateParam            
, ISNULL(@ContractorCodeParam,'') AS ContractorCodeParam            
, ISNULL(@FacilityNameParam, '') AS  FacilityNameParam               
From @@OutSourcedServiceRegisterRpt          
          
          
END TRY                
BEGIN CATCH                
                
 insert into ErrorLog(Spname,ErrorMessage,createddate)                
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())                
              
END CATCH                
              
SET NOCOUNT OFF                
              
END
GO
