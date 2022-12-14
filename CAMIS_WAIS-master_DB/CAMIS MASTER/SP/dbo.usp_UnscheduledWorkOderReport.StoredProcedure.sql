USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_UnscheduledWorkOderReport]    Script Date: 20-09-2021 16:43:00 ******/
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
CREATE PROCEDURE  [dbo].[usp_UnscheduledWorkOderReport](
		@Level				VARCHAR(20) = NULL,  
		@Facility_Id		VARCHAR(10) = '',  
		@From_Date			VARCHAR(50) = '',  
		@To_Date			VARCHAR(50) = '',  
		@WorkOrderPriority	INT = '',
		@WorkOrderCategory	INT=''  
)  
AS  
BEGIN  
  
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
 WorkOrderPriority	NVARCHAR(100),   
 WorkOrderCategory	NVARCHAR(100),
 FACILITYNAME		NVARCHAR(200),
 CUSTOMERYNAME		NVARCHAR(200)
)     

	INSERT INTO @@MaintenanceWorkReport(ASSETID, ASSETNO, AssetDescription, WORKORDERID, WorkOrderNo, 
	WorkOrderPriority, WorkOrderCategory, FACILITYNAME, CUSTOMERYNAME)

	SELECT EMWO.ASSETID, EA.ASSETNO, EA.AssetDescription, WORKORDERID, MaintenanceWorkNo, WOP.FieldValue AS WorkOrderPriority, 
	MWO.FieldValue AS MaintenanceWorkCategory,	MLF.FacilityName, MC.CustomerName
	FROM EngMaintenanceWorkOrderTxn AS EMWO
	INNER JOIN	ENGASSET AS EA WITH (NOLOCK) ON EA.ASSETID = EMWO.ASSETID
	INNER JOIN	MstLocationFacility AS MLF WITH (NOLOCK) ON MLF.FACILITYID = EMWO.FACILITYID
	INNER JOIN	MstCustomer AS MC WITH (NOLOCK) ON MC.CustomerId = EMWO.CustomerId
	LEFT JOIN		fmlovmst AS MWO WITH (NOLOCK) ON MWO.LOVID = EMWO.MaintenanceWorkType
	LEFT JOIN		fmlovmst AS WOP WITH (NOLOCK) ON WOP.LOVID = EMWO.WorkOrderPriority
	WHERE	EMWO.MaintenanceWorkCategory =188  and ((EMWO.FacilityId = @Facility_Id) or (@Facility_Id IS NULL) OR (@Facility_Id = ''))
	AND		((EMWO.WorkOrderPriority = @WorkOrderPriority) OR (@WorkOrderPriority IS NULL) OR (@WorkOrderPriority = ''))
	AND		CAST(emwo.MaintenanceWorkDateTime AS DATE) BETWEEN	CAST(@From_Date AS DATE)  AND CAST(@To_Date AS DATE)
	AND		((EMWO.MaintenanceWorkType = @WorkOrderCategory) OR (@WorkOrderCategory IS NULL) OR (@WorkOrderCategory = ''))
  

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

	SELECT  ASSETID, ASSETNO, AssetDescription, WORKORDERID, WorkOrderNo, WorkOrderPriority, WorkOrderCategory, 
		FACILITYNAME, CUSTOMERYNAME,
		ISNULL(@From_Date,'') AS FromDateParam,  
		ISNULL(@To_Date,'') AS ToDateParam,
		ISNULL(@WorkOrderPriorityParam,'') AS WorkOrderPriorityParam,
		ISNULL(@WorkOrderCategoryParam,'') AS WorkOrderCategoryParam
	From @@MaintenanceWorkReport

END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
