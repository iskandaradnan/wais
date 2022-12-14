USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionUpdateDedGenerationTxn]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
      
CREATE PROCEDURE [dbo].[DeductionUpdateDedGenerationTxn]      
(      
 @Remarks VARCHAR(MAX) NULL      
,@DedGenerationId INT      
)      
AS      
      
      
BEGIN      
      
-----NEED TO CHNAGE THE LOGIC FOR DCOUMENT NO AS NEED TO ADD THE LOGIC IN FMDOCUMENTGENERATION TABLE.      
      
--DECLARE @DocumentNo VARCHAR(20)      
--DECLARE @Remarks VARCHAR(20)      
--DECLARE @DedGenerationId VARCHAR(20)      
      
      
--SET @DocumentNo=''      
--SET @Remarks= ''      
--SET @DedGenerationId =''      
      
      
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
                  
SET @pCustomerId=157--(SELECT CustomerId FROM @Block )                  
SET @pFacilityId=144--(SELECT FacilityId FROM @Block )                  
SET @mDefaultkey='DED'                  
SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH,GETDATE())),2)) --FROM @Block)              
SET @mYear=(SELECT YEAR(GETDATE())) --FROM @Block)              
SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,GETDATE())),2)) --FROM @Block)                  
SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)                  
SET @YYMM=CONCAT(@mYear,@mMonth)         
SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM                  
                  
                  
                  
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Deduction',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                  
SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)         
      
      
      
UPDATE DedGenerationTxn SET DocumentNo =@pDocumentNo      
,Remarks =@Remarks        
,DeductionStatus = 'A'       
WHERE DedGenerationId =@DedGenerationId      
      
END 
GO
