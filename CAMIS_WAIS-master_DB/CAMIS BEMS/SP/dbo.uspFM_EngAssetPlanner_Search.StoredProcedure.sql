USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPlanner_Search]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : [uspFM_EngAssetPlanner_Fetch]  
Description   : Asset number fetch control  
Authors    : Dhilip V  
Date    : 12-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [uspFM_EngAssetPlanner_Fetch]  @pAssetNo='PANL00007',@pPageIndex=1,@pPageSize=1000,@pAssetTypeCodeId='',@pCurrentAssetId='',@pAssetClassificationId='',@pFacilityId=1,@pAssetType=NULL, @pYear =2019  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPlanner_Search]                             
                              
  @pAssetNo     NVARCHAR(100) = NULL,  
  @pAssetTypeCodeId   NVARCHAR(100) = NULL,  
  @pCurrentAssetId   INT    = NULL,  
  @pPageIndex    INT,  
  @pPageSize    INT,  
  @pAssetClassificationId INT    = NULL,  
  @pFacilityId    INT,  
  @pAssetType    INT    = NULL,  
  @pAssetDescription  NVARCHAR(500) = NULL,  
  @pYear     int    = NULL  
  
  
AS                                                
  
BEGIN TRY  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
  
 DECLARE @TotalRecords INT  
 DECLARE @WhereCondition NVARCHAR(MAX)  
  
 create table #tmpAssetlist   ( sno int identity(1,1) ,AssetId int,AssetType int)  
  
 insert into #tmpAssetlist   
 SELECT AssetId,81 AS AssetType  FROM EngContractOutRegisterDet WHERE AssetId IN (SELECT AssetId FROM EngAsset WHERE  Active =1 AND AssetStatusLovId <>2  
     AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND AssetNo LIKE '%' + @pAssetNo + '%'))  
     AND ((ISNULL(@pAssetDescription,'')='' )  OR (ISNULL(@pAssetDescription,'') <> '' AND AssetDescription LIKE '%' + @pAssetDescription + '%'))  
     )  
  
 insert into #tmpAssetlist   
 SELECT AssetId, 80 AS AssetType FROM EngAsset ea WHERE  Active =1 AND AssetStatusLovId <>2  
     AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND AssetNo LIKE '%' + @pAssetNo + '%')) AND WarrantyEndDate >= GETDATE()  
     AND ((ISNULL(@pAssetDescription,'')='' )  OR (ISNULL(@pAssetDescription,'') <> '' AND AssetDescription LIKE '%' + @pAssetDescription + '%'))  
     and  not exists (select 1 from #tmpAssetlist e where e.AssetId= ea.AssetId)  
  
  
---- Default Values  
--  IF EXISTS (SELECT 1 FROM EngContractOutRegisterDet WHERE AssetId IN (SELECT AssetId FROM EngAsset WHERE  Active =1 AND AssetStatusLovId <>2  
--     AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND AssetNo LIKE '%' + @pAssetNo + '%'))  
--     ))  
--   BEGIN  
--    SET @pAssetType = 81  
--   END  
--  ELSE IF EXISTS (SELECT 1 FROM EngAsset WHERE  Active =1 AND AssetStatusLovId <>2  
--     AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND AssetNo LIKE '%' + @pAssetNo + '%')) AND WarrantyEndDate >= GETDATE())  
--   BEGIN  
--    SET @pAssetType = 80  
--   END  
--  ELSE  
--   BEGIN  
--    SET @pAssetType = 82  
--   END  
---- Execution  
  
  
  
  
-- Contract Assets  
  
