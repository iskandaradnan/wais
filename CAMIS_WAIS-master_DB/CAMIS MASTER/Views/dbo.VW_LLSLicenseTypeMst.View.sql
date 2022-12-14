USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLicenseTypeMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLicenseTypeMst]
AS
SELECT  
A.CustomerId
,A.FacilityId
,A.LicenseTypeId                
,B.LovId                 
,B.FieldValue AS LicenseType                        
,C.LicenseCode                        
,C.LicenseDescription                        
,B.FieldValue AS IssuingBody                      
,A.ModifiedDate
,A.ModifiedDateUTC
,A.IsDeleted
 --@TotalRecords AS TotalRecords                        
FROM                        
dbo.LLSLicenseTypeMst A                        
INNER JOIN dbo.FMLovMst B                         
ON A.LicenseType =B.LovId
INNER JOIN LLSLicenseTypeMstDet C
ON A.LicenseTypeId=C.LicenseTypeId
--INNER JOIN dbo.LLSLicenseTypeMst C                         
--ON A.LicenseTypeId =C.LicenseTypeId                        
--INNER JOIN dbo.FMLovMst AS D                         
--ON A.LicenseType =D.LovId                        
WHERE ISNULL(A.IsDeleted,'')=''
GO
