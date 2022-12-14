USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Get_Attachemtfile_by_ModelId_ManufacturerId_ServiceId_TaskCode]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
                
                
/*========================================================================================================                
Application Name : UETrack-BEMS                              
Version    : 1.0                
Procedure Name  : uspFM_Attachment_Save                
Description   : Insert/update the Attachment                
Authors    : Dhilip V                
Date    : 28-June-2018                
-----------------------------------------------------------------------------------------------------------                
                
Unit Test:                
                      
                
SELECT * FROM FMDocument                
                
-----------------------------------------------------------------------------------------------------------                
Version History                 
-----:------------:---------------------------------------------------------------------------------------                
Init :  Date       : Details                
========================================================================================================*/                
                
CREATE PROCEDURE  [dbo].[uspFM_Get_Attachemtfile_by_ModelId_ManufacturerId_ServiceId_TaskCode]               
  @pModelId INT,                
  @pManufacturerId     INT,                
        @pServiceId       INT   ,              
             @pTaskCode  varchar(500)            
AS                                                              
                
BEGIN TRY                
                
               
                
-- Declaration                
                 
 DECLARE @DModelId  INT              
 DECLARE @DManufacturerId INT               
 DECLARE @dGuid  varchar(500)     
       
                
                
                
                
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------                
              
         SELECT  @DModelId= ModelId from EngAssetStandardization where ModelId_mappingTo_SeviceDB=@pModelId and ManufacturerId_mappingTo_SeviceDB=@pManufacturerId and ServiceId=@pServiceId       
  SELECT @DManufacturerId= ManufacturerId from EngAssetStandardization where ModelId_mappingTo_SeviceDB=@pModelId and ManufacturerId_mappingTo_SeviceDB=@pManufacturerId and ServiceId=@pServiceId     
  
  
  
   SET @dGuid=(select MAX(GuId) from EngAssetPPMCheckList where  ModelId=@DModelId and ManufacturerId=@DManufacturerId  and AssetTypeCodeId IS NOT NULL and TaskCode=@pTaskCode)     
 --SET @dGuid=(select MAX(GuId) from EngAssetPPMCheckList where   AssetTypeCode IS NOT NULL and TaskCode=@pTaskCode)            
              
 select [FileName] from FMDocument where  FileType=6 and DocumentGuId=@dGuid          
              
                
END TRY                
                
BEGIN CATCH                
                
               
              
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
