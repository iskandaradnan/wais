USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCode_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext'uspFM_EngAssetTypeCode_Save'      
      
        
        
/*========================================================================================================        
Application Name : UETrack-BEMS                      
Version    : 1.0        
Procedure Name  : uspFM_EngAssetTypeCode_Save        
Description   : Insert/update the typecode details        
Authors    : Dhilip V        
Date    : 19-April-2018        
-----------------------------------------------------------------------------------------------------------        
        
Unit Test:        
        
DECLARE @EngAssetTypeCode     [dbo].[udt_EngAssetTypeCode]        
INSERT INTO @EngAssetTypeCode (AssetTypeCodeId,ServiceId,AssetClassificationId,AssetTypeCode,AssetTypeDescription,RiskRatingLovId,EquipmentFunctionCatagoryLovId        
,IsLicenceAndCertificateApplicable,ExpectedLifeSpan,QAPAssetTypeB1,QAPServiceAvailabilityB2,QAPUptimeTargetPerc,EffectiveFrom,EffectiveFromUTC,TRPILessThan5YrsPerc        
,TRPI5to10YrsPerc,TRPIGreaterThan10YrsPerc,UserId,Criticality)         
VALUES ( 6,2,1,'BE301','bems 201',          115,116,0,     5,0,1,     20,'2018-03-20 13:23:42.203','2018-03-20 13:23:42.203',1,2,3,   1,2)         
        
DECLARE @EngAssetTypeCodeFlag    [dbo].[udt_EngAssetTypeCodeFlag]        
INSERT INTO @EngAssetTypeCodeFlag (AssetTypeCodeId,MaintenanceFlag,UserId)         
VALUES ( NULL,94,1)         
        
DECLARE @EngAssetTypeCodeAddSpecification [dbo].[udt_EngAssetTypeCodeAddSpecification]        
INSERT INTO @EngAssetTypeCodeAddSpecification (AssetTypeCodeId,SpecificationType,SpecificationUnit,UserId)         
VALUES ( NULL,120,118,1)         
        
DECLARE @EngAssetTypeCodeVariationRate  [dbo].[udt_EngAssetTypeCodeVariationRate]           
INSERT INTO @EngAssetTypeCodeVariationRate (AssetTypeCodeId,TypeCodeParameterId,VariationRate,EffectiveFromDate,EffectiveFromDateUTC,UserId)         
VALUES ( NULL,1,'50','2018-03-20 13:23:42.203','2018-03-20 13:23:42.203',1)         
        
EXEC [uspFM_EngAssetTypeCode_Save] @EngAssetTypeCode=@EngAssetTypeCode        
,@EngAssetTypeCodeFlag=@EngAssetTypeCodeFlag,@EngAssetTypeCodeAddSpecification=@EngAssetTypeCodeAddSpecification,        
@EngAssetTypeCodeVariationRate=@EngAssetTypeCodeVariationRate, @pAssetTypeCodeId=6,@pTimestamp='0x0000000000005D81'        
        
        
SELECT * FROM EngAssetTypeCode        
SELECT * FROM EngAssetTypeCodeFlag        
SELECT * FROM EngAssetTypeCodeAddSpecification        
SELECT * FROM EngAssetTypeCodeVariationRate        
        
-----------------------------------------------------------------------------------------------------------        
Version History         
-----:------------:---------------------------------------------------------------------------------------        
Init :  Date       : Details        
========================================================================================================*/        
        
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCode_Save]        
          
  @EngAssetTypeCode     [dbo].[udt_EngAssetTypeCode]   READONLY,        
  @EngAssetTypeCodeFlag    [dbo].[udt_EngAssetTypeCodeFlag]   READONLY,        
  @EngAssetTypeCodeVariationRate  [dbo].[udt_EngAssetTypeCodeVariationRate]   READONLY,        
  @pAssetTypeCodeId     INT       = NULL,        
  @pTimestamp       VARBINARY(200)    = NULL,          
  @pExpectedLifeSpan     INT       = NULL,        
  @pCriticality                 nvarchar(200)    = NULL        