--IF ( ISNULL(@pAssetType,0)=81)  
-- BEGIN  
  
  SELECT DISTINCT *   
  INTO #TempResSet  
  FROM (  
   SELECT  DISTINCT Asset.AssetId,  
      Asset.AssetNo,  
      Asset.AssetNoOld,  
      Asset.AssetDescription,  
      AssetClassification.AssetClassificationId,  
      AssetClassification.AssetClassificationCode,  
      AssetClassification.AssetClassificationDescription,  
      TypeCode.AssetTypeCodeId,  
      TypeCode.AssetTypeCode,  
      TypeCode.AssetTypeDescription,  
      Asset.Manufacturer  AS ManufacturerId,  
      Manufacturer.Manufacturer,  
      Asset.Model    AS ModelId,  
      Model.Model,  
      UserArea.UserAreaId,  
      UserArea.UserAreaCode,  
      UserArea.UserAreaName,  
      UserLocation.UserLocationId,  
      UserLocation.UserLocationCode,  
      UserLocation.UserLocationName,  
      Level.LevelId,  
      Level.LevelCode,  
      Level.LevelName,  
      Block.BlockId,  
      Block.BlockCode,  
      Block.BlockName,  
      Asset.WarrantyEndDate,  
      SupplierWar.ContractorName as MainSupplier,  
      Contractor.ContractEndDate,  
      ContractorandVend.SSMRegistrationCode AS ContractorCode,  
      ContractorandVend.ContractorName    AS ContractorName,  
      ContactInfo.ContactNo  AS ContactNumber,  
      Asset.SerialNo,  
      81 AS TypeofAsset,  
      'Contract' as TypeofAssetValue,  
      Asset.ContractType,  
      ContractType.FieldValue as ContractTypeValue,  
      Asset.typeofasset  as WOType,  
      PPMCheckListId as TaskCodeId,  
      PPMC.TaskCode,  
      PPMC.PPMFrequencyValue,
	  Asset.Asset_Name
   FROM  EngAsset          AS Asset    WITH(NOLOCK)  
      INNER JOIN #tmpAssetlist AS TmpList ON Asset.AssetId = TmpList.AssetId and TmpList.AssetType = 81  
      INNER JOIN EngAssetClassification    AS AssetClassification  WITH(NOLOCK) ON Asset.AssetClassification  = AssetClassification.AssetClassificationId  
      INNER JOIN EngAssetTypeCode     AS TypeCode    WITH(NOLOCK) ON Asset.AssetTypeCodeId   = TypeCode.AssetTypeCodeId        
      LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer    = Manufacturer.ManufacturerId  
      LEFT JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Asset.Model      = Model.ModelId  
      LEFT JOIN MstLocationUserLocation    AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId   = UserLocation.UserLocationId  
      LEFT JOIN MstLocationUserArea     AS UserArea   WITH(NOLOCK) ON UserLocation.UserAreaId   = UserArea.UserAreaId  
      LEFT JOIN MstLocationLevel     AS Level    WITH(NOLOCK) ON UserLocation.LevelId   = Level.LevelId  
      LEFT JOIN MstLocationBlock     AS Block    WITH(NOLOCK) ON UserLocation.BlockId   = Block.BlockId  
      LEFT  JOIN  FMLovMst       AS ContractType   WITH(NOLOCK) ON Asset.ContractType    = ContractType.LovId  
      OUTER APPLY ( SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate  
          FROM ( SELECT COR.ContractorId,  
             CORDet.AssetId,  
             RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,  
             MAX(ContractEndDate)  ContractEndDate,  
             MAX(ContractStartDate)  ContractStartDate  
             FROM EngContractOutRegister COR  
              INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId  
             WHERE  CORDet.AssetId=Asset.AssetId  
             GROUP BY COR.ContractorId,CORDet.AssetId  
            )a   
          WHERE RowValue =1  
         ) Contractor       
      LEFT JOIN MstContractorandVendor    AS ContractorandVend WITH(NOLOCK) ON Contractor.ContractorId  = ContractorandVend.ContractorId  
      OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo dET WHERE ContractorandVend.ContractorId=dET.ContractorId) AS ContactInfo  
      OUTER APPLY (SELECT TOP 1 PPMCheckListId,TaskCode, ISNULL(frequencyLov.FieldValue, '') AS PPMFrequencyValue FROM EngAssetPPMCheckList PPMCL   
      LEFT JOIN FMLovMst AS  frequencyLov WITH(NOLOCK) ON frequencyLov.LovId = PPMCL.PPMFrequency  
      WHERE PPMCL.AssetTypeCodeId=Asset.AssetTypeCodeId and Asset.Model =PPMCL.ModelId ) AS PPMC  
      OUTER APPLY (SELECT TOP 1 B.ContractorId,AssetId, B.ContractorName FROM EngTestingandCommissioningTxn ASW   
      JOIN MstContractorandVendor B ON ASW.ContractorId = B.ContractorId where ASW.AssetId=Asset.AssetId) AS SupplierWar   
   WHERE  Asset.Active =1 AND Asset.AssetStatusLovId <>2  
      AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))  
      AND ((ISNULL(@pAssetTypeCodeId,'')='' )  OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))  
      AND ((ISNULL(@pCurrentAssetId,'')='' )  OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))  
      AND ((ISNULL(@pAssetClassificationId,'')='' )  OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))  
      AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))  
      AND ((ISNULL(@pAssetType,'')='' )  OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NOT NULL))  
      AND ((ISNULL(@pAssetDescription,'')='' )  OR (ISNULL(@pAssetDescription,'') <> '' AND AssetDescription LIKE '%' + @pAssetDescription + '%'))  
      and exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=94 and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId)   
      and  not exists (select 1 from EngPlannerTxn  p where  p.AssetId  = Asset.AssetId  and p.Year=@pYear)  
   --ORDER BY Asset.ModifiedDateUTC DESC  
   --OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
