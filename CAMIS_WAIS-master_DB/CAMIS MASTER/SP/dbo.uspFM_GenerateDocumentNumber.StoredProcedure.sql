USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GenerateDocumentNumber]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
        
          
            
              
                
                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
        
          
            
              
                
                
/*========================================================================================================                
Application Name : UETrack-BEMS                              
Version    : 1.0                
Procedure Name  : uspFM_GenerateDocumentNumber                
Description   : If Testing and Commissioning already exists then update else insert.                
Authors    : DHILIP V                
Date    : 26-April-2018                
-----------------------------------------------------------------------------------------------------------                
                
Unit Test:                
                
DECLARE @pOutParam NVARCHAR(50)                  
                
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Clean Linen Despatch',@pCustomerId=157,@pFacilityId=144,@Defaultkey='CLD',@pModuleName=NULL,@pMonth=03,@pYear=2020,@pOutParam=@pOutParam OUTPUT                
SELECT @pOutParam                
                
SELECT * FROM FMDocumentNoGeneration                
-----------------------------------------------------------------------------------------------------------                
Version History                 
-----:------------:---------------------------------------------------------------------------------------                
Init :  Date       : Details                
========================================================================================================*/                
        
        
        
        
CREATE Procedure [dbo].[uspFM_GenerateDocumentNumber]                      
                      
 @pFlag nvarchar(50),                      
 @pCustomerId int,                      
 @pFacilityId int,                      
 @Defaultkey nvarchar(50),                      
 @pModuleName nvarchar(50) =NULL,                      
 @pService nvarchar(50)  =NULL,                      
 @pMonth int,                      
 @pYear int ,                      
 @pOutParam NVARCHAR(50) OUTPUT                                                                
                      
AS                      
BEGIN TRY                      
    
    
    
                      
 --DECLARE @mTRANSCOUNT INT = @@TRANCOUNT                      
                      
 --BEGIN TRANSACTION                      
                      
-- Paramter Validation                       
                      
 SET NOCOUNT ON;                      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                      
                      
-- Declaration                      
   DECLARE @DocumentNumber NVARCHAR(100)                  
   DECLARE @Prefix NVARCHAR(100)                        
   DECLARE @DocumentCount int                      
   DECLARE @CodeNumber int                      
   DECLARE @MonthName nvarchar(20)                      
   DECLARE @pFacility nvarchar(50)                      
   SELECT @pFacility = FacilityCode FROM MstLocationFacility WHERE FacilityId=@pFacilityId                      
                         
                         
 DECLARE @Table TABLE (ID INT)                      
                      
-- Default Values                      
                      
 SET @MonthName=UPPER(SUBSTRING (DATENAME(MONTH,DATEFROMPARTS(@pYear, @pMonth, 1 )),1,3))                      
                      
-- Execution                      
           
                      
---------------------------------------------------------- 1) TestingandCommissioning ---------------------------------------------------------------                      
                      
   IF(@pFlag='TestingandCommissioning')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='TestingandCommissioning'),0)                      
                      
   IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                       DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'TestingandCommissioning',                      
         @DocumentNumber,                      
1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='TestingandCommissioning'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='TestingandCommissioning'                      
                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
    --SELECT @DocumentNumber                      
   END                      
                      
                      
                      
---------------------------------------------------------- 1.1) TestingandCommissioningDet ---------------------------------------------------------------                      
                      
   IF(@pFlag='TestingandCommissioningDet')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='TestingandCommissioningDet'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,       
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'TestingandCommissioningDet',                      
         @DocumentNumber,                      
         1,       
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='TestingandCommissioningDet'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='TestingandCommissioningDet'                      
                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
    --SELECT @DocumentNumber                      
   END                      
                      
---------------------------------------------------------- 2) EngEODCaptureTxn ---------------------------------------------------------------                      
                      
  ELSE IF(@pFlag='EngEODCaptureTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngEODCaptureTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngEODCaptureTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngEODCaptureTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngEODCaptureTxn'                      
                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
---------------------------------------------------------- 3) BERApplicationTxn ---------------------------------------------------------------                      
                      
  ELSE IF(@pFlag='BERApplicationTxn')                      
               
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='BERApplicationTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
   @pFacilityId,                      
         'BERApplicationTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='BERApplicationTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='BERApplicationTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
