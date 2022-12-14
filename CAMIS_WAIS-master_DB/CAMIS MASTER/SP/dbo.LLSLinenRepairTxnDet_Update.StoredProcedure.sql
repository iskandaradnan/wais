USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                    
--APPLICATION  : UETrack 1.5                    
--NAME    : SaveUserAreaDetailsLLS                   
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenRepairTxnDet] TABLE                     
--AUTHORS   : SIDDHANT                    
--DATE    : 8-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                    
--VERSION HISTORY                     
--------------------:---------------:---------------------------------------------------------------------------------------                    
--Init    : Date          : Details                    
--------------------:---------------:---------------------------------------------------------------------------------------                    
--SIDDHANT          : 8-JAN-2020 :                     
-------:------------:----------------------------------------------------------------------------------------------------*/                    
                  
                    
                  
                  
                    
create PROCEDURE  [dbo].[LLSLinenRepairTxnDet_Update]                                               
                    
(                    
                
-- @RepairCompletedQuantity NUMERIC(24,2)                
--,@RepairQuantity NUMERIC(24,2)                
--,@DescriptionOfProblem Varchar(50)               
--,@LinenRepairId INT                
                
  @LLSLinenRepairTxnDet_Update AS [LLSLinenRepairTxnDet_Update] READONLY             
)                          
                    
AS                          
                    
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                  
DECLARE @Table TABLE (ID INT)                    
                  
UPDATE A          
SET                  
 A.RepairCompletedQuantity = B.RepairCompletedQuantity,                  
 A.BalanceRepairQuantity = B.RepairQuantity - B.RepairCompletedQuantity,                  
 A.DescriptionOfProblem = B.DescriptionOfProblem,                  
 A.ModifiedBy = B.ModifiedBy,                  
 A.ModifiedDate = GETDATE(),                  
 A.ModifiedDateUTC = GETUTCDATE()         
FROM LLSLinenRepairTxnDet as A Inner join @LLSLinenRepairTxnDet_Update as B on A.LinenRepairDetId= B.LinenRepairDetId      
WHERE A.LinenRepairDetId = B.LinenRepairDetId                  
                  
                  
SELECT LinenRepairDetId                  
      ,[Timestamp]                  
   ,'' ErrorMsg                  
      --,GuId                   
FROM LLSLinenRepairTxnDet WHERE LinenRepairDetId IN (SELECT ID FROM @Table)                    
                    
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END
GO