--END  
  
UNION  
-- Warrenty Assets  
  
--IF (ISNULL(@pAssetType,0)=80)  
-- BEGIN  
  
   SELECT  DISTINCT Asset.AssetId,  
      Asset.AssetNo,  
      Asset.AssetNoOld,  
      Asset.AssetDescription,  
      AssetClassification.AssetClassificationId,  
      AssetClassification.AssetClassificationCode,  
      AssetClassification.AssetClassificationDescription,  
      TypeCode.AssetTypeCodeId,  
      TypeCode.AssetTypeCode,  
      TypeCode.AssetTypeDescription,  
      Asset.Manufacturer  AS ManufacturerId,  
      Manufacturer.Manufacturer,  
      Asset.Model    AS ModelId,  
      Model.Model,  
      UserArea.UserAreaId,  
      UserArea.UserAreaCode,  
      UserArea.UserAreaName,  
      UserLocation.UserLocationId,  
      UserLocation.UserLocationCode,  
      UserLocation.UserLocationName,  
      Level.LevelId,  
      Level.LevelCode,  
      Level.LevelName,  
      Block.BlockId,  
      Block.BlockCode,  
      Block.BlockName,  
      Asset.WarrantyEndDate,  
      SupplierWar.ContractorName as MainSupplier,  
      Contractor.ContractEndDate,  
      ContractorandVend.SSMRegistrationCode AS ContractorCode,  
      ContractorandVend.ContractorName    AS ContractorName,  
      ContactInfo.ContactNo  AS ContactNumber,  
      Asset.SerialNo,  
      80 AS TypeofAsset,  
      'Warranty' as TypeofAssetValue,  
      Asset.ContractType,  
      ContractType.FieldValue as ContractTypeValue,  
      Asset.typeofasset  as WOType ,  
      PPMCheckListId as TaskCodeId,  
      PPMC.TaskCode,  
      PPMC.PPMFrequencyValue,
	  Asset.Asset_Name
   FROM  EngAsset          AS Asset    WITH(NOLOCK)  
      INNER JOIN #tmpAssetlist AS TmpList ON Asset.AssetId = TmpList.AssetId and TmpList.AssetType = 80  
      INNER JOIN EngAssetClassification    AS AssetClassification  WITH(NOLOCK) ON Asset.AssetClassification  = AssetClassification.AssetClassificationId  
      INNER JOIN EngAssetTypeCode     AS TypeCode    WITH(NOLOCK) ON Asset.AssetTypeCodeId   = TypeCode.AssetTypeCodeId        
      LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer    = Manufacturer.ManufacturerId  
      LEFT JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Asset.Model      = Model.ModelId  
      LEFT JOIN MstLocationUserLocation    AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId   = UserLocation.UserLocationId  
      LEFT JOIN MstLocationUserArea     AS UserArea   WITH(NOLOCK) ON UserLocation.UserAreaId   = UserArea.UserAreaId  
      LEFT JOIN MstLocationLevel     AS Level    WITH(NOLOCK) ON UserLocation.LevelId   = Level.LevelId  
      LEFT JOIN MstLocationBlock     AS Block    WITH(NOLOCK) ON UserLocation.BlockId   = Block.BlockId  
      LEFT  JOIN  FMLovMst       AS ContractType   WITH(NOLOCK) ON Asset.ContractType    = ContractType.LovId  
      OUTER APPLY ( SELECT  ContractorId,AssetId,ContractEndDate,ContractStartDate  
          FROM ( SELECT COR.ContractorId,  
             CORDet.AssetId,  
             RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,  
             MAX(ContractEndDate)  ContractEndDate,  
             MAX(ContractStartDate)  ContractStartDate  
             FROM EngContractOutRegister COR  
              INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId  
             WHERE  CORDet.AssetId=Asset.AssetId  
             GROUP BY COR.ContractorId,CORDet.AssetId  
            )a   
          WHERE RowValue =1  
         ) Contractor  
      LEFT JOIN MstContractorandVendor    AS ContractorandVend WITH(NOLOCK) ON Contractor.ContractorId  = ContractorandVend.ContractorId  
      OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo CCInfo WHERE  ContractorandVend.ContractorId=CCInfo.ContractorId) AS ContactInfo   
      OUTER APPLY (SELECT TOP 1 B.ContractorId,AssetId, B.ContractorName FROM EngTestingandCommissioningTxn ASW   
      JOIN MstContractorandVendor B ON ASW.ContractorId = B.ContractorId where ASW.AssetId=Asset.AssetId) AS SupplierWar   
      OUTER APPLY (SELECT TOP 1 PPMCheckListId,TaskCode , ISNULL(frequencyLov.FieldValue, '') AS PPMFrequencyValue FROM EngAssetPPMCheckList PPMCL   
      LEFT JOIN FMLovMst AS  frequencyLov WITH(NOLOCK) ON frequencyLov.LovId = PPMCL.PPMFrequency  
      WHERE PPMCL.AssetTypeCodeId=Asset.AssetTypeCodeId and Asset.Model =PPMCL.ModelId ) AS PPMC  
      --LEFT JOIN MstContractorandVendor    AS Supplier WITH(NOLOCK) ON SupplierWar.ContractorId  = Supplier.ContractorId  
   WHERE  Asset.Active =1 AND Asset.AssetStatusLovId <>2  
      AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))  
      AND ((ISNULL(@pAssetTypeCodeId,'')='' )  OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))  
      AND ((ISNULL(@pCurrentAssetId,'')='' )  OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))  
      AND ((ISNULL(@pAssetClassificationId,'')='' )  OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))  
      AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))  
      AND ((ISNULL(@pAssetType,'')='' )  OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NULL AND Asset.WarrantyEndDate >= GETDATE()))  
   and exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=94 and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId)   
   AND ((ISNULL(@pAssetDescription,'')='' )  OR (ISNULL(@pAssetDescription,'') <> '' AND AssetDescription LIKE '%' + @pAssetDescription + '%'))  
   and  not exists (select 1 from EngPlannerTxn  p where  p.AssetId  = Asset.AssetId  and p.Year=@pYear)  
   --ORDER BY Asset.ModifiedDateUTC DESC  
   --OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
