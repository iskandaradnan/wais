USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenCondemnationTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLinenCondemnationTxn]
AS

SELECT                  
  A.CustomerId
 ,A.FacilityId
 ,A.LinenCondemnationId                  
 ,A.DocumentNo                        
 ,A.DocumentDate                        
 ,UMUserRegistration1.StaffName as InspectedBy                        
 ,UMUserRegistration2.StaffName as VerifiedBy                        
 ,A.ModifiedDate
 ,A.ModifiedDateUTC
 ,A.IsDeleted
 ,SUM(B.Torn+B.Stained+B.Faded+B.Vandalism+B.WearTear+B.StainedByChemical) as TotalCondemns 
 
 --@TotalRecords AS TotalRecords                        
            
                        
FROM dbo.LLSLinenCondemnationTxn A                        
INNER JOIN dbo.UMUserRegistration AS UMUserRegistration1                         
ON A.InspectedBy = UMUserRegistration1.UserRegistrationId                        
INNER JOIN dbo.UMUserRegistration as UMUserRegistration2                         
ON A.VerifiedBy = UMUserRegistration2.UserRegistrationId                         
INNER JOIN dbo.LLSLinenCondemnationTxnDet B                        
ON A.LinenCondemnationId =B.LinenCondemnationId                        
INNER JOIN dbo.FMLovMst C                         
ON A.LocationOfCondemnation=C.LovId     
WHERE ISNULL(A.IsDeleted,'')=''
GROUP BY   A.CustomerId
 ,A.FacilityId
 ,A.LinenCondemnationId                  
 ,A.DocumentNo                        
 ,A.DocumentDate                        
 ,UMUserRegistration1.StaffName                         
 ,UMUserRegistration2.StaffName                         
 ,A.ModifiedDate
 ,A.ModifiedDateUTC
 ,A.IsDeleted

GO
