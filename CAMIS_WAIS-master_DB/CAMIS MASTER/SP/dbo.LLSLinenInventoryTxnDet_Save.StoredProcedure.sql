USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[LLSLinenInventoryTxnDet_Save]                                                           
                                
(                                
@LLSLinenInventoryTxnDet AS [dbo].[LLSLinenInventoryTxnDet] READONLY                              
)                                      
                                
AS                                      
                                
BEGIN                                
SET NOCOUNT ON                                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                
BEGIN TRY                                
                              
DECLARE @Table TABLE (ID INT)                                
                                
INSERT INTO LLSLinenInventoryTxnDet (                
 CustomerId,--GIVEN IN PDF FILE BUT NOT PRESENT IN TABLE                
 FacilityId,                
 LinenInventoryId,      
 LinenItemId,         
 InUse,        
 Shelf,        
  
 CCLSInUse,                
 CCLSShelf,                
 LLSUserAreaLocationId,  
 CreatedBy,                
 CreatedDate,                
 CreatedDateUTC,
 ModifiedBy

           
 )                               
                               
 OUTPUT INSERTED.LlsLinenInventoryTxnDetId INTO @Table                                
 SELECT               
 CustomerId,              
 FacilityId,              
 LinenInventoryId,      
 LinenItemId,        
 InUse,        
 Shelf,        
 CCLSInUse,                
 CCLSShelf,             
 LLSUserAreaLocationId,  
CreatedBy,                              
GETDATE(),                              
GETUTCDATE(),
ModifiedBy
          
FROM @LLSLinenInventoryTxnDet                                
                                
SELECT LlsLinenInventoryTxnDetId                              
      ,[Timestamp]                              
   ,'' ErrorMsg                              
      --,GuId                               
FROM LLSLinenInventoryTxnDet WHERE LlsLinenInventoryTxnDetId IN (SELECT ID FROM @Table)                                
                                
END TRY                                
BEGIN CATCH                                
                                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                
                                
THROW                                
                                
END CATCH                                
SET NOCOUNT OFF                                
END
GO
