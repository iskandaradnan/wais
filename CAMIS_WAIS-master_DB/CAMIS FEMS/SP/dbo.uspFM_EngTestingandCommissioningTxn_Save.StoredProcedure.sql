USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxn_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
    
    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
    
    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_EngTestingandCommissioningTxn_Save    
Description   : If Testing and Commissioning already exists then update else insert.    
Authors    : Balaji M S    
Date    : 05-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
    
    
EXEC [uspFM_EngTestingandCommissioningTxn_Save] @pUserId=2,@pTestingandCommissioningId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pTandCDocumentNo=NULL    
,@pTandCDate='2018-04-20 17:12:39.100',@pTandCDateUTC=null,@pTandCType=73,@pAssetTypeCodeId=1,@pTandCStatus=71,@pTandCCompletedDate='2018-04-01 17:12:39.100'    
,@pTandCCompletedDateUTC=null,@pHandoverDate='2018-04-25 17:12:39.100',@pHandoverDateUTC=null,@pVariationStatus=125,@pTandCContractorRepresentative='Dev'    
,@pFmsCustomerRepresentativeId=1,@pFmsFacilityRepresentativeId=2,@pRemarks=null ,@pPurchaseDate='2018-04-25 17:12:39.100'    
,@pPurchaseDateUTC=null,@pPurchaseCost='10',@pContractLPONo='LP010',@pServiceStartDate='2018-04-25 17:12:39.100',@pServiceStartDateUTC=null,@pServiceEndDate=null    
,@pServiceEndDateUTC=null,@pMainSupplierCode='Supp101',@pMainSupplierName='Supplier1',@pWarrantyStartDate='2018-04-25 17:12:39.100',@pWarrantyStartDateUTC=null    
,@pWarrantyDuration=12,@pWarrantyEndDate=null,@pWarrantyEndDateUTC=null ,@pUserAreaId=null,@pUserLocationId=null,@pTimestamp=null,@pStatus=7,@pVerifyRemarks=null,    
@pApprovalRemarks=null,@pRejectRemarks=null    
    
SELECT Timestamp,* FROM EngTestingandCommissioningTxn WHERE TestingandCommissioningId=63    
SELECT Timestamp,* FROM EngTestingandCommissioningTxnDet WHERE TestingandCommissioningId=63    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init :  Date       : Details    
EDIT BY PRANAY (TYPEOFSERVICE AND BATCHNO) 24-10-2019    
========================================================================================================*/    
    
CREATE PROCEDURE  [dbo].[uspFM_EngTestingandCommissioningTxn_Save]    
    
   @pUserId      INT       = NULL,     
   @pTestingandCommissioningId  INT       = NULL,    
   @pCustomerId     INT       = NULL,    
   @pFacilityId     INT       = NULL,    
   @pServiceId      INT       = NULL,    
    
   @pTandCDocumentNo    NVARCHAR(50)    = NULL,    
   @pTandCDate      DATETIME,    
   @pTandCDateUTC     DATETIME     = NULL,    
   @pAssetTypeCodeId    INT       = NULL,    
   @pTandCStatus     INT,    
   @pTandCCompletedDate   DATETIME     = NULL,    
   @pTandCCompletedDateUTC   DATETIME     = NULL,    
   @pHandoverDate     DATETIME     = NULL,    
   @pHandoverDateUTC    DATETIME     = NULL,    
   @pVariationStatus    INT,    
   @pTandCContractorRepresentative NVARCHAR(100)    = NULL,    
   @pFmsCustomerRepresentativeId INT,    
   @pFmsFacilityRepresentativeId INT,    
   @pTypeOfService    VARCHAR(100)               =   NULL,    
   @pBatchNo                       VARCHAR(100)               =   NULL,    
   @pRemarks      NVARCHAR(500)    = NULL,    
    
   @pPurchaseDate     DATETIME     = NULL,    
   @pPurchaseDateUTC    DATETIME     = NULL,    
   @pPurchaseCost     NUMERIC(24,2)    = NULL,    
   @pContractLPONo     NVARCHAR(100)    = NULL,       
   @pServiceStartDate    DATETIME     = NULL,    
   @pServiceStartDateUTC   DATETIME     = NULL,    
   @pServiceEndDate    DATETIME     = NULL,    
   @pServiceEndDateUTC    DATETIME     = NULL,    
   @pMainSupplierCode    NVARCHAR(50)    = NULL,    
   @pMainSupplierName    NVARCHAR(100)    = NULL,    
   @pWarrantyStartDate    DATETIME     = NULL,    
   @pWarrantyStartDateUTC   DATETIME     = NULL,    
   @pWarrantyDuration    INT       = NULL,    
   @pWarrantyEndDate    DATETIME     = NULL,    
   @pWarrantyEndDateUTC   DATETIME     = NULL,        
   @pVerifyRemarks     NVARCHAR(500)    = NULL,    
   @pApprovalRemarks    NVARCHAR(500)    = NULL,    
   @pRejectRemarks     NVARCHAR(500)    = NULL,    
    
   @pUserAreaId     INT       = NULL,    
   @pUserLocationId    INT       = NULL,    
   @pTimestamp      varbinary(200)    = NULL,    
   @pStatus      INT       = NULL,    
   @pQRCode      VARBINARY(MAX)    = NULL,    
   @pAssetCategoryLovId            INT       = NULL,    
   @pManufacturerId    INT       = NULL,    
   @pModelId      INT       = NULL,    
   @pAssetNoOld     NVARCHAR(100)    = NULL,    
   @pSerialNo      NVARCHAR(100)    = NULL,    
   @pPONo       NVARCHAR(100)    = NULL,    
   @pRequiredCompletionDate  DATETIME     = NULL,    
   @pCRMRequestId     INT       =   NULL,    
   @pRequestDate     DATETIME     = NULL,    
   @pRequestDateUTC    DATETIME     = NULL    
    
