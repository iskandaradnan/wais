USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_UnscheduledWorkOderReport_L2_Header]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name : UE-Track                  
Version    :                   
File Name   :    
Report Name		: Unscheduled Work Oder Report
Procedure Name  : usp_UnscheduledWorkOderReport     
Author(s) Name(s) : Ganesan S    
Date    : 21/05/2018    
Purpose    : SP to Check Service Request    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
EXEC SPNAME Parameter        
 
EXEC usp_UnscheduledWorkOderReport @Facility_Id= '1',@From_Date='2015-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000'
,@WorkOrderPriority=227, @WorkOrderCategory = 187
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/       
CREATE PROCEDURE  [dbo].[usp_UnscheduledWorkOderReport_L2_Header](
		--@Level				VARCHAR(20) = NULL,  
		@Facility_Id		VARCHAR(10) = '',  
		@From_Date			VARCHAR(50) = '',  
		@To_Date			VARCHAR(50) = '',  
		@WorkOrderPriority	INT = '',
		@WorkOrderCategory	INT=''  ,
		@MaintenanceWorkNo  varchar(200)=''  
)  
AS  
BEGIN  
  
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
BEGIN TRY    

     
	DECLARE @WorkOrderPriorityParam NVARCHAR(100)  
	DECLARE @WorkOrderCategoryParam NVARCHAR(100) 

	IF(ISNULL(@WorkOrderPriority,'') <> '')  
	BEGIN   

	    

		SELECT @WorkOrderPriorityParam = FieldValue FROM fmlovmst WHERE LOVID = @WorkOrderPriority  
	END  
	IF(ISNULL(@WorkOrderCategory,'') <> '')  
	BEGIN   
		SELECT @WorkOrderCategoryParam = FieldValue FROM fmlovmst WHERE LOVID = @WorkOrderCategory  
	END


	
  SELECT  EMWO.MaintenanceWorkNo
		,format(EMWO.MaintenanceWorkDateTime, 'dd-MMM-yyyy HH:mm')MaintenanceWorkDateTime
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
		,EMWO.TargetDateTime
		,Emwo.MaintenanceDetails
		,EMWO.ASSETID, WORKORDERID   
		,ISNULL(@From_Date,'') AS FromDateParam,  
        ISNULL(@To_Date,'') AS ToDateParam,
        ISNULL(@WorkOrderPriorityParam,'') AS WorkOrderPriorityParam,
		--EMWO.WorkOrderPriority,
		--EMWO.MaintenanceWorkCategory		AS MaintenanceWorkCategory,
		Mtype.FieldValue				AS WorkCategoryValue,
        ISNULL(@WorkOrderCategoryParam,'') AS WorkOrderCategoryParam,
		
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
	WHERE EMWO.MaintenanceWorkNo=@MaintenanceWorkNo  	


END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
