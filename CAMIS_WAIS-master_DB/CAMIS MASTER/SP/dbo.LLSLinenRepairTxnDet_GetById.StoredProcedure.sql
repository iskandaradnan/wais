USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
              
                  
CREATE PROCEDURE [dbo].[LLSLinenRepairTxnDet_GetById]                  
(                  
 @Id INT                  
)                  
                   
AS                   
    -- Exec [LLSLinenRepairTxnDet_GetById] 135               
                
--/*=====================================================================================================================                
--APPLICATION  : UETrack                
--NAME    : LLSLinenRepairTxnDet_GetById               
--DESCRIPTION  : GETS THE LLSLinenRepairTxnDet                
--AUTHORS   : SIDDHANT                
--DATE    : 17-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT           : 17-JAN-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
                
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                   
SELECT        
B.LinenCode,        
B.LinenDescription,        
A.RepairQuantity,        
A.RepairCompletedQuantity,        
(A.RepairQuantity - A.RepairCompletedQuantity) as BalanceRepairQuantity,        
A.DescriptionOfProblem  ,    
A.LinenRepairDetId    
FROM dbo.LLSLinenRepairTxnDet A        
INNER JOIN dbo.LLSLinenItemDetailsMst B        
ON A.LinenItemId = B.LinenItemId        
WHERE A.LinenRepairId=@Id   
AND ISNULL(A.IsDeleted,'')=''
AND ISNULL(A.IsDeleted,'')=''
              

            
              
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END
GO
