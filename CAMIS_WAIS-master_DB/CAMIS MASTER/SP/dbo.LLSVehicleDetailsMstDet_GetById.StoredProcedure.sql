USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSVehicleDetailsMstDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
              
                    
CREATE PROCEDURE [dbo].[LLSVehicleDetailsMstDet_GetById]                    
(                    
 @Id INT                    
)                    
                     
AS                     
    -- Exec [LLSVehicleDetailsMstDet_GetById] 16                
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack                  
--NAME    : LLSVehicleDetailsMstDet_GetById                 
--DESCRIPTION  : GETS THE LLSVehicleDetails                  
--AUTHORS   : SIDDHANT                  
--DATE    : 13-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT           : 13-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                  
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                     
SELECT          
A.VehicleId,        
 B.LicenseCode,                
 B.LicenseDescription,                
 A.LicenseNo,                
 C.LovId as ClassGrade,                
 D.LovId as IssuedBy,                
 A.IssuedDate,                
 A.ExpiryDate,      
 A.LicenseTypeDetId,  
 A.VehicleDetId  

 FROM dbo.LLSVehicleDetailsMstDet A                
LEFT JOIN dbo.LLSLicenseTypeMstDet B                 
ON A.LicenseTypeDetId =B.LicenseTypeDetId                
LEFT JOIN dbo.FMLovMst C                 
ON A.ClassGrade =C.LovId                
LEFT JOIN dbo.FMLovMst D                 
ON A.IssuedBy =D.LovId                 
WHERE VehicleId=@ID       
AND ISNULL(A.IsDeleted,'')=''
AND ISNULL(B.IsDeleted,'')=''
                
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END   
  
select * from LLSVehicleDetailsMstDet
GO
