USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport_Completion]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport_Completion](  
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

			format((select min (StartDateTime) from  EngMwoCompletionInfoTxnDet  where CompletionInfoId=MwoCompletionDet.CompletionInfoId),'dd-MMM-yyyy HH:mm') as StartDateTime,
			format((select max (EndDateTime) from  EngMwoCompletionInfoTxnDet  where CompletionInfoId=MwoCompletionDet.CompletionInfoId),'dd-MMM-yyyy HH:mm') as EndDateTime,
			
			CompletedBy.StaffName								AS CompletedBy,        
		    CDesignation.Designation							AS CompletedByDesignation,	  
		     QC.Description								        AS FailureSymptomCodeDescription,
			QCCode.FieldValue									AS FailureSymptomCode,
		    Cause.Details								        AS FailureRootCause,    --Failure Root Cause
			CauseCode.FieldValue								AS FailureRootCause, --Failure Root Cause Description 
			format(MwoCompletion.PPMAgreedDate,'dd-MMM-yyyy')	AS PPMAgreedDate,
		    MwoCompletion.VendorCost							AS VendorCost,		
			ProcessStatus.FieldValue							AS ProcessStatusValue,
			format(MwoCompletion.ProcessStatusDate	,'dd-MMM-yyyy HH:mm')AS ProcessStatusDate,
			ProcessStatusReason.FieldValue						AS ProcessStatusReasonValue,
			MwoCompletion.RunningHours							AS RunningHours,
			MaintenanceWorkOrder.WorkOrderStatus				AS WorkOrderStatus,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue,
			MwoCompletion.AcceptedBy							AS AcceptedBy,
			AcceptedBy.StaffName								AS AcceptedByName,
			ADesignation.Designation							AS AcceptedByDesignation,
			MwoCompletion.RepairDetails							AS RepairDetails,		
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			format(MaintenanceWorkOrder.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')		AS MaintenanceWorkDateTime,		
			format(MwoCompletion.StartDateTimeUTC	,'dd-MMM-yyyy HH:mm')					AS StartDateTimeUTC,
			
			
			---- sub table 
			UserReg.StaffName,
			StandardTaskDetId.TaskCode							AS TaskCode,
			format(MwoCompletionDet.StartDateTime	,'dd-MMM-yyyy HH:mm')					AS UdtStartDateTime,
			format(MwoCompletionDet.StartDateTimeUTC	,'dd-MMM-yyyy HH:mm')				AS UdtStartDateTimeUTC,
			format(MwoCompletionDet.EndDateTime	,'dd-MMM-yyyy HH:mm')					AS UdtEndDateTime,
			MwoCompletionDet.RepairHours						AS PPMHours

	FROM	EngMwoCompletionInfoTxn						AS MwoCompletion

			Left JOIN	MstQAPQualityCause		        AS QC						WITH(NOLOCK)	ON QC.QualityCauseId					= MwoCompletion.QCCode
			Left JOIN	MstQAPQualityCauseDet		    AS Cause					WITH(NOLOCK)	ON Cause.QualityCauseDetId				= MwoCompletion.CauseCode

			
			INNER JOIN	EngMwoCompletionInfoTxnDet		AS MwoCompletionDet			WITH(NOLOCK)	ON MwoCompletion.CompletionInfoId		= MwoCompletionDet.CompletionInfoId
			LEFT  JOIN  UMUserRegistration				AS UserReg					WITH(NOLOCK)	ON MwoCompletionDet.UserId				= UserReg.UserRegistrationId
			LEFT  JOIN  EngAssetPPMCheckList			AS StandardTaskDetId		WITH(NOLOCK)	ON MwoCompletionDet.StandardTaskDetId	= StandardTaskDetId.PPMCheckListId
			INNER JOIN	EngMaintenanceWorkOrderTxn		AS MaintenanceWorkOrder		WITH(NOLOCK)	ON MwoCompletion.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstService						AS ServiceKey				WITH(NOLOCK)	ON MwoCompletion.ServiceId				= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration				AS CompletedBy				WITH(NOLOCK)	ON MwoCompletion.CompletedBy			= CompletedBy.UserRegistrationId
			LEFT  JOIN  UMUserRegistration				AS AcceptedBy				WITH(NOLOCK)	ON MwoCompletion.AcceptedBy				= AcceptedBy.UserRegistrationId
			LEFT  JOIN  UserDesignation					AS CDesignation				WITH(NOLOCK)	ON CompletedBy.UserDesignationId		= CDesignation.UserDesignationId
			LEFT  JOIN  UserDesignation					AS ADesignation				WITH(NOLOCK)	ON AcceptedBy.UserDesignationId			= ADesignation.UserDesignationId
			LEFT  JOIN  MstContractorandVendor			AS ContractorandVendor		WITH(NOLOCK)	ON MwoCompletion.ContractorId			= ContractorandVendor.ContractorId			
			LEFT  JOIN  FMLovMst						AS CauseCode				WITH(NOLOCK)	ON MwoCompletion.CauseCode				= CauseCode.LovId
			LEFT  JOIN  FMLovMst						AS QCCode					WITH(NOLOCK)	ON MwoCompletion.QCCode					= QCCode.LovId
			--LEFT  JOIN  FMLovMst						AS ResourceType				WITH(NOLOCK)	ON MwoCompletion.ResourceType			= ResourceType.LovId
			LEFT  JOIN  FMLovMst						AS ProcessStatus			WITH(NOLOCK)	ON MwoCompletion.ProcessStatus			= ProcessStatus.LovId
			LEFT  JOIN  FMLovMst						AS ProcessStatusReason		WITH(NOLOCK)	ON MwoCompletion.ProcessStatusReason	= ProcessStatusReason.LovId
			LEFT  JOIN  FMLovMst						AS WorkOrderStatus			WITH(NOLOCK)	ON MaintenanceWorkOrder.WorkOrderStatus	= WorkOrderStatus.LovId
			--LEFT  JOIN  FMLovMst						AS CustomerFeedback			WITH(NOLOCK)	ON MwoCompletion.CustomerFeedback	= CustomerFeedback.LovId
			OUTER APPLY (select top 1 Portering.PorteringId,Portering.PorteringNo,engasset.AssetId,engasset.AssetNo 
						from 	 PorteringTransaction			AS Portering	WITH(NOLOCK)			
						LEFT  JOIN  EngAsset						AS engasset					WITH(NOLOCK)	ON engasset.AssetId	= Portering.AssetId 	
						WHERE  Portering.WorkOrderId	= MaintenanceWorkOrder.WorkOrderId 
						order by PorteringId desc ) as  Porter
			OUTER APPLY (	SELECT	ComDet.CompletionInfoId, SUM(ComDet.LabourCost) AS LabourCost
							FROM	EngMwoCompletionInfoTxnDet AS ComDet
							WHERE	MwoCompletion.CompletionInfoId	=	ComDet.CompletionInfoId
							GROUP BY ComDet.CompletionInfoId
						) AS LabourCostInfo
			OUTER APPLY (SELECT TOP 1  RescheduleDate FROM EngMwoReschedulingTxn		AS ReschedulingTxn		WITH(NOLOCK)	WHERE  MwoCompletion.WorkOrderId			= ReschedulingTxn.WorkOrderId
			ORDER BY WorkOrderReschedulingId DESC ) RES
	WHERE	MaintenanceWorkOrder.MaintenanceWorkNo = @MaintenanceWorkNo
	--ORDER BY MaintenanceWorkOrder.ModifiedDate ASC





END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
