USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PBIContractCreation]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBIContractCreation]  
AS  
BEGIN  
  
DELETE FROM PBITBLContractCreation   
  
;WITH CTE AS   
(  
SELECT C.AssetId  
      ,MAX(A.ContractId) AS ContractId  
   ,MAX(B.ContractStartDate) AS ContractStartDate   
   ,MAX(B.ContractEndDate) AS ContractEndDate  
FROM EngAsset C  
LEFT JOIN EngContractOutRegisterDet A  
ON C.AssetId=A.AssetId  
LEFT OUTER JOIN EngContractOutRegister B  
ON A.ContractId=B.ContractId  
GROUP BY  C.AssetId  
        
)  
INSERT INTO PBITBLContractCreation   
(  
 AssetId     
,ContractId   
,ContractStartDate   
,ContractEndDate   
,ContractExpireStatus   
)  
SELECT  AssetId,ContractId,ContractStartDate,ContractEndDate  
,CASE WHEN GETDATE() > ContractEndDate  THEN 'Contract Expired'  
      WHEN (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) < 30 THEN 'Less than a month'    
   WHEN (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) >=30   
   AND  (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) <=90 THEN '1 -3 Months'    
   WHEN (CASE WHEN GETDATE() < ContractEndDate THEN DATEDIFF(DAY,ContractEndDate,GETDATE()) END) >90 THEN 'More than 3 months'  
  END AS ContractExpireStatus   
FROM CTE  
  
END
GO