AS                                                      
        
BEGIN TRY        
        
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT        
        
 BEGIN TRANSACTION        
        
-- Paramter Validation         
        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;        
        
-- Declaration        
         
 DECLARE @Table TABLE (ID INT)         
 DECLARE @PrimaryKeyId  INT        
        
        
        
        
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------        
        
--//1.EngAssetTypeCode        
     IF(@pCriticality=10040 )     
  BEGIN   
    set @pCriticality=10044;  
  END       
  ELSE   
  BEGIN  
  set @pCriticality=10045;  
  END  
 IF(ISNULL(@pAssetTypeCodeId,0)=0 OR @pAssetTypeCodeId='')       
          
  BEGIN        
        
  DECLARE @Cnt INT;        
        
   SELECT @Cnt = COUNT(1)         
   FROM EngAssetTypeCode         
   WHERE AssetTypeCode = (SELECT AssetTypeCode FROM @EngAssetTypeCode)        
        
        
  IF (@Cnt = 0)         
           
   BEGIN        
        
    INSERT INTO EngAssetTypeCode        
       (         
        ServiceId,        
        AssetClassificationId,        
        AssetTypeCode,        
        AssetTypeDescription,        
        --RiskRatingLovId,        
        EquipmentFunctionCatagoryLovId,        
       -- IsLicenceAndCertificateApplicable,        
       -- ExpectedLifeSpan,        
        QAPAssetTypeB1,        
        QAPServiceAvailabilityB2,        
        QAPUptimeTargetPerc,        
        EffectiveFrom,        
        EffectiveFromUTC,        
        EffectiveTo,        
        EffectiveToUTC,        
        TRPILessThan5YrsPerc,        
        TRPI5to10YrsPerc,        
        TRPIGreaterThan10YrsPerc,        
        CreatedBy,        
        CreatedDate,        
        CreatedDateUTC,        
        ModifiedBy,        
        ModifiedDate,        
        ModifiedDateUTC,        
        Active,        
        --TypeOfContractLovId,        
        LifeExpectancy,    
   Criticality,        
        ExpectedLifeSpan        
              
        
       ) OUTPUT INSERTED.AssetTypeCodeId INTO @Table               
        
    SELECT ServiceId,        
      AssetClassificationId,        
      AssetTypeCode,        
      AssetTypeDescription,        
      --RiskRatingLovId,        
      EquipmentFunctionCatagoryLovId,        
      --IsLicenceAndCertificateApplicable,        
      --ExpectedLifeSpan,        
      QAPAssetTypeB1,        
      QAPServiceAvailabilityB2,        
      QAPUptimeTargetPerc,        
      EffectiveFrom,        
      EffectiveFromUTC,        
      EffectiveTo,        
      EffectiveToUTC,        
      TRPILessThan5YrsPerc,        
      TRPI5to10YrsPerc,        
      TRPIGreaterThan10YrsPerc,        
      UserId,        
      GETDATE(),        
      GETUTCDATE(),        
      UserId,        
      GETDATE(),        
      GETUTCDATE(),        
      1 ,        
     -- TypeOfContractLovId,        
      LifeExpectancy ,    
   @pCriticality,        
      @pExpectedLifeSpan      
    FROM @EngAssetTypeCode         
    WHERE   ISNULL(@pAssetTypeCodeId,0)=0        
        
        
        
       SET @PrimaryKeyId  = (SELECT ID FROM @Table)        
        
 ----//2.EngAssetTypeCodeFlag        
        
    INSERT INTO EngAssetTypeCodeFlag        
        ( AssetTypeCodeId,        
         MaintenanceFlag,        
         CreatedBy,        
         CreatedDate,        
         CreatedDateUTC,        
         ModifiedBy,        
         ModifiedDate,        
         ModifiedDateUTC        
        )        
        
    SELECT   @PrimaryKeyId,        
        MaintenanceFlag,        
        UserId,            
        GETDATE(),           
        GETUTCDATE(),        
        UserId,           
        GETDATE(),           
        GETUTCDATE()        
    FROM @EngAssetTypeCodeFlag        
    WHERE   ISNULL(@pAssetTypeCodeId,0)=0        
        
        
        
