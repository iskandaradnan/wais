USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLicenseTypeMstDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[LLSLicenseTypeMstDet_GetById]                                 
(                                
 @Id INT                                
)                                
                                 
AS                                 
    -- Exec [LLSLicenseTypeMstDet_GetById ] 132                             
                              
--/*=====================================================================================================================                              
--APPLICATION  : UETrack                              
--NAME    : LLSLicenseTypeMstDet_GetById                              
--DESCRIPTION  : GETS THE lICENSE DETAILS                              
--AUTHORS   : SIDDHANT                              
--DATE    : 8-JAN-2020                              
-------------------------------------------------------------------------------------------------------------------------                              
--VERSION HISTORY                               
--------------------:---------------:---------------------------------------------------------------------------------------                              
--Init    : Date          : Details                              
--------------------:---------------:---------------------------------------------------------------------------------------                              
--SIDDHANT           : 8-JAN-2020 :                               
-------:------------:----------------------------------------------------------------------------------------------------*/                              
                              
BEGIN                                
SET NOCOUNT ON                                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                
BEGIN TRY                                
                                 
SELECT        
 A.LicenseTypeId  ,      
 A.LicenseTypeDetId as LicenseTypeDetId,                
 A.LicenseCode as LicenseCode,                            
 A.LicenseDescription as LicenseDescription,                            
 B.LovId as IssuingBody      
FROM                            
 dbo.LLSLicenseTypeMstDet A                            
INNER JOIN dbo.FMLovMst B                             
ON A.IssuingBody = B.LovId                            
WHERE A.LicenseTypeId=@Id            
AND ISNULL(A.IsDeleted,'')=''            
                            
END TRY                                
BEGIN CATCH                                
                                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                
                                
THROW                                
                                
END CATCH                                
SET NOCOUNT OFF                                
END                      
                      
--select * from LLSLicenseTypeMstDet                      
                      
--select * from FMLovMst where LovId=GetById
GO
