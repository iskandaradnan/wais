USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStandardization_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext [uspFM_EngAssetStandardization_Save]                            --- Alter in Master DB
--sp_helptext [uspFM_EngAssetStandardizationManufacturer_Fetch]    ------ Alter in Master DB
--[UspFM_EngMwoCompletionInfoTxn_GetById]                ----Alter in BEMS AND FEMS
--[uspFM_EngMaintenanceWorkOrderTxn_Export]              ----Alter in BEMS AND FEMS
--[V_EngMaintenanceWorkOrderTxn_Export]                        --------Alter in BEMS AND FEMS
--SP_HELPTEXT [LLSLinenRejectReplacementTxnDet_FetchLinenCode]          --Alter in MasterDB.



    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [uspFM_EngAssetStandardization_Save]    
Description   : If Assesment already exists then update else insert.    
Authors    : Balaji M S    
Date    : 09-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
    
EXECUTE [uspFM_EngAssetStandardization_Save] @pAssetStandardizationId=0,@pAssetTypeCodeId=1,@pServiceId=2,@pManufacturerId=0,@pManufacturer='Hero',@pModelId=0,@pModel='Splendor'    
,@pUpperCost=NULL,@pLowerCost=NULL,@pStatus=1,@pUserId=2    
    
SELECT * FROM EngAssetStandardization    
SELECT * FROM EngAssetStandardizationManufacturer    
SELECT * FROM EngAssetStandardizationModel    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init :  Date       : Details    
========================================================================================================*/    
    
CREATE PROCEDURE  [dbo].[uspFM_EngAssetStandardization_Save]    
      
  @pAssetStandardizationId   INT    =NULL,    
  @pAssetTypeCodeId     INT    =NULL,    
  @pServiceId       INT    =NULL,    
  @pManufacturerId     INT    =NULL,    
  @pManufacturer      NVARCHAR(500) =NULL,    
  @pModelId       INT    =NULL,    
  @pModel        NVARCHAR(500) =NULL,    
  @pUpperCost       NUMERIC(24,2) =NULL,    
  @pLowerCost       NUMERIC(24,2) =NULL,    
  @pStatus       INT    =NULL,    
  @pUserId       INT    = NULL,    
  @pTimestamp       VARBINARY(200) = NULL    
    
AS                                                  
    
BEGIN TRY    
    
    
IF(ISNULL(@pAssetStandardizationId,0) = 0 AND ISNULL(@pAssetTypeCodeId,0) != 0 AND ISNULL(@pModelId,0) != 0 AND ISNULL(@pManufacturerId,0) != 0)    
BEGIN    
DECLARE @OriginalManufacturerName NVARCHAR(500);    
DECLARE @RecordCount INT = 0;    
SELECT @OriginalManufacturerName = Manufacturer FROM EngAssetStandardizationManufacturer WHERE ManufacturerId = @pManufacturerId    
SELECT @RecordCount = COUNT(*) FROM EngAssetStandardization WHERE AssetTypeCodeId = @pAssetTypeCodeId AND ModelId = @pModelId AND ManufacturerId = @pManufacturerId    
IF (@RecordCount > 0 AND @OriginalManufacturerName = @pManufacturer)    
BEGIN    
      SELECT  'Record already exists for the given combination of Type Code, Model and Manufacturer' ErrorMessage    
          
RETURN    
END    
END    
    
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT    
    
 BEGIN TRANSACTION    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
-- Declaration    
     
 DECLARE @Table TABLE (ID INT)     
 DECLARE @Manf TABLE (ID INT)     
 DECLARE @Model TABLE (ID INT)     
 DECLARE @PrimaryKeyId  INT    
    
 DECLARE @MoodelCount INT    
 DECLARE @StandardManufacturerId INT    
 DECLARE @StandardAssetStandardizationId INT    
    
     
 -- AND      
IF (ISNULL(@pModelId,0) > 0 and isnull(@pManufacturerId,0) = 0  )    
BEGIN    
    
     SET @MoodelCount=( SELECT COUNT(1) FROM EngAssetStandardization WHERE ModelId= @pModelId)    
    
  IF(ISNULL(@MoodelCount, 0) > 0)    
  BEGIN    
    SET @StandardAssetStandardizationId  = (SELECT TOP 1  AssetStandardizationId FROM EngAssetStandardization WHERE ModelId = @pModelId )    
    SET @StandardManufacturerId = (SELECT TOP 1  ManufacturerId FROM EngAssetStandardization WHERE ModelId = @pModelId )    
       
      
    
  END    
END    
    
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------    
    
IF(ISNULL(@pAssetStandardizationId,0)=0)    
    
