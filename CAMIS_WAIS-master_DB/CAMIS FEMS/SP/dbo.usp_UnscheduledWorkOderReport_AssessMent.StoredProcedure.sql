USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_UnscheduledWorkOderReport_AssessMent]    Script Date: 20-09-2021 16:56:52 ******/
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
CREATE PROCEDURE  [dbo].[usp_UnscheduledWorkOderReport_AssessMent](
		@Level				VARCHAR(20) = NULL,  
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


	
  SELECT	   MwoAssesment.Justification							AS Feedback,
           format(MwoAssesment.ResponseDateTime	,'dd-MMM-yyyy HH:mm') AS ResponseDateTime,
		   AssetRealtimeStatus.FieldValue						AS RealtimeStatus,
		   	MwoAssesment.ResponseDuration,
		    LovChangeToVendor.FieldValue						AS IsChangeToVendorValue,
			Contractor.ContractorName							AS AssignedVendorName
			
	FROM	EngMwoAssesmentTxn									AS MwoAssesment
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoAssesment.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoAssesment.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UMUser							WITH(NOLOCK)			on MwoAssesment.UserId				= UMUser.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS EngineerStaffId					WITH(NOLOCK)			on MaintenanceWorkOrder.EngineerUserId			= EngineerStaffId.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS AssetRealtimeStatus				WITH(NOLOCK)			on MwoAssesment.AssetRealtimeStatus	= AssetRealtimeStatus.LovId
			LEFT  JOIN  FMLovMst								AS LovChangeToVendor				WITH(NOLOCK)			on MwoAssesment.IsChangeToVendor	= LovChangeToVendor.LovId
			LEFT  JOIN  MstContractorandVendor					AS Contractor						WITH(NOLOCK)			on MwoAssesment.AssignedVendor		= Contractor.ContractorId
			LEFT  JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderStatus			= WorkOrderStatus.LovId
	 WHERE MaintenanceWorkOrder.MaintenanceWorkNo=@MaintenanceWorkNo  	


END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
