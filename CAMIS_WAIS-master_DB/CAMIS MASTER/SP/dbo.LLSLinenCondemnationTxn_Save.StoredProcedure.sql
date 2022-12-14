USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnationTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                    
-- Exec [LLSLinenCondemnationTxn_Save]                     
                    
--/*=====================================================================================================================                    
--APPLICATION  : UETrack 1.5                    
--NAME    : LLSLinenItemDetailsMst_Save                   
--DESCRIPTION  : SAVE RECORD IN [LLSLinenCondemnationTxn] TABLE                     
--AUTHORS   : SIDDHANT                    
--DATE    : 16-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                    
--VERSION HISTORY                     
--------------------:---------------:---------------------------------------------------------------------------------------                    
--Init    : Date          : Details                    
--------------------:---------------:---------------------------------------------------------------------------------------                    
--SIDDHANT          : 16-JAN-2020 :                     
-------:------------:----------------------------------------------------------------------------------------------------*/                    
                    
                
CREATE PROCEDURE  [dbo].[LLSLinenCondemnationTxn_Save]                                               
                    
(                    
 @LLSLinenCondemnationTxn As [dbo].[LLSLinenCondemnationTxn] READONLY                    
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
DECLARE @mMonth INT              
DECLARE @mYear INT              
DECLARE @mDay INT           
DECLARE @YYMM VARCHAR(50)          
DECLARE @YYMMDD VARCHAR(50)          
DECLARE @pOutParam VARCHAR(100)              
DECLARE @pDocumentNo VARCHAR(100)              
              
SET @pCustomerId=(SELECT CustomerId FROM @LLSLinenCondemnationTxn )              
SET @pFacilityId=(SELECT FacilityId FROM @LLSLinenCondemnationTxn )              
SET @mDefaultkey='LCN'              
SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH,DocumentDate)),2) FROM @LLSLinenCondemnationTxn)          
SET @mYear=(SELECT YEAR(DocumentDate) FROM @LLSLinenCondemnationTxn)          
SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,DocumentDate)),2) FROM @LLSLinenCondemnationTxn)              
SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)          
SET @YYMM=CONCAT(@mYear,@mMonth) 

--SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM              
              
              
              
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Linen Condemnation',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                              
SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)                
          
          
          
          
          
                  
INSERT INTO LLSLinenCondemnationTxn (                  
 CustomerId,                  
 FacilityId,                  
 DocumentNo,                  
 DocumentDate,                  
 InspectedBy,                  
 VerifiedBy,               
 TotalCondemns,              
 Value,              
 LocationOfCondemnation,                  
 Remarks,                  
 CreatedBy,                  
 CreatedDate,                  
 CreatedDateUTC,      
 ModifiedBy,      
 ModifiedDate,      
 ModifiedDateUTC)                  
                   
                  
OUTPUT INSERTED.LinenCondemnationId INTO @Table                    
SELECT   CustomerId,                  
 FacilityId,                  
@pDocumentNo AS DocumentNo,                  
 DocumentDate,                  
 InspectedBy,                  
 VerifiedBy,               
 TotalCondemns,              
 Value,              
 LocationOfCondemnation,                  
 Remarks,                  
CreatedBy,                  
GETDATE(),                  
GETUTCDATE()  ,      
ModifiedBy,                  
GETDATE(),                  
GETUTCDATE()      
FROM @LLSLinenCondemnationTxn                
                    
SELECT LinenCondemnationId                  
      ,[Timestamp]                  
   ,'' ErrorMsg                  
      --,GuId                   
FROM LLSLinenCondemnationTxn WHERE LinenCondemnationId IN (SELECT ID FROM @Table)                    
                    
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());           
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END    
    
    
    
    
    
    
    
    
GO
