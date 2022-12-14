USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenDespatchTxnDetSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                
--APPLICATION  : UETrack 1.5                
--NAME    : Save LinenDespatch               
--DESCRIPTION  : SAVE RECORD IN [LLSCleanLinenDespatchTxnDet] TABLE                 
--AUTHORS   : SIDDHANT                
--DATE    : 03-JAN-2020              
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT          : 03-JAN-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
          
          
                
CREATE PROCEDURE  [dbo].[LLSCleanLinenDespatchTxnDetSave]                                           
                
(                
 @Block As [dbo].[LLSCleanLinenDespatchTxnDet] READONLY                
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)                
                
INSERT INTO LLSCleanLinenDespatchTxnDet (              
 CleanLinenDespatchId,              
 LinenItemId,              
 DespatchedQuantity,              
 ReceivedQuantity,              
 Variance,              
 Remarks,              
 LinenDescription,          
 CreatedBy,              
 CreatedDate,              
 CreatedDateUTC)            
 OUTPUT INSERTED.CleanLinenDespatchDetId INTO @Table                
 SELECT                
 CleanLinenDespatchId,              
 LinenItemId,              
 DespatchedQuantity,              
 ReceivedQuantity,              
 DespatchedQuantity - ReceivedQuantity AS Variance,              
 Remarks,              
 LinenDescription,          
 CreatedBy,              
 GETDATE() AS CreatedDate,              
 GETUTCDATE() AS CreatedDateUTC      
FROM @Block                
                
SELECT CleanLinenDespatchDetId              
      ,[Timestamp]              
   ,'' ErrorMsg              
      --,GuId               
FROM LLSCleanLinenDespatchTxnDet WHERE CleanLinenDespatchDetId IN (SELECT ID FROM @Table)                
                
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END 
GO
