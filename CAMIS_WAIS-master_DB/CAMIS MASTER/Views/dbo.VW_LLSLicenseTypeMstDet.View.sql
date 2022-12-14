USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLicenseTypeMstDet]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLicenseTypeMstDet]
AS
SELECT        A.CustomerId, A.FacilityId, A.LicenseTypeId, D.LovId, D.FieldValue AS LicenseType, A.LicenseCode, A.LicenseDescription, B.FieldValue AS IssuingBody, A.ModifiedDate, A.ModifiedDateUTC, A.IsDeleted, 
                         A.LicenseTypeDetId
FROM            dbo.LLSLicenseTypeMstDet AS A INNER JOIN
                         dbo.FMLovMst AS B ON A.IssuingBody = B.LovId INNER JOIN
                         dbo.LLSLicenseTypeMst AS C ON A.LicenseTypeId = C.LicenseTypeId INNER JOIN
                         dbo.FMLovMst AS D ON C.LicenseType = D.LovId
WHERE        (ISNULL(A.IsDeleted, '') = '')
GO
