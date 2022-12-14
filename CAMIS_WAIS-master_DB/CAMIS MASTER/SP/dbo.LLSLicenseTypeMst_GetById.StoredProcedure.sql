USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLicenseTypeMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
                
CREATE PROCEDURE [dbo].[LLSLicenseTypeMst_GetById]                
(                
 @Id INT                
)                
                 
AS                 
    -- Exec [LLSLicenseTypeMst_GetById] 135             
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack              
--NAME    : LLSLicenseTypeMst_GetById             
--DESCRIPTION  : GETS THE License DETAILS              
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
A.LicenseTypeId,    
 B.LovId AS LicenseType    
FROM dbo.LLSLicenseTypeMst A            
INNER JOIN dbo.FMLovMst B            
ON A.LicenseType = B.LovId            
WHERE LicenseTypeId=@Id            
AND ISNULL(A.IsDeleted,'')=''

            
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END      
      
select * from LLSLicenseTypeMstDet 
GO