---------------------------------------------------------- 3) EngMaintenanceWorkOrderTxn (Only for UnScheduled) ---------------------------------------------------------------                      
                      
  ELSE IF(@pFlag='EngMaintenanceWorkOrderTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+right(cast(@pYear as varchar(10)),4)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngMaintenanceWorkOrderTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,            
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngMaintenanceWorkOrderTxn',            
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                     
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngMaintenanceWorkOrderTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngMaintenanceWorkOrderTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
---------------------------------------------------------- 4)EngStockUpdateRegisterTxn  ---------------------------------------------------------------                      
ELSE IF(@pFlag='EngStockUpdateRegisterTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngStockUpdateRegisterTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngStockUpdateRegisterTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                  
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngStockUpdateRegisterTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngStockUpdateRegisterTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
--------------------------------------------------------6) EngStockAdjustmentTxn--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='EngStockAdjustmentTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngStockAdjustmentTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
 begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
     'EngStockAdjustmentTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngStockAdjustmentTxn'                      
                        
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE  DocumentNumber=@DocumentNumber AND ScreenName='EngStockAdjustmentTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
--------------------------------------------------------7) CRMRequest--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='CRMRequest')                      
                      
   BEGIN                      
    --SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
       SET @DocumentNumber=@Defaultkey+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+'/'          
 SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='CRMRequest'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
       'CRMRequest',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='CRMRequest'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='CRMRequest'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
--------------------------------------------------------7) CRMRequestWorkOrderTxn--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='CRMRequestWorkOrderTxn')                      
                      
 BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='CRMRequestWorkOrderTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'CRMRequestWorkOrderTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='CRMRequestWorkOrderTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='CRMRequestWorkOrderTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
--------------------------------------------------------8) QAPCarTxn--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='QAPCarTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='QAPCarTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'QAPCarTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE       
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='QAPCarTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='QAPCarTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
--------------------------------------------------------9) PorteringTransaction--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='PorteringTransaction')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='PorteringTransaction'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
       CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'PorteringTransaction',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='PorteringTransaction'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='PorteringTransaction'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
--------------------------------------------------------10) DeductionGeneration--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='DedGenerationTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='DedGenerationTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
          DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                     
         'DedGenerationTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                  
       AND ScreenName='DedGenerationTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='DedGenerationTxn'            
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
--------------------------------------------------------11) EngTrainingScheduleTxn--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='EngTrainingScheduleTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngTrainingScheduleTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,            
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngTrainingScheduleTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngTrainingScheduleTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngTrainingScheduleTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
--------------------------------------------------------12) EngWarrantyManagementTxn--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='EngWarrantyManagementTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber = @Defaultkey+'/'+@pModuleName+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngWarrantyManagementTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngWarrantyManagementTxn',             
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngWarrantyManagementTxn'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngWarrantyManagementTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
                      
                      
--------------------------------------------------------13) QAPCarTxn--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='QAPCarTxn')                      
                      
   BEGIN                      
    SET @DocumentNumber = @Defaultkey+'/'+@pModuleName+'/'+@pFacility+'/'+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='QAPCarTxn'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'QAPCarTxn',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='QAPCarTxn'                      
                           
    UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='QAPCarTxn'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                 
                      
                      
                      
                      
                      
--------------------------------------------------------14) EngAssetClassification--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='EngAssetClassification')                      
                      
   BEGIN                      
    SET @DocumentNumber = @Defaultkey+'-'--+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngAssetClassification'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngAssetClassification',                      
         @DocumentNumber,                      
        1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngAssetClassification'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngAssetClassification'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000'+CAST (@CodeNumber AS VARCHAR(20)),3)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
                      
                      
                      
--------------------------------------------------------15) MstCustomer--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='MstCustomer')            
                      
   BEGIN                      
    SET @DocumentNumber = @Defaultkey+'-'--+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='MstCustomer'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'MstCustomer',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00'+cast (1 as varchar(10))                      
