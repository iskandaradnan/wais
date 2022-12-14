USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Get_Attachemtfile_by_ModelId_ManufacturerId_ServiceId]    Script Date: 20-09-2021 16:56:53 ******/
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
          
CREATE PROCEDURE  [dbo].[uspFM_Get_Attachemtfile_by_ModelId_ManufacturerId_ServiceId]         
  @pModelId INT,          
  @pManufacturerId     INT,          
        @pServiceId       INT           
          
AS                                                        
          
BEGIN TRY          
          
         
          
-- Declaration          
           
 DECLARE @DModelId  INT        
 DECLARE @DManufacturerId INT         
 DECLARE @dGuid  varchar(500)        
          
          
          
          
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------          
        
        
              
 SET @dGuid=(select MAX(GuId) from EngAssetPPMCheckList where  ModelId=@pModelId and ManufacturerId=@pManufacturerId  and AssetTypeCode IS NOT NULL)      
        
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
