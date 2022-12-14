USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
              
                        
-- Exec [LLSLinenInventoryTxn_Save]                         
                        
--/*=====================================================================================================================                        
--APPLICATION  : UETrack 1.5                        
--NAME    : LLSLinenInventoryTxn_Save                       
--DESCRIPTION  : SAVE RECORD IN [LLSLinenInventoryTxn] TABLE                         
--AUTHORS   : SIDDHANT                        
--DATE    : 13-FEB-2020                      
-------------------------------------------------------------------------------------------------------------------------                        
--VERSION HISTORY                         
--------------------:---------------:---------------------------------------------------------------------------------------                        
--Init    : Date          : Details                        
--------------------:---------------:---------------------------------------------------------------------------------------                        
--SIDDHANT          : 13-FEB-2020 :                         
-------:------------:----------------------------------------------------------------------------------------------------*/                        
                      
                        
                      
                      
                        
CREATE PROCEDURE  [dbo].[LLSLinenInventoryTxn_Save]                                                   
                        
(                        
@LLSLinenInventoryTxn AS [dbo].[LLSLinenInventoryTxn] READONLY                      
)                              
                        
AS                              
                        
BEGIN                        
SET NOCOUNT ON                        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
BEGIN TRY                        
                      
--SELECT StoreType FROM @LLSLinenInventoryTxn)=10171              
              
              
              
DECLARE @Table TABLE (ID INT)                        
DECLARE @pCustomerId INT                  
DECLARE @pFacilityId INT                  
DECLARE @mDefaultkey VARCHAR(100)                  
DECLARE @mMonth VARCHAR(50)                  
DECLARE @mYear INT                  
DECLARE @mDay VARCHAR(50)               
DECLARE @YYMM VARCHAR(50)              
DECLARE @YYMMDD VARCHAR(50)              
DECLARE @pOutParam VARCHAR(100)                  
DECLARE @pDocumentNo VARCHAR(100)                  
                  
SET @pCustomerId=(SELECT CustomerId FROM @LLSLinenInventoryTxn )                  
SET @pFacilityId=(SELECT FacilityId FROM @LLSLinenInventoryTxn )                  
SET @mDefaultkey=(SELECT CASE WHEN StoreType=10171 THEN 'LNV/CCLS'               
WHEN StoreType=10172 THEN 'LNV/UA'               
ELSE 'LNV/OS'              
END  FROM @LLSLinenInventoryTxn )              
SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH,[Date])),2) FROM @LLSLinenInventoryTxn)              
SET @mYear=(SELECT YEAR([Date]) FROM @LLSLinenInventoryTxn)              
SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,[Date])),2) FROM @LLSLinenInventoryTxn)                  
SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)              
SET @YYMM=CONCAT(@mYear,@mMonth)     
    
--SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM                  
                  
                  
                  
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Linen Inventory',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                  
SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)                    
              
              
                        
INSERT INTO LLSLinenInventoryTxn (                  
 CustomerId,                  
 FacilityId,                  
 StoreType,          
 DocumentNo,                  
 Date,                  
 UserAreaId,                  
 VerifiedBy,                  
 Remarks,                  
 CreatedBy,                
 CreatedDate,                  
 CreatedDateUTC,            
 ModifiedBy,            
 ModifiedDate,            
 ModifiedDateUTC            
 )                   
                       
 OUTPUT INSERTED.LinenInventoryId INTO @Table                        
 SELECT                      
 CustomerId,                  
 FacilityId,                  
 StoreType,                  
 @pDocumentNo AS DocumentNo,                  
 Date,                  
 UserAreaId,             
 VerifiedBy,                  
 Remarks,                  
CreatedBy   ,                   
GETDATE(),                      
GETUTCDATE(),            
ModifiedBy   ,                   
GETDATE(),                      
GETUTCDATE()             
                  
                      
FROM @LLSLinenInventoryTxn                       
                        
SELECT LinenInventoryId                      
      ,[Timestamp]                      
   ,'' ErrorMsg                      
      --,GuId                       
FROM LLSLinenInventoryTxn WHERE LinenInventoryId IN (SELECT ID FROM @Table)                        
              
              
END TRY                        
BEGIN CATCH                        
                        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                        
                        
THROW                    
                        
END CATCH                        
SET NOCOUNT OFF                        
END 
GO
