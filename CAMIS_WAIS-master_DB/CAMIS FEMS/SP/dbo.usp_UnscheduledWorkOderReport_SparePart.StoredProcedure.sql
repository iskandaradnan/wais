USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_UnscheduledWorkOderReport_SparePart]    Script Date: 20-09-2021 16:56:52 ******/
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
CREATE PROCEDURE  [dbo].[usp_UnscheduledWorkOderReport_SparePart](
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

     Declare @pWorkOrderId int =(select top  1 WorkOrderId from EngMaintenanceWorkOrderTxn where MaintenanceWorkNo = @MaintenanceWorkNo)




 SELECT	    SpareParts.PartNo									AS PartNo,				
			StockType.FieldValue								AS StockTypeValue,
			(SELECT ISNULL(SUM(a.Cost),0) from EngMwoPartReplacementTxn a WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalSparepartsCostSum,
		    (SELECT ISNULL(SUM(a.TotalPartsCost),0) from EngMwoPartReplacementTxn a  WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalCostSum,
			(SELECT ISNULL(SUM(a.LabourCost),0) from EngMwoPartReplacementTxn a WHERE WorkOrderId = @pWorkOrderId GROUP BY WorkOrderId) AS TotalLabourCostSum,
		
		
		
						MwoPartReplacement.Quantity							AS Quantity
			
	FROM	EngMwoPartReplacementTxn					AS MwoPartReplacement
			INNER JOIN	EngMaintenanceWorkOrderTxn		AS MaintenanceWorkOrder		WITH(NOLOCK)	ON MwoPartReplacement.WorkOrderId				= MaintenanceWorkOrder.WorkOrderId
			LEFT  JOIN	EngStockUpdateRegisterTxnDet	AS StockUpdateRegister		WITH(NOLOCK)	ON MwoPartReplacement.StockUpdateDetId			= StockUpdateRegister.StockUpdateDetId
			INNER JOIN  MstService						AS ServiceKey				WITH(NOLOCK)	ON MwoPartReplacement.ServiceId					= ServiceKey.ServiceId
			LEFT JOIN  EngSpareParts					AS SpareParts				WITH(NOLOCK)	ON MwoPartReplacement.SparePartStockRegisterId	= SpareParts.SparePartsId
			LEFT JOIN  FMItemMaster						AS ItemMaster				WITH(NOLOCK)	ON SpareParts.ItemId							= ItemMaster.ItemId
			LEFT  JOIN  FMLovMst						AS StockType				WITH(NOLOCK)	ON StockUpdateRegister.SparePartType			= StockType.LovId
			LEFT   JOIN  FMLovMst						AS LifeSpanOptionId			WITH(NOLOCK)	ON SpareParts.LifeSpanOptionId					= LifeSpanOptionId.LovId
			LEFT   JOIN  FMLovMst						AS LovIsPartReplace			WITH(NOLOCK)	ON MwoPartReplacement.IsPartReplacedCost		= LovIsPartReplace.LovId
			LEFT  JOIN  FMLovMst						AS WorkOrderStatus			WITH(NOLOCK)	ON MaintenanceWorkOrder.WorkOrderStatus	= WorkOrderStatus.LovId
			OUTER APPLY (	SELECT	ComDet.CompletionInfoId,VendorCost, SUM(ComDet.LabourCost) AS LabourCost
				FROM	EngMwoCompletionInfoTxnDet AS ComDet
						INNER JOIN EngMwoCompletionInfoTxn AS Com ON Com.CompletionInfoId	=	ComDet.CompletionInfoId
				WHERE	Com.WorkOrderId	=	MaintenanceWorkOrder.WorkOrderId
				GROUP BY ComDet.CompletionInfoId,VendorCost
						) AS LabourCostInfo
	 WHERE MaintenanceWorkOrder.MaintenanceWorkNo=@MaintenanceWorkNo  	


END TRY    
BEGIN CATCH    

	INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
	VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    

END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