BEGIN    
    IF (ISNULL(@pModelId,0)=0)    
 BEGIN    
  INSERT INTO EngAssetStandardizationModel ( Model,    
              CreatedBy,    
              CreatedDate,    
              CreatedDateUTC,    
              ModifiedBy,    
              ModifiedDate,    
              ModifiedDateUTC    
             )    
             OUTPUT INSERTED.ModelId INTO @Model    
     VALUES ( @pModel,    
        @pUserId,       
        GETDATE(),     
        GETDATE(),    
        @pUserId,     
        GETDATE(),     
        GETDATE()    
       )    
   SET @pModelId = (SELECT ID FROM @Model)    
 END    
     
 IF (ISNULL(@pManufacturerId,0)=0)    
 BEGIN    
    
  IF(ISNULL(@MoodelCount, 0) > 0)    
  BEGIN    
                  
             UPDATE EngAssetStandardizationManufacturer    
             SET Manufacturer = @pManufacturer    
          WHERE ManufacturerId = @StandardManufacturerId    
          SET @pManufacturerId =@StandardManufacturerId    
  END    
  ELSE    
  BEGIN    
             INSERT INTO EngAssetStandardizationManufacturer ( Manufacturer,    
               CreatedBy,    
               CreatedDate,    
               CreatedDateUTC,    
               ModifiedBy,    
               ModifiedDate,    
               ModifiedDateUTC,  
      ServiceID  
               )    
             OUTPUT INSERTED.ManufacturerId INTO @Manf    
     VALUES        ( @pManufacturer,    
                                    @pUserId,       
                                    GETDATE(),     
                                    GETDATE(),    
                                    @pUserId,     
                                    GETDATE(),     
                                    GETDATE() ,  
         @pServiceId  
              )    
     SET @pManufacturerId = (SELECT ID FROM @Manf)    
  END    
    
 END    
        
  Declare @AlreadyExists INT = (SELECT COUNT(1) FROM EngAssetStandardization WHERE AssetTypeCodeId=@pAssetTypeCodeId AND ModelId= @pModelId)    
    
  IF(@AlreadyExists = 0 )    
  BEGIN    
   INSERT INTO EngAssetStandardization    
      (     
       AssetTypeCodeId,    
       ServiceId,    
       ManufacturerId,    
       ModelId,    
       UpperCost,    
       LowerCost,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC,    
       Status    
      ) OUTPUT INSERTED.AssetStandardizationId INTO @Table           
    
   VALUES       
      (     
       @pAssetTypeCodeId,    
       @pServiceId,    
       @pManufacturerId,    
       @pModelId,    
       @pUpperCost,    
       @pLowerCost,    
       @pUserId,       
       GETDATE(),     
       GETDATE(),    
       @pUserId,     
       GETDATE(),     
       GETDATE(),    
       @pStatus    
      )    
    SELECT AssetStandardizationId,    
     [Timestamp],    
     '' ErrorMessage ,          
     ManufacturerId,    
        
     ModelId    
    FROM EngAssetStandardization    
    WHERE AssetStandardizationId IN (SELECT ID FROM @Table)    
  END     
  ELSE    
  BEGIN    
             
   SET @pAssetStandardizationId = (SELECT AssetStandardizationId FROM EngAssetStandardization WHERE AssetTypeCodeId=@pAssetTypeCodeId AND ModelId=@pModelId)    
    
             UPDATE  AssetStandardization SET     
            
         AssetStandardization.ManufacturerId    = @pManufacturerId,            
         --AssetStandardization.UpperCost     = @pUpperCost,    
         --AssetStandardization.LowerCost     = @pLowerCost,    
         --AssetStandardization.Status      = @pStatus,    
         AssetStandardization.ModifiedBy     = @pUserId,    
         AssetStandardization.ModifiedDate    = GETDATE(),    
         AssetStandardization.ModifiedDateUTC   = GETUTCDATE()    
         OUTPUT INSERTED.AssetStandardizationId INTO @Table    
      FROM EngAssetStandardization      AS AssetStandardization    
      WHERE AssetStandardization.AssetStandardizationId= @pAssetStandardizationId     
        --AND ISNULL(@pAssetStandardizationId,0)>0    
       
          SELECT AssetStandardizationId,    
     [Timestamp],    
     '' ErrorMessage ,          
     ManufacturerId,    
     ModelId    
    FROM EngAssetStandardization    
    WHERE AssetStandardizationId IN (SELECT ID FROM @Table)    
                  
  END     
           
    
END    
    
