USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSpareParts_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_EngSpareParts_Save  
Description   : If Testing and Commissioning already exists then update else insert.  
Authors    : DHILIP V  
Date    : 26-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [uspFM_EngSpareParts_Save] @pUserId=1,@pSparePartsId=1,@pServiceId=2,@pItemId=1,@pPartNo='P102',@pPartDescription='Part description',@pAssetTypeCodeId=1,@pManufacturerId=1  
@pBrandId=null,@pModelId=1,@pUnitOfMeasurement=1,@pSparePartType=37,@pLocation=41,@pSpecify=null,@pPartCategory=1,@pIsExpirydate=0,@pMinPrice='5.00',@pMaxPrice='10.00',  
@pMinPrice='5',@pMaxPrice='10',@pStatus=1,@pExpiryAgeInMonth=12,@pCurrentStockLevel=9,@pImagePath1= NULL,@pImagePath2= NULL,@pImagePath3=NULL, @pImagePath4=NULL,@pImagePath5= NULL,  
@pImagePath6= NULL,@pVideoPath= NULL,@pTimestamp= NULL  
  
SELECT Timestamp,* FROM EngSpareParts WHERE SparePartsId=1  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init :  Date       : Details  
========================================================================================================*/  
  
  
CREATE PROCEDURE  [dbo].[uspFM_EngSpareParts_Save]  
  
   @pUserId      INT     = NULL,    
   @pSparePartsId     INT     = NULL,  
   @pServiceId      INT,  
   @pItemId      INT,  
   @pPartNo      NVARCHAR(50)  = NULL,  
   @pPartDescription    NVARCHAR(100)  = NULL,  
   @pAssetTypeCodeId    INT     = NULL,  
   @pManufacturerId    INT     = NULL,  
   @pBrandId      INT     = NULL,  
   @pModelId      INT     = NULL,  
   @pUnitOfMeasurement    INT     = NULL,  
   @pSparePartType     INT     = NULL,  
   @pLocation      INT     = NULL,  
   @pSpecify      NVARCHAR(250)  = NULL,  
   @pPartCategory     INT     = NULL,  
    
   @pMinLevel      NUMERIC(24,2)  = NULL,  
   @pMaxLevel      NUMERIC(24,2)  = NULL,  
   @pMinPrice      NUMERIC(24,2)  = NULL,  
   @pMaxPrice      NUMERIC(24,2)  = NULL,  
   @pStatus      INT     = NULL,  
     
   @pCurrentStockLevel    NVARCHAR(150)  = NULL,  
   @pImage1DocumentId    INT     = NULL,  
   @pImage2DocumentId    INT     = NULL,  
   @pImage3DocumentId    INT     = NULL,  
   @pImage4DocumentId    INT     = NULL,  
   @pImage5DocumentId    INT     = NULL,  
   @pImage6DocumentId    INT     = NULL,  
   @pVideoDocumentId    NVARCHAR(500)  = NULL,  
   @pTimestamp      VARBINARY(200)  = NULL,  
   @pItemCode      VARCHAR(200)  = NULL,  
   @pItemDescription    VARCHAR(400)  = NULL,  
   @pPartSourceId     INT     = NULL,  
   @LifeSpanOptionId    INT     = NULL  
AS                                                
  
BEGIN TRY  
  
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT  
  
 BEGIN TRANSACTION  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
   
 DECLARE @Table TABLE (ID INT)  
 DECLARE @ItemTable TABLE (ID INT)  
 DECLARE @mItemId int = null   
