USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLaundryPlantMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_LLSLaundryPlantMst]  
AS  
SELECT          
  A.CustomerId  
 ,A.FacilityId  
 ,A.LaundryPlantId          
 ,A.LaundryPlantCode              
 ,A.LaundryPlantName              
 ,B.FieldValue as Ownership              
 ,A.Capacity              
 ,A.ContactPerson     
 ,C.LovId as StatusId         
 ,C.FieldValue as Status 
 ,A.ModifiedDate  
 ,A.ModifiedDateUTC  
 ,A.IsDeleted  
 --,@TotalRecords AS TotalRecords                    
FROM              
 dbo.LLSLaundryPlantMst A              
INNER JOIN              
 dbo.FMLovMst  B ON A.Ownership =B.LovId              
INNER JOIN              
dbo.FMLovMst AS C ON A.Status =C.LovId   
WHERE ISNULL(A.IsDeleted,'')=''  
  
  
GO
