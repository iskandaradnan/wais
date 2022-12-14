USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSDriverDetailsMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSDriverDetailsMst]
AS
SELECT             
 A.CustomerId,
 A.FacilityId,
 A.DriverId,            
 A.DriverCode,                
 B.LaundryPlantName,                
 A.DriverName,                
 C.FieldValue as Status,                
 A.EffectiveFrom,                
 A.EffectiveTo,                
 A.ContactNo, 
 A.ModifiedDate,
 A.ModifiedDateUTC,
 A.IsDeleted
--@TotalRecords AS TotalRecords                
                 
FROM                
 dbo.LLSDriverDetailsMst A                
INNER JOIN dbo.LLSLaundryPlantMst B                
ON A.LaundryPlantId =B.LaundryPlantId                
INNER JOIN dbo.FMLovMst C                 
ON A.Status = C.LovId                 
WHERE ISNULL(A.IsDeleted,'')=''
AND ISNULL(B.IsDeleted,'')=''
GO
