USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenItemDetailsMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec [LLSLinenItemDetailsMst_Save]           
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : LLSLinenItemDetailsMst_Save         
--DESCRIPTION  : SAVE RECORD IN [LLSLinenItemDetailsMst] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 8-JAN-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 8-JAN-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
      
     
          
CREATE PROCEDURE  [dbo].[LLSLinenItemDetailsMst_Save]                                     
          
(          
 @Block As [dbo].[LLSLinenItemDetailsMst] READONLY          
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
          
INSERT INTO LLSLinenItemDetailsMst (        
 CustomerId        
,FacilityId        
,LinenCode        
,LinenDescription        
,UOM        
,Status     
,Material    
,EffectiveDate        
,Size        
,Colour        
,IdentificationMark        
,Standard        
,CreatedBy        
,CreatedDate        
 ,CreatedDateUTC  
, ModifiedBy    
,  ModifiedDate  
,ModifiedDateUTC   
)  
 OUTPUT INSERTED.LinenItemId INTO @Table          
 SELECT   CustomerId        
,FacilityId        
,LinenCode        
,LinenDescription        
,UOM        
,Status      
,Material    
,EffectiveDate        
,Size        
,Colour        
,IdentificationMark        
,Standard        
,CreatedBy        
,GETDATE()        
,GETUTCDATE()  
,ModifiedBy    
,GETDATE()       
,GETUTCDATE()        
FROM @Block          
          
SELECT LinenItemId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSLinenItemDetailsMst WHERE LinenItemId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
