USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxn_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : LLSLinenInjectionTxn_Update           
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenInjectionTxn] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 20-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 20-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
          
            
          
          
            
CREATE PROCEDURE  [dbo].[LLSLinenInjectionTxn_Update]                                       
            
(            
 @Remarks  AS NVARCHAR(1000)      NULL=NULL  
,@LinenInjectionId    AS INT      
,@ModifiedBy AS INT
        
)                  
            
AS                  
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
DECLARE @Table TABLE (ID INT)            
          
UPDATE        
 LLSLinenInjectionTxn        
SET        
 Remarks = @Remarks,        
 ModifiedBy =@ModifiedBy,        
 ModifiedDate = GETDATE(),      
 ModifiedDateUTC =GETUTCDATE()      
WHERE LinenInjectionId = @LinenInjectionId           
          
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
