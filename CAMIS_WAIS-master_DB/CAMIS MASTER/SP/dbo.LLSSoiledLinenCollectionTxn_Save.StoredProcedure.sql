USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE  [dbo].[LLSSoiledLinenCollectionTxn_Save]                                                           
                                
(                                
 @LLSSoiledLinenCollection As [dbo].[LLSSoiledLinenCollectionTxn] READONLY                                
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
                          
SET @pCustomerId=(SELECT CustomerId FROM @LLSSoiledLinenCollection )                          
SET @pFacilityId=(SELECT FacilityId FROM @LLSSoiledLinenCollection )                          
SET @mDefaultkey='SLC'                          
SET @mMonth=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH,CollectionDate)),2) FROM @LLSSoiledLinenCollection)                      
SET @mYear=(SELECT YEAR(CollectionDate) FROM @LLSSoiledLinenCollection)                      
SET @mDay=(SELECT RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY,CollectionDate)),2) FROM @LLSSoiledLinenCollection)                          
SET @YYMMDD=CONCAT(CONCAT(@mYear,@mMonth),@mDay)                      
SET @YYMM=CONCAT(@mYear,@mMonth)             
            
--SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM                          
                          
                          
                          
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Soiled Linen Collection',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                 
  
    
      
        
         
SELECT @pDocumentNo=REPLACE(@pOutParam,@YYMM,@YYMMDD)                            
                      
            
                      
                      
                              
INSERT INTO LLSSoiledLinenCollectionTxn (                              
 CustomerId,                              
 FacilityId,                              
 DocumentNo,                              
 CollectionDate,                              
 LaundryPlantId,                              
 DespatchDate,                              
 CreatedBy,                              
 CreatedDate,                              
 CreatedDateUTC,                  
 ModifiedBy,                  
 ModifiedDate,                  
 ModifiedDateUTC,    
 Guid    
    
 )                                
                              
                              
OUTPUT INSERTED.SoiledLinenCollectionId INTO @Table                                
SELECT CustomerId,                              
 FacilityId,                              
 @pDocumentNo as DocumentNo,                              
 CollectionDate,                              
LaundryPlantId,                              
 DespatchDate,                              
CreatedBy,                              
GETDATE(),                              
GETUTCDATE(),                  
ModifiedBy,                              
GETDATE(),                              
GETUTCDATE(),    
Guid    
    
FROM @LLSSoiledLinenCollection                               
                                
SELECT SoiledLinenCollectionId                              
      ,[Timestamp]                              
   ,'' ErrorMsg                              
      --,GuId                             
FROM LLSSoiledLinenCollectionTxn WHERE SoiledLinenCollectionId IN (SELECT ID FROM @Table)                                
                  
END TRY                                
BEGIN CATCH                                
                                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                             
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                
                 
THROW                                
                                
END CATCH                                
SET NOCOUNT OFF                                
END 
GO
