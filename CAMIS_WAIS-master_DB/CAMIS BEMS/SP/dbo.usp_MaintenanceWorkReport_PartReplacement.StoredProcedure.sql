USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MaintenanceWorkReport_PartReplacement]    Script Date: 20-09-2021 17:05:50 ******/
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
CREATE PROCEDURE  [dbo].[usp_MaintenanceWorkReport_PartReplacement](  
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
			SpareParts.PartNo									AS PartNo,	
			SpareParts.PartDescription							AS PartDescription,
			StockType.FieldValue								AS StockTypeValue,
			MwoPartReplacement.Quantity							AS Quantity,
			ISNULL(PartReplacementCost,0)					    AS PartReplacementCost,
	
			SparePartRunningHours								AS AverageRunningHours
			
				
			
	FROM	EngMwoPartReplacementTxn					AS MwoPartReplacement
			INNER JOIN	EngMaintenanceWorkOrderTxn		AS MaintenanceWorkOrder		WITH(NOLOCK)	ON MwoPartReplacement.WorkOrderId				= MaintenanceWorkOrder.WorkOrderId
			LEFT  JOIN	EngStockUpdateRegisterTxnDet	AS StockUpdateRegister		WITH(NOLOCK)	ON MwoPartReplacement.StockUpdateDetId			= StockUpdateRegister.StockUpdateDetId
			INNER JOIN  MstService						AS ServiceKey				WITH(NOLOCK)	ON MwoPartReplacement.ServiceId					= ServiceKey.ServiceId
			LEFT JOIN  EngSpareParts					AS SpareParts				WITH(NOLOCK)	ON MwoPartReplacement.SparePartStockRegisterId	= SpareParts.SparePartsId
			LEFT JOIN  FMItemMaster						AS ItemMaster				WITH(NOLOCK)	ON SpareParts.ItemId							= ItemMaster.ItemId
			LEFT  JOIN  FMLovMst						AS StockType				WITH(NOLOCK)	ON StockUpdateRegister.SparePartType			= StockType.LovId
			
			OUTER APPLY (	SELECT	ComDet.CompletionInfoId,VendorCost, SUM(ComDet.LabourCost) AS LabourCost
				FROM	EngMwoCompletionInfoTxnDet AS ComDet
						INNER JOIN EngMwoCompletionInfoTxn AS Com ON Com.CompletionInfoId	=	ComDet.CompletionInfoId
				WHERE	Com.WorkOrderId	=	MaintenanceWorkOrder.WorkOrderId
				GROUP BY ComDet.CompletionInfoId,VendorCost
						) AS LabourCostInfo
	WHERE	MaintenanceWorkOrder.MaintenanceWorkNo = @MaintenanceWorkNo 
  



END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