AS                                                  
    
BEGIN TRY    
    
    
    
--select @pOutParam    
    
    
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT    
    
 BEGIN TRANSACTION    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
-- Declaration    
     
 DECLARE @Table TABLE (ID INT)    
    
-- Default Values    
    
 SET @pTandCDateUTC   = DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pTandCDate)    
 SET @pPurchaseDateUTC  = DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pPurchaseDate)    
 SET @pTandCCompletedDateUTC = DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pTandCCompletedDate)    
 SET @pHandoverDateUTC  = DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pHandoverDate)    
 SET @pServiceStartDateUTC = DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceStartDate)    
 SET @pServiceEndDateUTC  = DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pServiceEndDate)    
    
-- Execution    
    
    IF(ISNULL(@pTestingandCommissioningId,0)= 0 OR @pTestingandCommissioningId='')    
   BEGIN    
    
DECLARE @pOutParam NVARCHAR(50)     
EXEC [uspFM_GenerateDocumentNumber] @pFlag='TestingandCommissioning',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='TC',@pModuleName='FEMS',@pMonth=NULL,@pYear=NULL,@pOutParam=@pOutParam out    
    
SELECT @pTandCDocumentNo=@pOutParam    
    
           INSERT INTO EngTestingandCommissioningTxn(    
           CustomerId,    
           FacilityId,    
           ServiceId,    
           TandCDocumentNo,    
           TandCDate,    
           TandCDateUTC,    
           AssetTypeCodeId,    
           TandCStatus,               
           TandCCompletedDate,    
           TandCCompletedDateUTC,    
           HandoverDate,    
           HandoverDateUTC,    
           PurchaseCost,    
           PurchaseDate,    
           PurchaseDateUTC,    
           ServiceStartDate,    
           ServiceStartDateUTC,    
           ContractLPONo,    
           VariationStatus,    
           TandCContractorRepresentative,    
           CustomerRepresentativeUserId,    
           FacilityRepresentativeUserId,    
           UserAreaId,    
           UserLocationId,    
           Remarks,   
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC,    
           WarrantyDuration,    
           WarrantyStartDate,    
           WarrantyStartDateUTC,    
           WarrantyEndDate,    
           WarrantyEndDateUTC,    
           MainSupplierCode,    
           MainSupplierName,    
           ServiceEndDate,    
           ServiceEndDateUTC,    
           Status,    
           VerifyRemarks,    
           ApprovalRemarks,    
           RejectRemarks,    
           QRCode,    
           AssetCategoryLovId,     
           ManufacturerId,         
           ModelId,                
           AssetNoOld,             
           SerialNo,               
           PONo ,    
           RequiredCompletionDate,    
           CRMRequestId ,    
           RequestDate,    
           RequestDateUTC ,    
           BatchNo    
                           )OUTPUT INSERTED.TestingandCommissioningId INTO @Table    
     VALUES      (    
           @pCustomerId,    
           @pFacilityId,    
           @pServiceId,    
           @pTandCDocumentNo,    
           --(SELECT 'TC' +  ISNULL(CAST(MAX(RIGHT(TandCDocumentNo,4)) + 1 AS NVARCHAR(50)),1000) FROM EngTestingandCommissioningTxn) ,    
           @pTandCDate,    
           @pTandCDateUTC,    
           @pAssetTypeCodeId,    
           @pTandCStatus,              
           @pTandCCompletedDate,    
           @pTandCCompletedDateUTC,    
           @pHandoverDate,    
           @pHandoverDateUTC,    
           @pPurchaseCost,    
           @pPurchaseDate,    
           @pPurchaseDateUTC,    
           @pServiceStartDate,    
           @pServiceStartDateUTC,    
           @pContractLPONo,    
           @pVariationStatus,    
           @pTandCContractorRepresentative,    
           @pFmsCustomerRepresentativeId,    
           @pFmsFacilityRepresentativeId,    
           @pUserAreaId,    
           @pUserLocationId,    
           @pRemarks,    
           @pUserId,    
           GETDATE(),    
           GETUTCDATE(),    
           @pUserId,    
           GETDATE(),    
           GETUTCDATE(),    
           @pWarrantyDuration,    
           @pWarrantyStartDate,    
           @pWarrantyStartDateUTC,    
           @pWarrantyEndDate,    
           @pWarrantyEndDateUTC,    
           @pMainSupplierCode,    
           @pMainSupplierName,    
           @pServiceEndDate,    
           @pServiceEndDateUTC,    
           @pStatus,    
           @pVerifyRemarks,    
           @pApprovalRemarks,    
           @pRejectRemarks,    
           @pQRCode,    
           @pAssetCategoryLovId,    
           @pManufacturerId,     
           @pModelId,       
           @pAssetNoOld,      
           @pSerialNo,       
           @pPONo,    
           @pRequiredCompletionDate,    
           @pCRMRequestId,    
           @pRequestDate,    
           @pRequestDateUTC,    
           @pBatchNo    
           )    
   UPDATE CRMRequest SET RequestStatus = 142 WHERE CRMRequestId = @pCRMRequestId    
    
   DECLARE @mPrimaryId INT    
   SELECT @mPrimaryId =  TestingandCommissioningId     
   FROM EngTestingandCommissioningTxn    
   WHERE TestingandCommissioningId IN (SELECT ID FROM @Table)    
    
