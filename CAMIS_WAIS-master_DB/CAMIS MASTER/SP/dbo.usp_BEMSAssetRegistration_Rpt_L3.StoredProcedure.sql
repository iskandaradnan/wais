USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BEMSAssetRegistration_Rpt_L3]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
Application Name : UE-Track      
Version    :      
File Name   :      
Procedure Name  : uspFM_CRMRequest_Rpt      
Author(s) Name(s) : Krishna S      
Date    : 28/12/2018      
Purpose    : SP to Check Service Request      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
          
EXEC usp_BEMSAssetRegistration_Rpt @Facility_Id= 1    
EXEC usp_BEMSAssetRegistration_Rpt_L3 @AssetNo = 'PANH00020'    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~               
Modification History              
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS              
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/             
CREATE PROCEDURE  [dbo].[usp_BEMSAssetRegistration_Rpt_L3](        
   @Facility_Id  INT = null,        
   @AssetCategory  INT = null,        
   @AssetStatus  varchar(200) = null,        
   @Typecode   VARCHAR(50) = '',      
   @VariationStatus INT = null,      
   @Level    VARCHAR(100) = NULL,      
   @AssetNo            varchar(100)= null      
 )        
AS        
BEGIN        
        
SET NOCOUNT ON  
SET FMTONLY OFF        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
        
BEGIN TRY      
/*      
EXEC usp_BEMSAssetRegistration_Rpt @Facility_Id= 1, @AssetStatus= 1, @AssetCategory = 73, @Typecode = 1057 , @VariationStatus = 125      
*/      
      
DECLARE @FacilityNameParam NVARCHAR(512),      
@AssetCategoryParam   NVARCHAR(512),       
@TypecodeParam    NVARCHAR(512),      
@VariationStatusParam  NVARCHAR(512)      
      
if(@AssetStatus = 'null')      
begin       
  set @AssetStatus= null      
 end     
   
IF(ISNULL(@Facility_Id,'') <> '')    
BEGIN     
 SELECT @FacilityNameParam = FacilityName FROM MstLocationFacility where FacilityId = @Facility_Id    
END     
   
     
      
  SELECT         
            1 as SNO,       
                
   MaintenanceWO.MaintenanceWorkNo      AS MaintenaceWorkNo,      
   CASE WHEN          
    MaintenanceWO.MaintenanceWorkCategory = 187 THEN      
   CAST(MWOCompletionInfo.StartDateTime AS DATE)      
   ELSE      
   CAST(MaintenanceWO.MaintenanceWorkDateTime AS DATE)       
   END             AS WorkOrderDate,        
   LovMWOCategory.FieldValue       AS WorkCategory ,      
   LovMWOType.FieldValue        AS Type,      
   ISNULL(MAX(DownTimeHours),0.00) AS TotalDownTime,      
   SUM(ISNULL(MwoPartRep.TotalPartsCost,0.00))   AS SparepartsCost,      
   SUM(ISNULL(MwoPartRep.LabourCost,0.00))    AS LabourCost,      
   SUM(ISNULL(MwoPartRep.TotalCost,0.00))    AS TotalCost      
   , LovAssetStatus.FieldValue  as AssetStatus   
   , mlf.FacilityName , mc.CustomerName, LovContractType.FieldValue  as ContractType  
   , ISNULL(CASE WHEN @AssetStatus = 1 THEN 'Active' WHEN @AssetStatus = 2 THEN 'Inactive' END,'') AS AssetStatusParam  
   , Asset.AssetNo
  FROM EngMaintenanceWorkOrderTxn    AS MaintenanceWO  WITH(NOLOCK)      
   INNER JOIN EngAsset     AS Asset    WITH(NOLOCK) ON Asset.AssetId       = MaintenanceWO.AssetId      
   LEFT JOIN EngMwoCompletionInfoTxn  AS MWOCompletionInfo WITH(NOLOCK) ON MaintenanceWO.WorkOrderId    = MWOCompletionInfo.WorkOrderId      
   LEFT JOIN EngMwoPartReplacementTxn AS MwoPartRep   WITH(NOLOCK) ON MaintenanceWO.WorkOrderId    = MwoPartRep.WorkOrderId      
   INNER JOIN FMLovMst     AS LovMWOCategory  WITH(NOLOCK) ON MaintenanceWO.MaintenanceWorkCategory = LovMWOCategory.LovId      
   INNER JOIN FMLovMst     AS LovMWOType   WITH(NOLOCK) ON MaintenanceWO.TypeOfWorkOrder   = LovMWOType.LovId      
   LEFT JOIN  FMLovMst        AS LovAssetStatus   WITH(NOLOCK)   ON Asset.AssetStatusLovId      = LovAssetStatus.LovId     
   INNER JOIN MstLocationFacility AS MLF WITH(NOLOCK)   ON mlf.facilityid = asset.facilityid  
   INNER JOIN MSTCUSTOMER AS MC WITH(NOLOCK)   ON MC.CUSTOMERID = ASSET.CUSTOMERID  
   --INNER JOIN MSTservice AS MC WITH(NOLOCK)   ON MC.CUSTOMERID = ASSET.CUSTOMERID  
   LEFT JOIN  FMLovMst        AS LovContractType   WITH(NOLOCK)   ON Asset.ContractType  = LovContractType.LovId     
    
 WHERE Asset.AssetNo = @AssetNo      
 GROUP BY MaintenanceWO.WorkOrderId,       
   MaintenanceWO.MaintenanceWorkNo,      
   MaintenanceWO.MaintenanceWorkDateTime,      
   MWOCompletionInfo.StartDateTime,      
   MaintenanceWO.MaintenanceWorkCategory,      
   LovMWOCategory.FieldValue,      
   MaintenanceWO.TypeOfWorkOrder, LovMWOType.FieldValue, LovAssetStatus.FieldValue, mlf.FacilityName, mc.CustomerName, LovContractType.FieldValue 
   , Asset.AssetNo  
 ORDER BY MaintenanceWO.MaintenanceWorkDateTime ASC      
END TRY          
BEGIN CATCH          
          
 insert into ErrorLog(Spname,ErrorMessage,createddate)          
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())          
        
END CATCH          
        
SET NOCOUNT OFF          
        
END
GO
