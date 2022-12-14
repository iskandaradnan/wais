USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSVehicleDetailsMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSVehicleDetailsMst]
AS
SELECT 
 
 A.CustomerId,
 A.FacilityId,
 A.VehicleId,            
 A.VehicleNo,              
 B.FieldValue as Manufacturer,              
 C.LaundryPlantName,              
 D.FieldValue as Status,              
 A.EffectiveFrom,              
 A.EffectiveTo,              
 A.LoadWeight,              
 A.ModifiedDate,
 A.ModifiedDateUTC,
 A.IsDeleted
 
 --@TotalRecords AS TotalRecords             
FROM              
 dbo.LLSVehicleDetailsMst A              
INNER JOIN              
 dbo.FMLovMst B ON A.Manufacturer =B.LovId              
INNER JOIN dbo.LLSLaundryPlantMst C               
 ON A.LaundryPlantId =C.LaundryPlantId              
INNER JOIN dbo.FMLovMst D               
ON A.Status =D.LovId               
WHERE ISNULL(A.IsDeleted,'')=''
AND ISNULL(C.IsDeleted,'')=''
GO
