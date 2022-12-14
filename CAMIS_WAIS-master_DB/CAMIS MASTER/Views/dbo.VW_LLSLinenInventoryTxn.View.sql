USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenInventoryTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLinenInventoryTxn]  
AS  
SELECT                 
 A.CustomerId  
 ,A.FacilityId  
 ,A.LinenInventoryId AS LinenInventoryId              
 ,YEAR(A.Date) AS Year                        
 ,FORMAT(A.Date,'MMMM') AS Month                        
 ,B.FieldValue AS StoreType                        
 ,A.DocumentNo                        
 ,A.Date           
 ,A.ModifiedDate  
 ,A.ModifiedDateUTC  
 ,A.IsDeleted  
 ,D.UserLocationCode
 ,D.LLSUserAreaLocationId
 ,D.UserAreaCode
 ,SUM( CASE When StoreType='10172' Then C.InUse+C.Shelf Else c.CCLSInUse+c.CCLSShelf End ) AS TotalPcs           
                      
 --@TotalRecords AS TotalRecords                                    
                        
FROM dbo.LLSLinenInventoryTxn A                      
INNER JOIN dbo.FMLovMst B                        
ON A.StoreType = B.LovId        
--AND A.IsDeleted IS NULL      
INNER JOIN dbo.LLSLinenInventoryTxnDet C                         
ON A.LinenInventoryId =C.LinenInventoryId                         
INNER JOIN LLSUserAreaDetailsLocationMstDet D
ON C.LLSUserAreaLocationId=D.LLSUserAreaLocationId

WHERE ISNULL(A.IsDeleted,'')=''  
  GROUP BY           
   A.IsDeleted,      
   A.LinenInventoryId ,              
   B.FieldValue,                        
   A.DocumentNo,                        
   A.Date,                    
   A.ModifiedDateUTC,  
   A.CustomerId,  
   A.FacilityId,  
   A.ModifiedDate,  
   D.UserLocationCode,
   D.LLSUserAreaLocationId,
   D.UserAreaCode
  
  
  
GO
