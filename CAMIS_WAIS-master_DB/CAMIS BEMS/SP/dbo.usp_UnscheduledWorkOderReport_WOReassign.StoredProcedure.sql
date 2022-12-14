USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_UnscheduledWorkOderReport_WOReassign]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE PROCEDURE  [dbo].[usp_UnscheduledWorkOderReport_WOReassign](
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


	
  SELECT	

			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			format(MaintenanceWorkOrder.MaintenanceWorkDateTime ,'dd-MMM-yyyy HH:mm')		AS MaintenanceWorkDateTime,
			format(MwoTransfer.AssignedDate						,'dd-MMM-yyyy HH:mm')	   AS AssignedDate,
			TransferReason.FieldValue							      AS TransferReasonValue,
			UserReg.StaffName									AS OldAssignedStaffName,
			UserReg.StaffName									AS NewAssignedStaffName
			
		
	FROM	EngMwoTransferTxn									AS MwoTransfer
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoTransfer.WorkOrderId							= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN	EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId						= Asset.AssetId
			INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoTransfer.ServiceId							= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UserReg							WITH(NOLOCK)			on MwoTransfer.AssignedUserId						= UserReg.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS TransferReason					WITH(NOLOCK)			on MwoTransfer.TransferReasonLovId					= TransferReason.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderCategory				WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory		= WorkOrderCategory.LovId
			
	 WHERE MaintenanceWorkOrder.MaintenanceWorkNo=@MaintenanceWorkNo  	


END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