------//4.EngAssetTypeCodeVariationRate        
        
    INSERT INTO EngAssetTypeCodeVariationRate        
        ( AssetTypeCodeId,        
         TypeCodeParameterId,        
         VariationRate,        
         EffectiveFromDate,        
         EffectiveFromDateUTC,        
         CreatedBy,        
         CreatedDate,        
         CreatedDateUTC,        
         ModifiedBy,        
         ModifiedDate,        
         ModifiedDateUTC        
        )        
        
    SELECT   @PrimaryKeyId,        
        TypeCodeParameterId,        
        VariationRate,        
        EffectiveFromDate,        
        EffectiveFromDateUTC,        
        UserId,            
        GETDATE(),           
        GETUTCDATE(),        
        UserId,           
        GETDATE(),           
        GETUTCDATE()        
    FROM @EngAssetTypeCodeVariationRate        
    WHERE   ISNULL(@pAssetTypeCodeId,0)=0        
        
    SELECT AssetTypeCodeId,        
      [Timestamp],        
      '' ErrorMsg         
    FROM EngAssetTypeCode        
    WHERE AssetTypeCodeId IN (SELECT ID FROM @Table)        
        
  END       
  ELSE         
    SELECT 0  AS AssetTypeCodeId,        
      NULL AS [Timestamp],        
      'Asset Type Code Already Exists' ErrorMsg         
  END        
        
 ELSE         
-------------------------------------------------------------------- UPDATE STATEMENT ----------------------------------------------------        
        
------1.EngAssetTypeCode        
        
           
        
  BEGIN        
           
        
   DECLARE @mTimestamp varbinary(200);        
        
   SELECT @mTimestamp = [Timestamp]         
   FROM EngAssetTypeCode         
   WHERE AssetTypeCodeId = @pAssetTypeCodeId        
        
   IF (@mTimestamp = @pTimestamp )        
           
   BEGIN        
         
        
     UPDATE  TypeCode   SET         
          --TypeCode.RiskRatingLovId     =   TypeCodeUDT.RiskRatingLovId,        
          TypeCode.EquipmentFunctionCatagoryLovId  =   TypeCodeUDT.EquipmentFunctionCatagoryLovId,        
          --TypeCode.IsLicenceAndCertificateApplicable =   TypeCodeUDT.IsLicenceAndCertificateApplicable,        
          --TypeCode.ExpectedLifeSpan     =   TypeCodeUDT.ExpectedLifeSpan ,        
          TypeCode.QAPAssetTypeB1      =   TypeCodeUDT.QAPAssetTypeB1 ,        
          TypeCode.QAPServiceAvailabilityB2   =   TypeCodeUDT.QAPServiceAvailabilityB2,        
          TypeCode.QAPUptimeTargetPerc    =   TypeCodeUDT.QAPUptimeTargetPerc  ,        
          TypeCode.EffectiveFrom      =   TypeCodeUDT.EffectiveFrom ,        
          TypeCode.EffectiveFromUTC     =   TypeCodeUDT.EffectiveFromUTC ,        
          TypeCode.EffectiveTo      =   TypeCodeUDT.EffectiveTo  ,        
          TypeCode.EffectiveToUTC      = TypeCodeUDT.EffectiveToUTC ,        
          TypeCode.TRPILessThan5YrsPerc    =   TypeCodeUDT.TRPILessThan5YrsPerc ,        
          TypeCode.TRPI5to10YrsPerc     =   TypeCodeUDT.TRPI5to10YrsPerc,        
          TypeCode.TRPIGreaterThan10YrsPerc   = TypeCodeUDT.TRPIGreaterThan10YrsPerc,        
          TypeCode.ModifiedBy       =   TypeCodeUDT.UserId,        
          TypeCode.ModifiedDate      =   GETDATE(),        
          TypeCode.ModifiedDateUTC     =   GETUTCDATE(),        
          Typecode.LifeExpectancy      =   TypeCodeUDT.LifeExpectancy,     
    Typecode.Criticality     =         @pCriticality,      
          Typecode.ExpectedLifeSpan     =   @pExpectedLifeSpan        
          OUTPUT INSERTED.AssetTypeCodeId INTO @Table          
  FROM EngAssetTypeCode       AS TypeCode         
    INNER JOIN @EngAssetTypeCode    AS TypeCodeUDT ON TypeCode.AssetTypeCodeId = TypeCodeUDT.AssetTypeCodeId        
  WHERE ISNULL(TypeCodeUDT.AssetTypeCodeId,0)>0 and  TypeCodeUDT.AssetTypeCodeId=@pAssetTypeCodeId        
        
