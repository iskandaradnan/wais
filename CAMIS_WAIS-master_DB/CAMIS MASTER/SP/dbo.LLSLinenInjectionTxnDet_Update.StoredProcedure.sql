USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : SaveUserAreaDetailsLLS           
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenInjectionTxnDet_Update] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 21-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 21-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
          
            
          
          
            
CREATE PROCEDURE  [dbo].[LLSLinenInjectionTxnDet_Update]                                       
            
(            
@LLSLinenInjectionTxnDet AS  [LLSLinenInjectionTxnDet_Update] READONLY  
-- @QuantityInjected  AS INT        
--,@TestReport AS NVARCHAR(300)      
--,@LinenInjectionId AS INT        
        
)                  
            
AS                  
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
DECLARE @Table TABLE (ID INT)            
          
UPDATE A        
SET        
A.QuantityInjected = B.QuantityInjected,        
A.TestReport = B.TestReport,        
A.ModifiedBy = B.ModifiedBy,        
A.ModifiedDate = GETDATE(),        
A.ModifiedDateUTC = GETUTCDATE()    
FROM LLSLinenInjectionTxnDet A  
INNER JOIN @LLSLinenInjectionTxnDet B   
ON A.LinenInjectionDetId = B.LinenInjectionDetId  
WHERE A.LinenInjectionDetId = B.LinenInjectionDetId           
          
SELECT LinenInjectionDetId          
      ,[Timestamp]          
   ,'' ErrorMsg          
      --,GuId           
FROM LLSLinenInjectionTxnDet WHERE LinenInjectionDetId IN (SELECT ID FROM @Table)            
            
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