-- Default Values  
  
  
-- Execution  
  
    IF(ISNULL(@pSparePartsId,0)= 0 OR @pSparePartsId='')  
 BEGIN     
  
 DECLARE @Cnt INT;  
  
   SELECT @Cnt = COUNT(1) FROM EngSpareParts WHERE PartNo = @pPartNo  
  
   IF (@Cnt = 0)   
     
   BEGIN  
  
     SET @mItemId= @pItemId  
  
      DECLARE @pItemCodeCount INT = (SELECT COUNT(1) FROM FMItemMaster WHERE ItemNo=@pItemCode)     
      IF(ISNULL(@pItemId,0) = 0 AND @pItemCodeCount = 0)  
      BEGIN  
                  INSERT INTO FMItemMaster (  
                                            ServiceId  
                                           ,ItemNo  
                                           ,ItemDescription  
                                           ,Status  
                                           ,PartCategory  
                                           ,CreatedBy  
                                           ,CreatedDate  
                                           ,CreatedDateUTC  
                                           ,ModifiedBy  
                                           ,ModifiedDate  
                                           ,ModifiedDateUTC  
                                           ) OUTPUT inserted.ItemId INTO @ItemTable  
      VALUES (@pServiceId, @pItemCode, @pItemDescription, 1 ,1, @pUserId, GETDATE(), GETDATE(), @pUserId, GETDATE(), GETDATE())  
  
  
      SET @mItemId=(SELECT ItemId FROM FMItemMaster WHERE ItemId IN (SELECT ID FROM @ItemTable))  
  
      END   
      ELSE IF (ISNULL(@pItemId,0) = 0 AND @pItemCodeCount > 0  )  
  
      BEGIN  
             SET @mItemId = (SELECT TOP 1 ItemId FROM FMItemMaster WHERE ItemNo=@pItemCode)   
      END   
  
              INSERT INTO EngSpareParts( ServiceId,  
           ItemId,  
           PartNo,  
           PartDescription,  
           AssetTypeCodeId,  
           ManufacturerId,  
           BrandId,  
           ModelId,  
           UnitOfMeasurement,  
           SparePartType,  
           Location,  
           Specify,  
           PartCategory,  
            
           MinLevel,  
           MaxLevel,  
           MinPrice,  
           MaxPrice,  
           Status,  
             
           CurrentStockLevel,  
           Image1DocumentId,  
           Image2DocumentId,  
           Image3DocumentId,  
           Image4DocumentId,  
           Image5DocumentId,  
           Image6DocumentId,  
           VideoDocumentId,  
           CreatedBy,  
           CreatedDate,  
           CreatedDateUTC,  
           ModifiedBy,  
           ModifiedDate,  
           ModifiedDateUTC , PartSourceId ,LifeSpanOptionId                                                                                                              
         )OUTPUT INSERTED.SparePartsId INTO @Table  
     VALUES    ( @pServiceId,  
          @mItemId,  
          @pPartNo,  
          @pPartDescription,  
          @pAssetTypeCodeId,  
          @pManufacturerId,  
          @pBrandId,  
          @pModelId,  
          @pUnitOfMeasurement,  
          @pSparePartType,  
          @pLocation,  
          @pSpecify,  
          @pPartCategory,  
           
          @pMinLevel,  
          @pMaxLevel,  
          @pMinPrice,  
          @pMaxPrice,  
          @pStatus,  
          @pCurrentStockLevel,  
          @pImage1DocumentId,  
          @pImage2DocumentId,  
          @pImage3DocumentId,  
          @pImage4DocumentId,  
          @pImage5DocumentId,  
          @pImage6DocumentId,  
          @pVideoDocumentId,  
          @pUserId,  
          GETDATE(),  
          GETUTCDATE(),  
          @pUserId,  
          GETDATE(),  
          GETUTCDATE() ,  
          @pPartSourceId,@LifeSpanOptionId  
           
            
         )  
  
         SELECT SparePartsId,  
       PartNo,  
       [Timestamp],         
       '' ErrorMessage,  
       GuId  
       FROM  EngSpareParts  
       WHERE SparePartsId IN (SELECT ID FROM @Table)  
   END  
   ELSE  
   BEGIN  
          SELECT 0  AS SparePartsId,  
      NULL PartNo,  
      NULL AS [Timestamp],  
      'Part No. Already Exists' ErrorMessage ,  
      NULL GuId  
   END  
  
        
   
  END  
  ELSE  
  
  BEGIN  
     
   DECLARE @mTimestamp varbinary(200);  
   SELECT @mTimestamp = Timestamp FROM EngSpareParts   
   WHERE SparePartsId = @pSparePartsId  
  
   IF (@mTimestamp= @pTimestamp)  
     
   BEGIN  
  
  
    UPDATE EngSpareParts SET   
             
           AssetTypeCodeId   = @pAssetTypeCodeId,  
           ManufacturerId   = @pManufacturerId,  
           BrandId     = @pBrandId,  
           ModelId     = @pModelId,  
           UnitOfMeasurement  = @pUnitOfMeasurement,  
           SparePartType   = @pSparePartType,  
           Location    = @pLocation,  
           Specify     = @pSpecify,  
           PartCategory   = @pPartCategory,  
             
           MinLevel    = @pMinLevel,  
           MaxLevel    = @pMaxLevel,  
           MinPrice    = @pMinPrice,  
           MaxPrice    = @pMaxPrice,  
           Status     = @pStatus,  
            
           CurrentStockLevel  = @pCurrentStockLevel,  
           Image1DocumentId  = @pImage1DocumentId,  
           Image2DocumentId  = @pImage2DocumentId,  
           Image3DocumentId  = @pImage3DocumentId,  
           Image4DocumentId  = @pImage4DocumentId,  
           Image5DocumentId  = @pImage5DocumentId,  
           Image6DocumentId  = @pImage6DocumentId,  
           VideoDocumentId   = @pVideoDocumentId,  
           ModifiedBy    = @pUserId,  
           ModifiedDate   = GETDATE(),  
           ModifiedDateUTC   = GETUTCDATE(),   
           PartSourceId   = @pPartSourceId ,  
           LifeSpanOptionId  = @LifeSpanOptionId  
             
    WHERE SparePartsId =   @pSparePartsId  
  
    SELECT SparePartsId,  
      PartNo,  
      [Timestamp],         
      '' ErrorMessage,  
      GuId  
    FROM EngSpareParts  
    WHERE SparePartsId =@pSparePartsId  
  
  END  
  ELSE  
   BEGIN  
    SELECT SparePartsId,  
      PartNo,  
      [Timestamp],         
      'Record Modified. Please Re-Select' AS ErrorMessage,  
      GuId  
    FROM EngSpareParts  
    WHERE SparePartsId =@pSparePartsId  
   END  
  END  
  
 IF @mTRANSCOUNT = 0  
        BEGIN  
            COMMIT TRANSACTION  
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
