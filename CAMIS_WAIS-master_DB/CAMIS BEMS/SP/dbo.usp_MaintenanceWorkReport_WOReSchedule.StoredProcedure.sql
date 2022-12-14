USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport_WOReSchedule]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport_WOReSchedule](  
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
			WorkOrder.MaintenanceWorkNo											AS MaintenanceWorkNo,
			format(WorkOrder.MaintenanceWorkDateTime, 'dd-MMM-yyyy')			AS MaintenanceWorkDateTime,
			Asset.AssetNo														AS AssetNo,
			Asset.AssetDescription												AS AssetDescription,
			
			format(WorkOrder.TargetDateTime, 'dd-MMM-yyyy')						AS TargetDateTime,
			format(dbo.[EngNextScheduleDateCalc](3,WorkOrder.TargetDateTime), 'dd-MMM-yyyy')			AS NextScheduleDate,
			format(PPMReschedule.RescheduleDate	, 'dd-MMM-yyyy')				AS RescheduleDate,
	
			isnull(PPMReschedule.Remarks,'')																	AS ReasonName
			
	FROM	EngMwoReschedulingTxn												AS PPMReschedule		WITH(NOLOCK)
			INNER JOIN  EngMaintenanceWorkOrderTxn								AS WorkOrder			WITH(NOLOCK)			on PPMReschedule.WorkOrderId			= WorkOrder.WorkOrderId
			INNER JOIN	EngAsset												AS Asset				WITH(NOLOCK)			on WorkOrder.AssetId					= Asset.AssetId
			INNER JOIN	EngAssetTypeCode										AS AssetTypeCode		WITH(NOLOCK)			on Asset.AssetTypeCodeId				= AssetTypeCode.AssetTypeCodeId
			--LEFT JOIN  EngPlannerTxn											AS Planner				WITH(NOLOCK)			on WorkOrder.PlannerId					= Planner.PlannerId
			--LEFT JOIN	UMUserRegistration										AS Staff				WITH(NOLOCK)			on PPMReschedule.RescheduleApprovedBy	= Staff.UserRegistrationId
			--INNER JOIN	FMLovMst												AS TypeofPlanners		WITH(NOLOCK)			on WorkOrder.TypeOfWorkOrder			= TypeofPlanners.LovId
			--INNER JOIN	FMLovMst												AS Reasons				WITH(NOLOCK)			on PPMReschedule.Reason					= Reasons.LovId

	WHERE	WorkOrder.MaintenanceWorkNo = @MaintenanceWorkNo 




END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