END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='MstCustomer'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='MstCustomer'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000'+CAST (@CodeNumber AS VARCHAR(20)),3)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                
                      
                      
                      
                      
                      
--------------------------------------------------------16) MstLocationFacility--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='MstLocationFacility')                      
                      
   BEGIN                      
    SET @DocumentNumber = @Defaultkey--+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='MstLocationFacility'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                   
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'MstLocationFacility',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00'+cast (1 as varchar(10))                      
   END                   
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                      
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='MstLocationFacility'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='MstLocationFacility'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000'+CAST (@CodeNumber AS VARCHAR(20)),3)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
                      
---------------------------------------------------------- 17) EngMaintenanceWorkOrderTxn (Only for Scheduled) ---------------------------------------------------------------                      
                      
  ELSE IF(@pFlag='EngMaintenanceWorkOrderTxnSchd')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey--+'/'+@pModuleName                      
         +'/'+@pService+'/'+right(cast(@pYear as varchar(10)),4)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngMaintenanceWorkOrderTxnSchd'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
       CreatedDateUTC,                    
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngMaintenanceWorkOrderTxnSchd',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngMaintenanceWorkOrderTxnSchd'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngMaintenanceWorkOrderTxnSchd'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
                      
                      
                      
--------------------------------------------------------18) EngAssetClassification--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='EngAssetPPMCheckList')                      
                      
   BEGIN                      
    SET @DocumentNumber = @Defaultkey+'/'--+RIGHT(CAST(@pYear AS VARCHAR(10)),4)+RIGHT('0'+CAST(@pMonth AS VARCHAR(10)),2)+'/'                      
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngAssetPPMCheckList'),0)                      
                      
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                    
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngAssetPPMCheckList',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'0000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngAssetPPMCheckList'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngAssetPPMCheckList'                      
      SET @DocumentNumber=@DocumentNumber+RIGHT('0000'+CAST (@CodeNumber AS VARCHAR(20)),4)                      
    END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
        
                      
                      
                      
--------------------------------------------------------18) EngAsset--------------------------------------------------------------------------------------                      
                      
ELSE IF(@pFlag='EngAsset')                      
                      
   BEGIN                      
    SET @DocumentNumber =@Defaultkey                    
    SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngAsset'),0)                      
    SET @Prefix=(select[FacilityCode] from [MstLocationFacility] where [FacilityId]=@pFacilityId)                
    IF(@DocumentCount=0)                      
    BEGIN                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
             CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'EngAsset',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
)                       
    SET @DocumentNumber=@DocumentNumber+'0000'+cast (1 as varchar(10))                   
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='EngAsset'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngAsset'                  
      SET @DocumentNumber=@DocumentNumber+RIGHT('00000'+CAST (@CodeNumber AS VARCHAR(20)),5)               
     END                      
                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
                      
          
--------------------------LLS MODULE DOCUMENT GENERATION SCRIPT-----------------          
          
-------------------------Clean Linen Despatch          
          
          
  ELSE IF(@pFlag='Clean Linen Despatch')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Clean Linen Despatch'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Clean Linen Despatch',                      
         @DocumentNumber,                      
         1,                      
         1,           
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Clean Linen Despatch'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Clean Linen Despatch'                      
     SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
   -------------------------------Clean Linen Request          
          
   ELSE IF(@pFlag='Clean Linen Request')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Clean Linen Request'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Clean Linen Request',                      
         @DocumentNumber,                      
         1,                      
         1,       
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Clean Linen Request'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Clean Linen Request'                      
    SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
   ----------------------------Clean Linen Issue          
          
    ELSE IF(@pFlag='Clean Linen Issue')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Clean Linen Issue'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Clean Linen Issue',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Clean Linen Issue'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Clean Linen Issue'                      
     SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
