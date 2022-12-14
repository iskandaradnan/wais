USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name : UE-Track                  
Version    :                   
File Name   :                  
Procedure Name  : usp_MaintenanceWorkReport     
Author(s) Name(s) : Ganesan S    
Date    : 21/05/2018    
Purpose    : SP to Check Service Request    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
EXEC SPNAME Parameter        
 
EXEC usp_MaintenanceWorkReport @Facility_Id= '1',@From_Date='2015-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000'
,@ContractType=279, @MaintenanceType = 81  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/       
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport](  
		@Facility_Id		VARCHAR(10) = '',  
		@From_Date			VARCHAR(50) = '',  
		@To_Date			VARCHAR(50) = '',  
		@MaintenanceType	varchar(200)='' , 
		@ContractType		varchar(200)=''  
)  
AS  
BEGIN  
  
  if(isnull(@MaintenanceType,'') ='null')
  begin
 set @MaintenanceType=null 
  end
    
  if(@ContractType='null' or @ContractType is null)
  begin
 set @ContractType='' 
  end


SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
BEGIN TRY    

DECLARE  @@MaintenanceWorkReport TABLE(      
 RowId				INT IDENTITY(1,1), 
 AssetId			INT,
 ASSETNO			NVARCHAR(256),
 AssetDescription	NVARCHAR(256),
 WORKORDERID		INT,
 WorkOrderNo		NVARCHAR(256), 
 MaintenanceType	NVARCHAR(100),   
 ContractType		NVARCHAR(100),
 FACILITYNAME		NVARCHAR(200),
 CUSTOMERYNAME		NVARCHAR(200)
)     

	INSERT INTO @@MaintenanceWorkReport(ASSETID, ASSETNO, AssetDescription, WORKORDERID, WorkOrderNo, 
	MaintenanceType, FACILITYNAME, CUSTOMERYNAME, ContractType)

	SELECT EMWO.ASSETID, EA.ASSETNO, EA.AssetDescription, WORKORDERID,    MaintenanceWorkNo,Mtype.FieldValue  as MaintenanceWorkType, 
	MLF.FacilityName, MC.CustomerName, CONT.FieldValue AS ContractType 
	FROM EngMaintenanceWorkOrderTxn AS EMWO
	INNER JOIN	ENGASSET AS EA WITH (NOLOCK) ON EA.ASSETID = EMWO.ASSETID
	INNER JOIN	MstLocationFacility AS MLF WITH (NOLOCK) ON MLF.FACILITYID = EMWO.FACILITYID
	INNER JOIN	MstCustomer AS MC WITH (NOLOCK) ON MC.CustomerId = EMWO.CustomerId
	LEFT JOIN		fmlovmst AS CONT WITH (NOLOCK) ON CONT.LOVID = EA.ContractType
    LEFT JOIN		fmlovmst AS Mtype WITH (NOLOCK) ON Mtype.LOVID = EMWO.MaintenanceWorkType
	WHERE	EMWO.MaintenanceWorkCategory =187 and  ((EMWO.FacilityId = @Facility_Id) or (@Facility_Id IS NULL) OR (@Facility_Id = ''))
	AND		((EMWO.MaintenanceWorkType = @MaintenanceType) OR (@MaintenanceType IS NULL) OR (@MaintenanceType = ''))
	and		cast(emwo.MaintenanceWorkDateTime AS DATE) BETWEEN	CAST(@From_Date AS DATE)  AND CAST(@To_Date AS DATE)
	AND		((EA.ContractType = @ContractType) OR (@ContractType IS NULL) OR (@ContractType = ''))
  
  
DECLARE @MaintenanceTypeParam NVARCHAR(100)  
DECLARE @ContractTypeParam NVARCHAR(100) 

IF(ISNULL(@ContractType,'') <> '')  
BEGIN   
 SELECT @ContractTypeParam = FieldValue FROM fmlovmst WHERE LOVID = @ContractType  
END 

IF(ISNULL(@MaintenanceType,'') <> '')  
BEGIN   
 SELECT @MaintenanceTypeParam = FieldValue FROM fmlovmst WHERE LOVID = @MaintenanceType  
END  
 
SELECT  *,
  ISNULL(@From_Date,'') AS FromDateParam,  
  ISNULL(@To_Date,'') AS ToDateParam,
  ISNULL(@ContractTypeParam,'') AS ContractTypeParam,
  ISNULL(@MaintenanceTypeParam,'') AS MaintenanceTypeParam
  
From @@MaintenanceWorkReport

END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