DECLARE @pOutParam1 NVARCHAR(50) ,@pAssetPreRegistrationNo NVARCHAR(50)    
   EXEC [uspFM_GenerateDocumentNumber] @pFlag='TestingandCommissioningDet',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='FEMS',@pModuleName='FEMS',@pMonth=NULL,@pYear=NULL,@pOutParam=@pOutParam1 out    
SELECT @pAssetPreRegistrationNo =@pOutParam1    
    
     INSERT INTO EngTestingandCommissioningTxnDet(    
             CustomerId,    
             FacilityId,    
             ServiceId,    
             TestingandCommissioningId,    
             AssetPreRegistrationNo,    
             CreatedBy,    
             CreatedDate,    
             CreatedDateUTC,    
             ModifiedBy,    
             ModifiedDate,    
             ModifiedDateUTC    
                                                    )    
    
       SELECT           
             @pCustomerId,    
             @pFacilityId,    
             @pServiceId,    
             @mPrimaryId,    
             @pAssetPreRegistrationNo,    
             --(SELECT 'BEMS/TC/' +  ISNULL(CAST(MAX(RIGHT(AssetPreRegistrationNo,3)) + 1 AS NVARCHAR(50)),1000) FROM EngTestingandCommissioningTxnDet),     
             @pUserId,      
             GETDATE(),    
             GETUTCDATE(),    
             @pUserId,    
             GETDATE(),    
             GETUTCDATE()    
          
    
         SELECT CommissioningTxn.TestingandCommissioningId,    
       TandCDocumentNo,    
       CommissioningTxnDet.AssetPreRegistrationNo,    
       CASE    
        WHEN CommissioningTxn.WarrantyEndDate >= GETDATE() THEN '99'    
        WHEN CommissioningTxn.WarrantyEndDate <  GETDATE() THEN '100'    
        ELSE NULL     
       END                 AS WarrantyStatus,    
       CommissioningTxn.[Timestamp],           
       '' ErrorMessage,    
       CommissioningTxn.QRCode,    
       LovActions.FieldValue    AS StatusName,    
       CommissioningTxn.GuId    
       FROM  EngTestingandCommissioningTxn AS CommissioningTxn WITH(NOLOCK)    
       INNER JOIN EngTestingandCommissioningTxnDet AS CommissioningTxnDet WITH(NOLOCK) ON CommissioningTxn.TestingandCommissioningId = CommissioningTxnDet.TestingandCommissioningId    
       LEFT JOIN FMLovMst       AS LovActions WITH(NOLOCK) ON CommissioningTxn.Status = LovActions.LovId    
       WHERE CommissioningTxn.TestingandCommissioningId IN (SELECT ID FROM @Table)    
     
  END    
  ELSE    
    
  BEGIN    
       
   DECLARE @mTimestamp varbinary(200);    
   SELECT @mTimestamp = Timestamp FROM EngTestingandCommissioningTxn     
   WHERE TestingandCommissioningId = @pTestingandCommissioningId    
    
   IF (@mTimestamp=@pTimestamp)    
       
   BEGIN    
    
    
    UPDATE EngTestingandCommissioningTxn SET    
         TandCDate         = @pTandCDate,    
         TandCDateUTC        = @pTandCDateUTC,    
         AssetTypeCodeId        = @pAssetTypeCodeId,    
         TandCStatus         = @pTandCStatus,    
         TandCCompletedDate       = @pTandCCompletedDate,    
         TandCCompletedDateUTC      = @pTandCCompletedDateUTC,    
         HandoverDate        = @pHandoverDate,    
         HandoverDateUTC        = @pHandoverDateUTC,    
         PurchaseCost        = @pPurchaseCost,    
         PurchaseDate        = @pPurchaseDate,    
         PurchaseDateUTC        = @pPurchaseDateUTC,    
         ServiceStartDate       = @pServiceStartDate,    
         ServiceStartDateUTC       = @pServiceStartDateUTC,    
         ContractLPONo        = @pContractLPONo,    
         VariationStatus        = @pVariationStatus,    
         TandCContractorRepresentative    = @pTandCContractorRepresentative,    
         CustomerRepresentativeUserId    = @pFmsCustomerRepresentativeId,    
         FacilityRepresentativeUserId    = @pFmsFacilityRepresentativeId,    
         UserAreaId         = @pUserAreaId,    
         UserLocationId        = @pUserLocationId,    
         Remarks          = @pRemarks,    
         ModifiedBy         = @pUserId,    
         ModifiedDate        = GETDATE(),    
         ModifiedDateUTC        = GETUTCDATE(),    
         WarrantyDuration       = @pWarrantyDuration,    
         WarrantyStartDate       = @pWarrantyStartDate,    
         WarrantyStartDateUTC      = @pWarrantyStartDateUTC,    
         WarrantyEndDate        = @pWarrantyEndDate,    
         WarrantyEndDateUTC        = @pWarrantyEndDateUTC,    
         MainSupplierCode       = @pMainSupplierCode,    
         MainSupplierName       = @pMainSupplierName,    
         ServiceEndDate        = @pServiceEndDate,    
         ServiceEndDateUTC       = @pServiceEndDateUTC,    
         Status          = @pStatus,    
         QRCode          = @pQRCode,    
         AssetCategoryLovId       = @pAssetCategoryLovId,    
         ManufacturerId        = @pManufacturerId,    
         ModelId          = @pModelId,             
         AssetNoOld         = @pAssetNoOld,            
         SerialNo         = @pSerialNo,         
         PONo          = @pPONo  ,    
         RequiredCompletionDate      = @pRequiredCompletionDate,    
         CRMRequestId        =   @pCRMRequestId,    
         RequestDate         = @pRequestDate,    
         RequestDateUTC        = @pRequestDateUTC,    
         BatchNo                                     =   @pBatchNo    
      WHERE TestingandCommissioningId =   @pTestingandCommissioningId    
    
      IF (@pStatus=289)    
      BEGIN    
    UPDATE EngTestingandCommissioningTxn SET VerifyRemarks=@pVerifyRemarks WHERE TestingandCommissioningId =   @pTestingandCommissioningId    
      END           
      IF (@pStatus=290)    
      BEGIN    
    UPDATE EngTestingandCommissioningTxn SET ApprovalRemarks=@pApprovalRemarks WHERE TestingandCommissioningId =   @pTestingandCommissioningId    
      END          
      IF (@pStatus=291)    
      BEGIN    
    UPDATE EngTestingandCommissioningTxn SET RejectRemarks=@pRejectRemarks WHERE TestingandCommissioningId =   @pTestingandCommissioningId    
      END     
    
      SELECT CommissioningTxn.TestingandCommissioningId,    
      TandCDocumentNo,    
      CommissioningTxnDet.AssetPreRegistrationNo,    
      CASE    
       WHEN CommissioningTxn.WarrantyEndDate >= GETDATE() THEN '99'    
       WHEN CommissioningTxn.WarrantyEndDate <  GETDATE() THEN '100'    
       ELSE NULL     
      END                 AS WarrantyStatus,    
      CommissioningTxn.[Timestamp],           
      '' ErrorMessage,    
      CommissioningTxn.QRCode,    
      --CASE WHEN CommissioningTxn.Status = 7 THEN 'Approved'    
      --  WHEN CommissioningTxn.Status = 8 THEN 'Rejected'    
      --  WHEN CommissioningTxn.Status = 9 THEN 'Verified'    
      --  WHEN ISNULL(CommissioningTxn.Status,0) = 2 THEN 'Submitted'    
      --  WHEN ISNULL(CommissioningTxn.Status,0) = 1 THEN 'Cancelled'    
      --END StatusName    
      LovActions.FieldValue    AS StatusName,    
      CommissioningTxn.GuId    
    FROM EngTestingandCommissioningTxn     AS CommissioningTxn WITH(NOLOCK)    
      INNER JOIN EngTestingandCommissioningTxnDet AS CommissioningTxnDet WITH(NOLOCK) ON CommissioningTxn.TestingandCommissioningId = CommissioningTxnDet.TestingandCommissioningId    
      LEFT JOIN FMLovMst       AS LovActions WITH(NOLOCK) ON CommissioningTxn.Status = LovActions.LovId    
    WHERE CommissioningTxn.TestingandCommissioningId = @pTestingandCommissioningId    
    
  END    
  ELSE    
   BEGIN    
         SELECT CommissioningTxn.TestingandCommissioningId,    
       TandCDocumentNo,    
       CommissioningTxnDet.AssetPreRegistrationNo,    
       CASE    
        WHEN CommissioningTxn.WarrantyEndDate >= GETDATE() THEN '99'    
        WHEN CommissioningTxn.WarrantyEndDate <  GETDATE() THEN '100'    
        ELSE NULL     
       END                 AS WarrantyStatus,    
       CommissioningTxn.[Timestamp],    
       'Record Modified. Please Re-Select' AS ErrorMessage,    
       CommissioningTxn.QRCode,    
       LovActions.FieldValue    AS StatusName,    
       CommissioningTxn.GuId    
       FROM  EngTestingandCommissioningTxn     AS CommissioningTxn WITH(NOLOCK)    
       INNER JOIN EngTestingandCommissioningTxnDet AS CommissioningTxnDet WITH(NOLOCK) ON CommissioningTxn.TestingandCommissioningId = CommissioningTxnDet.TestingandCommissioningId    
       LEFT JOIN FMLovMst       AS LovActions WITH(NOLOCK) ON CommissioningTxn.Status = LovActions.LovId    
       WHERE CommissioningTxn.TestingandCommissioningId = @pTestingandCommissioningId    
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