----------------------------------Soiled Linen Collection          
          
 ELSE IF(@pFlag='Soiled Linen Collection')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Soiled Linen Collection'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Soiled Linen Collection',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Soiled Linen Collection'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Soiled Linen Collection'                      
    SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
   --------------------------------------Linen Repair          
          
   ELSE IF(@pFlag='Linen Repair')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Linen Repair'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
   VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Linen Repair',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Linen Repair'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Linen Repair'                      
   SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
   ----------------------------Linen Reject / Replacement          
          
    ELSE IF(@pFlag='Linen Reject / Replacement')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Linen Reject / Replacement'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                        INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Linen Reject / Replacement',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Linen Reject / Replacement'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Linen Reject / Replacement'                      
   SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
----------------------------------------Linen Condemnation          
          
          
    ELSE IF(@pFlag='Linen Condemnation')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Linen Condemnation'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Linen Condemnation',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
      1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Linen Condemnation'                      
     
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Linen Condemnation'                      
    SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
          
          
   ------------------------------------Linen Inventory          
          
    ELSE IF(@pFlag='Linen Inventory')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Linen Inventory'),0)                    
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Linen Inventory',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Linen Inventory'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Linen Inventory'                      
    SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
          
--------------------------------Linen Adjustments          
          
    ELSE IF(@pFlag='Linen Adjustments')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Linen Adjustments'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                  
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Linen Adjustments',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Linen Adjustments'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Linen Adjustments'                      
  SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END                      
          
------------------Linen Injection          
          
          
    ELSE IF(@pFlag='Linen Injection')                      
                      
   BEGIN                      
    SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Linen Injection'),0)                      
                      
    IF(@DocumentCount=0)                      
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Linen Injection',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Linen Injection'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Linen Injection'                      
 SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('00000',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CONCAT('0000',CAST (@CodeNumber AS VARCHAR(20))),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END      
         
------------------      
      
ELSE IF(@pFlag='Driver Code')                      
                      
   BEGIN                      
    SET @DocumentNumber='SCT'--@Defaultkey+'/'+@pFacility+'/'+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'                      
    SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='Driver Code'),0)                      
                      
    IF(@DocumentCount=0)                     
    begin                      
    INSERT INTO FMDocumentNoGeneration( CustomerId,                      
             FacilityId,                      
             ScreenName,                      
             DocumentNumber,                      
             CodeNumber,                      
CreatedBy,                      
             CreatedDate,                      
             CreatedDateUTC,                      
             ModifiedBy,                      
             ModifiedDate,                      
             ModifiedDateUTC)                       
      VALUES ( @pCustomerId,                      
         @pFacilityId,                      
         'Driver Code',                      
         @DocumentNumber,                      
         1,                      
         1,                      
         GETDATE(),                      
         GETUTCDATE(),                      
         1,                      
         GETDATE(),                      
         GETUTCDATE()                      
        )                       
    SET @DocumentNumber=@DocumentNumber--+'000'+cast (1 as varchar(10))                      
   END                      
   ELSE                      
    BEGIN                      
     SELECT @CodeNumber=CodeNumber+1                       
     FROM FMDocumentNoGeneration                       
     WHERE DocumentNumber = @DocumentNumber                       
       AND ScreenName='Driver Code'                      
                           
     UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber WHERE    DocumentNumber=@DocumentNumber AND ScreenName='Driver Code'                      
  SET @DocumentNumber=@DocumentNumber+CASE WHEN CAST (@CodeNumber AS VARCHAR(20)) IN (1,2,3,4,5,6,7,8,9)     
  THEN RIGHT(CONCAT('0',CAST (@CodeNumber AS VARCHAR(20))),6)     
  ELSE RIGHT(CAST (@CodeNumber AS VARCHAR(20)),6) END    
              
           
 END                      
    SET @pOutParam = @DocumentNumber;                       
   END      
      
      
      
      
      
      
      
------------          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
----------------------------------LLS MODULE GENERATION SCRIPT END          
          
          
          
          
          
          
          
          
          
                      
                      
                      
 --IF @mTRANSCOUNT = 0                      
 --       BEGIN                      
 --           COMMIT TRANSACTION                      
        --END                         
                      
                      
END TRY                      
                      
BEGIN CATCH                      
                      
 --IF @mTRANSCOUNT = 0                      
 --       BEGIN                      
 --           ROLLBACK TRAN                      
 --       END                      
                      
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
