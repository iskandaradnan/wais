USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport_L2_D1]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport_L2_D1](  
		@Facility_Id		VARCHAR(10) = '',  
		@From_Date			VARCHAR(50) = '',  
		@To_Date			VARCHAR(50) = '',  
		@MaintenanceType	varchar(200)='' , 
		@ContractType		varchar(200)=''  ,
		@MaintenanceWorkNo  varchar(200)=''  
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
 
  SELECT   EMWO.MaintenanceWorkNo
		,FORMAT(EMWO.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm') as MaintenanceWorkDateTime

        ,MC.CustomerName
		,MLF.FacilityName
		,Mtype.FieldValue  as MaintenanceWorkType
		,CONT.FieldValue AS ContractType 
		,EA.AssetNo
		,EA.AssetDescription
		,Mode.Model
		,Man.Manufacturer
		,EMWO.AssignedUserId
		,AssigneeUser.StaffName AssgneeName
		,FORMAT(EMWO.TargetDateTime,'dd-MMM-yyyy') as TargetDateTime
		,Emwo.MaintenanceDetails
		,EMWO.ASSETID, WORKORDERID   
		,ISNULL(@From_Date,'') AS FromDateParam,  
        ISNULL(@To_Date,'') AS ToDateParam,
        ISNULL(@ContractTypeParam,'') AS ContractTypeParam,

		--EMWO.MaintenanceWorkCategory		AS MaintenanceWorkCategory,
		WorkCategory.FieldValue				AS WorkCategoryValue,
        ISNULL(@MaintenanceTypeParam,'') AS MaintenanceTypePara,
		
	    WorkOrderPriority.FieldValue		AS WorkOrderPriorityValue
	FROM EngMaintenanceWorkOrderTxn AS EMWO
	INNER JOIN	ENGASSET AS EA WITH (NOLOCK) ON EA.ASSETID = EMWO.ASSETID
	INNER JOIN	MstLocationFacility AS MLF WITH (NOLOCK) ON MLF.FACILITYID = EMWO.FACILITYID
	INNER JOIN	MstCustomer AS MC WITH (NOLOCK) ON MC.CustomerId = EMWO.CustomerId
	LEFT JOIN		fmlovmst AS CONT WITH (NOLOCK) ON CONT.LOVID = EA.ContractType
    LEFT JOIN		fmlovmst AS Mtype WITH (NOLOCK) ON Mtype.LOVID = EMWO.MaintenanceWorkType
	Left JOIN	EngAssetStandardizationModel AS Mode WITH (NOLOCK) ON Mode.ModelId = EA.Model
	Left JOIN	EngAssetStandardizationManufacturer AS Man WITH (NOLOCK) ON Man.ManufacturerId = EA.Manufacturer
	Left JOIN	UMUserRegistration AS AssigneeUser WITH (NOLOCK) ON AssigneeUser.UserRegistrationId = EMWO.AssignedUserId
	LEFT  JOIN  FMLovMst					AS WorkOrderPriority				WITH(NOLOCK)			on EMWO.WorkOrderPriority		= WorkOrderPriority.LovId
	LEFT  JOIN  FMLovMst					AS WorkCategory						WITH(NOLOCK)			on EMWO.MaintenanceWorkCategory	= WorkCategory.LovId
	WHERE EMWO.MaintenanceWorkNo=@MaintenanceWorkNo and 	EMWO.MaintenanceWorkCategory =187 --and  ((EMWO.FacilityId = @Facility_Id) or (@Facility_Id IS NULL) OR (@Facility_Id = ''))
	--AND		((EMWO.MaintenanceWorkType = @MaintenanceType) OR (@MaintenanceType IS NULL) OR (@MaintenanceType = ''))
	--and		cast(emwo.MaintenanceWorkDateTime AS DATE) BETWEEN	CAST(@From_Date AS DATE)  AND CAST(@To_Date AS DATE)
	--AND		((EA.ContractType = @ContractType) OR (@ContractType IS NULL) OR (@ContractType = ''))
  



END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