------ //2 EngAssetTypeCodeFlag           
        
  DELETE FROM EngAssetTypeCodeFlag WHERE AssetTypeCodeId =@pAssetTypeCodeId        
        
  INSERT INTO EngAssetTypeCodeFlag        
      ( AssetTypeCodeId,        
       MaintenanceFlag,        
       CreatedBy,        
       CreatedDate,        
       CreatedDateUTC,        
       ModifiedBy,        
       ModifiedDate,        
       ModifiedDateUTC        
      )        
        
  SELECT   @pAssetTypeCodeId,        
      MaintenanceFlag,        
      UserId,            
      GETDATE(),           
      GETUTCDATE(),        
      UserId,           
      GETDATE(),           
      GETUTCDATE()        
  FROM @EngAssetTypeCodeFlag        
  --WHERE   ISNULL(@pAssetTypeCodeId,0)>0        
        
        
------ //3 EngAssetTypeCodeAddSpecification         
                
-- Delete where Active = false records         
       
------ //4 EngAssetTypeCodeVariationRate         
     UPDATE  VRate SET   -- VRate.AssetTypeCodeId   =   VRateUDT.AssetTypeCodeId,        
          --VRate.TypeCodeParameterId  =   VRateUDT.TypeCodeParameterId,        
          VRate.VariationRate    =   VRateUDT.VariationRate,        
          VRate.EffectiveFromDate   =   VRateUDT.EffectiveFromDate,        
          VRate.EffectiveFromDateUTC  =   VRateUDT.EffectiveFromDateUTC,        
          VRate.ModifiedBy    = VRateUDT.UserId,        
          VRate.ModifiedDate    =   GETDATE(),        
          VRate.ModifiedDateUTC   =   GETUTCDATE()        
  FROM EngAssetTypeCodeVariationRate    AS VRate         
    INNER JOIN @EngAssetTypeCodeVariationRate AS VRateUDT ON VRate.AssetTypeCodeVariationId = VRateUDT.AssetTypeCodeVariationId        
  WHERE ISNULL(VRateUDT.AssetTypeCodeVariationId,0)>0 and VRate.AssetTypeCodeId=@pAssetTypeCodeId        
        
        
    SELECT AssetTypeCodeId,        
      [Timestamp],        
      '' ErrorMsg        
    FROM EngAssetTypeCode        
    WHERE AssetTypeCodeId  =@pAssetTypeCodeId        
        
  END        
  ELSE        
   BEGIN        
    SELECT AssetTypeCodeId,        
      [Timestamp],        
      'Record Modified. Please Re-Select' AS ErrorMsg        
    FROM EngAssetTypeCode        
    WHERE AssetTypeCodeId =@pAssetTypeCodeId        
   END        
  END        
        
        
 IF @mTRANSCOUNT = 0        
        BEGIN        
            COMMIT        
        END        
        
END TRY        
        
BEGIN CATCH        
        
 IF @mTRANSCOUNT = 0        
        BEGIN        
            ROLLBACK TRAN        
        END        
        
 INSERT INTO ErrorLog(        
    Spname,        
    ErrorMessage,        
    createddate)        
 VALUES(  OBJECT_NAME(@@PROCID),        
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),        
    getdate()        
     );        
THROW;        
END CATCH
GO
