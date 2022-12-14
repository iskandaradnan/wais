USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BEMSAssetRegistration_Rpt_L4]    Script Date: 20-09-2021 16:56:52 ******/
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
EXEC usp_BEMSAssetRegistration_Rpt_L4 @AssetNo = 'PANH00020'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
Modification History          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/         
CREATE PROCEDURE  [dbo].[usp_BEMSAssetRegistration_Rpt_L4](    
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
  
   SELECT DISTINCT   
           1 as SNO,   
          TandC.TandCDocumentNo    AS SNFDocumentNo,  
          TandC.PurchaseCost     AS PurchaseProjectCost,  
		  LovVariationStatus.FieldValue  AS VariationStatusLovName,  
		  format(cast(  TandC.TandCDate   as Date),'dd-MMM-yyyy')      AS VariationDate,       
          format(cast( TandC.ServiceStartDate   as Date),'dd-MMM-yyyy')    AS StartServiceDate,  
   format(cast(TandC.TandCDate as Date),'dd-MMM-yyyy')     AS CommissioningDate,    
   format(cast(TandC.ServiceEndDate as Date),'dd-MMM-yyyy')   AS StopServiceDate,  
   format(cast(TandC.TandCDate   as Date),'dd-MMM-yyyy')   AS SnfDate,  
   format(cast(TandC.WarrantyEndDate as Date),'dd-MMM-yyyy')   AS WarrantyEndDate,  
     
    datename(mm,TandC.TandCDate)  AS VariationMonthName,   
   YEAR(TandC.TandCDate)    AS VariationYear,   
     
     
   CASE   
  
    WHEN TandC.Status=7 THEN 'Approved'  
  
    ELSE 'Reject'  
  
   END         AS VariationApprovedStatusLovName,  
    
    
   TandC.TestingandCommissioningId  AS TestingandCommissioningId,  
  
   Asset.AssetId      AS AssetId,  
  
   Asset.CustomerId     AS CustomerId,  
  
   Asset.FacilityId     AS FacilityId,  
  
   Asset.ServiceId      AS ServiceId,  
  
     
  
    
     
  
     
  
   format(cast(TandC.TandCDate   as Date),'dd-MMM-yyyy')   AS VariationDate,     ---- & [SnfDate] Have to verify this    
  
   format(cast(TandC.TandCDate   as Date),'dd-MMM-yyyy')   AS SnfDate,  
  
   format(cast(TandC.ServiceStartDate as Date),'dd-MMM-yyyy')    AS StartServiceDate,  
  
  format(cast( TandC.ServiceEndDate  as Date),'dd-MMM-yyyy')  AS StopServiceDate,  
  
   format(cast(TandC.TandCDate  as Date),'dd-MMM-yyyy')    AS CommissioningDate,    ---- Have to verify this  
  
     
   MONTH(TandC.TandCDate)    AS VariationMonth,     ---- Have to verify this  
   datename(mm,TandC.TandCDate)  AS VariationMonthName,   
   YEAR(TandC.TandCDate)    AS VariationYear,     ---- Have to verify this  
  
   CASE   
  
    WHEN TandC.Status=7 THEN 371  
  
    ELSE 372  
  
   END         AS VariationApprovedStatusLovId, ---- Name has to check with bala  
  
  
---------- These fields extra needed to the VmVaraiationTable -------------------  
  
   Asset.AssetClassification,  
  
   TandC.WarrantyDuration,  
  
  format(cast( TandC.WarrantyStartDate as Date),'dd-MMM-yyyy')  AS WarrantyStartDate,  
  
   TandC.MainSupplierCode,  
  
   TandC.MainSupplierName,  
  
   TandC.ContractLPONo,  
  
  format(cast( Asset.PurchaseDate as Date),'dd-MMM-yyyy')  AS PurchaseDate,   
  
   --CAST(CASE WHEN Asset.[Authorization]=199 THEN 1  
  
   --  ELSE 0  
  
   --END         AS BIT)  AS AuthorizedStatus,  
  
   vm.AuthorizedStatus,  
   TandC.Timestamp,  
  
   VM.VariationId  
     , mlf.FacilityName , mc.CustomerName, LovContractType.FieldValue  as ContractType, Asset.AssetNo
     , ISNULL(CASE WHEN @AssetStatus = 1 THEN 'Active' WHEN @AssetStatus = 2 THEN 'Inactive' END,'') AS AssetStatusParam  
  FROM EngAsset          AS Asset    WITH(NOLOCK)  
  
   --LEFT JOIN EngTestingandCommissioningTxnDet AS TandCDet   WITH(NOLOCK) ON Asset.TestingandCommissioningDetId = TandCDet.TestingandCommissioningDetId  
  
   --LEFT JOIN EngTestingandCommissioningTxn  AS TandC    WITH(NOLOCK) ON TandCDet.TestingandCommissioningId = TandC.TestingandCommissioningId  
  
   INNER JOIN EngTestingandCommissioningTxn  AS TandC    WITH(NOLOCK) ON Asset.AssetId      = TandC.AssetId  
  
   INNER JOIN FMLovMst       AS LovVariationStatus WITH(NOLOCK) ON TandC.VariationStatus    = LovVariationStatus.LovId  
   INNER JOIN MstLocationFacility AS MLF WITH(NOLOCK)   ON mlf.facilityid = asset.facilityid  
   INNER JOIN MSTCUSTOMER AS MC WITH(NOLOCK)   ON MC.CUSTOMERID = ASSET.CUSTOMERID  
   --INNER JOIN MSTservice AS MC WITH(NOLOCK)   ON MC.CUSTOMERID = ASSET.CUSTOMERID  
   LEFT JOIN  FMLovMst        AS LovContractType   WITH(NOLOCK)   ON Asset.ContractType  = LovContractType.LovId     
   OUTER APPLY (SELECT VariationId,AuthorizedStatus FROM VmVariationTxn AS Variation WHERE Asset.AssetId = Variation.AssetId AND TandC.VariationStatus=Variation.VariationStatus) VM  
  
--  Asset.AssetId = @pAssetId  
  
     
     WHERE TandC.Status = 290  
 ORDER BY Asset.AssetId ASC  
END TRY      
BEGIN CATCH      
      
 insert into ErrorLog(Spname,ErrorMessage,createddate)      
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())      
    
END CATCH      
    
SET NOCOUNT OFF      
    
END
GO
