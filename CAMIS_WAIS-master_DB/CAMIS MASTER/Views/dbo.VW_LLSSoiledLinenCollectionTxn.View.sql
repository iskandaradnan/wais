USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSSoiledLinenCollectionTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE VIEW [dbo].[VW_LLSSoiledLinenCollectionTxn]    
AS    
SELECT     
 A.CustomerId,    
 A.FacilityId,    
 A.SoiledLinenCollectionId,                      
 A.DocumentNo,                  
 A.CollectionDate,                      
 A.ModifiedDate,    
 A.ModifiedDateUTC,    
 A.IsDeleted,    
 C.LaundryPlantName,                      
 SUM(B.Weight) as TotalWeight,                      
 SUM(B.TotalWhiteBag) as TotalWhiteBag,         
 SUM(B.TotalRedBag) as TotalRedBag,                      
 SUM(B.TotalGreenBag) as TotalGreenBag ,    
 SUM(B.TotalBrownBag) as TotalBrownBag                    
-- @TotalRecords AS TotalRecords                     
                 
FROM dbo.LLSSoiledLinenCollectionTxn A                      
INNER JOIN dbo.LLSSoiledLinenCollectionTxnDet B                      
ON A.SoiledLinenCollectionId=B.SoiledLinenCollectionId                      
INNER JOIN dbo.LLSLaundryPlantMst C                      
ON A.LaundryPlantId=C.LaundryPlantId                      
WHERE ISNULL(A.IsDeleted,'')=''    
AND ISNULL(C.IsDeleted,'')=''    
AND ISNULL(B.IsDeleted,'')=''    
GROUP BY A.CustomerId,    
 A.FacilityId,    
 A.SoiledLinenCollectionId,                      
 A.DocumentNo,                  
 A.CollectionDate,                      
 A.ModifiedDate,    
 A.ModifiedDateUTC,    
 A.IsDeleted,    
 C.LaundryPlantName 
GO
