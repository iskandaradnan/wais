USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[External_EngAssetTypeCodeSP]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC External_EngAssetTypeCodeSP

CREATE PROCEDURE [dbo].[External_EngAssetTypeCodeSP]
AS 
BEGIN

MERGE [dbo].[EngAssetTypeCode] AS TARGET
USING [dbo].[External_EngAssetTypeCode] AS SOURCE 
ON (TARGET.AssetTypeCodeId=SOURCE.AssetTypeCodeId)
--,TARGET.[ServicesID]=TARGET.[ServicesID]
WHEN NOT MATCHED BY TARGET 
THEN 
INSERT 
           (
		    [ServiceId]
           ,[AssetClassificationId]
           ,[AssetTypeCode]
           ,[AssetTypeDescription]
           ,[EquipmentFunctionCatagoryLovId]
           ,[QAPAssetTypeB1]
           ,[QAPServiceAvailabilityB2]
           ,[QAPUptimeTargetPerc]
           ,[EffectiveFrom]
           ,[EffectiveFromUTC]
           ,[EffectiveTo]
           ,[EffectiveToUTC]
           ,[TRPILessThan5YrsPerc]
           ,[TRPI5to10YrsPerc]
           ,[TRPIGreaterThan10YrsPerc]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[CreatedDateUTC]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[ModifiedDateUTC]
           ,[Active]
           ,[BuiltIn]
           ,[GuId]
           ,[LifeExpectancy]
           ,[ExpectedLifeSpan]
           --,[AssetTypeCodeId_mappingTo_SeviceDB]
           ,[Criticality])
 VALUES(    

            SOURCE.[ServiceId]
           ,SOURCE.[AssetClassificationId]
           ,SOURCE.[AssetTypeCode]
           ,SOURCE.[AssetTypeDescription]
           ,SOURCE.[EquipmentFunctionCatagoryLovId]
           ,SOURCE.[QAPAssetTypeB1]
           ,SOURCE.[QAPServiceAvailabilityB2]
           ,SOURCE.[QAPUptimeTargetPerc]
           ,SOURCE.[EffectiveFrom]
           ,SOURCE.[EffectiveFromUTC]
           ,SOURCE.[EffectiveTo]
           ,SOURCE.[EffectiveToUTC]
           ,SOURCE.[TRPILessThan5YrsPerc]
           ,SOURCE.[TRPI5to10YrsPerc]
           ,SOURCE.[TRPIGreaterThan10YrsPerc]
           ,SOURCE.[CreatedBy]
           ,SOURCE.[CreatedDate]
           ,SOURCE.[CreatedDateUTC]
           ,SOURCE.[ModifiedBy]
           ,SOURCE.[ModifiedDate]
           ,SOURCE.[ModifiedDateUTC]
           ,SOURCE.[Active]
           ,SOURCE.[BuiltIn]
           ,SOURCE.[GuId]
           ,SOURCE.[LifeExpectancy]
           ,SOURCE.[ExpectedLifeSpan]
           --,SOURCE.[AssetTypeCodeId_mappingTo_SeviceDB]
           ,SOURCE.[Criticality]
		   )
WHEN MATCHED THEN
UPDATE 
SET 

  TARGET.[ServiceId]=SOURCE.[ServiceId]
 ,TARGET.[AssetClassificationId]=SOURCE.[AssetClassificationId]
 ,TARGET.[AssetTypeCode]=SOURCE.[AssetTypeCode]
 ,TARGET.[AssetTypeDescription]=SOURCE.[AssetTypeDescription]
 ,TARGET.[EquipmentFunctionCatagoryLovId]=SOURCE.[EquipmentFunctionCatagoryLovId]
 ,TARGET.[QAPAssetTypeB1]=SOURCE.[QAPAssetTypeB1]
 ,TARGET.[QAPServiceAvailabilityB2]=SOURCE.[QAPServiceAvailabilityB2]
 ,TARGET.[QAPUptimeTargetPerc]=SOURCE.[QAPUptimeTargetPerc]
 ,TARGET.[EffectiveFrom]=SOURCE.[EffectiveFrom]
 ,TARGET.[EffectiveFromUTC]=SOURCE.[EffectiveFromUTC]
 ,TARGET.[EffectiveTo]=SOURCE.[EffectiveTo]
 ,TARGET.[EffectiveToUTC]=SOURCE.[EffectiveToUTC]
 ,TARGET.[TRPILessThan5YrsPerc]=SOURCE.[TRPILessThan5YrsPerc]
 ,TARGET.[TRPI5to10YrsPerc]=SOURCE.[TRPI5to10YrsPerc]
 ,TARGET.[TRPIGreaterThan10YrsPerc]=SOURCE.[TRPIGreaterThan10YrsPerc]
 ,TARGET.[CreatedBy]=SOURCE.[CreatedBy]
 ,TARGET.[CreatedDate]=SOURCE.[CreatedDate]
 ,TARGET.[CreatedDateUTC]=SOURCE.[CreatedDateUTC]
 ,TARGET.[ModifiedBy]=SOURCE.[ModifiedBy]
 ,TARGET.[ModifiedDate]=SOURCE.[ModifiedDate]
 ,TARGET.[ModifiedDateUTC]=SOURCE.[ModifiedDateUTC]
 ,TARGET.[Active]=SOURCE.[Active]
 ,TARGET.[BuiltIn]=SOURCE.[BuiltIn]
 ,TARGET.[GuId]=SOURCE.[GuId]
 ,TARGET.[LifeExpectancy]=SOURCE.[LifeExpectancy]
 ,TARGET.[ExpectedLifeSpan]=SOURCE.[ExpectedLifeSpan]
 --,TARGET.[AssetTypeCodeId_mappingTo_SeviceDB]=SOURCE.[AssetTypeCodeId_mappingTo_SeviceDB]
 ,TARGET.[Criticality]=SOURCE.[Criticality]
 ;
 END
GO
