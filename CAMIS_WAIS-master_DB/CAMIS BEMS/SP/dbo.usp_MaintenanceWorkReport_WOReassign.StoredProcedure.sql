USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport_WOReassign]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport_WOReassign](  
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
 
 SELECT
			
				MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			format(MaintenanceWorkOrder.MaintenanceWorkDateTime, 'dd-MMM-yyyy HH:mm')		AS MaintenanceWorkDateTime,
			WorkOrderCategory.FieldValue						AS WorkOrderCategory,

			UserReg.StaffName									AS OldAssignedStaffName,
			UserReg.StaffName									AS NewAssignedStaffName,
			format(MwoTransfer.AssignedDate	, 'dd-MMM-yyyy')							AS AssignedDate
			
			
		
			
	FROM	EngMwoTransferTxn									AS MwoTransfer
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoTransfer.WorkOrderId							= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN	EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId						= Asset.AssetId
			INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoTransfer.ServiceId							= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UserReg							WITH(NOLOCK)			on MwoTransfer.AssignedUserId						= UserReg.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS TransferReason					WITH(NOLOCK)			on MwoTransfer.TransferReasonLovId					= TransferReason.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderCategory				WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory		= WorkOrderCategory.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderStatus			= WorkOrderStatus.LovId
	WHERE	MaintenanceWorkOrder.MaintenanceWorkNo = @MaintenanceWorkNo 
	--ORDER BY MaintenanceWorkOrder.ModifiedDate ASC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
