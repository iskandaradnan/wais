USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenDespatchTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
                  
CREATE PROCEDURE [dbo].[LLSCleanLinenDespatchTxn_GetById]                  
(                  
 @Id INT                  
                
)                  
                   
AS                   
                  
                
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
 DECLARE @TotalRecords INT;                 
BEGIN TRY                  
                   
DECLARE @TotalReceivedPcs INT   
SET @TotalReceivedPcs=(SELECT SUM(ReceivedQuantity) FROM LLSCleanLinenDespatchTxnDet A WHERE CleanLinenDespatchId=@Id AND ISNULL(A.IsDeleted,'')='')  
  
  
  
SELECT             
A.CleanLinenDespatchId,          
 A.DocumentNo,                
 A.DateReceived,                
 B. LaundryPlantId AS [DespatchedFrom],                
 C.StaffName AS [Received By],                
 A.NoOfPackages,                
 A.TotalWeightKg,                
 @TotalReceivedPcs AS TotalReceivedPcs,            
 A.GuId,        
 @TotalRecords AS TotalRecords                   
FROM                
 dbo.LLSCleanLinenDespatchTxn A                
INNER JOIN                
 dbo.LLSLaundryPlantMst B ON A.DespatchedFrom = B.LaundryPlantId                
INNER JOIN                
 dbo.UMUserRegistration C ON A.ReceivedBy = C.UserRegistrationId                 
WHERE CleanLinenDespatchId=@Id                
AND ISNULL(A.IsDeleted,'')=''    
AND ISNULL(B.IsDeleted,'')=''    
--GROUP BY                    
--A.CleanLinenDespatchId,          
-- A.DocumentNo,                
-- A.DateReceived,                
-- B.LaundryPlantId ,                
-- C.StaffName,                
-- A.NoOfPackages,                
-- A.TotalWeightKg,      
-- A.DespatchedFrom,      
-- A.ReceivedBy,   
-- A.TotalReceivedPcs,  
-- A.GuId      
                              
                
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END 
GO
