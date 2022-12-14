USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSCentralLinenStoreHKeepingTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSCentralLinenStoreHKeepingTxn]  
AS  
SELECT          
 A.CustomerId,  
 A.FacilityId,  
 A.HouseKeepingId AS Id,        
 B.FieldValue AS StoreType,                
 A.[Year] AS Year,                
 A.[Month] AS Month,             
 A.ModifiedDate,  
 A.ModifiedDateUTC,  
 A.IsDeleted  
  
  
 --@TotalRecords AS TotalRecords                
FROM                
dbo.LLSCentralLinenStoreHKeepingTxn A                
INNER JOIN dbo.FMLovMst  B ON A.StoreType =B.LovId              
--INNER JOIN dbo.FMLovMst  C    ON A.[Month] =C.LovId            
--INNER JOIN dbo.FMLovMst  D    ON A.[YEAR] =D.LovId          
WHERE ISNULL(A.IsDeleted,'')=''
GO
