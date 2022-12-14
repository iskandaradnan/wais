USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSDriverDetailsMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec [LLSDriverDetailsMst_Save]                   
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack 1.5                  
--NAME    : LLSDriverDetailsMst_Save                 
--DESCRIPTION  : SAVE RECORD IN [LLSDriverDetailsMst] TABLE                   
--AUTHORS   : SIDDHANT                  
--DATE    : 13-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT          : 13-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
              
                  
CREATE PROCEDURE  [dbo].[LLSDriverDetailsMst_Save]                                             
                  
(                  
 @Block As [dbo].[LLSDriverDetailsMst] READONLY              
             
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
--DECLARE @mDay INT           
--DECLARE @YYMM VARCHAR(50)          
--DECLARE @YYMMDD VARCHAR(50)          
DECLARE @pOutParam VARCHAR(100)              
DECLARE @pDocumentNo VARCHAR(100)              
              
SET @pCustomerId=(SELECT CustomerId FROM @Block )              
SET @pFacilityId=(SELECT FacilityId FROM @Block )              
SET @mDefaultkey='DDT'              
SET @mMonth=(SELECT MONTH(EffectiveTo) FROM @Block)          
SET @mYear=(SELECT YEAR(EffectiveTo) FROM @Block)          
--SET @mDay=(SELECT DAY(EffectiveTo) FROM @Block)              
--SET @YYMMDD=CONCAT(CONCAT(CONCAT(@mYear,'0'),@mMonth),@mDay)          
--SET @YYMM=CONCAT(CONCAT(@mYear,'0'),@mMonth)          
--SELECT @pCustomerId,@pFacilityId,@mDefaultkey,@mMonth,@mYear,@mDay,@YYMMDD,@YYMM              
              
              
              
EXEC [uspFM_GenerateDocumentNumber] @pFlag='Driver Code',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                              
SELECT @pDocumentNo=@pOutParam        
        
        
        
        
        
INSERT INTO LLSDriverDetailsMst (                
 CustomerId,                
 FacilityId,                
 DriverCode,                
 LaundryPlantId,                
 DriverName,                
 Status,                
 EffectiveFrom,             
 EffectiveTo,            
 ContactNo,                
 ICNo,                
 CreatedBy,                
 CreatedDate,                
CreatedDateUTC,          
 ModifiedBy,            
ModifiedDate,            
ModifiedDateUTC           
)          
                 
 OUTPUT INSERTED.DriverId INTO @Table                  
 SELECT  CustomerId,                
 FacilityId,                
 @pDocumentNo,                
 LaundryPlantId,                
 DriverName,                
 Status,                
 EffectiveFrom,            
 EffectiveTo,            
 ContactNo,                
 ICNo,                
CreatedBy,                
GETDATE(),           
GETUTCDATE(),           
ModifiedBy,                
GETDATE(),      
GETUTCDATE()                
FROM @Block                 
                  
SELECT DriverId                
      ,[Timestamp]                
   ,'' ErrorMsg                
      --,GuId                 
FROM LLSDriverDetailsMst WHERE DriverId IN (SELECT ID FROM @Table)                  
                  
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                
END        
        
        
--LLSDriverDetailsMst        
--LLSDriverDetailsMstDet      
      
      
      
      
GO
