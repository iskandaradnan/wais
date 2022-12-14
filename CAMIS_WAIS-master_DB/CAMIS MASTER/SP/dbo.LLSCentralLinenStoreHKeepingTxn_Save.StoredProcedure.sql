USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : LLSCentralLinenStoreHKeepingTxn_Save         
--DESCRIPTION  : SAVE RECORD IN [LLSCentralLinenStoreHKeepingTxn] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 13-JAN-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 23-APR-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
    
    
    
CREATE PROCEDURE [dbo].[LLSCentralLinenStoreHKeepingTxn_Save]    
(          
  @Block As [dbo].[LLSCentralLinenStoreHKeepingTxn] READONLY          
    
)       
    
AS    
    
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
    
--DECLARE @StoreType INT    
--DECLARE @Year INT     
--DECLARE @MONTH INT    
--DECLARE @VAREXIST VARCHAR(10)    
    
    
--SET @VAREXIST=(SELECT 'YES' AS VALUE FROM LLSCentralLinenStoreHKeepingTxn    
--WHERE [Year]=@Year    
--AND [Month]=@MONTH    
--AND [StoreType]=@StoreType    
--)    
    
--IF(@VAREXIST='YES')    
    
--BEGIN     
    
--SELECT 'This record Already Exist' AS ErrorMessage          
    
--END     
--ELSE     
--BEGIN    
    
DECLARE @Table TABLE (ID INT)          
    
INSERT INTO LLSCentralLinenStoreHKeepingTxn (        
 CustomerId,        
 FacilityId,      
[Year],        
 [Month],        
  StoreType,       
 CreatedBy,        
 CreatedDate,        
 CreatedDateUTC,    
 ModifiedBy,    
 ModifiedDate,    
 ModifiedDateUTC)         
        
        
 OUTPUT INSERTED.HouseKeepingId INTO @Table          
 SELECT  CustomerId,        
 FacilityId,       
[Year],        
 [Month],        
  StoreType,       
CreatedBy,        
GETDATE(),        
GETUTCDATE(),    
ModifiedBy,        
GETDATE(),        
GETUTCDATE()     
FROM @Block         
    
    
SELECT HouseKeepingId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSCentralLinenStoreHKeepingTxn WHERE HouseKeepingId IN (SELECT ID FROM @Table)          
          
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END  
GO
