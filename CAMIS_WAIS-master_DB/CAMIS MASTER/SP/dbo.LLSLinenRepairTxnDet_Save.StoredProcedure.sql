USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                      
--APPLICATION  : UETrack 1.5                      
--NAME    : LLSSoiledLinenCollectionTxn_Save                     
--DESCRIPTION  : SAVE RECORD IN [LLSLinenRepairTxnDet_Save] TABLE                       
--AUTHORS   : SIDDHANT                      
--DATE    : 17-JAN-2020                    
-------------------------------------------------------------------------------------------------------------------------                      
--VERSION HISTORY                       
--------------------:---------------:---------------------------------------------------------------------------------------                      
--Init    : Date          : Details                      
--------------------:---------------:---------------------------------------------------------------------------------------                      
--SIDDHANT          : 17-JAN-2020 :                       
-------:------------:----------------------------------------------------------------------------------------------------*/                      
    
    
                      
CREATE PROCEDURE  [dbo].[LLSLinenRepairTxnDet_Save]                                                 
                      
(                      
 @Block As [dbo].[LLSLinenRepairTxnDet] READONLY                      
)                            
                      
AS                            
                      
BEGIN                      
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY                      
                    
DECLARE @Table TABLE (ID INT)                      
                    
                    
                    
INSERT INTO LLSLinenRepairTxnDet (               
 LinenRepairId,              
 CustomerId,                    
 FacilityId,              
 LinenItemId,                    
 RepairQuantity,                    
 RepairCompletedQuantity,                    
 BalanceRepairQuantity,                    
 DescriptionOfProblem,                    
 CreatedBy,                    
 CreatedDate,                    
 CreatedDateUTC          
 )                    
                    
OUTPUT INSERTED.LinenRepairDetId INTO @Table                      
SELECT LinenRepairId,        
 CustomerId,                    
 FacilityId,                    
 LinenItemId,                    
 RepairQuantity,                    
 RepairCompletedQuantity,                    
 BalanceRepairQuantity,                    
 DescriptionOfProblem,                    
CreatedBy,                    
GETDATE(),                    
GETUTCDATE()          
         
FROM @Block                      
                      
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
