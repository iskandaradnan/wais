USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLicenseTypeMstDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================              
APPLICATION  : UETrack 1.5              
NAME    : SaveUserAreaDetailsLLS             
DESCRIPTION  : UPDATE RECORD IN [LLSLicenseTypeMstDet] TABLE               
AUTHORS   : SIDDHANT              
DATE    : 8-JAN-2020            
-----------------------------------------------------------------------------------------------------------------------              
VERSION HISTORY               
------------------:---------------:---------------------------------------------------------------------------------------              
Init    : Date          : Details              
------------------:---------------:---------------------------------------------------------------------------------------              
SIDDHANT          : 8-JAN-2020 :               
-----:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
            
              
CREATE PROCEDURE  [dbo].[LLSLicenseTypeMstDet_Update]                                         
              
(              
 @LLSLicenseTypeMstDet_Update AS LLSLicenseTypeMstDet_Update READONLY    
          
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
UPDATE A            
SET            
 A.LicenseDescription = B.LicenseDescription,            
 A.IssuingBody = B.IssuingBody,            
 A.ModifiedBy = B.ModifiedBy,            
 A.ModifiedDate = GETDATE(),            
 A.ModifiedDateUTC = GETUTCDATE()            
 FROM LLSLicenseTypeMstDet A    
 INNER JOIN @LLSLicenseTypeMstDet_Update B    
 ON A.LicenseTypeDetId=B.LicenseTypeDetId    
WHERE A.LicenseTypeDetId =B.LicenseTypeDetId            
            
            
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