--END  
  
UNION  
  
--- None Category  
  
   SELECT  DISTINCT Asset.AssetId,  
      Asset.AssetNo,  
      Asset.AssetNoOld,  
      Asset.AssetDescription,  
      AssetClassification.AssetClassificationId,  
      AssetClassification.AssetClassificationCode,  
      AssetClassification.AssetClassificationDescription,  
      TypeCode.AssetTypeCodeId,  
      TypeCode.AssetTypeCode,  
      TypeCode.AssetTypeDescription,  
      Asset.Manufacturer  AS ManufacturerId,  
      Manufacturer.Manufacturer,  
      Asset.Model    AS ModelId,  
      Model.Model,  
      UserArea.UserAreaId,  
      UserArea.UserAreaCode,  
      UserArea.UserAreaName,  
      UserLocation.UserLocationId,  
      UserLocation.UserLocationCode,  
      UserLocation.UserLocationName,  
      Level.LevelId,  
      Level.LevelCode,  
      Level.LevelName,  
      Block.BlockId,  
      Block.BlockCode,  
      Block.BlockName,  
      Asset.WarrantyEndDate,  
      SupplierWar.ContractorName as MainSupplier,  
      Contractor.ContractEndDate,  
      ContractorandVend.SSMRegistrationCode AS ContractorCode,  
      ContractorandVend.ContractorName    AS ContractorName,  
      ContactInfo.ContactNo  AS ContactNumber,  
      Asset.SerialNo,  
      82 AS TypeofAsset,  
      'Inhouse' as TypeofAssetValue,  
      Asset.ContractType,  
      ContractType.FieldValue as ContractTypeValue,  
      Asset.typeofasset  as WOType,  
      PPMCheckListId as TaskCodeId,  
      PPMC.TaskCode,  
      PPMC.PPMFrequencyValue,
	  Asset.Asset_Name
   FROM  EngAsset          AS Asset    WITH(NOLOCK)  
      INNER JOIN EngAssetClassification    AS AssetClassification  WITH(NOLOCK) ON Asset.AssetClassification  = AssetClassification.AssetClassificationId  
      INNER JOIN EngAssetTypeCode     AS TypeCode    WITH(NOLOCK) ON Asset.AssetTypeCodeId   = TypeCode.AssetTypeCodeId       
      LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer    = Manufacturer.ManufacturerId  
      LEFT JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Asset.Model      = Model.ModelId  
      LEFT JOIN MstLocationUserLocation    AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId   = UserLocation.UserLocationId  
      LEFT JOIN MstLocationUserArea     AS UserArea   WITH(NOLOCK) ON UserLocation.UserAreaId   = UserArea.UserAreaId  
      LEFT JOIN MstLocationLevel     AS Level    WITH(NOLOCK) ON UserLocation.LevelId   = Level.LevelId  
      LEFT JOIN MstLocationBlock     AS Block    WITH(NOLOCK) ON UserLocation.BlockId   = Block.BlockId  
      LEFT  JOIN  FMLovMst       AS ContractType   WITH(NOLOCK) ON Asset.ContractType    = ContractType.LovId  
      LEFT JOIN ( SELECT ContractorId,AssetId,ContractEndDate,ContractStartDate  
          FROM ( SELECT COR.ContractorId,  
             CORDet.AssetId,  
             RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue,  
             MAX(ContractEndDate)  ContractEndDate,  
             MAX(ContractStartDate)  ContractStartDate  
             FROM EngContractOutRegister COR  
              INNER JOIN  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId   
             GROUP BY COR.ContractorId,CORDet.AssetId  
            )a   
          WHERE RowValue =1  
         ) Contractor     ON Contractor.AssetId=Asset.AssetId  
      LEFT JOIN MstContractorandVendor    AS ContractorandVend WITH(NOLOCK) ON Contractor.ContractorId  = ContractorandVend.ContractorId  
      OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo FROM MstContractorandVendorContactInfo dET WHERE ContractorandVend.ContractorId=dET.ContractorId) AS ContactInfo  
      OUTER APPLY (SELECT TOP 1 PPMCheckListId,TaskCode, ISNULL(frequencyLov.FieldValue, '') AS PPMFrequencyValue FROM EngAssetPPMCheckList PPMCL   
      LEFT JOIN FMLovMst AS  frequencyLov WITH(NOLOCK) ON frequencyLov.LovId = PPMCL.PPMFrequency  
      WHERE PPMCL.AssetTypeCodeId=Asset.AssetTypeCodeId and Asset.Model =PPMCL.ModelId ) AS PPMC  
      OUTER APPLY (SELECT TOP 1 B.ContractorId,AssetId, B.ContractorName FROM EngTestingandCommissioningTxn ASW   
      JOIN MstContractorandVendor B ON ASW.ContractorId = B.ContractorId where ASW.AssetId=Asset.AssetId) AS SupplierWar   
   WHERE  Asset.Active =1 AND Asset.AssetStatusLovId <>2  
      AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))  
      AND ((ISNULL(@pAssetTypeCodeId,'')='' )  OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND Asset.AssetTypeCodeId =  + @pAssetTypeCodeId ))  
      AND ((ISNULL(@pCurrentAssetId,'')='' )  OR (ISNULL(@pCurrentAssetId,'') <> '' AND Asset.AssetId <>  + @pCurrentAssetId ))  
      AND ((ISNULL(@pAssetClassificationId,'')='' )  OR (ISNULL(@pAssetClassificationId,'') <> '' AND Asset.AssetClassification =   @pAssetClassificationId ))  
      AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))  
      --AND ((ISNULL(@pAssetType,'')='' )  OR (ISNULL(@pAssetType,'') <> '' AND Contractor.AssetId IS NULL AND Asset.WarrantyEndDate >= GETDATE()))  
      AND Asset.AssetId NOT IN (SELECT AssetId FROM #tmpAssetlist)  
      and exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=94 and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId)   
      AND ((ISNULL(@pAssetDescription,'')='' )  OR (ISNULL(@pAssetDescription,'') <> '' AND AssetDescription LIKE '%' + @pAssetDescription + '%'))  
      and  not exists (select 1 from EngPlannerTxn  p where  p.AssetId  = Asset.AssetId  and p.Year=@pYear)  
   --ORDER BY Asset.ModifiedDateUTC DESC  
   --OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
--END  
  ) ResSet  
  
  SELECT  @TotalRecords = COUNT(*)  
  FROM #TempResSet  
  
  SELECT * ,  
  
  
  case when WOType = 190 then 87  
    when WOType = 191 then 86   
    when  TypeofAsset = 80 then 84  
    when TypeofAsset = 81 then 85  
    when TypeofAsset = 82 then 83  
    ELSE  
    NULL  
    END as WorkOrderType,  
  @TotalRecords AS TotalRecords  
  FROM #TempResSet  
  ORDER BY AssetId DESC  
  OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
  
  
  
  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH
GO
