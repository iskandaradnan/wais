USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================          
APPLICATION  : UETrack 1.5          
NAME    : LLSCentralCleanLinenStoreMst_Save         
DESCRIPTION  : SAVE RECORD IN [LLSCentralCleanLinenStoreMst_Save] TABLE           
AUTHORS   : SIDDHANT          
DATE    : 14-FEB-2020    
-----------------------------------------------------------------------------------------------------------------------          
VERSION HISTORY           
------------------:---------------:---------------------------------------------------------------------------------------          
Init    : Date          : Details          
------------------:---------------:---------------------------------------------------------------------------------------          
SIDDHANT          : 14-FEB-2020 :           
-----:------------:----------------------------------------------------------------------------------------------------*/          
        
CREATE PROCEDURE  [dbo].[LLSCentralCleanLinenStoreMst_Save]                                     
          
(          
@LLSCentralCleanLinenStoreMst AS [dbo].[LLSCentralCleanLinenStoreMst] READONLY        
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
          
INSERT INTO LLSCentralCleanLinenStoreMst (    
 CustomerId,    
 FacilityId,    
 StoreType,    
 CreatedBy,    
 CreatedDate,    
 CreatedDateUTC)       
         
 OUTPUT INSERTED.CCLSId INTO @Table          
 SELECT        
 CustomerId,    
 FacilityId,    
 StoreType,    
 CreatedBy,        
GETDATE(),        
GETUTCDATE()        
FROM @LLSCentralCleanLinenStoreMst         
          
SELECT CCLSId    
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSCentralCleanLinenStoreMst WHERE CCLSId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
