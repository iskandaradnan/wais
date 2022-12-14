USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCode_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_EngAssetTypeCode_GetById    
Description   : To Get the AssetTypeCode using the AssetTypeCodeId    
Authors    : Dhilip V    
Date    : 19-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC [uspFM_EngAssetTypeCode_GetById]  @pAssetTypeCodeId=4    
    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCode_GetById]                               
    
  @pAssetTypeCodeId    INT     
AS                                                  
    
BEGIN TRY    
    
    
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
 IF(ISNULL(@pAssetTypeCodeId,0) = 0) RETURN    
    
  SELECT TypeCode.AssetTypeCodeId,    
    TypeCode.ServiceId,    
    TypeCode.AssetClassificationId,    
    AssetClassification.AssetClassificationCode ,    
    TypeCode.AssetTypeCode,    
    TypeCode.AssetTypeDescription,    
  TypeCode.Criticality,    
    AssetClassification.AssetClassificationDescription ,    
    --TypeCode.TypeOfContractLovId,    
    
    TypeCode.LifeExpectancy,       
    TypeCode.EquipmentFunctionCatagoryLovId,    
    LovEquipCatagory.FieldValue     AS EquipmentFunctionCatagory,    
       
    TypeCode.QAPAssetTypeB1,    
    CASE WHEN TypeCode.QAPAssetTypeB1 = 0 THEN 'No'    
      WHEN TypeCode.QAPAssetTypeB1 = 1 THEN 'Yes'     
    END           AS QAPAssetTypeB1Name,    
    TypeCode.QAPServiceAvailabilityB2,    
    CASE WHEN TypeCode.QAPServiceAvailabilityB2 = 0 THEN 'No'    
      WHEN TypeCode.QAPServiceAvailabilityB2 = 1 THEN 'Yes'     
    END           AS QAPServiceAvailabilityB2Name,    
    TypeCode.QAPUptimeTargetPerc,    
    TypeCode.EffectiveFrom,    
    TypeCode.EffectiveFromUTC,    
    TypeCode.EffectiveTo,    
    TypeCode.EffectiveToUTC,    
    TypeCode.TRPILessThan5YrsPerc,    
    TypeCode.TRPI5to10YrsPerc,    
    TypeCode.TRPIGreaterThan10YrsPerc,    
    TypeCode.ModifiedDateUTC,    
    TypeCode.Timestamp,    
    Typecode.ExpectedLifeSpan    
  FROM EngAssetTypeCode         AS TypeCode    WITH(NOLOCK)    
    INNER JOIN   MstService      AS AssetService   WITH(NOLOCK) ON TypeCode.ServiceId      = AssetService.ServiceId    
    INNER JOIN   EngAssetClassification   AS AssetClassification WITH(NOLOCK) ON TypeCode.AssetClassificationId   = AssetClassification.AssetClassificationId       
        
    INNER JOIN   FMLovMst      AS LovEquipCatagory  WITH(NOLOCK) ON TypeCode.EquipmentFunctionCatagoryLovId = LovEquipCatagory.LovId    
  WHERE TypeCode.AssetTypeCodeId  = @pAssetTypeCodeId    
  ORDER BY TypeCode.ModifiedDate ASC    
    
  SELECT TypeCodeFlag.AssetTypeCodeFlagId,    
    TypeCodeFlag.AssetTypeCodeId,    
    TypeCodeFlag.MaintenanceFlag,    
    LovFlag.FieldValue AS MaintenanceFlagName,    
    TypeCodeFlag.ModifiedDateUTC    
  FROM EngAssetTypeCode         AS TypeCode   WITH(NOLOCK)    
    INNER JOIN   EngAssetTypeCodeFlag   AS TypeCodeFlag  WITH(NOLOCK)  ON TypeCode.AssetTypeCodeId   = TypeCodeFlag.AssetTypeCodeId    
    INNER JOIN   FMLovMst      AS LovFlag   WITH(NOLOCK)  ON TypeCodeFlag.MaintenanceFlag  = LovFlag.LovId    
  WHERE TypeCode.AssetTypeCodeId  = @pAssetTypeCodeId    
  ORDER BY TypeCode.ModifiedDate ASC    
    
     
 -- variation lookup     
  SELECT VariationRate.AssetTypeCodeVariationId,    
    VariationRate.AssetTypeCodeId,    
    VariationRate.TypeCodeParameterId,    
    Parameter.TypeCodeParameter AS TypeCodeParameter,    
    VariationRate.VariationRate,    
    VariationRate.EffectiveFromDate,    
    VariationRate.EffectiveFromDateUTC,    
    VariationRate.ModifiedDateUTC    
  FROM EngAssetTypeCode         AS TypeCode   WITH(NOLOCK)    
    INNER JOIN   EngAssetTypeCodeVariationRate AS VariationRate WITH(NOLOCK)  ON TypeCode.AssetTypeCodeId    = VariationRate.AssetTypeCodeId    
    INNER JOIN   EngAssetTypeCodeParameter  AS Parameter  WITH(NOLOCK)  ON VariationRate.TypeCodeParameterId = Parameter.TypeCodeParameterId        
  WHERE TypeCode.AssetTypeCodeId  = @pAssetTypeCodeId     
  ORDER BY TypeCode.ModifiedDate ASC    
      
      
  -- SELECT AddSpec.AssetTypeCodeAddSpecId,    
  --  AddSpec.AssetTypeCodeId,    
  --  AddSpec.SpecificationType,    
  --  LovSpecType.FieldValue AS SpecificationTypeName,    
  --  AddSpec.SpecificationUnit,    
  --  LovSpecUnit.FieldValue AS SpecificationUnitName,    
  --  AddSpec.ModifiedDateUTC    
  --FROM EngAssetTypeCode          AS TypeCode   WITH(NOLOCK)    
  --  INNER JOIN   EngAssetTypeCodeAddSpecification AS AddSpec   WITH(NOLOCK)  ON TypeCode.AssetTypeCodeId  = AddSpec.AssetTypeCodeId    
  --  LEFT JOIN   FMLovMst       AS LovSpecType  WITH(NOLOCK)  ON AddSpec.SpecificationType = LovSpecType.LovId    
  --  LEFT JOIN   FMLovMst       AS LovSpecUnit  WITH(NOLOCK)  ON AddSpec.SpecificationUnit = LovSpecUnit.LovId    
  --WHERE TypeCode.AssetTypeCodeId  = @pAssetTypeCodeId and AddSpec.active= 1    
  --ORDER BY TypeCode.ModifiedDate ASC    
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
