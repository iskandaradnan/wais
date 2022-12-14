USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
       
CREATE PROCEDURE [dbo].[LLSLinenAdjustmentTxnDet_GetById]                    
(                    
 @Id INT                    
)                    
                     
AS                     
    -- Exec [LLSLinenAdjustmentTxnDet_GetById] 135                 
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack                  
--NAME    : LLSLinenAdjustmentTxnDet_GetById                 
--DESCRIPTION  : GETS THE LLSLinenAdjustmentTxnDet                
--AUTHORS   : SIDDHANT                  
--DATE    : 16-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT           : 16-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                  
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                     
SELECT           
A.LinenAdjustmentId,          
 B.LinenCode,              
 B.LinenDescription,              
 A.ActualQuantity,              
 C.StoreBalance,              
  (A.ActualQuantity-C.StoreBalance) as AdjustQuantity,              
 A.Justification,        
 A.LinenAdjustmentDetId        
FROM              
dbo.LLSLinenAdjustmentTxnDet A              
INNER JOIN dbo.LLSLinenItemDetailsMst B              
ON A.LinenItemId =B.LinenItemId              
INNER JOIN dbo.LLSCentralCleanLinenStoreMstDet C              
ON A.LinenItemId =C.LinenItemId               
WHERE A.LinenAdjustmentId=@Id
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(B.IsDeleted,'')=''               
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END
GO
