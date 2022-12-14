USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport_PPMCheckList]    Script Date: 20-09-2021 16:43:00 ******/
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
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport_PPMCheckList](  
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
 
  	SELECT		--PPMCheckListWorkOrder.WOPPMCheckListId,
				--PPMCheckList.PPMCheckListId,
				--PPMCheckList.AssetTypeCodeId,
				--TypeCode.AssetTypeCode,
				--TypeCode.AssetTypeDescription	AS	AssetTypeCodeDesc,
				PPMCheckList.TaskCode,
			--	PPMCheckList.TaskDescription,
				PPMCheckList.PPMChecklistNo,
				
				LovFrequency.FieldValue			AS	PPMFrequencyName,
				PPMCheckList.PPMHours,
				PPMCheckList.SpecialPrecautions,
				PPMCheckList.Remarks
				

	    From  EngAssetPPMCheckListWorkOrder					AS  PPMCheckListWorkOrder 
			INNER JOIN EngAssetPPMCheckList					AS	PPMCheckList	 WITH(NOLOCK) ON PPMCheckListWorkOrder.PPMCheckListId	=	PPMCheckList.PPMCheckListId
			INNER JOIN EngAssetTypeCode						AS	TypeCode		 WITH(NOLOCK) ON PPMCheckList.AssetTypeCodeId			=	TypeCode.AssetTypeCodeId
			INNER JOIN FMLovMst								AS	LovFrequency	 WITH(NOLOCK) ON PPMCheckList.PPMFrequency				=	LovFrequency.LovId
		    
		--WHERE	PPMCheckListWorkOrder.PPMCheckListId	=	@pPPMCheckListId AND PPMCheckListWorkOrder.WorkOrderId = @pWorkOrderId
	WHERE	PPMCheckListWorkOrder.WorkOrderId = (select top 1  WorkOrderId from EngMaintenanceWorkOrderTxn where MaintenanceWorkNo= @MaintenanceWorkNo) 




END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