ELSE     
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------    
      
    
BEGIN    
   DECLARE @mTimestamp varbinary(200);    
   SELECT @mTimestamp = Timestamp FROM EngAssetStandardization     
   WHERE AssetStandardizationId = @pAssetStandardizationId    
       
 IF(@mTimestamp= @pTimestamp)    
 BEGIN    
     IF (ISNULL(@pModelId,0)=0)    
  BEGIN    
    INSERT INTO EngAssetStandardizationModel ( Model,    
              CreatedBy,    
              CreatedDate,    
              CreatedDateUTC,    
              ModifiedBy,    
              ModifiedDate,    
              ModifiedDateUTC    
             )    
             OUTPUT INSERTED.ModelId INTO @Model    
     VALUES ( @pModel,    
        @pUserId,       
        GETDATE(),     
        GETDATE(),    
        @pUserId,     
        GETDATE(),     
        GETDATE()    
       )    
   SET @pModelId = (SELECT ID FROM @Model)    
  END    
    
  IF (ISNULL(@pManufacturerId,0)=0)    
  BEGIN    
   IF(ISNULL(@MoodelCount, 0) > 0)    
      BEGIN    
                  
        UPDATE EngAssetStandardizationManufacturer    
             SET Manufacturer = @pManufacturer    
          WHERE ManufacturerId = @StandardManufacturerId    
          SET @pManufacturerId =@StandardManufacturerId    
        SET @pManufacturerId =@StandardManufacturerId    
     END    
     ELSE    
     BEGIN    
     INSERT INTO EngAssetStandardizationManufacturer ( Manufacturer,    
               CreatedBy,    
               CreatedDate,    
               CreatedDateUTC,    
               ModifiedBy,    
               ModifiedDate,    
               ModifiedDateUTC    
               )    
             OUTPUT INSERTED.ManufacturerId INTO @Manf    
     VALUES ( @pManufacturer,    
        @pUserId,       
        GETDATE(),     
        GETDATE(),    
        @pUserId,     
        GETDATE(),     
        GETDATE()    
       )    
          SET @pManufacturerId = (SELECT ID FROM @Manf)    
     END     
        
        
 END    
    
   Declare @AlreadyExistsUPDATE INT = (SELECT COUNT(1) FROM EngAssetStandardization WHERE AssetTypeCodeId=@pAssetTypeCodeId AND ModelId= @pModelId)    
    
  IF(@AlreadyExistsUPDATE = 0 )    
  BEGIN    
   INSERT INTO EngAssetStandardization    
      (     
       AssetTypeCodeId,    
       ServiceId,    
       ManufacturerId,    
       ModelId,    
       UpperCost,    
       LowerCost,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC,    
       Status    
      ) OUTPUT INSERTED.AssetStandardizationId INTO @Table           
    
   VALUES       
      (     
       @pAssetTypeCodeId,    
       @pServiceId,    
       @pManufacturerId,    
       @pModelId,    
       @pUpperCost,    
       @pLowerCost,    
       @pUserId,       
       GETDATE(),     
       GETDATE(),    
       @pUserId,     
       GETDATE(),     
       GETDATE(),    
       @pStatus    
      )    
    SELECT AssetStandardizationId,    
     [Timestamp],    
     '' ErrorMessage ,          
     ManufacturerId,    
     ModelId    
    FROM EngAssetStandardization a    
    WHERE AssetStandardizationId IN (SELECT ID FROM @Table)    
        
  END    
  ELSE    
  BEGIN    
   UPDATE  AssetStandardization SET     
         AssetStandardization.AssetTypeCodeId   = @pAssetTypeCodeId,    
         AssetStandardization.ServiceId     = @pServiceId,    
         AssetStandardization.ManufacturerId    = @pManufacturerId,    
         AssetStandardization.ModelId     = @pModelId,    
         AssetStandardization.UpperCost     = @pUpperCost,    
         AssetStandardization.LowerCost     = @pLowerCost,    
         AssetStandardization.Status      = @pStatus,    
         AssetStandardization.ModifiedBy     = @pUserId,    
         AssetStandardization.ModifiedDate    = GETDATE(),    
         AssetStandardization.ModifiedDateUTC   = GETUTCDATE()    
         OUTPUT INSERTED.AssetStandardizationId INTO @Table    
      FROM EngAssetStandardization      AS AssetStandardization    
      WHERE AssetStandardization.AssetStandardizationId= @pAssetStandardizationId     
        AND ISNULL(@pAssetStandardizationId,0)>0    
          
     SELECT AssetStandardizationId,    
       [Timestamp],    
       '' ErrorMessage,    
       ManufacturerId,    
       ModelId    
     FROM EngAssetStandardization    
     WHERE AssetStandardizationId  = @pAssetStandardizationId    
    
  END    
    
    
        
   END       
  ELSE    
  BEGIN    
      SELECT AssetStandardizationId,    
      [Timestamp],    
      'Record Modified. Please Re-Select' ErrorMessage    
      FROM  EngAssetStandardization    
      WHERE AssetStandardizationId =@pAssetStandardizationId    
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
