USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSCleanLinenDespatchTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSCleanLinenDespatchTxn]    
AS    
SELECT                
 A.CustomerId,    
 A.FacilityId,    
 A.CleanLinenDespatchId,            
 A.DocumentNo,                
 A.DateReceived,             
 B.LaundryPlantName AS [Despatched From],                
 A.TotalWeightKg,                
 A.ModifiedDate,    
 A.ModifiedDateUTC,    
 A.IsDeleted,    
 SUM(C.ReceivedQuantity) AS TotalReceivedPcs               
   
 --@TotalRecords AS TotalRecords                      
FROM dbo.LLSCleanLinenDespatchTxn A                
INNER JOIN dbo.LLSLaundryPlantMst B                
ON A.DespatchedFrom = B.LaundryPlantId     
INNER JOIN dbo.LLSCleanLinenDespatchTxnDet C                
ON A.CleanLinenDespatchId=C.CleanLinenDespatchId  
WHERE ISNULL(A.IsDeleted,'')=''    
AND ISNULL(B.IsDeleted,'')=''    
AND ISNULL(C.IsDeleted,'')=''    
GROUP BY A.CustomerId,    
 A.FacilityId,    
 A.CleanLinenDespatchId,            
 A.DocumentNo,                
 A.DateReceived,             
 B.LaundryPlantName,  
 A.TotalWeightKg,                
 A.ModifiedDate,    
 A.ModifiedDateUTC,    
 A.IsDeleted 
GO
