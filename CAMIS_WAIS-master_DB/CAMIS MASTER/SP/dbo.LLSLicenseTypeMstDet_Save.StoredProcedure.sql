USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLicenseTypeMstDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================        
APPLICATION  : UETrack 1.5        
NAME    : LLSLicenseTypeMstDet_Save       
DESCRIPTION  : SAVE RECORD IN [LLSLicenseTypeMstDet] TABLE         
AUTHORS   : SIDDHANT        
DATE    : 8-JAN-2020      
-----------------------------------------------------------------------------------------------------------------------        
VERSION HISTORY         
------------------:---------------:---------------------------------------------------------------------------------------        
Init    : Date          : Details        
------------------:---------------:---------------------------------------------------------------------------------------        
SIDDHANT          : 8-JAN-2020 :         
-----:------------:----------------------------------------------------------------------------------------------------*/        
        
     
    
CREATE PROCEDURE  [dbo].[LLSLicenseTypeMstDet_Save]                                   
        
(        
 @Block As [dbo].[LLSLicenseTypeMstDet] READONLY        
)              
        
AS              
        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
      
DECLARE @Table TABLE (ID INT)        
INSERT INTO LLSLicenseTypeMstDet (      
CustomerId,        
 FacilityId,    
 LicenseTypeId,      
 LicenseCode,      
 LicenseDescription,      
 IssuingBody,      
 CreatedBy,      
 CreatedDate,      
 CreatedDateUTC,  
 ModifiedBy,    
ModifiedDate,    
ModifiedDateUTC   
)  
      
  OUTPUT INSERTED.LicenseTypeDetId INTO @Table        
 SELECT  CustomerId,        
 FacilityId,    
 LicenseTypeId,      
 LicenseCode,      
 LicenseDescription,      
 IssuingBody,      
CreatedBy,      
GETDATE(),      
GETUTCDATE(),   
ModifiedBy,        
GETDATE(),        
GETUTCDATE()       
FROM @Block        
        
SELECT LicenseTypeDetId      
      ,[Timestamp]      
   ,'' ErrorMsg      
      --,GuId       
FROM LLSLicenseTypeMstDet WHERE LicenseTypeDetId IN (SELECT ID FROM @Table)        
        
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
END
GO
