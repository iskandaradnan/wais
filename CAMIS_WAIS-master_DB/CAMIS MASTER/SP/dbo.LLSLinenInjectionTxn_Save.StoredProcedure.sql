USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
                      
-- Exec [LLSLinenInjectionTxn_Save]                       
                      
--/*=====================================================================================================================                      
--APPLICATION  : UETrack 1.5                      
--NAME    : LLSLinenInjectionTxn_Save                     
--DESCRIPTION  : SAVE RECORD IN [LLSLinenInjectionTxn] TABLE                       
--AUTHORS   : SIDDHANT                      
--DATE    : 20-JAN-2020                    
-------------------------------------------------------------------------------------------------------------------------                      
--VERSION HISTORY                       
--------------------:---------------:---------------------------------------------------------------------------------------                      
--Init    : Date          : Details                      
--------------------:---------------:---------------------------------------------------------------------------------------                      
--SIDDHANT          : 20-JAN-2020 :                       
-------:------------:----------------------------------------------------------------------------------------------------*/                      
                      
                  
CREATE PROCEDURE  [dbo].[LLSLinenInjectionTxn_Save]                                                 
                      
(                      
 @Block As [dbo].[LLSLinenInjectionTxn] READONLY                      
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
SET @mDefaultkey='LNJ'                  
SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH,InjectionDate)),2) FROM @Block)              
SET @mYear=(SELECT YEAR(InjectionDate) FROM @Block)              
SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,InjectionDate)),2) FROM @Block)                  
SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)            
SET @YYMM=CONCAT(@mYear,@mMonth)   
--SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM                  
                  
                  
                  
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Linen Injection',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                  
SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)                    
              
              
              
INSERT INTO LLSLinenInjectionTxn (                  
 CustomerId,                  
 FacilityId,                  
 DocumentNo,                  
 InjectionDate,                  
 DONo,        
 PONo,        
 DODate,                  
 Remarks,                  
 CreatedBy,                  
 CreatedDate,                  
 CreatedDateUTC,          
 ModifiedBy,          
 ModifiedDate,          
 ModifiedDateUTC)                   
                     
                    
OUTPUT INSERTED.LinenInjectionId INTO @Table                      
SELECT   CustomerId,                  
 FacilityId,                  
 @pDocumentNo AS DocumentNo,                  
 InjectionDate,                  
DONo,        
 PONo,        
 DODate,                  
 Remarks,                  
CreatedBy,                    
GETDATE(),     
GETUTCDATE(),          
ModifiedBy,                    
GETDATE(),                    
GETUTCDATE()          
FROM @Block                      
                      
SELECT LinenInjectionId                    
      ,[Timestamp]                    
   ,'' ErrorMsg                    
      --,GuId                     
FROM LLSLinenInjectionTxn WHERE LinenInjectionId IN (SELECT ID FROM @Table)                      
                      
END TRY                      
BEGIN CATCH                      
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                      
                      
THROW           
                      
END CATCH                      
SET NOCOUNT OFF                      
END      
GO
