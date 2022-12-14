USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenItemTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec [LLSCleanLinenRequestLinenItemTxnDet_Save]                 
                
--/*=====================================================================================================================                
--APPLICATION  : UETrack 1.5                
--NAME    : LLSCleanLinenRequestLinenItemTxnDet_Save               
--DESCRIPTION  : SAVE RECORD IN [LLSCleanLinenRequestLinenItemTxnDet] TABLE                 
--AUTHORS   : SIDDHANT                
--DATE    : 23-JAN-2020              
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT          : 23-JAN-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
--EXEC LLSCleanLinenRequestLinenItemTxnDet_Save 157,144,2,3,7,10,5          
-- [CustomerId] [int] NULL,157          
-- [FacilityId] [int] NULL,144          
-- [CleanLinenRequestId] [int] NOT NULL,2          
-- [CleanLinenIssueId] [int] NULL,3          
-- [LinenItemId] [int] NOT NULL,7          
-- [BalanceOnShelf] [int] NULL,10          
-- [RequestedQuantity] [int] NOT NULL 5          
--)          
           
          
          
CREATE PROCEDURE  [dbo].[LLSCleanLinenRequestLinenItemTxnDet_Save]                                           
                
(                
 @Block As [dbo].[LLSCleanLinenRequestLinenItemTxnDet] READONLY                
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)        
    
------------deepak added-------------           
DECLARE @CleanLinenRequestId int    
DECLARE @CleanLinenIssueId int    
    
set @CleanLinenRequestId=( SELECT top (1) [CleanLinenRequestId] FROM @Block)    
set @CleanLinenIssueId=(select max([CleanLinenIssueId]) from    LLSCleanLinenRequestLinenBagTxnDet where    [CleanLinenRequestId]=@CleanLinenRequestId)    
    
IF (@CleanLinenIssueId >0)    
BEGIN    
---- insert into issue  
INSERT INTO LLSCleanLinenIssueLinenItemTxnDet (                 
 CleanLinenIssueId           
 ,LinenItemId                   
 ,RequestedQuantity   
 ,DeliveryIssuedQty1st  
 ,DeliveryIssuedQty2nd           
 ,CreatedBy            
 ,CreatedDate            
 ,CreatedDateUTC)             
    OUTPUT INSERTED.CleanLinenIssueId INTO @Table                
             
 SELECT    
@CleanLinenIssueId           
 ,LinenItemId         
 ,RequestedQuantity     
 ,0  
 ,0           
 ,CreatedBy              
 ,GETDATE()          
 ,GETUTCDATE()              
FROM @Block    
-------in request  
INSERT INTO LLSCleanLinenRequestLinenItemTxnDet (            
  CustomerId          
 ,FacilityId          
 ,CleanLinenRequestId          
 ,CleanLinenIssueId           
 ,LinenItemId            
 ,BalanceOnShelf           
 ,RequestedQuantity            
 ,CreatedBy            
 ,CreatedDate            
 ,CreatedDateUTC)             
              
 OUTPUT INSERTED.CLRLinenItemId INTO @Table                
             
 SELECT   CustomerId          
 ,FacilityId          
 ,CleanLinenRequestId          
 ,@CleanLinenIssueId           
 ,LinenItemId            
 ,BalanceOnShelf           
 ,RequestedQuantity              
 ,CreatedBy              
 ,GETDATE()          
 ,GETUTCDATE()              
FROM @Block   
  
  
  
  
  
  
  
  
  
  
  
                      
END    
ELSE    
BEGIN    
INSERT INTO LLSCleanLinenRequestLinenItemTxnDet (            
  CustomerId          
 ,FacilityId          
 ,CleanLinenRequestId          
 ,[CleanLinenIssueId]           
 ,LinenItemId            
 ,BalanceOnShelf           
 ,RequestedQuantity            
 ,CreatedBy            
 ,CreatedDate            
 ,CreatedDateUTC)             
              
 OUTPUT INSERTED.CLRLinenItemId INTO @Table                
             
 SELECT   CustomerId          
 ,FacilityId          
 ,CleanLinenRequestId          
 ,@CleanLinenIssueId         
 ,LinenItemId            
 ,BalanceOnShelf           
 ,RequestedQuantity              
 ,CreatedBy              
 ,GETDATE()          
 ,GETUTCDATE()              
FROM @Block       
END    
 -----END added deepak    
       
    
                
SELECT CLRLinenItemId              
      ,[Timestamp]              
   ,'' ErrorMsg              
      --,GuId               
FROM LLSCleanLinenRequestLinenItemTxnDet WHERE CLRLinenItemId IN (SELECT ID FROM @Table)                
                
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END
GO
