USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMstDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : LLSCentralCleanLinenStoreMstDet         
--DESCRIPTION  : SAVE RECORD IN [LLSCentralCleanLinenStoreMstDet] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 14-FEB-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 14-FEB-2020 :           
-------:------------:-----------------------------------------------  
          
        
        
          
CREATE PROCEDURE  [dbo].[LLSCentralCleanLinenStoreMstDet_Save]                                     
          
(          
@LLSCentralCleanLinenStoreMstDet AS [dbo].[LLSCentralCleanLinenStoreMstDet] READONLY        
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
          
INSERT INTO LLSCentralCleanLinenStoreMstDet (    
 CustomerId,    
 FacilityId,    
 CCLSId,    
 LinenItemId,    
 StoreBalance,    
 StockLevel,    
 ReorderQuantity,    
 Par1,    
 Par2,    
 CreatedBy,    
 CreatedDate,    
 CreatedDateUTC)       
         
 OUTPUT INSERTED.CCLSDetId INTO @Table          
 SELECT        
 CustomerId,    
 FacilityId,    
 CCLSId,    
 LinenItemId,    
 StoreBalance,    
 StockLevel,    
 ReorderQuantity,    
 Par1,    
 Par2,    
CreatedBy,        
GETDATE(),        
GETUTCDATE()        
FROM @LLSCentralCleanLinenStoreMstDet         
          
SELECT CCLSDetId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSCentralCleanLinenStoreMstDet WHERE CCLSDetId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
