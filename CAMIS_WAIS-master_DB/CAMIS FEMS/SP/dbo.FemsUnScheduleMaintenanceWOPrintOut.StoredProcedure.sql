USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[FemsUnScheduleMaintenanceWOPrintOut]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FemsUnScheduleMaintenanceWOPrintOut]      
(      
@WorkOrderId INT      
)      
      
AS      
      
BEGIN      
      
DECLARE @DATE DATETIME        
--DECLARE @WorkOrderNo INT        
DECLARE @ASSETID INT        
DECLARE @TYPEOFWORKORDER INT        
        
        
--SET @WorkOrderNo=3499        
      
SET @DATE=(SELECT MAX(MaintenanceWorkDateTime) FROM EngMaintenanceWorkOrderTxn A WITH(NOLOCK) WHERE WorkOrderId=@WorkOrderId)         
SET @ASSETID=(SELECT MAX(AssetId)FROM EngMaintenanceWorkOrderTxn A WITH(NOLOCK) WHERE WorkOrderId=@WorkOrderId )        
SET @TYPEOFWORKORDER=(SELECT MAX(TypeOfWorkOrder) FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId=@WorkOrderId)   
      
  
--DECLARE @WorkOrderId INT      
--SET @WorkOrderId=1335      
      
SELECT DISTINCT      
A.MaintenanceWorkNo AS RequestNo      
,A.WorkOrderId      
,A.MaintenanceWorkDateTime AS RequestDateTime      
,A.WorkGroupType  
,O.AssetClassificationId  
,B.StaffName AS RequestedBy      
,C.Designation       
,B.PhoneNumber AS ContactNo      
,D.FieldValue AS Category      
,O.AssetClassificationDescription AS WorkGroup      
,F.AssetNo      
,F.SerialNo As SerialNo    
,F.Asset_Name AS AssetName      
,G.UserLocationCode AS AssetLocationCode      
,G.UserLocationName AS AssetlocationName     
,H.Manufacturer      
,I.Model      
,A.MaintenanceDetails AS RequestDetails      
,J.Justification AS AssesmentDetails      
,K.StaffName AS ResponseBy     
,L.UserAreaName As UserAreaName    
,J.ResponseDateTime AS AssesmentDateTime      
,CASE WHEN F.IsLoaner=1 THEN F.AssetNo ELSE '' END AS LoanerAssetNo      
,CASE WHEN F.IsLoaner=1 THEN F.Asset_Name ELSE '' END AS LoanerAssetName      
,M.FieldValue AS MaintenanceWorkType  
,N.StaffName AS AssigneName  
,y.Fieldvalue as [priority] 
FROM EngMaintenanceWorkOrderTxn A WITH (NOLOCK)              
LEFT OUTER JOIN UMUserRegistration B WITH (NOLOCK)              
ON A.RequestorUserId=B.UserRegistrationId      
LEFT OUTER JOIN UserDesignation C WITH (NOLOCK)              
ON B.UserDesignationId=C.UserDesignationId      
LEFT OUTER JOIN FMLovMst D WITH (NOLOCK)              
ON A.MaintenanceWorkCategory=D.LovId      
LEFT OUTER JOIN EngAssetWorkGroup E WITH (NOLOCK)              
ON A.WorkGroupId=E.WorkGroupId      
LEFT OUTER JOIN EngAsset F WITH (NOLOCK)              
ON A.AssetId=F.AssetId              
LEFT OUTER JOIN MstLocationUserLocation G WITH (NOLOCK)              
ON F.UserLocationId=G.UserLocationId              
LEFT OUTER JOIN EngAssetStandardizationManufacturer H WITH (NOLOCK)              
ON F.Manufacturer=H.ManufacturerId              
LEFT OUTER JOIN EngAssetStandardizationModel I WITH (NOLOCK)              
ON F.Model=I.ModelId           
LEFT OUTER JOIN EngMwoAssesmentTxn J      
ON A.WorkOrderId=J.WorkOrderId      
LEFT OUTER JOIN UMUserRegistration K      
ON J.UserId=K.UserRegistrationId      
LEFT OUTER JOIN MstLocationUserArea L    
ON F.UserAreaId =L.UserAreaId    
LEFT OUTER JOIN FMLovMst M  
ON A.MaintenanceWorkType=M.LovId  
LEFT OUTER JOIN UMUserRegistration N  
ON A.AssignedUserId=N.UserRegistrationId  
LEFT OUTER JOIN EngAssetClassification O  
ON A.WorkGroupType=O.AssetClassificationId 

LEFT OUTER JOIN EngAssetClassification z with(nolock)     
ON A.WorkGroupType=z.AssetClassificationId   
  
LEFT OUTER JOIN FMLovMst y WITH (NOLOCK)                  
ON A.WorkOrderPriority=y.LovId


    
WHERE MaintenanceWorkCategory=188              
AND TypeOfWorkOrder=@TYPEOFWORKORDER             
AND A.WorkOrderId=@WorkOrderId      
      
      
      
END      
GO
