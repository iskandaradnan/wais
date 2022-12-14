USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Get_Attachemtfile_by_ModelId_ManufacturerId_ServiceId]    Script Date: 20-09-2021 16:43:01 ******/
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
    
DECLARE @pFMDocument     [dbo].[udt_FMDocument]    
INSERT INTO @pFMDocument ([DocumentId],[GuId],[CustomerId],[FacilityId],[DocumentNo],[DocumentTitle],[DocumentDescription],[DocumentCategory],[DocumentCategoryOthers],    
[DocumentExtension],[MajorVersion],[MinorVersion],[FileType],[FilePath],[FileName],[UploadedDateUTC],[ScreenId],[Remarks],[UserId])     
VALUES (0,NEWID(),1,1,'fILEnAME8','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',    
'fILENAME1.xls','2018-05-10 19:38:41.797',1,null,2),    
(0,NEWID(),1,1,'fILEnAME8','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',    
'fILENAME1.xls','2018-05-10 19:38:41.797',1,null,2)    
SELECT COUNT(*) FROM  @pFMDocument GROUP BY LTRIM(RTRIM(FileName)) HAVING COUNT(FileName)>1    
select * from @pFMDocument    
    
    
EXEC [uspFM_Attachment_Save] @pFMDocument=@pFMDocument,@pGuId=NULL,@pUserId=2    
    
SELECT * FROM FMDocument    
    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init :  Date       : Details    
========================================================================================================*/    
    
CREATE PROCEDURE  [dbo].[uspFM_Get_Attachemtfile_by_ModelId_ManufacturerId_ServiceId]   
  @pModelId int,    
  @pManufacturerId     int,    
        @pServiceId       INT     
    
AS                                                  
    
BEGIN TRY    
    
   
    
-- Declaration    
     
 DECLARE @DModelId  INT  
 DECLARE @DManufacturerId INT   
 DECLARE @DGuid  varchar(500)  
    
    
    
    
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------    
  
  
  
  
  SELECT  @DModelId= ModelId from EngAssetStandardization where ModelId_mappingTo_SeviceDB=@pModelId and ManufacturerId_mappingTo_SeviceDB=@pManufacturerId and ServiceId=@pServiceId   
  SELECT @DManufacturerId= ManufacturerId from EngAssetStandardization where ModelId_mappingTo_SeviceDB=@pModelId and ManufacturerId_mappingTo_SeviceDB=@pManufacturerId and ServiceId=@pServiceId   
  
 SELECT @DGuid= GuId from EngAssetPPMCheckList where  ModelId=@DModelId and ManufacturerId=@DManufacturerId and ServiceId=@pServiceId  
  
 select [FileName] from FMDocument where  FileType=6 and DocumentGuId=@DGuid  
    
    
    
  
  
    
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
