USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                    
-- Exec [LLSLinenRepairTxn_Save ]                     
                    
--/*=====================================================================================================================                    
--APPLICATION  : UETrack 1.5                    
--NAME    : LLSLinenRepairTxn_Save                   
--DESCRIPTION  : SAVE RECORD IN [LLSLinenRepairTxn] TABLE                     
--AUTHORS   : SIDDHANT                    
--DATE    : 8-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                    
--VERSION HISTORY                     
--------------------:---------------:---------------------------------------------------------------------------------------                    
--Init    : Date          : Details                    
--------------------:---------------:---------------------------------------------------------------------------------------                    
--SIDDHANT          : 8-JAN-2020 :                     
-------:------------:----------------------------------------------------------------------------------------------------*/                    
                 
                    
CREATE PROCEDURE  [dbo].[LLSLinenRepairTxn_Save]                                               
                    
(                    
 @Block As [dbo].[LLSLinenRepairTxn] READONLY                    
)                          
                    
AS                          
                    
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                  
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
                
SET @pCustomerId=(SELECT CustomerId FROM @Block )                
SET @pFacilityId=(SELECT FacilityId FROM @Block )                
SET @mDefaultkey='LRP'                
SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,DocumentDate)),2) FROM @Block)            
SET @mYear=(SELECT YEAR(DocumentDate) FROM @Block)            
SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,DocumentDate)),2) FROM @Block)                
SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)            
SET @YYMM=CONCAT(@mYear,@mMonth)   
  
--SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM                
                
                
                
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Linen Repair',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                
SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)                  
            
            
            
INSERT INTO LLSLinenRepairTxn (                  
 CustomerId,                  
 FacilityId,                  
 DocumentNo,                  
 DocumentDate,                  
 RepairedBy,                  
 CheckedBy,                  
 Remarks,                  
 CreatedBy,                  
 CreatedDate,                  
 CreatedDateUTC,        
 ModifiedBy,        
 ModifiedDate,        
 ModifiedDateUTC)                   
                  
OUTPUT INSERTED.LinenRepairId INTO @Table                    
SELECT CustomerId,                  
 FacilityId,                  
 @pDocumentNo as DocumentNo,                  
 DocumentDate,                  
 RepairedBy,                  
 CheckedBy,                  
 Remarks,                  
CreatedBy,                  
GETDATE(),              
GETUTCDATE(),        
ModifiedBy,                  
GETDATE(),                  
GETUTCDATE()        
FROM @Block                    
                    
SELECT LinenRepairId     
      ,[Timestamp]                  
   ,'' ErrorMsg                  
      --,GuId                   
FROM LLSLinenRepairTxn WHERE LinenRepairId IN (SELECT ID FROM @Table)                    
                    
END TRY                    
BEGIN CATCH                
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());             
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END      
      
GO
