USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : LLSLinenAdjustmentTxnDet_Save           
--DESCRIPTION  : SAVE RECORD IN [LLSLinenAdjustmentTxnDet] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 16-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 16-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
            
        
CREATE PROCEDURE  [dbo].[LLSLinenAdjustmentTxnDet_Save]                                       
            
(            
 @Block As [dbo].[LLSLinenAdjustmentTxnDet] READONLY            
)                  
            
AS                  
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
DECLARE @Table TABLE (ID INT)            
          
INSERT INTO LLSLinenAdjustmentTxnDet (        
LinenAdjustmentId,      
 CustomerId,        
 FacilityId,        
 LinenItemId,        
 ActualQuantity,        
 StoreBalance,        
 AdjustQuantity,        
 Justification,        
 CreatedBy,        
 CreatedDate,        
 CreatedDateUTC)          
           
          
OUTPUT INSERTED.LinenAdjustmentDetId INTO @Table            
SELECT         
 LinenAdjustmentId,      
 CustomerId,        
 FacilityId,        
 LinenItemId,        
 ActualQuantity,        
 StoreBalance,        
 ActualQuantity-StoreBalance as AdjustQuantity,        
 Justification,          
CreatedBy,          
GETDATE(),          
GETUTCDATE()          
FROM @Block            
            
SELECT LinenAdjustmentDetId          
      ,[Timestamp]          
   ,'' ErrorMsg          
      --,GuId           
FROM LLSLinenAdjustmentTxnDet WHERE LinenAdjustmentDetId IN (SELECT ID FROM @Table)            
            
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
